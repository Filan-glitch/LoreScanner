# LoreScanner

A scanner application for the Lorcana TCG by Ravensburger

## Strategie: Merkmalsvergleich mit vortrainierten Modellen

Die Grundidee ist, nicht zu versuchen, dem Modell beizubringen, 1000 spezifische Kartentypen direkt zu "klassifizieren", sondern stattdessen:

1.  **Merkmale extrahieren:** Aus jedem deiner 1000 Referenzbilder extrahierst du markante visuelle Merkmale (sogenannte "Embeddings" oder "Feature Vektoren") mit einem leistungsstarken, vortrainierten neuronalen Netz. Diese Merkmalsvektoren repräsentieren den visuellen Inhalt der Karte in kompakter Form.
2.  **Referenzdatenbank erstellen:** Speichere diese 1000 Merkmalsvektoren zusammen mit den Namen der Karten in einer Datenbank, die du mit deiner App auslieferst.
3.  **Scannen und Vergleichen in der App:**
    * Wenn der Nutzer eine Karte mit der Kamera scannt, extrahierst du ebenfalls die Merkmale aus dem Kamerabild mit demselben vortrainierten Modell.
    * Dann vergleichst du diesen neuen Merkmalsvektor mit allen 1000 Vektoren in deiner Referenzdatenbank.
    * Die Karte, deren gespeicherter Merkmalsvektor dem des gescannten Bildes am ähnlichsten ist (z.B. höchste Kosinus-Ähnlichkeit), ist die erkannte Karte.

---

## Schritte zur Implementierung

Hier sind die konkreten Schritte, um dies umzusetzen:

### 1. Wahl eines vortrainierten Modells & Merkmalsextraktion (Offline-Vorbereitung)

Dies machst du einmalig auf deinem Computer, um die Referenzdatenbank zu erstellen.

* **Modell wählen:** Suche auf Plattformen wie TensorFlow Hub nach vortrainierten Modellen zur "Image Feature Vector" Extraktion. Gute Kandidaten sind oft MobileNetV2, EfficientNetLite oder ähnliche Modelle, die für mobile Anwendungen optimiert sind und gute Merkmale liefern. Wichtig ist, dass das Modell später in das TensorFlow Lite (.tflite) Format konvertiert werden kann.
* **Merkmale extrahieren (z.B. mit Python und TensorFlow/Keras):**
    1.  Lade das vortrainierte Modell (ohne dessen letzte Klassifikationsschicht, du willst den Merkmalsvektor davor).
    2.  Für jedes deiner 1000 Kartenbilder:
        * Lade das Bild.
        * Verarbeite es vor (Größe anpassen, Pixelwerte normalisieren), so wie es das gewählte Modell erwartet.
        * Gib das Bild durch das Modell und extrahiere den resultierenden Merkmalsvektor.
    3.  Speichere diese 1000 Merkmalsvektoren zusammen mit einer eindeutigen ID oder dem Namen jeder Karte (z.B. in einer JSON-Datei, einer einfachen Datenbank oder einem NumPy-Array). Diese Datei wird Teil deiner Flutter-App.
* **Modell konvertieren:** Konvertiere das genutzte vortrainierte Modell (den Teil für die Merkmalsextraktion) in das TensorFlow Lite (`.tflite`) Format. Dieses Modell wird in deiner Flutter-App ausgeführt.

### 2. Flutter App Entwicklung mit ML Kit

