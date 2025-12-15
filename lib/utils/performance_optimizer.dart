import 'package:flutter/material.dart';

class PerformanceOptimizer {
  /// Optimize list views with automatic keep alive
  static Widget optimizeListView({
    required List<Widget> children,
    ScrollController? controller,
    bool shrinkWrap = false,
    bool physics = false,
  }) {
    return ListView.builder(
      controller: controller,
      shrinkWrap: shrinkWrap,
      physics: physics ? const NeverScrollableScrollPhysics() : null,
      itemCount: children.length,
      itemBuilder: (context, index) {
        return _OptimizedListItem(
          child: children[index],
        );
      },
    );
  }

  /// Create an optimized network image with caching
  static Widget optimizedNetworkImage({
    required String imageUrl,
    double? width,
    double? height,
    BoxFit fit = BoxFit.cover,
    Widget? placeholder,
    Widget? errorWidget,
  }) {
    // In a real implementation, you would use CachedNetworkImage
    return Image.network(
      imageUrl,
      width: width,
      height: height,
      fit: fit,
      loadingBuilder: (context, child, loadingProgress) {
        if (loadingProgress == null) return child;
        return placeholder ??
            Center(
              child: CircularProgressIndicator(
                value: loadingProgress.expectedTotalBytes != null
                    ? loadingProgress.cumulativeBytesLoaded /
                        loadingProgress.expectedTotalBytes!
                    : null,
              ),
            );
      },
      errorBuilder: (context, error, stackTrace) {
        return errorWidget ??
            Icon(
              Icons.error,
              size: width ?? height ?? 50,
              color: Colors.grey,
            );
      },
    );
  }

  /// Debounce function calls
  static void debounce(Function callback, Duration delay) {
    Future.delayed(delay, callback);
  }
}

/// Wrapper widget that keeps list items alive for better performance
class _OptimizedListItem extends StatefulWidget {
  final Widget child;

  const _OptimizedListItem({required this.child});

  @override
  State<_OptimizedListItem> createState() => _OptimizedListItemState();
}

class _OptimizedListItemState extends State<_OptimizedListItem>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return widget.child;
  }
}