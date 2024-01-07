#!/bin/bash

if [ $# -eq 0 ]; then
  echo "Usage: $0 <filename>"
  exit 1
fi

filename="$1"

echo "Searching for files matching: $filename"
found_files=$(find / -type f -name "$filename" 2>/dev/null)  #redirect the error messages to /dev/null.

if [ -z "$found_files" ]; then        #if nothing has been found 
  echo "No files found matching: $filename"
else
  echo "Found files:"
  echo "$found_files"
fi

exit 0


 
