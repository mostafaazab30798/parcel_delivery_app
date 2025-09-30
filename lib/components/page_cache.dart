import 'package:flutter/material.dart';

/// A lightweight widget that caches pages to prevent unnecessary rebuilds during navigation
class PageCache extends StatefulWidget {
  final Widget child;
  final String cacheKey;
  final bool keepAlive;

  const PageCache({
    super.key,
    required this.child,
    required this.cacheKey,
    this.keepAlive = true,
  });

  @override
  State<PageCache> createState() => _PageCacheState();
}

class _PageCacheState extends State<PageCache>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => widget.keepAlive;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return widget.child;
  }
}

/// A simple cache manager for navigation pages
class NavigationPageCache {
  static final Map<String, Widget> _cache = {};
  static const int _maxCacheSize = 10; // Limit cache size to prevent memory issues

  static Widget getCachedPage(String key, Widget Function() builder) {
    if (!_cache.containsKey(key)) {
      // Clear cache if it gets too large
      if (_cache.length >= _maxCacheSize) {
        _cache.clear();
      }
      
      _cache[key] = PageCache(
        cacheKey: key,
        child: builder(),
      );
    }
    return _cache[key]!;
  }

  static void clearCache() {
    _cache.clear();
  }

  static void removeFromCache(String key) {
    _cache.remove(key);
  }

  static bool isCached(String key) {
    return _cache.containsKey(key);
  }

  static int get cacheSize => _cache.length;
}
