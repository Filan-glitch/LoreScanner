# Card Scanning and Recognition

## Overview

The LoreScanner app uses the device's camera to scan Lorcana TCG cards. Once an image is captured, it's processed to recognize text on the card, primarily the card's name. This recognized text is then used to identify the card by matching it against a database of known Lorcana cards.

## Implementation Details

The card scanning and recognition process involves several key components:

### 1. Camera Integration (`lib/screens/scanner_screen.dart`)

-   **Camera Access**: The `camera` plugin is used to access the device's camera.
-   **Preview**: A live camera preview is displayed to the user.
-   **Capture**: The user can trigger an image capture.
-   **Overlay**: A card template overlay is displayed on the camera preview to help users position the card correctly for optimal scanning. The `CardTemplateOverlay` widget is used for this.
-   **Resolution**: The camera is initialized with `ResolutionPreset.medium` to balance performance and image quality.

### 2. Image Preparation and Cropping (`lib/service/cards_analysis.dart`)

-   **Image Input**: The captured image is taken as an `XFile`.
-   **Cropping (Region of Interest - ROI)**:
    -   Before text recognition, the image can be cropped to the region where the card is expected to be. This is guided by the `CardTemplateOverlay` dimensions.
    -   The `_prepareImage` function in `cards_analysis.dart` handles this. It decodes the image, calculates crop boundaries based on the overlay, crops the image using the `image` package, and saves a temporary cropped image.
    -   If cropping fails, the original image is used.
-   **InputImage**: The (potentially cropped) image is converted to an `InputImage` format suitable for ML Kit.

### 3. Text Recognition (`lib/service/cards_analysis.dart`)

-   **Google ML Kit**: The `google_mlkit_text_recognition` plugin is used for on-device text recognition.
-   **Latin Script**: The `TextRecognizer` is initialized for `TextRecognitionScript.latin`.
-   **Processing**: The `processImage` method of the `TextRecognizer` extracts text blocks, lines, and elements from the `InputImage`.
-   **Extracted Text**: The full recognized text string is compiled from the recognized elements.

### 4. Card Matching (`lib/service/cards_analysis.dart`)

-   **Card Database**: A list of `Card` objects (fetched via `lib/service/api.dart` from `lorcanajson.org`) is used as the reference database.
-   **Potential Names**:
    -   The recognized text is split into lines.
    -   Lines that are all uppercase and longer than one character are considered potential card names.
    -   Lines with mixed case that appear to be title-cased (checked by `_isLikelyCardName`) are also considered.
-   **Matching Logic (`_findMatchingCards` function)**:
    -   Each potential name is compared against the `simpleName` of each card in the database (case-insensitive).
    -   **Exact Match**: Direct string equality.
    -   **Partial Match**: Checks if the card name contains the potential name or vice-versa.
    -   **Fuzzy Match**: A Levenshtein distance calculation (`_levenshteinDistance`) is used to allow for minor OCR errors. A match is considered if the distance is within 20% of the longer string's length.
-   **Results**: A `Set<Card>` of matching cards is returned.

### 5. User Interface and Flow (`lib/screens/scanner_screen.dart`)

-   **Loading State**: A loading indicator is shown during picture taking and analysis.
-   **Results Display**:
    -   If cards are found, the `FoundCardsOverview` widget is pushed, allowing the user to select the correct card and whether it's a foil version.
    -   If no cards are found, a SnackBar message informs the user.
-   **Collection**: Once a card is confirmed, it's added to the user's collection via `CardsProvider.addCardToCollection`.
-   **Performance Metrics**: In debug mode, performance metrics for image preparation, text recognition, and card matching are displayed in a dialog.

## Usage

1.  Navigate to the "Scanner" tab in the app.
2.  Position the Lorcana card within the template overlay visible on the camera preview.
3.  Tap the camera button to capture an image.
4.  The app will process the image and attempt to recognize the card.
5.  If multiple cards are potential matches, or to confirm the recognized card, an overview screen is shown. Select the correct card and specify if it's a foil version.
6.  The selected card is then added to your collection.

## Future Improvements

-   **Isolate Processing**: Move image analysis to a separate isolate for smoother UI performance, especially on older devices. (The current implementation notes this as a future step).
-   **Advanced ROI Detection**: Implement more sophisticated methods to automatically detect the card boundaries within the image, rather than relying solely on a fixed overlay.
-   **Orientation Handling**: Ensure robust handling of different card orientations.
-   **Improved Fuzzy Matching**: Enhance the fuzzy matching algorithm to better handle common OCR errors specific to card names or game terms.
-   **User Feedback**: Provide more granular feedback during the scanning process (e.g., "No text detected," "Multiple names found").
