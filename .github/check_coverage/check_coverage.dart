import 'dart:io';

Future<void> main() async {
  final file = File('coverage/lcov.info');

  if (!await file.exists()) {
    stderr.writeln('❌ coverage/lcov.info not found.');
    exit(1);
  }

  final lines = await file.readAsLines();

  int totalLines = 0;
  int coveredLines = 0;

  for (final line in lines) {
    if (line.startsWith('DA:')) {
      totalLines++;
      final parts = line.substring(3).split(',');
      if (int.parse(parts[1]) > 0) {
        coveredLines++;
      }
    }
  }

  if (totalLines == 0) {
    stderr.writeln('❌ No lines found in coverage.');
    exit(1);
  }

  final coveragePercent = (coveredLines / totalLines) * 100;
  final rounded = coveragePercent.toStringAsFixed(2);
  print('✅ Coverage: $rounded%');

  if (coveragePercent < 90.0) {
    stderr.writeln('❌ Coverage is below 90%.');
    exit(1);
  }
}
