import 'package:anyhoo_core/models/arguments.dart';
import 'package:anyhoo_router/anyhoo_router.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:example_app/main.dart';
import 'package:example_app/pages/homePage/home_page.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class HomePageRoute extends AnyhooRoute<AnyhooRouteName> {
  final Arguments arguments;
  final FirebaseFirestore firestore;

  HomePageRoute({required this.arguments, required this.firestore});

  @override
  Widget? Function(BuildContext, GoRouterState)? get builder =>
      (context, state) => HomePage(arguments: arguments, firestore: firestore);

  @override
  String get path => '/';

  @override
  String? get redirect => null;

  @override
  bool get requireLogin => false;

  @override
  AnyhooRouteName get routeName => AnyhooRouteName.home;

  @override
  String get title => 'Home';
}
