#!/usr/bin/env shellspec -f tap
Describe 'join_by properly joins the parameters it receives'
  Include src/commons.sh
  It 'Basic usage'
    When call join_by , 1 2 3
    The output should equal '1,2,3'
  End
  It 'Empty array'
    When call join_by ,
    The output should equal ''
  End
  It 'Single item in array'
    When call join_by , a
    The output should equal 'a'
  End
  It 'Empty delimiter'
    When call join_by '' Hell o World
    The output should equal 'HelloWorld'
  End
  It 'Multi-characters delimiter'
    When call join_by '),(' '(1' 2 '3)'
    The output should equal '(1),(2),(3)'
  End
End

Describe 'fatal'
  Include src/commons.sh
  It 'Providing only a message exits with an error'
    When run fatal "I'm dead"
    The status should equal 1
    The stderr should include "I'm dead"
  End
  It 'Providing a return code != 0 exits with an error'
    When run fatal "I'm dead" 2
    The status should equal 2
    The stderr should include "I'm dead"
  End
  It 'Providing a return code == 0 exits with an error'
    When run fatal "I'm dead" 0
    The status should equal 0
    The stderr should include "I'm dead"
  End
  It 'Providing an empty message exits without printing'
    When run fatal ""
    The status should be failure
    The stderr should equal ""
  End
  It 'Not providing any parameters exits without printing'
    When run fatal
    The status should be failure
    The stderr should equal ""
  End
End

Describe 'filelog'
  Include src/commons.sh
  BeforeEach 'tmp_dir="$(mktemp -d)"'
  AfterEach 'rm -rf "$tmp_dir"'
  Mock speaker
    # Using threading, give time for buffers to clear for better reproducibility
    echo 'Test out'
    sleep 0.01
    echo 'Test err' >&2
    sleep 0.01
    exit ${1:-0}
  End
  It 'Simple logging'
    When call filelog "${tmp_dir}/out" "${tmp_dir}/err" speaker
    The status should be success
    The stdout should equal 'Test out'
    The stderr should equal 'Test err'
    The contents of the file "${tmp_dir}/out" should equal 'Test out'
    The contents of the file "${tmp_dir}/err" should equal 'Test err'
  End
  It 'Combined logging'
    When call filelog "${tmp_dir}/out" '' speaker
    The status should be success
    The line 1 of the contents of the file "${tmp_dir}/out" should equal "Test out"
    The line 2 of the contents of the file "${tmp_dir}/out" should equal "Test err"
    The stdout should equal 'Test out'
    The stderr should equal 'Test err'
  End
  It 'Return value bubble-up'
    When call filelog "${tmp_dir}/out" '' speaker 1
    The status should equal 1
    The line 1 of the contents of the file "${tmp_dir}/out" should equal "Test out"
    The line 2 of the contents of the file "${tmp_dir}/out" should equal "Test err"
    The stdout should equal 'Test out'
    The stderr should equal 'Test err'
  End
  It 'Append mode does not reset file'
    testit() {
      filelog "${tmp_dir}/out" '' speaker
      LOG_STRATEGY=add filelog "${tmp_dir}/out" '' speaker
    }
    When call testit
    The line 1 of the contents of the file "${tmp_dir}/out" should equal "Test out"
    The line 2 of the contents of the file "${tmp_dir}/out" should equal "Test err"
    The line 3 of the contents of the file "${tmp_dir}/out" should equal "Test out"
    The line 4 of the contents of the file "${tmp_dir}/out" should equal "Test err"
    The line 1 of the stdout should equal 'Test out'
    The line 2 of the stdout should equal 'Test out'
    The line 1 of the stderr should equal 'Test err'
    The line 2 of the stderr should equal 'Test err'
  End
  It 'Not using append mode does reset file'
    testit() {
      filelog "${tmp_dir}/out" '' speaker
      filelog "${tmp_dir}/out" '' speaker
    }
    When call testit
    The line 1 of the contents of the file "${tmp_dir}/out" should equal "Test out"
    The line 2 of the contents of the file "${tmp_dir}/out" should equal "Test err"
    The line 3 of the contents of the file "${tmp_dir}/out" should be undefined
    The line 1 of the stdout should equal 'Test out'
    The line 2 of the stdout should equal 'Test out'
    The line 1 of the stderr should equal 'Test err'
    The line 2 of the stderr should equal 'Test err'
  End
End
