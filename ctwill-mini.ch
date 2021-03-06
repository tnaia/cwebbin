@x
The information that \.{CTWILL} concocts from \.{foo.w} is not always
correct. Sometimes you'll use an identifier that you don't want
indexed; for example, your exposition might talk about |f(x)| when you
don't mean to refer to program variables |f| or |x|. Sometimes you'll
use an identifier that's defined in a header file, unknown to
\.{CTWILL}. Sometimes you'll define a single identifier in several
different places, and \.{CTWILL} won't know which definition to choose.
But all is not lost. \.{CTWILL} guesses right most of the time, and you can
give it the necessary hints in other places via your change file.
@y
The information that \.{CTWILL} concocts from \.{foo.w} is not always
correct. Sometimes you'll use an identifier that you don't want
indexed; for example, your exposition might talk about |f(x)| when you
don't mean to refer to program variables |f| or |x|. Sometimes you'll
use an identifier that's defined in a header file, unknown to
\.{CTWILL}. Sometimes you'll define a single identifier in several
different places, and \.{CTWILL} won't know which definition to choose.
But all is not lost. \.{CTWILL} guesses right most of the time, and you can
give it the necessary hints in other places via your change file.
@-f@>
@-x@>
@z

@x
@i prod-twill.w
@y
@i prod-twill.w
@-any@>
@-any_other@>
@-g@>
@-in@>
@-z@>
@z
