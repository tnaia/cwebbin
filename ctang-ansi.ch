Changes for CTANGLE.W by Andreas Scherer et al.

This set of changes converts the CTANGLE.W module into ANSI-C and C++ code.
All functions are both declared and defined in prototypical form, while
several functions are declared `static' instead of `extern'.  At several
places additional casts are introduced and `char *' is replaced by
`void *', the default pointer type in ANSI-C.

This is a standalone change file, although CTANG-PATCH.CH should be applied
as well to bump the revision information.

For a complete history of the changes made to CTANGLE.W see CTANG-PATCH.CH.

Material in limbo.

@x l.49
@s not_eq normal @q unreserve a C++ keyword @>
@y
@z

Section 2.

@x l.72
@ We predeclare several standard system functions here instead of including
their system header files, because the names of the header files are not as
standard as the names of the functions. (For example, some \CEE/ environments
have \.{<string.h>} where others have \.{<strings.h>}.)

@<Predecl...@>=
extern int strlen(); /* length of string */
extern int strcmp(); /* compare strings lexicographically */
extern char* strcpy(); /* copy one string to another */
extern int strncmp(); /* compare up to $n$ string characters */
extern char* strncpy(); /* copy up to $n$ string characters */
@y
@ For string handling we include the {\mc ANSI C} system header file instead
of predeclaring the standard system functions |strlen|, |strcmp|, |strcpy|,
|strncmp|, and |strncpy|.
@^system dependencies@>

@<Include files@>=
#include <string.h>
@z

Section 3.

@x l.92
int main (ac, av)
int ac;
char **av;
@y
int main (
int ac,
char **av)
@z

Section 4.

@x l.100
  if (show_banner) printf(banner); /* print a ``banner line'' */
@y
  if (show_banner) puts(banner); /* print a ``banner line'' */
@z

Sections 5--15.

@x l.127
@i common.h
@y
@i comm-foo.h
@z

Section 16.

@x l.148
If your machine does not support |unsigned char| you should change
the definition of \&{eight\_bits} to |unsigned short|.
@^system dependencies@>
@y
@z

Section 20.

@x l.178
name_dir->equiv=(char *)text_info; /* the undefined section has no replacement text */
@y
init_node(name_dir); /* the undefined section has no replacement text */
@z

Section 21.

