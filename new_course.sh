#!/bin/sh

proj_root=$(./find_root.sh) || { echo "Error: Failed to run find_root.sh";       exit 1; }
[ -n "$proj_root" ]         || { echo "Error: No name returned by find_root.sh"; exit 1; }

course="$1"
acronym="$2"
json_file=$proj_root/courses.json

if [ ! -f "$json_file" ]; then
    echo "{}" > "$json_file"
fi

if jq -e "has(\"$course\")" "$json_file" >/dev/null; then
    echo "Error: Key '$course' already exists in $json_file"
    exit 1
fi

if jq --arg k "$course" --arg v "$acronym" '.[$k] = $v' "$json_file" > "$json_file.tmp"; then
    mv "$json_file.tmp" "$json_file"
    echo "Successfully added {\"$course\":\"$acronym\"} to $json_file"
else
    echo "Error writing to $json_file"
    rm -f "$json_file.tmp"
    exit 1
fi

DIR=$proj_root
mkdir -p $DIR/courses/$course
mkdir -p $DIR/courses/$key/literature
mkdir -p $DIR/courses/$key/notes
mkdir -p $DIR/courses/$key/notes/handwritten
mkdir -p $DIR/courses/$key/notes/exp
mkdir -p $DIR/courses/$key/notes/src
echo "*\n*/\n!.gitignore" >> $DIR/courses/$key/literature/.gitignore
echo "*\n*/\n!.gitignore" >> $DIR/courses/$key/notes/handwritten/.gitignore
echo "*\n*/\n!.gitignore" >> $DIR/courses/$key/notes/exp/.gitignore
