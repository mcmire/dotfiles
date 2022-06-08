" Fix Prolog syntax file to account for backslashed single quotes in atoms
syntax region prologAtom start="'" skip="\\'" end="'" oneline extend
