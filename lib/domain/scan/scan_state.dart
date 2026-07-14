/// Scanner pipeline state exposed to the UI.
sealed class ScanState {
  const ScanState();
}

/// What the pipeline is doing right now — drives the live status line.
enum ScanPhase {
  /// No usable text in the ROI yet.
  searching,

  /// OCR found text, extracting name/footer.
  reading,

  /// Candidates scored against the card index.
  matching,

  /// A candidate card is accumulating stability hits.
  tracking,
}

/// Camera not started (tab inactive, permissions pending, disposed).
class ScanIdle extends ScanState {
  const ScanIdle();
}

/// Camera initializing.
class ScanStarting extends ScanState {
  const ScanStarting();
}

/// Live stream running.
class ScanStreaming extends ScanState {
  const ScanStreaming({
    this.phase = ScanPhase.searching,
    this.trackingCardId,
    this.trackingHits = 0,
    this.requiredHits = 2,
  });

  final ScanPhase phase;
  final int? trackingCardId;
  final int trackingHits;
  final int requiredHits;
}

/// A card cleared threshold + stability — quick-confirm bar shows. The
/// stream keeps running underneath.
class ScanDetected extends ScanState {
  const ScanDetected({required this.cardId, required this.score});

  final int cardId;
  final double score;
}

class ScanFailure extends ScanState {
  const ScanFailure(this.message);

  final String message;
}
