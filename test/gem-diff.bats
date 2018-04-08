#!/usr/bin/env bats

load test_helper
script=gem-diff.bats

gen_command() {
  RESULT="/usr/bin/env ruby $HONEST_ROOT/share/honest/gem/diff.rb $FIXTURES_PATH/$1 $FIXTURES_PATH/$2"
}
@test "$script: addtional files exist" {
  gen_command dont_care corrupted_metadata.gem
  run $RESULT
  [ "$status" -eq 1 ]
  [ "$output" = "Unhonest! Additional files in package: file.hack." ]
}

@test "$script: gdb-ruby" {
  gen_command gdb-ruby-0.3.0.git gdb-0.3.0.gem
  run $RESULT
  [ "$status" -eq 0 ]
}

@test "$script: backdoor inserted" {
  gen_command gdb-ruby-0.3.0.git backdoor_inserted.gem
  run $RESULT
  [ "$status" -eq 1 ]
  [ "$output" = "Unhonest! Files different: lib/gdb.rb." ]
}
