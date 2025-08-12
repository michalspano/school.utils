# School.Utils

# WIP

Custom utility tools written in `POSIX sh` to enhance students' studies.

<!-- We have to set up at least one of these env. variables `BSC`, `MSC`, `PHD`. -->

Call `./find_root.sh` to get BSC, MSC, PHD. Example usage in script:

```sh
level_root=$(./find_root.sh) || { echo "Error: Failed to run find_root.sh"; exit 1; }
[ -n "$level_root" ]         || { echo "Error: No path returned by find_root.sh"; exit 1; }
```

This will determine the root of the project for you. Ensure that the script is accessible when calling it on the first line (e.g., place it to `/user/local/bin` for simplicity, then remove the prefix `./`).
