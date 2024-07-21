#!/bin/csh -f

set localdir=`/usr/bin/dirname $0`
echo "Comparing:: $localdir  to  ~/"

# Get A list of files
# Loop Over Files
foreach file ( `ls $localdir` )
# Check for non-loop files
#    echo $file

# Check for files that aren't in ~/ 
    switch ($file)
        case 'filetypes.vim':
            echo "Checking: $file"
            diff $file ~/.vim/$file
            breaksw
        case 'init.lua':
            echo "Checking: $file"
            diff $file ~/.config/nvim/$file
            breaksw
        case 'install.sh':
            breaksw
        case 'check.csh':
            breaksw
        case 'LICENSE':
            breaksw
        case 'README.md':
            breaksw
        case 'vim-Readme.log'
            breaksw
        default:
            echo "Checking: $file"
            diff $file ~/.$file
            breaksw
        endsw
end
