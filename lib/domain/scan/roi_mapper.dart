import 'dart:math';
import 'dart:ui';

/// Maps between preview-widget coordinates and upright-image coordinates.
///
/// Replaces the legacy hardcoded 375×667 viewport mapping: the same mapper
/// output drives both the overlay painter and the OCR block filter, so what
/// the user aligns is exactly what gets matched.
///
/// Assumes the preview is drawn with BoxFit.cover semantics (full-screen
/// CameraPreview): the upright camera image is scaled to cover the widget
/// and centered, cropping the overflow.
class RoiMapper {
  RoiMapper({required this.widgetSize, required this.uprightImageSize})
      : _scale = max(
          widgetSize.width / uprightImageSize.width,
          widgetSize.height / uprightImageSize.height,
        );

  final Size widgetSize;

  /// Camera image size after rotation to upright orientation (swap width and
  /// height for 90°/270° sensor rotations — see [uprightSize]).
  final Size uprightImageSize;

  final double _scale;

  Offset get _coverOffset => Offset(
        (uprightImageSize.width * _scale - widgetSize.width) / 2,
        (uprightImageSize.height * _scale - widgetSize.height) / 2,
      );

  /// Widget-space rect → upright-image-space rect.
  Rect widgetToImage(Rect rect) {
    final offset = _coverOffset;
    return Rect.fromLTRB(
      (rect.left + offset.dx) / _scale,
      (rect.top + offset.dy) / _scale,
      (rect.right + offset.dx) / _scale,
      (rect.bottom + offset.dy) / _scale,
    );
  }

  /// Upright-image-space rect → widget-space rect.
  Rect imageToWidget(Rect rect) {
    final offset = _coverOffset;
    return Rect.fromLTRB(
      rect.left * _scale - offset.dx,
      rect.top * _scale - offset.dy,
      rect.right * _scale - offset.dx,
      rect.bottom * _scale - offset.dy,
    );
  }

  /// Raw sensor size → upright size for a given rotation in degrees.
  static Size uprightSize(Size sensorSize, int rotationDegrees) =>
      rotationDegrees % 180 == 0
          ? sensorSize
          : Size(sensorSize.height, sensorSize.width);

  /// Transforms a rect from raw sensor coordinates into upright-image
  /// coordinates for a clockwise [rotationDegrees] (0/90/180/270).
  static Rect uprightRect(Rect rect, Size sensorSize, int rotationDegrees) {
    switch (rotationDegrees % 360) {
      case 90:
        return Rect.fromLTRB(
          sensorSize.height - rect.bottom,
          rect.left,
          sensorSize.height - rect.top,
          rect.right,
        );
      case 180:
        return Rect.fromLTRB(
          sensorSize.width - rect.right,
          sensorSize.height - rect.bottom,
          sensorSize.width - rect.left,
          sensorSize.height - rect.top,
        );
      case 270:
        return Rect.fromLTRB(
          rect.top,
          sensorSize.width - rect.right,
          rect.bottom,
          sensorSize.width - rect.left,
        );
      default:
        return rect;
    }
  }
}

/// Lorcana cards are 63×88 mm. The scan ROI is a centered card-shaped frame
/// at [widthFraction] of the widget width.
Rect cardRoi(Size widgetSize, {double widthFraction = 0.8}) {
  const cardAspect = 63.0 / 88.0;
  final width = widgetSize.width * widthFraction;
  final height = width / cardAspect;
  return Rect.fromCenter(
    center: widgetSize.center(Offset.zero),
    width: width,
    height: height,
  );
}
