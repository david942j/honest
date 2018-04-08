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

@test "$script: seccomp-tools" {
  gen_command seccomp-tools-1.2.0.git seccomp-tools-1.2.0.gem
  run $RESULT
  [ "$status" -eq 0 ]
}

@test "$script: backdoor inserted" {
  gen_command seccomp-tools-1.2.0.git backdoor_inserted.gem
  run $RESULT
  [ "$status" -eq 1 ]
  [ "$output" = "Unhonest! Files different: lib/seccomp-tools.rb." ]
}
