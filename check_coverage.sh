#!/bin/bash

# Run tests with coverage
dart test --coverage=coverage

# Format coverage into lcov.info
dart pub global run coverage:format_coverage \
  --lcov --in=coverage \
  --packages=.dart_tool/package_config.json \
  --report-on=lib \
  -o coverage/lcov.info

# Extract line counts using grep + cut (no -P)
lf=$(grep "LF:" coverage/lcov.info | cut -d: -f2 | paste -sd+ - | bc)
lh=$(grep "LH:" coverage/lcov.info | cut -d: -f2 | paste -sd+ - | bc)

# Calculate and display coverage percentage
if [ "$lf" -gt 0 ]; then
  pct=$(awk "BEGIN { printf(\"%.2f\", ($lh/$lf)*100) }")
  echo "Coverage: $pct%"
else
  echo "No lines found to measure coverage."
fi