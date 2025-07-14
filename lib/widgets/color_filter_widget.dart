// Ein spezielles Widget für die Farbauswahl mit Symbolen
import 'package:flutter/material.dart';

class ColorFilterWidget extends StatefulWidget {
  final ValueNotifier<bool>? resetNotifier;

  const ColorFilterWidget({
    super.key,
    this.resetNotifier,
  });

  @override
  State<ColorFilterWidget> createState() => _ColorFilterWidgetState();
}

class _ColorFilterWidgetState extends State<ColorFilterWidget> {
  // Beispieldaten für die Farben
  final List<Map<String, dynamic>> _colors = [
    {'icon': Icons.shield, 'color': Colors.amber, 'isSelected': false},
    {'icon': Icons.local_fire_department, 'color': Colors.purple, 'isSelected': false},
    {'icon': Icons.eco, 'color': Colors.green, 'isSelected': false},
    {'icon': Icons.flash_on, 'color': Colors.red, 'isSelected': false},
    {'icon': Icons.water_drop, 'color': Colors.blue, 'isSelected': false},
    {'icon': Icons.security, 'color': Colors.grey, 'isSelected': false},
  ];

  @override
  void initState() {
    super.initState();
    widget.resetNotifier?.addListener(_reset);
  }

  @override
  void dispose() {
    widget.resetNotifier?.removeListener(_reset);
    super.dispose();
  }

  void _reset() {
    setState(() {
      for (var colorData in _colors) {
        colorData['isSelected'] = false;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 12.0,
      runSpacing: 12.0,
      alignment: WrapAlignment.center,
      children: _colors.map((colorData) {
        return InkWell(
          onTap: () {
            setState(() {
              colorData['isSelected'] = !colorData['isSelected'];
            });
          },
          borderRadius: BorderRadius.circular(24),
          child: Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: colorData['isSelected'] ? colorData['color'].withOpacity(0.3) : Colors.black.withOpacity(0.2),
              border: Border.all(
                color: colorData['isSelected'] ? colorData['color'] : Colors.grey[700]!,
                width: 2,
              ),
              shape: BoxShape.circle,
            ),
            child: Icon(
              colorData['icon'],
              color: colorData['color'],
              size: 24,
            ),
          ),
        );
      }).toList(),
    );
  }
}