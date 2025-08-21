#!/bin/sh

if ! command -v jq >/dev/null 2>&1; then
    echo "Error: jq is not installed"
    exit 1
fi

merge=false
key=""

# Parse arguments
while [ $# -gt 0 ]; do
    case $1 in
        --merge|-m)
            merge=true
            shift
            ;;
        *)
            if [ -n "$key" ]; then
                echo "Usage: $0 [--merge|-m] key"
                exit 1
            fi
            key="$1"
            shift
            ;;
    esac
done

if [ -z "$key" ]; then
    echo "Usage: $0 [--merge|-m] key"
    exit 1
fi

level_root=$(./find_root.sh) || { echo "Error: Failed to run find_root.sh"; exit 1; }
[ -n "$level_root" ]         || { echo "Error: No name returned by find_root.sh"; exit 1; }

json_file=$level_root/courses.json

if [ ! -f "$json_file" ]; then
    echo "Error: $json_file does not exist"
    exit 1
fi

value=$(jq -r --arg k "$key" '.[$k] // null' "$json_file")

if [ "$value" = "null" ]; then
    echo "Error: Key '$key' not found in $json_file"
    exit 1
fi

course_notes=$level_root/courses/$key/notes

for file in $(ls "$course_notes/src"/*.md 2>/dev/null | sort); do
    filename=$(basename "$file" .md)
    echo "$key: $filename"
    pandoc -o "$course_notes/exp/$filename.pdf" "$file"
done

if [ "$merge" = true ]; then
    if ! command -v gs >/dev/null 2>&1; then
        echo "Error: gs (Ghostscript) is not installed"
        exit 1
    fi
    pdfs=$(ls "$course_notes/exp"/*.pdf 2>/dev/null | sort)
    if [ -n "$pdfs" ]; then
        gs -dBATCH -dNOPAUSE -q -sDEVICE=pdfwrite -sOutputFile="$level_root/courses/$key/$key-complete.pdf" $pdfs
    else
        echo "No PDF files to merge"
    fi
fi
