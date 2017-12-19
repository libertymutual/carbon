#/bin/bash
#This file setups the pre-commit hook for git which the specified scripts below.

#variables
hook_file="pre-commit";

#cd to .git directory
cd "${0%/*}/../.git/hooks"

#Check if the file exists before we add it
if [ ! -e $hook_file ]; then
    touch $hook_file && chmod +x $hook_file

    #Setup file
    echo "Creating pre-commit file"
    echo "#/bin/bash" >> $hook_file  
fi

#Function to handle adding in pre-commits
function append_precommit ()
{
    #Check if string exists in file
    if ! grep -q $1 $hook_file
    then
        #modify file to add scripts to run
        echo "sh $1" >> $hook_file
    fi
}

#Add pre-commit scripts here
append_precommit scripts/git/hooks/pre-commit.sh
