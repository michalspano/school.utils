# School.Utils

This repository contains some utility scripts written in `POSIX sh` that are useful for students, namely for knowledge management and if you want to keep organized! All scripts are placed to `sh/*`. Clone the repo and save them to wherever is convenient.

## Pre-requisites

- The [`jq`](https://jqlang.org/) command-line JSON processor is used to manipulate the underlying `JSON` file to manage present courses.
- [`pandoc`](https://pandoc.org/) is used to convert `*.md` -> `*.pdf` on `Markdown` notes.
- Read [`find_root.sh`](#find_root.sh) below.

## convert_to_pdf.sh

This script requires a `course_code` as an argument. It will compile `*.md` notes (from the course) to `*.pdf` files.

**Optional**: if you want to merge all `PDF`s on the go, [Ghostscript](https://www.ghostscript.com/) is required. Pass the `--merge` or `-m` flag for this!

## find_root.sh

This script is used to automatically detect the "root" directory what level of studies (i.e., `BSc`, `MSc`, `PhD`) you're currently working on (based on your current path). E.g. `/Users/foo/bar/baz/MSc/something/else` detects that the user is under `MSc` and will output `$MSc` - which should in this case be set to `/Users/foo/bar/baz/MSc`.

Also, make sure that the script can be called **globally** (in your shell); add it to `PATH` or simply copy/symlink it to, e.g., `user/local/bin/` (depending on your system).

## new_course.sh

This will create a new entry to `courses.json` given a `course_code` and a `course_acronym`. It will also create the following file structure for the new course:

```
$DIR/courses/$course
$DIR/courses/$course/literature
$DIR/courses/$course/notes
$DIR/courses/$course/notes/handwritten
$DIR/courses/$course/notes/exp
$DIR/courses/$course/notes/src
$DIR/courses/$course/pset
$DIR/courses/$course/misc
```

## new_note.sh

This script will create a new `Markdown` file to type lecture notes to; the files are sorted numerically in ascending order, always with a `lecture-XX` prefix. The script will detect the ordinal of the latest `Markdown` entry, and create a new file with `+1` added to the number.

The script will also add `YAML` header to the file which is elegant when rendering with `pandoc`!