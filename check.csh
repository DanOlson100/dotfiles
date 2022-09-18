#!/bin/csh -f

set localdir=`/usr/bin/dirname $0`
echo "Working from:: $localdir  to  ~/"

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
        case 'install.sh':
            breaksw
        case 'check.csh':
            breaksw
        case 'LICENSE':
            breaksw
        case 'README.md':
            breaksw
        default:
            echo "Checking: $file"
            diff $file ~/.$file
            breaksw
        endsw
end
