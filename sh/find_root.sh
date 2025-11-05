#!/bin/sh

LEVELS=(
    "BSc"
    "MSc"
    "PhD"
)

pwd=$(pwd | tr '[:upper:]' '[:lower:]')

level=""
count=0
for l in "${LEVELS[@]}"; do
    l_lower=$(echo "$l" | tr '[:upper:]' '[:lower:]')
    if echo "$pwd" | grep -q "$l_lower"; then
        level="$l"
        count=$((count + 1))
    fi
done

if [ "$count" != 1 ]; then
    exit 1
fi

if [ -z "${!level}" ]; then
    echo "Environment variable '$level' does not exist."
    exit -1
fi

eval echo "\${$level}"