@x l.184
int names_match(p,first,l)
name_pointer p; /* points to the proposed match */
char *first; /* position of first character of string */
int l; /* length of identifier */
{
@y
boolean names_match(@t\1\1@>
name_pointer p, /* points to the proposed match */
const char *first, /* position of first character of string */
size_t l, /* length of identifier */
eight_bits t@t\2\2@>) /* not used by \.{TANGLE} */
{@+(void)t;
@z

Section 22.

@x l.199
void
init_node(node)
name_pointer node;
@y
void
init_node(
name_pointer node)
@z

@x l.203
    node->equiv=(char *)text_info;
@y
    node->equiv=(void *)text_info;
@z

Section 22.

@x l.205
void
init_p() {}
@y
void
init_p(name_pointer p,eight_bits t) {@+(void)p;@+(void)t;@+}
@z

Section 26.

@x l.261
void
store_two_bytes(x)
sixteen_bits x;
@y
static void
store_two_bytes(
sixteen_bits x)
@z

Section 30.

@x l.337
void
push_level(p) /* suspends the current level */
name_pointer p;
@y
static void
push_level(@t\1\1@> /* suspends the current level */
name_pointer p@t\2\2@>)
@z

Section 31.

@x l.356
void
pop_level(flag) /* do this when |cur_byte| reaches |cur_end| */
int flag; /* |flag==0| means we are in |output_defs| */
@y
static void
pop_level(@t\1\1@> /* do this when |cur_byte| reaches |cur_end| */
int flag@t\2\2@>) /* |flag==0| means we are in |output_defs| */
@z

Section 33.

@x l.392
void
get_output() /* sends next token to |out_char| */
@y
static void
get_output(void) /* sends next token to |out_char| */
@z

Section 34.

@x l.426
  if ((a+name_dir)->equiv!=(char *)text_info) push_level(a+name_dir);
@y
  if ((a+name_dir)->equiv!=(void *)text_info) push_level(a+name_dir);
@z

Section 37.

@x l.482
void
flush_buffer() /* writes one line to output file */
@y
static void
flush_buffer(void) /* writes one line to output file */
@z

Section 41.

@x l.534
void phase_two();
@y
static void phase_two(void);@/
@z

Section 42.

@x l.537
void
phase_two () {
@y
static void
phase_two (void) {
@z

Section 46.

@x l.603
void output_defs();
@y
static void output_defs(void);@/
@z

Section 47.

@x l.606
void
output_defs()
@y
static void
output_defs(void)
@z

Section 48.

@x l.649
static void out_char();
@y
static void out_char(eight_bits);@/
@z

Section 49.

@x l.652
static void
out_char(cur_char)
eight_bits cur_char;
@y
static void
out_char(
eight_bits cur_char)
@z

Section 50.

@x l.690
case not_eq: C_putc('!');@+C_putc('='); out_state=normal; break;
@y
case non_eq: C_putc('!');@+C_putc('='); out_state=normal; break;
@z

Section 58.

@x l.814
eight_bits
skip_ahead() /* skip to next control code */
@y
static eight_bits
skip_ahead(void) /* skip to next control code */
@z

Section 60.

@x l.849
int skip_comment(is_long_comment) /* skips over comments */
boolean is_long_comment;
@y
static boolean skip_comment(@t\1\1@> /* skips over comments */
boolean is_long_comment@t\2\2@>)
@z

Section 63.

@x l.901
eight_bits
get_next() /* produces the next input token */
@y
static eight_bits
get_next(void) /* produces the next input token */
@z

Section 64.

@x l.954
    else if (*loc=='>') if (*(loc+1)=='*') {loc++; compress(minus_gt_ast);}
                        else compress(minus_gt); break;
@y
    else { if (*loc=='>') { if (*(loc+1)=='*') {loc++; compress(minus_gt_ast);}
                        else compress(minus_gt); } } break;
@z

@x l.969
  case '!': if (*loc=='=') compress(not_eq); break;
@y
  case '!': if (*loc=='=') compress(non_eq); break;
@z

Section 65.

@x l.974
  while (isalpha(*++loc) || isdigit(*loc) || isxalpha(*loc) || ishigh(*loc));
@y
  while (isalpha((eight_bits)*++loc) || isdigit((eight_bits)*loc) @|
      || isxalpha((eight_bits)*loc) || ishigh((eight_bits)*loc));
@z

Section 76.

@x l.1200
void
scan_repl(t) /* creates a replacement text */
eight_bits t;
@y
static void
scan_repl(@t\1\1@> /* creates a replacement text */
eight_bits t@t\2\2@>)
@z

Section 77.

@x l.1235 -- rename local var, not to shadow previous local
{int a=id_lookup(id_first,id_loc,0)-name_dir; app_repl((a / 0400)+0200);
  app_repl(a % 0400);}
@y
{int a_l=id_lookup(id_first,id_loc,0)-name_dir; app_repl((a_l / 0400)+0200);
  app_repl(a_l % 0400);}
@z

Section 81.

@x l.1323
        c=toupper(*id_first)-'A'+10;
@y
        c=toupper((eight_bits)*id_first)-'A'+10;
@z

@x l.1328
        c=16*c+toupper(*id_first)-'A'+10;
@y
        c=16*c+toupper((eight_bits)*id_first)-'A'+10;
@z

Section 83.

@x l.1361
void
scan_section()
@y
static void
scan_section(void)
@z

Section 89.

@x l.1449
else if (p->equiv==(char *)text_info) p->equiv=(char *)cur_text;
@y
else if (p->equiv==(void *)text_info) p->equiv=(void *)cur_text;
@z

Section 90.

@x l.1461
void phase_one();
@y
static void phase_one(void);@/
@z

Section 91.

@x l.1464
void
phase_one() {
@y
static void
phase_one(void) {
@z

Section 92.

@x l.1479
void skip_limbo();
@y
static void skip_limbo(void);@/
@z

Section 93.

@x l.1482
void
skip_limbo()
@y
static void
skip_limbo(void)
@z

Section 94.

@x l.1528
      strncpy(translit[i-0200],beg,loc-beg);
@y
      strncpy(translit[i-0200],beg,(size_t)(loc-beg));
@z

Section 95.

@x l.1537
void
print_stats() {
@y
void
print_stats(void) {
@z

Additional material.

@x l.1550
@** Index.
@y
@* Function declarations.  Here are declarations---conforming to
{\mc ANSI~C}---of all functions in this code, as far as they are
not already in |"common.h"|.  These are private to \.{CTANGLE}.

@<Predecl...@>=
static eight_bits get_next(void);@/
static eight_bits skip_ahead(void);@/
static boolean skip_comment(boolean);@/
static void flush_buffer(void);@/
static void get_output(void);@/
static void pop_level(int);@/
static void push_level(name_pointer);@/
static void scan_repl(eight_bits);@/
static void scan_section(void);@/
static void store_two_bytes(sixteen_bits);@/

@** Index.
@z
