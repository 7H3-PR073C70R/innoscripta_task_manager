import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// Please use this router extension to navigate to a route
/// instead of using the navigator directly.
/// So we can avoid importing go_router in every file.
extension RouterExtension on BuildContext {
  void pushNamed(
    String name, {
    Object? extra,
  }) => go(
    name,
    extra: extra,
  );

  void back(String name) => pop(
    name,
  );
}
