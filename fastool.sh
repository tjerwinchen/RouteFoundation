#! /usr/bin/env bash

cd "$(dirname "$0")" || exit

SWIFTFORMAT_FILE=~/.tooling/swiftformat/base
SWIFTLINT_FILE=~/.tooling/swiftlint/base.yml
VERBOSE=false
OUTPUT=""

function parse_args() {
  while [[ $# -gt 0 ]]; do
    key="$1"

    case $key in
    --verbose)
      VERBOSE=true
      # Shift past argument since there's no value expected.
      shift
      ;;
    # Unknown option.
    *)
      # Save it in an array for later,
      POSITIONAL+=("$1")
      # Shift past argument.
      shift
      ;;
    esac
  done
  # Restore positional parameters.
  set -- "${POSITIONAL[@]}"
}

# swiftformat
function format() {
  if ! which swiftformat &> /dev/null; then
    printf "⚠️  You don't have SwiftFormat installed locally. Learn more about SwiftFormat by visiting https://github.com/nicklockwood/SwiftFormat.\n"
  else
    if [ -f $SWIFTFORMAT_FILE ]; then
      if $VERBOSE; then
        swiftformat --config $SWIFTFORMAT_FILE . --verbose
      else
        OUTPUT+=$(swiftformat --config $SWIFTFORMAT_FILE .)
      fi
    else
      printf "Not found $SWIFTLINT_FILE"
      exit 1
    fi
  fi
}

# swiftlint
function lint() {
  if ! which swiftlint &> /dev/null; then
    printf "⚠️  You don't have SwiftLint installed locally. Learn more about SwiftLint by visiting https://github.com/realm/SwiftLint.\n"
    printf "ℹ️️  run \e[0;32minfra/developer-tools/libs/environment/swift.sh\e[0m under monorepo to install tooling\n"
  else
    if [ -f $SWIFTLINT_FILE ]; then
      if $VERBOSE; then
        swiftlint --no-cache --config $SWIFTLINT_FILE
      else
        OUTPUT+=$(swiftlint --no-cache --config $SWIFTLINT_FILE)
      fi
    else
      printf "Not found $SWIFTLINT_FILE"
      exit 1
    fi
  fi
}

function podlint() {
  if ! which bundle &> /dev/null; then
    printf "⚠️  You don't have SwiftLint installed locally.\n"
    gem install bundler & bundle install
    if $VERBOSE; then
      bundle exec pod lib lint RouteFoundation.podspec --verbose
    else
      bundle exec pod lib lint RouteFoundation.podspec
    fi
  else
    if $VERBOSE; then
      bundle exec pod lib lint RouteFoundation.podspec --verbose
    else
      bundle exec pod lib lint RouteFoundation.podspec
    fi
  fi
}

function release() {
  if output=$(git status --untracked-files=no --porcelain) && [ -z "$output" ]; then
    podlint
  else
    printf "⚠️  You have uncommitted changes.\n${output}\n"
  fi
}

function generate() {
  xcodegen generate -s Example/Cocoapods/.project.yml --project Example/Cocoapods/
  xcodegen generate -s Example/SPM/.project.yml --project Example/SPM/
}

function check() {
  format
  lint
}

if [[ $1 =~ ^(format|lint|check|podlint|release|generate)$ ]]; then
  # Parsing common args
  parse_args "$@"
  "$@"
#  if [ "$OUTPUT" ]; then
#    echo "$OUTPUT" >&2
#    exit 1
#  fi
else
  echo "Invalid subcommand $1" >&2
  exit 1
fi
