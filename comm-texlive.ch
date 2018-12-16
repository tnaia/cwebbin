% Original Kpathsea changes for CWEB by Wlodek Bzyl and Olaf Weber
% This file is in the Public Domain.

% Most of the original changes were merged with the set of change files
% of the CWEBbin project.  This stripped change file is last in line of
% comm-patch.ch, comm-ansi.ch, comm-extensions.ch, comm-output.ch,
% comm-i18n.ch and comm-texlive.ch that get tie'd into comm-w2c.ch that
% is used as a monolithic changefile for common.w in TeX Live.

Material in limbo.

FIXME: Apply a more generic @VERSION@ scheme.

@x l.25 and l.178 of COMM-PATCH.CH
\def\title{Common code for CTANGLE and CWEAVE (Version 3.65 [CWEBbin 2018])}
@y
\def\Kpathsea/{{\mc KPATHSEA\spacefactor1000}}
\def\title{Common code for CTANGLE and CWEAVE (\TeX~Live 2019/dev)}
@z

@x l.30 and l.184 of COMM-PATCH.CH
  \centerline{(Version 3.65 [CWEBbin 2018])}
@y
  \centerline{(Version 3.65 [\TeX~Live 2019/dev])}
@z

Section 2.

@x l.82
typedef bool boolean;
@y
@z

Section 4.

@x l.101
  @<Initialize pointers@>@;
@y
  @<Initialize pointers@>@;
  @<Set up |PROGNAME| feature and initialize the search path mechanism@>@;
@z

Section 9.

@x l.192
    if ((*(k++) = c) != ' ') limit = k;
@y
    if ((*(k++) = c) != ' ' && c != '\r') limit = k;
@z

Section 10.

@x l.232 - no alt_web_file_name needed.
char alt_web_file_name[max_file_name_length]; /* alternate name to try */
@y
@z

Section 19.

@x l.405 and l.78 of COMM-I18N.CH
if ((web_file=fopen(web_file_name,"r"))==NULL) {
  strcpy(web_file_name,alt_web_file_name);
  if ((web_file=fopen(web_file_name,"r"))==NULL)
       fatal(_("! Cannot open input file "), web_file_name);
}
@y
if ((found_filename=kpse_find_cweb(web_file_name))==NULL || @|
    (web_file=fopen(found_filename,"r"))==NULL) {
  fatal(_("! Cannot open input file "), web_file_name);
} else if (strlen(found_filename) < max_file_name_length) {
  strcpy(web_file_name, found_filename);
  free(found_filename);
} else fatal(_("! Filename too long\n"), found_filename);
@z

@x l.413 and l.84 of COMM-I18N.CH
if ((change_file=fopen(change_file_name,"r"))==NULL)
       fatal(_("! Cannot open change file "), change_file_name);
@y
if ((found_filename=kpse_find_cweb(change_file_name))==NULL || @|
    (change_file=fopen(found_filename,"r"))==NULL) {
  fatal(_("! Cannot open change file "), change_file_name);
} else if (strlen(found_filename) < max_file_name_length) {
  strcpy(change_file_name, found_filename);
  free(found_filename);
} else fatal(_("! Filename too long\n"), found_filename);
@z

Section 22.

@x l.469 and l.26 of COMM-EXTENSIONS.CH
@ When an \.{@@i} line is found in the |cur_file|, we must temporarily
stop reading it and start reading from the named include file.  The
\.{@@i} line should give a complete file name with or without
double quotes.
The remainder of the \.{@@i} line after the file name is ignored.
\.{CWEB} will look for include files in standard directories specified in the
environment variable \.{CWEBINPUTS}. Multiple search paths can be specified by
delimiting them with \.{PATH\_SEPARATOR}s.  The given file is searched for in
the current directory first.  You also may include device names; these must
have a \.{DEVICE\_SEPARATOR} as their rightmost character.
@^system dependencies@>
@y
@ When an \.{@@i} line is found in the |cur_file|, we must temporarily
stop reading it and start reading from the named include file.  The
\.{@@i} line should give a complete file name with or without
double quotes.
The actual file lookup is done with the help of the \Kpathsea/ library;
see section~\X89:File lookup with \Kpathsea/\X~for details. % FIXME
The remainder of the \.{@@i} line after the file name is ignored.
@z

