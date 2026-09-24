import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class ShimmerSkeleton extends StatelessWidget {
  const ShimmerSkeleton({
    Key? key,
    required this.width,
    required this.height,
    this.borderRadius = const BorderRadius.all(Radius.circular(4.0)),
    this.baseColor,
    this.highlightColor,
    this.enabled = true,
  }) : super(key: key);

  final double width;
  final double height;
  final BorderRadius borderRadius;
  final Color? baseColor;
  final Color? highlightColor;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    final effectiveBaseColor = baseColor ?? Colors.brown.shade100;
    final effectiveHighlightColor = highlightColor ?? Colors.brown.shade50;

    return Shimmer.fromColors(
      baseColor: effectiveBaseColor,
      highlightColor: effectiveHighlightColor,
      enabled: enabled,
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: effectiveBaseColor,
          borderRadius: borderRadius,
        ),
      ),
    );
  }
}
