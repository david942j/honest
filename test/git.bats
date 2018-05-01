#!/usr/bin/env bats

load test_helper
script=git.bats

setup() {
  [ -z "$CI"] && skip "No git test on local"
}

@test "$script: latest tag" {
  tmp_dir="$(helper_make_tmp_dir)"
  honest-git github:david942j/gdb-ruby "$tmp_dir"
  cd "$tmp_dir" && run git branch
  [ "${lines[0]:0:21}" = "* (HEAD detached at v" ]
}

@test "$script: specific branch" {
  tmp_dir="$(helper_make_tmp_dir)"
  honest-git github:david942j/honest "$tmp_dir" -v branch_for_test
  cd "$tmp_dir" && run git branch
  [ "${lines[0]}" = "* branch_for_test" ]
}
