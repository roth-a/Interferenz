#!/bin/bash


git status 
defaultmessage=$(git log -1 | tail -n +5)
txt=$(echo "$defaultmessage"  | zenity --text-info --editable       --title="Description of your commit"  --width 600 --height 600)
git add --all
git commit -m "$txt"

echo "------------------------------------------------------------------------------"
echo "Committed with "
echo "$txt"
echo "------------------------------------------------------------------------------"
