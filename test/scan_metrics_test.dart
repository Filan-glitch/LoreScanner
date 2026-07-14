import 'package:flutter_test/flutter_test.dart';
import 'package:lorescanner/domain/scan/scan_metrics.dart';

void main() {
  test('aggregates averages, max and fps over the window', () {
    final metrics = ScanMetrics(capacity: 3);
    metrics.add(const FrameTiming(inputMs: 10, ocrMs: 100, parseMs: 5, matchMs: 15));
    metrics.add(const FrameTiming(inputMs: 20, ocrMs: 200, parseMs: 5, matchMs: 25));

    expect(metrics.avgInputMs, 15);
    expect(metrics.avgOcrMs, 150);
    expect(metrics.avgTotalMs, (130 + 250) / 2);
    expect(metrics.maxTotalMs, 250);
    expect(metrics.fps, closeTo(1000 / 190, 0.01));
    expect(metrics.framesProcessed, 2);
  });

  test('window evicts oldest beyond capacity, total count keeps growing', () {
    final metrics = ScanMetrics(capacity: 2);
    for (var i = 1; i <= 3; i++) {
      metrics.add(FrameTiming(inputMs: i, ocrMs: 0, parseMs: 0, matchMs: 0));
    }
    expect(metrics.avgInputMs, 2.5); // frames 2 and 3
    expect(metrics.framesProcessed, 3);
  });

  test('empty metrics report safely', () {
    final metrics = ScanMetrics();
    expect(metrics.isEmpty, isTrue);
    expect(metrics.fps, 0);
    expect(metrics.summary(), 'no frames yet');
  });
}
