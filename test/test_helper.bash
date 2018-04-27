export HONEST_TMPDIR="$BATS_TEST_DIRNAME"/tmp
HONEST_ROOT="$(dirname "$BATS_TEST_DIRNAME")"
FIXTURES_PATH="$BATS_TEST_DIRNAME"/fixtures
export PATH="$HONEST_ROOT/bin:$HONEST_ROOT/libexec:$PATH"

helper_make_tmp_dir() {
  tmp_dir=$(TMPDIR=$HONEST_TMPDIR mktemp -d -t honest-XXXXXXXXXX)
  mkdir -p $tmp_dir
  echo $tmp_dir
}
