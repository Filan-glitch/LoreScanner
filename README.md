# LoreScanner

A scanner application for the Lorcana TCG by Ravensburger

## Strategie: Textbasierte Kartenerkennung mit Google ML Kit
- **Ziel:** Erkenne Lorcana-Karten in Echtzeit mit der Kamera und zeige erkannte mögliche Karten an.
- **Vorgehen:** Nutze Google ML Kit für die Texterkennung, um Kartennamen zu extrahieren und diese mit einer Datenbank abzugleichen.
- **Vorteile:** 
  - Keine Notwendigkeit, ein komplexes Bildklassifikationsmodell zu trainieren.
  - Nutzt die Stärke von ML Kit für Texterkennung, was in vielen Fällen robuster ist als reine Bildklassifikation.
---

## Schritte zur Implementierung

Hier sind die konkreten Schritte, um dies umzusetzen:

### Flutter App Entwicklung mit ML Kit

* **Kamera-Integration:** Nutze das `camera` Plugin für Flutter, um Zugriff auf die Kamera zu erhalten und Bilder aufzunehmen.
* **Texterkennung:** Verwende das `google_ml_kit` Plugin, um die Texterkennung auf den aufgenommenen Bildern durchzuführen.
* **Bildverarbeitung in der App:**
    1.  Nimm ein Bild mit der Kamera auf.
    2.  **Optional, aber empfohlen: Kartenerkennung/Zuschnitt (Region of Interest - ROI):**
        * Bevor du Merkmale extrahierst, versuche, die Karte im Kamerabild zu isolieren. Das verbessert die Genauigkeit erheblich, da der Hintergrund Rauschen entfernen wird.
        * Alternativ können traditionelle Bildverarbeitungsverfahren (Kantenerkennung, Konturenfindung) helfen, wenn die Karten einen guten Kontrast zum Hintergrund haben.
        * Wenn das nicht zuverlässig klappt, muss der Nutzer die Karte vielleicht manuell in einem vorgegebenen Rahmen positionieren.
    3.  Schneide das Bild auf die erkannte Karte zu (falls ROI-Erkennung verwendet wird).
    4.  Extrahiere den Text aus dem Bild mit ML Kit.
* **Anzeige:** Zeige dem Nutzer die erkannte Karte an.
