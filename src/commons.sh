## @file
## @brief Common utility functions

## @fn merge_parameters()
## @brief Merge parameters received with the first parameter
## @internal
## @param merge_key String to insert between each merged item
## @param items... Strings to merge
## @return Merged string
function merge_parameters() {
  local merge_key="$1"
  shift
  if test "$#" -eq 0; then
    return
  fi

  local value="$1"
  shift
  echo -n "$value"
  for value in "$@"; do
    # Ignore empty strings
    test -z "$value" || echo -n "${merge_key}${value}"
  done
}

## @fn fatal()
## @brief Exit script with an error message
## @param message Error message to print
## @param retVal Script exit value
function fatal() {
  local message="$1"
  local retVal="$2"
  
  if test -n "$message"; then
    echo "[FATAL] $message" >&2:
  fi
  exit "$retVal"
}

## @fn filelog()
## @brief Log command's output to a file
## @param log_file Output log file to write to
## @param error_file Error log file to output to (If not provided, defaults to \p log_file )
## @param exec_command... Command to execute
## @return Return value of the function called
## @note If \p log_file and \p error_file are identical, all outputted logs will go to stdout
## @note If LOG_STRATEGY is 'add', the output file will be appended to
function filelog() {
  local log_file="$1"
  local error_file="${2:-$log_file}"
  shift; shift

  local tee_arg=( )
  if test "$LOG_STRATEGY" == add; then
    tee_arg=( -a )
  fi

  if test "$log_file" == "$error_file"; then
    { "$@" 2>&1 ; } > >(tee "${tee_arg[@]}" "$log_file")
  else
    "$@" > >(tee "${tee_arg[@]}" "$log_file") 2> >(tee "${tee_arg[@]}" "$error_file" >&2)
  fi
}
