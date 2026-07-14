/// Per-frame pipeline timings and a rolling aggregate for tuning.
class FrameTiming {
  const FrameTiming({
    required this.inputMs,
    required this.ocrMs,
    required this.parseMs,
    required this.matchMs,
  });

  /// CameraImage → InputImage conversion.
  final int inputMs;

  /// ML Kit processImage (native side).
  final int ocrMs;

  /// Line filtering + footer/name parsing.
  final int parseMs;

  /// compute() isolate round-trip incl. Levenshtein scoring.
  final int matchMs;

  int get totalMs => inputMs + ocrMs + parseMs + matchMs;
}

/// Rolling window over the last [capacity] processed frames.
class ScanMetrics {
  ScanMetrics({this.capacity = 50});

  final int capacity;
  final List<FrameTiming> _window = [];
  int framesProcessed = 0;

  void add(FrameTiming timing) {
    framesProcessed++;
    _window.add(timing);
    if (_window.length > capacity) _window.removeAt(0);
  }

  bool get isEmpty => _window.isEmpty;

  double _avg(int Function(FrameTiming) pick) => _window.isEmpty
      ? 0
      : _window.map(pick).reduce((a, b) => a + b) / _window.length;

  int _max(int Function(FrameTiming) pick) =>
      _window.isEmpty ? 0 : _window.map(pick).reduce((a, b) => a > b ? a : b);

  double get avgInputMs => _avg((t) => t.inputMs);
  double get avgOcrMs => _avg((t) => t.ocrMs);
  double get avgParseMs => _avg((t) => t.parseMs);
  double get avgMatchMs => _avg((t) => t.matchMs);
  double get avgTotalMs => _avg((t) => t.totalMs);
  int get maxTotalMs => _max((t) => t.totalMs);

  /// Effective analysis throughput, bounded by processing time.
  double get fps => avgTotalMs <= 0 ? 0 : 1000 / avgTotalMs;

  String summary() => isEmpty
      ? 'no frames yet'
      : 'avg ${avgTotalMs.toStringAsFixed(0)}ms '
          '(input ${avgInputMs.toStringAsFixed(0)} · '
          'ocr ${avgOcrMs.toStringAsFixed(0)} · '
          'parse ${avgParseMs.toStringAsFixed(0)} · '
          'match ${avgMatchMs.toStringAsFixed(0)}) '
          'max ${maxTotalMs}ms · ${fps.toStringAsFixed(1)} fps · '
          'n=$framesProcessed';
}
