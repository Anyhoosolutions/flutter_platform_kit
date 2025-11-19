import 'dart:convert';
import 'dart:io';

import 'package:console/documentation_uploader/models/upload_data.dart';
import 'package:http/http.dart' as http;

class Uploader {
  Uploader({required this.uploadData});
  final UploadData uploadData;

  String getUploadUrl() {
    final url = String.fromEnvironment('UPLOAD_URL',
        defaultValue: Platform.environment['UPLOAD_URL'] ??
            'UPLOAD_URL has not been set');
    print('UPLOAD_URL: $url');
    return url;
  }

  Future<int> upload() async {
    final jsonString = jsonEncode(uploadData.toJson());
    // print(jsonString);

    final url = Uri.parse(getUploadUrl());

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonString,
      );

      if (response.statusCode == 200) {
        print('Upload successful: ${response.body}');
      } else {
        print('Failed to upload: ${response.statusCode}');
        print(response.body);
      }
      return response.statusCode;
    } catch (e) {
      print('Error occurred: $e');
      rethrow;
    }
  }
}
