#!/usr/bin/env shellspec -f tap

Describe 'argument_parser'
  Include src/argument_parser.sh
  arg_handler() {
    echo "Received $*"
    case "$1$2" in
      *z*)
        return 0
        ;;
      *y*)
        return 1
        ;;
      *)
        return 2
        ;;
    esac
  }
  It 'Call without callback function and parameters'
    When call argument_parsing_assistant
    The status should be failure
    The stderr should not equal ''
  End
  It 'Call without parameters'
    When call argument_parsing_assistant arg_handler
    The status should be success
    The output should equal ''
  End
  It 'Call without option parameters'
    When call argument_parsing_assistant arg_handler arg1 arg2 arg3
    The status should be success
    The line 1 of the output should equal 'Received  arg1 1'
    The line 2 of the output should equal 'Received  arg2 1'
    The line 3 of the output should equal 'Received  arg3 1'
    The line 4 of the output should be undefined
  End
  It 'Simple call with greedy options'
    When call argument_parsing_assistant arg_handler --opt arg1 -o arg2 arg3
    The status should be success
    The line 1 of the output should equal 'Received --opt arg1 1'
    The line 2 of the output should equal 'Received -o arg2 1'
    The line 3 of the output should equal 'Received  arg3 1'
    The line 4 of the output should be undefined
  End
  It 'Simple call with greedy single-arg options'
    When call argument_parsing_assistant arg_handler --opt=arg1 -oarg2 arg3
    The status should be success
    The line 1 of the output should equal 'Received --opt arg1 0'
    The line 2 of the output should equal 'Received -o arg2 0'
    The line 3 of the output should equal 'Received  arg3 1'
    The line 4 of the output should be undefined
  End
  It 'Multiple single-char options'
    When call argument_parsing_assistant arg_handler -osh -hey 3 -oyo
    The status should be success
    The line 1 of the output should equal 'Received -o sh 0'
    The line 2 of the output should equal 'Received -h ey 0'
    The line 3 of the output should equal 'Received -e y 0'
    The line 4 of the output should equal 'Received -y 3 1'
    The line 5 of the output should equal 'Received  3 1'
    The line 6 of the output should equal 'Received -o yo 0'
    The line 7 of the output should equal 'Received -y o 0'
    The line 8 of the output should equal 'Received -o  1'
    The line 9 of the output should be undefined
  End
  It 'Return immediately on unsupported error code'
    failing_handler() {
      return ${2:-1}
    }
    When call argument_parsing_assistant failing_handler 3
    The status should equal 3
    The output should equal ''
  End
  It 'Overload expected option prefix string'
    caller() {
      ARGPARSE_SHORT_OPTION_NORMALIZED_PREFIX=/ ARGPARSE_LONG_OPTION_NORMALIZED_PREFIX=_ argument_parsing_assistant arg_handler -osh --tyst
    }
    When call caller
    The status should be success
    The line 1 of the output should equal 'Received /o sh 0'
    The line 2 of the output should equal 'Received _tyst  1'
    The line 3 of the output should be undefined
  End
End

