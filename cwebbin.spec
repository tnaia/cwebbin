# 'make fullmanual' requires TeX (pdflatex).
# use '--without doc' to exclude this step; default is 'with'.
%bcond_without doc
# By default CWEB and CWEBBIN are compiled and linked with optimization
# switched on. Use '--with debuginfo' to switch debugging on.
%bcond_with debuginfo
# Apply only the set of ANSI changes.
%bcond_with ansi_only
# Prepare CWEBbin as base for TeXLive.
%bcond_with texlive

Name: cwebbin%{?with_texlive:-texlive}
Summary: The CWEBbin extension of the CWEB package
License: Public Domain
URL: http://www-cs-faculty.stanford.edu/~uno/cweb.html
Packager: Andreas Scherer <https://ascherer.github.io>

%if %{_vendor} == "debbuild"
Group: tex
Distribution: Kubuntu 18.04 (x86_64)
Requires: texlive, pandoc, gettext
%if %{with texlive}
Requires: pax
%endif
%if %{with doc}
BuildRequires: texlive
%endif
%else
Group: Productivity/Publishing/TeX/Base
Distribution: openSUSE 42 (x86_64)
%global __msgfmt %{_bindir}/msgfmt
%global __pax /bin/pax
%global __touch %{_bindir}/touch
%global __texlive_local %(kpsewhich --var-value=TEXMFLOCAL)
%endif
BuildRoot: %{_tmppath}/%{name}-%{version}-root

# Start with CTWILL; only very few things are actually used
Source0: ftp://ftp.cs.stanford.edu/pub/ctwill/ctwill.tar.gz
# Overwrite 'prod.w' with CWEB original
Source1: ftp://ftp.cs.stanford.edu/pub/cweb/cweb-3.64c.tar.gz
# Add CWEBbin stuff on top
Source2: cwebbin-2020.tar.gz

Patch2: 0001-Make-clean-twinx.patch
Patch3: 0002-Make-clean-refsort.patch

%if %{with ansi_only}
Version: 3.64c
Release: ansi
%else
Version: 2020
Release: 18
%endif

%global __sed_i %{__sed} -i

%global __make %{__make} -f Makefile.unix \\\
	-e PDFTEX=pdftex \\\
	-e TEXMFDIR=%{__texlive_local} \\\
	%{!?with_texlive:-e CWEBINPUTS=%{_libdir}/cweb}

%global __pandoc %{_bindir}/pandoc \\\
	--standalone --from markdown+all_symbols_escapable --to man

%description
The 'CWEBbin' package is an extension of the 'CWEB' package by Silvio Levy
and Donald Knuth for Literate Programming in C/C++.

%prep
%if %{_vendor} == "debbuild"
%autosetup -c -a1 -a2
%else
%autosetup -c -T -a 0 -N
%autosetup -D -T -a 1 -N
%autosetup -D -T -a 2
%endif

for f in Makefile.unix po/cweb.pot po/*/cweb.po
do %{__sed_i} -e "s/@@VERSION@@/Version 3.64 [CWEBbin %{version}]/" $f; done

%if %{with texlive}
%{__sed_i} -e "s/# \(.*-texlive\)/\1/" Makefile.unix

%else

%{!?with_doc:%{__sed_i} -e "s/cweave fullmanual/cweave # fullmanual/" Makefile.unix}

%if ! %{with debuginfo}
%{__sed_i} -e "s/CFLAGS = -g/#CFLAGS = -g/" \
	-e "s/#CFLAGS = -O/CFLAGS = -O/" \
	-e "s/LINKFLAGS = -g/#LINKFLAGS = -g/" \
	-e "s/#LINKFLAGS = -s/LINKFLAGS = -s/" \
	Makefile.unix
%endif

%if %{with ansi_only}
%{__sed_i} Makefile.unix -e \
	"/CHANGES):/{N;s/\(.*: [a-z.\/]*\)\( .*\)\? \(.*ansi[.ch]*\).*/\1 \3/}"
%{?with_doc:%{__sed_i} -e "s/cweave fullmanual/cweave docs/" Makefile.unix}
%{__sed_i} -e "/case not_eq/ s/@+/ /" ctang-ansi.ch
%{__sed_i} -e "0,/char \*b/ s/, where/,where/" cweav-ansi.ch
%endif

%endif

%build
%if %{with texlive}

%{__make} -e CCHANGES=comm-w2c.ch comm-w2c.ch \
	-e HCHANGES=comm-w2c.h comm-w2c.h \
	-e TCHANGES=ctang-w2c.ch ctang-w2c.ch \
	-e WCHANGES=cweav-w2c.ch cweav-w2c.ch \
	-e LCHANGES=ctwill-w2c.ch ctwill-w2c.ch \
	prod-twill.w

for m in comm ctang cweav ctwill
do %{__sed_i} -e "1r texlive.w" -e "1d" $m-w2c.ch; done

%else

%{__touch} *.cxx
%{__make} boot cautiously all

%endif

