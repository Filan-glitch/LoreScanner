/// Central constants: endpoints, scan thresholds, UI strings (German-only app).
library;

// --- Data sources ---
const String lorcanaJsonBaseUrl = 'https://www.lorcanajson.org/files/current';
const String cardmarketPriceGuideBaseUrl =
    'https://downloads.s3.cardmarket.com/productCatalog/priceGuide';
const int defaultPriceGuideId = 19;

// --- External links ---
const String officialAppUrl =
    'https://apps.apple.com/de/app/disney-lorcana-tcg-companion/id6450800311';
const String officialWebsiteUrl = 'https://www.disneylorcana.com/de-DE';

// --- Sync policy ---
const Duration cardSyncCheckInterval = Duration(hours: 24);
const Duration priceRefreshInterval = Duration(hours: 24);

// --- Scan pipeline ---
const double matchConfidenceThreshold = 0.7;

/// Matches at or above this score confirm after a single frame instead of
/// the full stability window.
const double scanInstantConfidence = 0.95;
const double matchAmbiguityWindow = 0.05;
const Duration scanFrameInterval = Duration(milliseconds: 250);
const int scanStabilityHits = 2;
const Duration scanConfirmTimeout = Duration(seconds: 4);
const Duration scanCardCooldown = Duration(seconds: 3);
