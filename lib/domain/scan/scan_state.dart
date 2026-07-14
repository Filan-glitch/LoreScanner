/// Scanner pipeline state exposed to the UI.
sealed class ScanState {
  const ScanState();
}

/// Camera not started (tab inactive, permissions pending, disposed).
class ScanIdle extends ScanState {
  const ScanIdle();
}

/// Camera initializing.
class ScanStarting extends ScanState {
  const ScanStarting();
}

/// Live stream running, looking for cards. [trackingCardId] is set while a
/// candidate accumulates stability hits.
class ScanStreaming extends ScanState {
  const ScanStreaming({this.trackingCardId});

  final int? trackingCardId;
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
