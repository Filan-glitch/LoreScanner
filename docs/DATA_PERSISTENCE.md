# Data Persistence

## Overview

The LoreScanner app persists two main types of data locally on the device:

1.  **Card Definitions**: A local cache of Lorcana card information (name, set, images, etc.) fetched from an external API.
2.  **User's Card Collection**: The cards the user has scanned and added to their personal collection, including quantities of normal and foil versions.

This persistence ensures that the app can function offline (once initial card data is fetched) and that the user's collection is saved between app sessions.

## Technology

-   **SQLite**: The `sqflite` Flutter plugin is used to manage a local SQLite database.
-   **Database File**: The database is stored in a file named `lorcana.db` in the app's standard database location.

## Database Schema (`lib/service/database.dart`)

The database (`lorcana.db`) contains two main tables:

### 1. `cards` Table

This table stores the definitions of all known Lorcana cards that have been fetched by the app.

-   `id` (INTEGER, PRIMARY KEY): Unique identifier for the card (typically from the source API).
-   `images` (TEXT): JSON string or path to card images.
-   `setCode` (TEXT): The set code the card belongs to.
-   `simpleName` (TEXT): The name of the card, used for matching.
-   `language` (TEXT, DEFAULT 'de'): The language of the card data.

**Operations**:
-   `insertCards(List<Card> cards)`: Inserts a list of `Card` objects into this table. Uses `ConflictAlgorithm.replace` to update existing entries if an `id` conflict occurs.
-   `fetchCardsFromDB()`: Retrieves all cards stored in this table.

### 2. `collection` Table

This table stores the user's personal card collection. Each row links to a card in the `cards` table and stores the quantity owned.

-   `cardId` (INTEGER, PRIMARY KEY): Foreign key referencing the `id` in the `cards` table. This means each card can only have one entry in the collection table.
-   `amount` (INTEGER, DEFAULT 0): The number of regular (non-foil) copies of this card owned by the user.
-   `amountFoil` (INTEGER, DEFAULT 0): The number of foil copies of this card owned by the user.

**Operations**:
-   `addCardToCollection(int cardId, {int amount = 1, int amountFoil = 0})`: Adds a card to the collection or updates its quantity if it already exists.
    -   It first queries if the `cardId` is already in the `collection`.
    -   If it exists, it increments the `amount` and/or `amountFoil` fields.
    -   If it doesn't exist, it inserts a new row.
-   `fetchCollectionFromDB()`: Retrieves the user's entire collection as a `Map<int, Map<String, int>>`, where the key is `cardId` and the value is a map containing `amount` and `amountFoil`.

## Data Flow and Management

### Card Definitions

-   Card definitions are initially fetched from the `lorcanajson.org` API via `fetchCards` in `lib/service/api.dart`.
-   During app initialization (specifically in `InitializationService`), these fetched cards are then stored in the local SQLite `cards` table using `db.insertCards`. This creates a local cache.
-   The `CardsProvider` loads these cards from the database into memory using `db.fetchCardsFromDB()` during its `loadCollection` method (although primarily for collection construction, the full card list is available).

### User's Collection

-   The user's collection is managed by the `CardsProvider` (`lib/provider/cards_provider.dart`).
-   **Loading**:
    -   When `CardsProvider.loadCollection()` is called (e.g., during app startup or when refreshing the collection), it fetches all card definitions (`db.fetchCardsFromDB()`) and the collection data (`db.fetchCollectionFromDB()`).
    -   It then constructs a list of `CollectionEntry` objects by combining the card details with their stored amounts. This list is held in the `_collection` field of the provider.
-   **Adding Cards**:
    -   When a user scans and confirms a card, `CardsProvider.addCardToCollection(Card card, ...)` is called.
    -   This method updates the in-memory `_collection` object.
    -   Crucially, it also calls `db.addCardToCollection(card.id, ...)` to persist the change to the SQLite `collection` table.
-   **State Management**: `CardsProvider` extends `ChangeNotifier`, so UI components listening to it will rebuild when the collection changes.

## Database Initialization (`openDB` function in `lib/service/database.dart`)

-   The `openDB()` function is responsible for opening the `lorcana.db` database.
-   If the database file doesn't exist, it's created.
-   During the `onOpen` callback (or `onCreate` if it were the first time for a version), `CREATE TABLE IF NOT EXISTS` statements are executed to ensure both the `cards` and `collection` tables are present with the correct schema.
-   The database version is currently set to `1`.

## Future Considerations

-   **Database Migrations**: If the schema needs to change in future versions, a proper migration strategy using `onUpgrade` in `openDatabase` will be necessary.
-   **Backup/Restore**: For valuable user collections, implementing a backup and restore mechanism (e.g., cloud sync) could be considered.
-   **Data Synchronization**: If the app were to support multiple devices, a more robust data synchronization strategy would be needed beyond local SQLite.
-   **Performance for Large Collections**: For very large collections, queries and updates might need optimization. Indexing is implicitly handled for primary keys, but other indexes might be beneficial depending on query patterns.
