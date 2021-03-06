Changes for CTANGLE.W by Andreas Scherer, November 1, 2018.

This set of changes modifies the output behaviour of the CWEB system.
Instead of writing directly to the C or TeX file as described in the
manual, the current run is documented in a temporary output file which is
copied to the expected file in the last moment.  In case of an user abort,
previous results are not destroyed.

This change file requires CTANG-PATCH.CH, CTANG-ANSI.CH, and
CTANG-EXTENSIONS.CH to be applied as well.

For a complete history of the changes made to CTANGLE.W see CTANG-PATCH.CH.

Section 43.

@x l.572
@<Write all the named output files@>=
for (an_output_file=end_output_files; an_output_file>cur_out_file;) {
    an_output_file--;
    sprint_section_name(output_file_name,*an_output_file);
    fclose(C_file);
    C_file=fopen(output_file_name,"w");
    if (C_file ==0) fatal("! Cannot open output file:",output_file_name);
@.Cannot open output file@>
    if (show_progress) { printf("\n(%s)",output_file_name); update_terminal; }
    cur_line=1;
    stack_ptr=stack+1;
    cur_name= (*an_output_file);
    cur_repl= (text_pointer)cur_name->equiv;
    cur_byte=cur_repl->tok_start;
    cur_end=(cur_repl+1)->tok_start;
    while (stack_ptr > stack) get_output();
    flush_buffer();
}
@y
@<Write all the named output files@>=
fclose(C_file); C_file=NULL;
@<Update the primary result when it has changed@>@;
for (an_output_file=end_output_files; an_output_file>cur_out_file;) {
    an_output_file--;
    sprint_section_name(output_file_name,*an_output_file);
    if((C_file=fopen(check_file_name,"wb"))==NULL)
      fatal("! Cannot open output file ",check_file_name);
@.Cannot open output file@>
    if (show_progress) { printf("\n(%s)",output_file_name); update_terminal; }
    cur_line=1;
    stack_ptr=stack+1;
    cur_name= (*an_output_file);
    cur_repl= (text_pointer)cur_name->equiv;
    cur_byte=cur_repl->tok_start;
    cur_end=(cur_repl+1)->tok_start;
    while (stack_ptr > stack) get_output();
    flush_buffer(); fclose(C_file); C_file=NULL;
    @<Update the secondary results when they have changed@>@;
}
strcpy(check_file_name,""); /* We want to get rid of the temporary file */
@z

Additional material.

@x l.1550
@** Index.
@y
@* Output file update.  Most \CEE/ projects are controlled by a
\.{Makefile} that automatically takes care of the temporal dependecies
between the different source modules.  It is suitable that \.{CWEB} doesn't
create new output for all existing files, when there are only changes to
some of them. Thus the \.{make} process will only recompile those modules
where necessary. The idea and basic implementation of this mechanism can
be found in the program \.{NUWEB} by Preston Briggs, to whom credit is due.

@<Update the primary result...@>=
if((C_file=fopen(C_file_name,"r"))!=NULL) {
  @<Set up the comparison of temporary output@>@;
  @<Create the primary output depending on the comparison@>@;
} else
  rename(check_file_name,C_file_name); /* This was the first run */

@ @<Set up the comparison of temporary output@>=
  char x[BUFSIZ],y[BUFSIZ];
  int x_size,y_size,comparison;

  if((check_file=fopen(check_file_name,"r"))==NULL)
    fatal("! Cannot open output file ",check_file_name);
@.Cannot open output file@>

  @<Compare the temporary output to the previous output@>@;

  fclose(C_file); C_file=NULL;
  fclose(check_file); check_file=NULL;

@ We hope that this runs fast on most systems.

@<Compare the temp...@>=
do {
  x_size = fread(x,1,BUFSIZ,C_file);
  y_size = fread(y,1,BUFSIZ,check_file);
  comparison = (x_size == y_size); /* Do not merge these statements! */
  if(comparison) comparison = !memcmp(x,y,x_size);
} while(comparison && !feof(C_file) && !feof(check_file));

@ Note the superfluous call to |remove| before |rename|.  We're using it to
get around a bug in some implementations of |rename|.

@<Create the primary output...@>=
if(comparison)
  remove(check_file_name); /* The output remains untouched */
else {
  remove(C_file_name);
  rename(check_file_name,C_file_name);
}

@ @<Update the secondary results...@>=
if((C_file=fopen(output_file_name,"r"))!=NULL) {
  @<Set up the comparison of temporary output@>@;
  @<Create the secondary output depending on the comparison@>@;
} else
  rename(check_file_name,output_file_name); /* This was the first run */

@ Again, we use a call to |remove| before |rename|.

@<Create the secondary output...@>=
if(comparison)
  remove(check_file_name); /* The output remains untouched */
else {
  remove(output_file_name);
  rename(check_file_name,output_file_name);
}

@** Index.
@z
