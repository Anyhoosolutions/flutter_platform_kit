import 'package:flutter/material.dart';

extension WidgetExtension on Widget {
  Padding pad({double? r, double? l, double? t, double? b, double? h, double? v, double? all}) {
    assert(l == null || h == null, 'l and h cannot both be provided');
    assert(r == null || h == null, 'r and h cannot both be provided');
    assert(t == null || v == null, 't and v cannot both be provided');
    assert(b == null || v == null, 'b and v cannot both be provided');

    final left = l ?? h ?? all ?? 0;
    final right = r ?? h ?? all ?? 0;
    final top = t ?? v ?? all ?? 0;
    final bottom = b ?? v ?? all ?? 0;

    return Padding(
      padding: EdgeInsets.only(right: right, left: left, top: top, bottom: bottom),
      child: this,
    );
  }

  /// Wrap the widget with Opacity
  Widget opacity(double value) => Opacity(opacity: value, child: this);

  /// Wrap the widget with Visibility
  Widget visible(bool visible, {Widget fallback = const SizedBox.shrink()}) => visible ? this : fallback;

  /// Wrap the widget with Center
  Widget get center => Center(child: this);

  /// Wrap the widget with Expanded
  Widget get expanded => Expanded(child: this);

  /// Wrap the widget with FittedBox
  Widget get fitted => FittedBox(child: this);

  /// Wrap the widget with Hero
  Widget hero(Object tag) => Hero(tag: tag, child: this);

  /// Wrap the widget with InkWell
  Widget tooltip(String message) => Tooltip(message: message, child: this);
}
