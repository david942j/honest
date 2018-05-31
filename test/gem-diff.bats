#!/usr/bin/env bats

load test_helper
script=gem-diff.bats

gen_command() {
  RESULT="/usr/bin/env ruby $HONEST_ROOT/share/honest/gem/diff.rb $FIXTURES_PATH/$1 $FIXTURES_PATH/$2"
}
@test "$script: extra files exist" {
  gen_command dont_care gem/corrupted_metadata
  run $RESULT
  [ "$status" -eq 1 ]
  [ "$output" = "Extra files in package: \"file.hack\"." ]
}

@test "$script: gdb-ruby" {
  gen_command git/gdb-ruby-0.3.0 gem/gdb-0.3.0
  run $RESULT
  [ "$status" -eq 0 ]
}

@test "$script: backdoor inserted" {
  gen_command git/gdb-ruby-0.3.0 gem/backdoor_inserted
  run $RESULT
  [ "$status" -eq 1 ]
}
