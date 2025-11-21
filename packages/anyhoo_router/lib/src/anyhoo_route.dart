import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

abstract class AnyhooRoute<T extends Enum> {
  String get path;
  String get title;
  T get routeName;
  Widget? Function(BuildContext, GoRouterState)? get builder;
  bool get requireLogin;
  String? get redirect;
}