* **Kamera-Integration:** Nutze das `camera` Plugin für Flutter, um Zugriff auf die Kamera zu erhalten und Bilder aufzunehmen.
* **TensorFlow Lite Modell laden:** Integriere das `.tflite` Modell in deine Flutter-App (als Asset). Verwende ein Plugin wie `tflite_flutter` oder `tflite_flutter_helper`, um das Modell in deiner App zu laden und Inferenz durchzuführen. Google ML Kit bietet auch APIs für benutzerdefinierte Modelle, die hier passen könnten.
* **Referenzdatenbank laden:** Lade die in Schritt 1 erstellte Datei mit den Merkmalsvektoren deiner 1000 Karten in den Speicher der App.
* **Bildverarbeitung in der App:**
    1.  Nimm ein Bild mit der Kamera auf.
    2.  **Optional, aber empfohlen: Kartenerkennung/Zuschnitt (Region of Interest - ROI):**
        * Bevor du Merkmale extrahierst, versuche, die Karte im Kamerabild zu isolieren. Das verbessert die Genauigkeit erheblich, da der Hintergrund Rauschen entfernen wird.
        * Du könntest versuchen, ein sehr einfaches Objekterkennungsmodell (z.B. mit ML Kit Object Detection) zu trainieren, das nur "eine Karte" allgemein erkennt, ohne die spezifische Karte zu identifizieren.
        * Alternativ können traditionelle Bildverarbeitungsverfahren (Kantenerkennung, Konturenfindung) helfen, wenn die Karten einen guten Kontrast zum Hintergrund haben.
        * Wenn das nicht zuverlässig klappt, muss der Nutzer die Karte vielleicht manuell in einem vorgegebenen Rahmen positionieren.
    3.  Schneide das Bild auf die erkannte Karte zu (falls ROI-Erkennung verwendet wird).
    4.  Verarbeite das (zugeschnittene) Kamerabild genauso vor wie deine Referenzbilder (Größe, Normalisierung).
* **Merkmalsextraktion im gescannten Bild:** Führe das `.tflite` Modell mit dem vorverarbeiteten Kamerabild aus, um dessen Merkmalsvektor zu erhalten.
* **Ähnlichkeitssuche:**
    1.  Vergleiche den Merkmalsvektor des gescannten Bildes mit allen 1000 gespeicherten Referenzvektoren.
    2.  Berechne hierfür ein Ähnlichkeitsmaß. Die **Kosinus-Ähnlichkeit** (Cosine Similarity) ist hier oft sehr gut geeignet. Alternativ ginge auch der Euklidische Abstand.
    3.  Die Karte aus deiner Datenbank, deren Merkmalsvektor die höchste Ähnlichkeit (oder den geringsten Abstand) zum Vektor des gescannten Bildes aufweist, ist deine erkannte Karte.
* **Schwellenwert:** Definiere einen Ähnlichkeits-Schwellenwert. Liegt die beste gefundene Ähnlichkeit unter diesem Wert, kannst du die Karte als "nicht erkannt" oder "unbekannt" einstufen, um Falscherkennungen zu reduzieren.
* **Anzeige:** Zeige dem Nutzer die erkannte Karte an.

---

## Warum dieser Ansatz?

* **Effektiv bei "One-Shot"-Learning:** Du umgehst das Problem, ein Modell mit nur einem Bild pro Klasse trainieren zu müssen, indem du auf die Fähigkeit vortrainierter Modelle zur Merkmalsextraktion setzt.
* **Skalierbarkeit:** Das Hinzufügen neuer Karten erfordert nur die Extraktion und Speicherung ihres Merkmalsvektors, nicht ein komplettes Neutraining eines riesigen Klassifikators.
* **Nutzung von ML Kit:** Du kannst die Inferenz des `.tflite` Modells auf dem Gerät mit ML Kit (oder entsprechenden TFLite Flutter Plugins) durchführen, was eine Offline-Nutzung ermöglicht.

---

## Wichtige Überlegungen

* **Bildqualität:** Die Qualität deiner Referenzbilder und der gescannten Bilder ist entscheidend. Sorge für gute, konsistente Beleuchtung und Schärfe.
* **Robustheit:** Um die Robustheit zu erhöhen, könntest du für jedes deiner Referenzbilder nicht nur das Original, sondern auch einige leicht augmentierte Versionen (kleine Drehungen, Helligkeitsänderungen) zur Merkmalsextraktion heranziehen und ggf. den Durchschnitt der Merkmalsvektoren speichern.
* **Performance:** Die Merkmalsextraktion und der Vergleich mit 1000 Vektoren müssen auf dem Mobilgerät performant sein. Optimiere die Bildgröße und wähle ein für Mobilgeräte optimiertes `.tflite` Modell. Der Vergleich der Vektoren selbst (z.B. 1000 Kosinus-Ähnlichkeitsberechnungen) sollte relativ schnell sein.