for m in ctwill cweb; do %{__pandoc} $m.md --output $m.1; done

%if %{with texlive}
%check
# Use system CWEB, most likely from TeXLive
%{__make} -e CTANGLE=ctangle -e HCHANGES=comm-w2c.h \
	-e CCHANGES=comm-w2c.ch common.cxx \
	-e TCHANGES=ctang-w2c.ch ctangle.cxx \
	-e WCHANGES=cweav-w2c.ch cweave.cxx \
	-e LCHANGES=ctwill-w2c.ch ctwill.cxx
%endif

%install
%if %{with texlive}

for m in proof twinx; do %{__mv} ${m}mac.tex ct${m}mac.tex; done
%{__mv} texinputs/dproofmac.tex texinputs/dctproofmac.tex
%{__sed_i} -e "s/proofmac/ctproofmac/" texinputs/dctproofmac.tex
%{__sed_i} -e "s/twinxmac/cttwinxmac/" twinx.w

%{__mkdir} man

for m in ctwill cweb
do %{__sed} -e "/Web2c/ s/\\\\\[at\]/@/g" $m.1 > man/$m.man; done

%{__sed_i} -e "s/proofmac/ctproofmac/g" \
	-e "s/refsort/ctwill-refsort/g" \
	-e "s/twinx/ctwill-twinx/g" \
	man/ctwill.man

%{__pax} *-w2c.ch comm-w2c.h prod-twill.w ct*mac.tex \
	po cwebinputs texinputs refsort.w twinx.w man \
	-wzf %{getenv:PWD}/cweb-texlive.tar.gz \
	-s ,^man,texk/web2c/man, -s ,^,texk/web2c/cwebdir/,

%else

%{__rm} -rf %{buildroot}

%make_install

for l in de it
do
	%{__install} -d %{buildroot}%{_datadir}/locale/$l/LC_MESSAGES
	%{__msgfmt} po/$l/cweb.po \
		-o %{buildroot}%{_datadir}/locale/$l/LC_MESSAGES/cweb.mo
done

for m in ctwill cweb
do %{__sed_i} -e "s/Web2c .*\[at\]/CWEBbin %{version}/" $m.1; done

%endif

%files
%if ! %{with texlive}
%{_bindir}/*
%{_datadir}/emacs/site-lisp/cweb.el
%{_libdir}/cweb/*
%{_mandir}/man1/*
%{_datadir}/locale/de/LC_MESSAGES/cweb.mo
%{_datadir}/locale/it/LC_MESSAGES/cweb.mo
%{__texlive_local}/tex/plain/cweb/*
%endif

%post
%{__texhash}

%postun
%{__texhash}

%changelog
* Sun Sep 22 2019 Andreas Scherer <https://ascherer.github.io>
- Prepare new release

* Tue Jan 01 2019 Andreas Scherer <https://ascherer.github.io>
- Prepare new release

* Sun Dec 30 2018 Andreas Scherer <https://ascherer.github.io>
- Add CTWILL and its utiliy programs and macros

* Fri Nov 09 2018 Andreas Scherer <https://ascherer.github.io>
- Add internationalization (i18n)

* Sun Feb 19 2017 Andreas Scherer <https://ascherer.github.io>
- Update for the 2017 sources

* Tue Mar 08 2016 Andreas Scherer <https://ascherer.github.io>
- Prepare release for CTAN/Web2c/TeX Live

* Tue Feb 23 2016 Andreas Scherer <https://ascherer.github.io>
- Update for the updated 2016 sources

* Sun Jan 31 2016 Andreas Scherer <https://ascherer.github.io>
- Update for the 2016 sources

* Sat Jan 09 2016 Andreas Scherer <https://ascherer.github.io>
- Conditional Build Stuff for non-TeX systems

* Thu Oct 29 2015 Andreas Scherer <andreas_tex@freenet.de> 22p-5
- Fully parametrized specfile

* Sat Aug 22 2015 Andreas Scherer <andreas_tex@freenet.de> 22p-4
- Put the TeX stuff into the correct 'local texmf tree'

* Sat Aug 15 2015 Andreas Scherer <andreas_tex@freenet.de> 22p-3
- Provide consistent information in URL and Source0

* Mon Jul 06 2015 Andreas Scherer <andreas_tex@freenet.de> 22p-2
- Use a simpler %prep section

* Thu Aug 18 2011 Andreas Scherer <andreas_tex@freenet.de> 22p-1
- Compile the package on Kubuntu 10.04

* Sat Apr 21 2007 Andreas Scherer <andreas_tug@freenet.de> p21-4
- Update for the 2006 sources

* Sun Dec 18 2005 Andreas Scherer <andreas_tug@freenet.de> p21-3
- Install (and hide) cwebmac.tex

* Fri Nov 04 2005 Andreas Scherer <andreas_tug@freenet.de> p21-2
- Build from two source archives (CWEBbin + cweb)

* Sat Oct 29 2005 Andreas Scherer <andreas_tug@freenet.de> p21-1
- Initial build
