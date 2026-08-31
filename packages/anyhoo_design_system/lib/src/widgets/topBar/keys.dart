import 'package:flutter/material.dart';

class TopBarKeys {
  final avatar = const Key('topBarAvatar');
  final settings = const Key('topBarSettings');
  final profile = const Key('topBarProfile');
  final logout = const Key('topBarLogout');
}

class BottomBarKeys {
  final backButton = const Key('topBarBackButton');
}

class Keys {
  final topBar = TopBarKeys();
  final bottomBar = BottomBarKeys();
}

final keys = Keys();

// String _stripName(String name) => name.toLowerCase().replaceAll(' ', '_').replaceAll('(', '').replaceAll(')', '');
