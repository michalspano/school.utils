#!/bin/sh

if ! command -v jq >/dev/null 2>&1; then
    echo "Error: jq is not installed"
    exit 1
fi

if [ "$#" -ne 1 ]; then
    echo "Usage: $0 key"
    exit 1
fi

level_root=$(./find_root.sh) || { echo "Error: Failed to run find_root.sh";       exit 1; }
[ -n "$level_root" ]         || { echo "Error: No name returned by find_root.sh"; exit 1; }

course="$1"
courses_json=$level_root/courses.json

if [ ! -f "$courses_json" ]; then
    echo "Error: $courses_json does not exist"
    exit 1
fi

value=$(jq -r --arg k "$course" '.[$k] // null' "$courses_json")

if [ "$value" = "null" ]; then
    echo "Error: Course: '$course' not found."
    exit 1
fi

notes_src_filepath=$level_root/courses/$key/notes/src

if [ ! -d "$notes_src_filepath" ]; then
    echo "Error: Directory $notes_src_filepath does not exist"
    exit 1
fi

files=$(ls "$notes_src_filepath"/lecture-[0-9][0-9].md 2>/dev/null)

# Found no file yet!
if [ -z "$files" ]; then
    touch "$notes_src_filepath/lecture-01.md"
    echo "Created $notes_src_filepath/lecture-01.md"
    exit 0
fi

last_file=$(echo "$files" | tr ' ' '\n' | sort | tail -n 1)
idx=$(echo "$last_file" | sed -n 's/^.*lecture-\([0-9][0-9]\)\.md$/\1/p')
next_num=$((idx + 1))
next_num=$(printf "%02d" "$next_num")

new_file="$notes_src_filepath/lecture-$next_num.md"
touch "$new_file"

if [ -f "$new_file" ]; then
    echo "Created $new_file"
else
    echo "Error: Failed to create $new_file"
    exit 1
fi