Section 23.

@x l.487
  char temp_file_name[max_file_name_length];
  char *cur_file_name_end=cur_file_name+max_file_name_length-1;
  char *k=cur_file_name, *kk;
  int l; /* length of file name */
@y
  char *cur_file_name_end=cur_file_name+max_file_name_length-1;
  char *k=cur_file_name;
@z

@x l.501
  if ((cur_file=fopen(cur_file_name,"r"))!=NULL) {
@y
  if ((found_filename=kpse_find_cweb(cur_file_name))!=NULL && @|
      (cur_file=fopen(found_filename,"r"))!=NULL) {
    /* Copy name for |#line| directives. */
    if (strlen(found_filename) < max_file_name_length) {
      strcpy(cur_file_name, found_filename);
      free(found_filename);
    } else fatal(_("! Filename too long\n"), found_filename);
@z

Replaced by Kpathsea `kpse_find_file'.

@x l.505 and l.67 of COMM-EXTENSIONS.CH
  if(0==set_path(include_path,getenv("CWEBINPUTS"))) {
    include_depth--; goto restart; /* internal error */
  }
  path_prefix = include_path;
  while(path_prefix) {
    for(kk=temp_file_name, p=path_prefix, l=0;
      p && *p && *p!=PATH_SEPARATOR;
      *kk++ = *p++, l++);
    if(path_prefix && *path_prefix && *path_prefix!=PATH_SEPARATOR && @|
      *--p!=DEVICE_SEPARATOR && *p!=DIR_SEPARATOR) {
      *kk++ = DIR_SEPARATOR; l++;
    }
    if(k+l+2>=cur_file_name_end) too_long(); /* emergency break */
    strcpy(kk,cur_file_name);
    if((cur_file = fopen(temp_file_name,"r"))!=NULL) {
      cur_line=0; print_where=1; goto restart; /* success */
    }
    if((next_path_prefix = strchr(path_prefix,PATH_SEPARATOR))!=NULL)
      path_prefix = next_path_prefix+1;
    else break; /* no more paths to search; no file found */
  }
@y
@z

Section 67.

@x l.1227
the names of those files. Most of the 128 flags are undefined but available
for future extensions.
@y
the names of those files. Most of the 128 flags are undefined but available
for future extensions.

We use `kpathsea' library functions to find literate sources.  When the files
you expect are not found, the thing to do is to enable `kpathsea' runtime
debugging by assigning to the |kpathsea_debug| variable a small number via the
`\.{-d}' option. The meaning of this number is shown below. To set more than
one debugging option, simply sum the corresponding numbers.
$$\halign{\hskip5em\tt\hfil#&&\qquad\tt#\cr
 1&report `\.{stat}' calls\cr
 2&report lookups in all hash tables\cr
 4&report file openings and closings\cr
 8&report path information\cr
16&report directory list\cr
32&report on each file search\cr
64&report values of variables being looked up\cr}$$
Debugging output is always written to |stderr|, and begins with the string
`\.{kdebug:}'.
@z

@x l.1233
@d show_happiness flags['h'] /* should lack of errors be announced? */
@y
@d show_happiness flags['h'] /* should lack of errors be announced? */
@d show_kpathsea_debug flags['d']
  /* should results of file searching be shown? */
@z

Section 68.

@x l.1234
show_banner=show_happiness=show_progress=1;
@y
@z

Section 71.

@x l.1301
@ We use all of |*argv| for the |web_file_name| if there is a |'.'| in it,
otherwise we add |".w"|. If this file can't be opened, we prepare an
|alt_web_file_name| by adding |"web"| after the dot.
The other file names come from adding other things
after the dot.  We must check that there is enough room in
|web_file_name| and the other arrays for the argument.
@y
@ We use all of |*argv| for the |web_file_name| if there is a |'.'| in it,
otherwise we add |".w"|.  The other file names come from adding other things
after the dot.  We must check that there is enough room in |web_file_name| and
the other arrays for the argument.
@z

@x l.1318 - no alt_web_file_name
  sprintf(alt_web_file_name,"%s.web",*argv);
@y
@z

Section 74.

@x l.1360
@<Handle flag...@>=
{
@y
@<Handle flag...@>=
{
  if (strcmp("-help",*argv)==0 || strcmp("--help",*argv)==0)
@.--help@>
    @<Display help message and exit@>@;
  if (strcmp("-version",*argv)==0 || strcmp("--version",*argv)==0)
@.--version@>
    @<Display version information and exit@>@;
@z

@x l.1362 and l.243 of COMM-EXTENSIONS.CH
  for(dot_pos=*argv+1;*dot_pos>'\0';dot_pos++)
@y
  for(dot_pos=*argv+1;*dot_pos>'\0';dot_pos++)
    if (*dot_pos=='d') {
      if (sscanf(*argv+2,"%u",&kpathsea_debug)!=1) @<Print usage error...@>@;
    } else
@z

Section 75.

@x l.1368 and l.273 of COMM-I18N.CH
if (program==ctangle)
  fatal(
_("! Usage: ctangle [options] webfile[.w] [{changefile[.ch]|-} [outfile[.c]]]\n")
   ,"");
@.Usage:@>
else fatal(
_("! Usage: cweave [options] webfile[.w] [{changefile[.ch]|-} [outfile[.tex]]]\n")
   ,"");
@y
cb_usage(program==ctangle ? "ctangle" : "cweave");
@.Usage:@>
@z

Section 77.

@x l.1389
FILE *active_file; /* currently active file for \.{CWEAVE} output */
@y
FILE *active_file; /* currently active file for \.{CWEAVE} output */
char *found_filename; /* filename found by |kpse_find_file| */
@z

Changes to former addenda.

@x l.259 of COMM-EXTENSIONS.CH
static boolean set_path(char *,char *);@/
@y
@z

@x l.267 of COMM-EXTENSIONS.CH and l.308 of COMM-I18N.CH
@* Path searching.  By default, \.{CTANGLE} and \.{CWEAVE} are looking
for include files along the path |CWEBINPUTS|.  By setting the environment
variable of the same name to a different search path you can suit your
personal needs.  If this variable is empty, some decent defaults are used
internally.  The following procedure takes care that these internal entries
are appended to any setting of the environmnt variable, so you don't have
to repeat the defaults.
@^system dependencies@>

@c
static boolean set_path(char *include_path,char *environment)
{
  char string[max_path_length+2];
@#
#ifdef CWEBINPUTS
  strncpy(include_path,CWEBINPUTS,max_path_length);
  include_path[max_path_length]='\0';
#endif

  if(environment) {
    if(strlen(environment)+strlen(include_path) >= max_path_length) {
      err_print(_("! Include path too long")); return(0);
@.Include path too long@>
    } else {
      sprintf(string,"%s%c%s",environment,PATH_SEPARATOR,include_path);
      strcpy(include_path,string);
    }
  }
  return(1);
}

@y
@z

@x l.298 of COMM-EXTENSIONS.CH
@ The path search algorithm defined in section |@<Try to open...@>|
needs a few extra variables.

@d max_path_length (BUFSIZ-2)

@d PATH_SEPARATOR   separators[0]
@d DIR_SEPARATOR    separators[1]
@d DEVICE_SEPARATOR separators[2]

@<Other...@>=
char include_path[max_path_length+2];@/
char *p, *path_prefix, *next_path_prefix;

@y
@ The |scan_args| routine needs a few extra variables.

@d PATH_SEPARATOR   separators[0]
@d DIR_SEPARATOR    separators[1]
@d DEVICE_SEPARATOR separators[2]

@<Other...@>=
@z

Material++

@x l.1452
@** Index.
@y
@* File lookup with \Kpathsea/.  The \.{CTANGLE} and \.{CWEAVE} programs from
the original \.{CWEB} package use the compile-time default directory or the
value of the environment variable \.{CWEBINPUTS} as an alternative place to be
searched for files, if they could not be found in the current directory.

This version uses the \Kpathsea/ mechanism for searching files.
The directories to be searched for come from three sources:

 (a)~a user-set environment variable \.{CWEBINPUTS}
    (overriden by \.{CWEBINPUTS\_cweb});\par
 (b)~a line in \Kpathsea/ configuration file \.{texmf.cnf},\hfil\break
    e.g. \.{CWEBINPUTS=.:\$TEXMF/texmf/cweb//}
    or \.{CWEBINPUTS.cweb=.:\$TEXMF/texmf/cweb//};\hangindent=2\parindent\par
 (c)~compile-time default directories \.{.:\$TEXMF/texmf/cweb//}
    (specified in \.{texmf.in}).

@d kpse_find_cweb(name) kpse_find_file(name,kpse_cweb_format,true)

@<Include files@>=
typedef bool boolean;
#define HAVE_BOOLEAN
#include <kpathsea/kpathsea.h> /* include every \Kpathsea/ header */
@#
#define CWEB
#include "help.h"

@ The simple file searching is replaced by the ``path searching'' mechanism
that the \Kpathsea/ library provides.

We set |kpse_program_name| to `\.{cweb}'.  This means if the variable
\.{CWEBINPUTS.cweb} is present in \.{texmf.cnf} (or \.{CWEBINPUTS\_cweb}
in the environment) its value will be used as the search path for
filenames.  This allows different flavors of \.{CWEB} to have
different search paths.

\&{FIXME}: Not sure this is the best way to go about this.

@<Set up |PROGNAME| feature and initialize the search path mechanism@>=
kpse_set_program_name(argv[0], "cweb");

@* System dependent changes. The most volatile stuff comes at the very end.

@ Modules for dealing with help messages and version info.

@<Display help message and exit@>=
cb_usagehelp(program==ctangle ? CTANGLEHELP : CWEAVEHELP, NULL);
@.--help@>

@ Special variants from \Kpathsea/ for i18n/t10n.

@<Predecl...@>=
static void cb_usage (const_string str);@/
static void cb_usagehelp (const_string *message, const_string bug_email);@/

@ We simply filter the strings through the catalog (if available).

@c
static void cb_usage (const_string str)
{
  textdomain("cweb-tl");
@.cweb-tl.mo@>
  fprintf(stderr, _("%s: Need one to three file arguments.\n"), str);
  fprintf(stderr, _("Try `%s --help' for more information.\n"), str);
@.--help@>
  textdomain("cweb");
@.cweb.mo@>
  history=fatal_message; exit(wrap_up());
}

static void cb_usagehelp (const_string *message, const_string bug_email)
{
  if (!bug_email)
    bug_email = "tex-k@@tug.org";
  textdomain("web2c-help");
@.web2c-help.mo@>
  while (*message) {
    printf("%s\n", strcmp("", *message) ? _(*message) : *message);
    ++message;
  }
  textdomain("cweb-tl");
@.cweb-tl.mo@>
  printf(_("\nEmail bug reports to %s.\n"), bug_email);
  textdomain("cweb");
@.cweb.mo@>
  history=spotless; exit(wrap_up());
}

@ Will have to change these if the version numbers change (ouch).

@d ctangle_banner "CTANGLE (CWEBBIN, TeX Live 2019/dev) 3.64"
@d cweave_banner "CWEAVE (CWEBBIN, TeX Live 2019/dev) 3.64"

@<Display version information and exit@>={
  puts(program==ctangle ? ctangle_banner : cweave_banner);
@.--version@>
  puts("Copyright 2019 Silvio Levy and Donald E. Knuth");
  history=spotless; exit(wrap_up());
}

@** Index.
@z
