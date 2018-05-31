#!/usr/bin/env bats

load test_helper
script=pip-diff.bats

gen_command() {
  RESULT="/usr/bin/env python $HONEST_ROOT/share/honest/pip/diff.py $FIXTURES_PATH/$1 $FIXTURES_PATH/$2"
}

@test "$script: missing file" {
  gen_command dont_care pip/corrupted_record
  run $RESULT
  [ "$status" -eq 1 ]
  [ "$output" = "Unhonest! Missing files in package: 'fake_pkg/api.py'." ]
}

@test "$script: requests-2.18.3" {
  gen_command git/requests-2.18.3 pip/requests-2.18.3
  run $RESULT
  [ "$status" -eq 0 ]
}
