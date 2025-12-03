import 'package:anyhoo_router/anyhoo_router.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:example_app/main.dart';
import 'package:example_app/pages/firestoreDemo/firestore_demo_page.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class FirestoreDemoPageRoute extends AnyhooRoute<AnyhooRouteName> {
  FirestoreDemoPageRoute();

  @override
  Widget? Function(BuildContext, GoRouterState)? get builder => (context, state) {
    return FirestoreDemoPage(firestore: state.extra as FirebaseFirestore);
  };

  @override
  String get path => '/firestore';

  @override
  String? get redirect => null;

  @override
  bool get requireLogin => false;

  @override
  AnyhooRouteName get routeName => AnyhooRouteName.firestore;

  @override
  String get title => 'Firestore';
}
