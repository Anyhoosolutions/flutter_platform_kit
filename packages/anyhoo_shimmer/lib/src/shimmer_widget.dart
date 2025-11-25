import 'package:anyhoo_shimmer/src/shimmer_loading.dart';
import 'package:flutter/material.dart';

/// Shimmer widget that works with global DefaultShimmer wrapper
/// This eliminates the need for individual ShimmerWidget instances
class ShimmerWidget extends StatelessWidget {
  const ShimmerWidget({
    super.key,
    required this.width,
    required this.height,
    this.borderRadius,
    this.color,
    this.margin,
    this.padding,
  });

  final double width;
  final double height;
  final BorderRadius? borderRadius;
  final Color? color;
  final EdgeInsets? margin;
  final EdgeInsets? padding;

  @override
  Widget build(BuildContext context) {
    // Just return a simple container - the shimmer effect comes from the parent DefaultShimmer
    return ShimmerLoading(
      isLoading: true,
      child: Container(
        width: width,
        height: height,
        margin: margin,
        padding: padding,
        decoration: BoxDecoration(color: color ?? Colors.grey[300], borderRadius: borderRadius),
      ),
    );
  }
}

/// Predefined shimmer shapes that work with global DefaultShimmer
class ShimmerShapes {
  /// Standard button shimmer
  static Widget button({double width = double.infinity, double height = 56, BorderRadius? borderRadius}) {
    return ShimmerWidget(width: width, height: height, borderRadius: borderRadius ?? BorderRadius.circular(8));
  }

  /// Standard card shimmer
  static Widget card({double width = double.infinity, double height = 100, BorderRadius? borderRadius}) {
    return ShimmerWidget(width: width, height: height, borderRadius: borderRadius ?? BorderRadius.circular(8));
  }

  /// Text shimmer
  static Widget text({double width = double.infinity, double height = 16, BorderRadius? borderRadius}) {
    return ShimmerWidget(width: width, height: height, borderRadius: borderRadius ?? BorderRadius.circular(4));
  }

  /// Circle shimmer (for avatars, etc.)
  static Widget circle({required double size}) {
    return ShimmerWidget(width: size, height: size, borderRadius: BorderRadius.circular(size / 2));
  }

  /// Image shimmer
  static Widget image({double width = double.infinity, double height = 200, BorderRadius? borderRadius}) {
    return ShimmerWidget(width: width, height: height, borderRadius: borderRadius ?? BorderRadius.circular(8));
  }
}
