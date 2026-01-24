import 'dart:convert';
import 'dart:io';

import 'package:upload_documentation/documentation_uploader/models/upload_data.dart';
import 'package:http/http.dart' as http;

class Uploader {
  Uploader({required this.uploadData});
  final UploadData uploadData;

  String getUploadUrl() {
    final url = String.fromEnvironment('UPLOAD_URL',
        defaultValue: Platform.environment['UPLOAD_URL'] ?? 'UPLOAD_URL has not been set');
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

      final statusCode = response.statusCode;
      if (statusCode == 200 || statusCode == 201) {
        print('Upload successful: ${response.body}');
      } else {
        print('Failed to upload: $statusCode');
        print(response.body);
        throw HttpException('Upload failed with status $statusCode: ${response.body}');
      }
      return statusCode;
    } catch (e) {
      print('Error occurred: $e');
      rethrow;
    }
  }
}
