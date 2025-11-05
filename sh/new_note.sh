#!/bin/sh

if ! command -v jq >/dev/null 2>&1; then
    echo "Error: jq is not installed"
    exit 1
fi

if [ "$#" -ne 1 ]; then
    echo "Usage: $0 course_code"
    exit 1
fi

level_root=$(find_root.sh) || { echo "Error: Failed to run find_root.sh";       exit 1; }
[ -n "$level_root" ]       || { echo "Error: No name returned by find_root.sh"; exit 1; }

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

notes_src_filepath=$level_root/courses/$course/notes/src

if [ ! -d "$notes_src_filepath" ]; then
    echo "Error: Directory $notes_src_filepath does not exist"
    exit 1
fi

files=$(ls "$notes_src_filepath"/lecture-[0-9][0-9].md 2>/dev/null)

new_file=""

# Found no file yet!
if [ -z "$files" ]; then
    new_file="$notes_src_filepath/lecture-01.md"
else
    last_file=$(echo "$files" | tr ' ' '\n' | sort | tail -n 1)
    idx=$(echo "$last_file" | sed -n 's/^.*lecture-\([0-9][0-9]\)\.md$/\1/p')
    next_num=$((idx + 1))
    next_num=$(printf "%02d" "$next_num")

    new_file="$notes_src_filepath/lecture-$next_num.md"
fi

touch "$new_file"

if [ -f "$new_file" ]; then
    echo   "---"                                    >> "$new_file"
    printf "title: $course TODO title\n"            >> "$new_file"
    printf "author: Michal Spano\n"                 >> "$new_file"
    printf "date: $(date +%Y-%m-%d)\n"              >> "$new_file"
    printf "header-includes: |\n"                   >> "$new_file"
    printf "    \\\usepackage{fancyhdr}\n"          >> "$new_file"
    printf "    \\\pagestyle{fancy}\n"              >> "$new_file"
    printf "    \\\fancyhead[CO,CE]{TODO: title}\n" >> "$new_file"
    printf "    \\\fancyfoot[CO,CE]{\\\textsc{$course}, $(date +%Y)}\n" >> "$new_file"
    printf "    \\\fancyfoot[LE,RO]{\\\thepage}\n"  >> "$new_file"
    printf "papersize: a4\n"                        >> "$new_file"
    printf "fontsize: 12pt\n"                       >> "$new_file"
    printf "colorlinks: true\n"                     >> "$new_file"
    printf "geometry: margin=1.5cm\n"               >> "$new_file"
    printf "output: pdf_document\n"                 >> "$new_file"
    echo "---"                                      >> "$new_file"

    echo "Created $new_file"
else
    echo "Error: Failed to create $new_file"
    exit 1
fi
