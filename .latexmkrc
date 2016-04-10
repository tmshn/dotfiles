#!/usr/bin/env perl
$latex      = 'platex %O -synctex=1 -guess-input-enc %S -halt-on-error';
$bibtex     = 'pbibtex %O %B';
$dvipdf     = 'dvipdfmx %O -o %D %S';
$makeindex  = 'mendex %O -o %D -U %S';
$max_repeat = 5;
$pdf_mode   = 3;


# Prevent latexmk from removing PDF after typeset.
$pvc_view_file_via_temporary = 0;
# Use SumatraPDF as a previewer
$pdf_previewer = '"C:\Program Files (x86)\SumatraPDF\SumatraPDF.exe" -reuse-instance';
