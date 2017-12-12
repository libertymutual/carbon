#/bin/bash
#This script will check for instances of the string Created By and or a LM username in the code
#that is being commited.

#setup variables
failed_commit="COMMIT FAILED";
warning_message="Please remove any author names or usernames from code from following files:";
no_errors_message="No errors found, proceeding with commit";
exclude_file="scripts/git/hooks/pre-commit.sh";

#setup pattern with regex
#Searches for instanced of Created By since a lot of editors will put that in by default
#Searches for any usernames that start with n or a and have atleast 4 numbers
pattern="Created By|([[Nn][0-9]{4,12}]*$)|([[Aa][0-9]{4,12}]*$)";

#navigate to root and directory
cd "${0%/*}/../../.."

echo "Running username checks"
echo "............................"

#Set count to keep track of failed files
count=0;

#Set the output so we can display is after the check is done
arr=();

#Checks only the files that are staged in git
for file in `git diff --name-only --cached`
    do
        if [ $file != $exclude_file ]; then
            if [[ $file =~ [A-z] ]]; then
                #Searches through codebase for the pattern
                output=$(grep -ilRE "$pattern" $file);
                if [[ -n $output ]]; then
                    #store data in array
                    arr[count]=$output;

                    #increment the counter
                    count=$((count+1));
                fi
            fi
        fi
    done

#Check number of errors encountered
if (( $count > 0 )); then
    #If errors are found then display them with a warning message
    set -e
    echo ${failed_commit};
    echo ${warning_message};
    for item in ${arr[*]}
        do
        echo $item
        done
    #Prevents user from commiting
    exit 1;
else
    #If there are no errors then display the message
    echo ${no_errors_message}
fi