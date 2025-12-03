import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

const firstNames = ['Alice', 'Bob', 'Charlie', 'David', 'Eve', 'Frank', 'Grace', 'Heidi', 'Ivan', 'Julia'];
const lastNames = ['Anderson', 'Brown', 'Clark', 'Davis', 'Evans', 'Foster', 'Garcia', 'Harris', 'Jackson', 'Johnson'];

class FirestoreDemoPage extends StatelessWidget {
  final FirebaseFirestore firestore;
  const FirestoreDemoPage({super.key, required this.firestore});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Arguments Demo')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text('Firestore Demo'),
            TextButton(
              onPressed: () {
                final firestore = FirebaseFirestore.instance;
                firestore.collection('test').add({
                  'name':
                      '${firstNames[Random().nextInt(firstNames.length)]} ${lastNames[Random().nextInt(lastNames.length)]}',
                });
              },
              child: const Text('Add Test Data'),
            ),
            StreamBuilder(
              stream: firestore.collection('test').snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator();
                }
                final data = snapshot.data?.docs.map((doc) => doc.data()).toList();
                return Column(children: data?.map((e) => Text(e['name'] ?? '')).toList() ?? []);
              },
            ),
          ],
        ),
      ),
    );
  }
}
