## @file
## @author Guillaume Foreau <ayowel@noreply.github.com>
## @copyright CC-BY
## @brief Contains definitions of resources required or referenced by #argument_parsing_assistant     that do not have to be defined in normal use

## Whether detection of short options should be attempted (0) or not (1)
declare -i ARGPARSE_SHORT_OPTION_ENABLE=0

## Whether detection of long options should be attempted (0) or not (1)
declare -i ARGPARSE_LONG_OPTION_ENABLE=0

## An array of prefixes to use to recognise a short parameter
declare -a ARGPARSE_SHORT_OPTION_PREFIX=( - )

## An array of prefixes to use to recognise a long parameter
declare -a ARGPARSE_LONG_OPTION_PREFIX=( -- )

## If not empty, replace the user-provided prefix on short options to this
declare ARGPARSE_SHORT_OPTION_NORMALIZED_PREFIX=""

## If not empty, replace the user-provided prefix on long options to this
declare ARGPARSE_LONG_OPTION_NORMALIZED_PREFIX=""

## What string should be used to detect distinguish between option and value section in long options when it is provided as a single parameter 
declare ARGPARSE_LONG_OPTION_FIELD_SEPARATOR="="

## @fn argument_parsing_assistant_virtual_callback()
## @brief A handler function called by #argument_parsing_assistant to parse option
## @param option The option string received as parameter (or the empty string if parsing a parameter)
## @param parameter The value to use if one is required when handling the option
## @param is_monoparameter Whether the option and value were received as a single parameter from the command-line or were already split
## @return
##    * 1 if only the option (or parameter if no option was provided) was consumed
##    * 0 or 2 if the parameter was consumed
##    * any other value if an error occured
function argument_parsing_assistant_virtual_callback() {
  # Template method for documentation
  local option="$1"
  local value="$2"
  local is_monoparameter="$3"
}