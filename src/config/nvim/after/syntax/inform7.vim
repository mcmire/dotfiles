" vim-inform7's Fold regions declare `contains=ALL` / `contains=ALLBUT,...`,
" which bypasses the `contained` flag on i7Substitution and makes it
" available at the top level everywhere a Book/Volume/Part/Chapter/Section
" fold is active (i.e. almost the whole file). Since i7Substitution shares
" i7Comment's start pattern (\[) but is declared after it, it wins Vim's
" same-position tie-break, so nested comments stop recognizing themselves
" and close at the first `]` instead of properly nesting. Re-declare the
" Fold regions excluding i7Substitution to fix this.
syn clear i7VolumeFold i7BookFold i7PartFold i7ChapterFold i7SectionFold
syn region i7VolumeFold start=/\n^[vV]olume\s/ end=/\ze\n^[vV]olume/ fold transparent contains=ALLBUT,i7Substitution keepend
syn region i7BookFold start=/\n^[bB]ook\s/ end=/\ze\n^[bB]ook/ fold transparent contains=ALLBUT,i7VolumeFold,i7Substitution keepend
syn region i7PartFold start=/\n^[pP]art\s/ end=/\ze\n^[pP]art/ fold transparent contains=ALLBUT,i7VolumeFold,i7BookFold,i7Substitution keepend
syn region i7ChapterFold start=/\n^[cC]hapter\s/ end=/\ze\n^[cC]hapter/ fold transparent contains=ALLBUT,i7VolumeFold,i7BookFold,i7PartFold,i7Substitution keepend
syn region i7SectionFold start=/\n^[sS]ection\s/ end=/\ze\n^[sS]ection/ fold transparent contains=ALLBUT,i7VolumeFold,i7BookFold,i7PartFold,i7ChapterFold,i7Substitution keepend
