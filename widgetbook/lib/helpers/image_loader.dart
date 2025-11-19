import 'dart:math';

import 'package:cross_file/cross_file.dart';
import 'package:flutter/services.dart';
import 'package:image/image.dart' as img;

enum Images {
  pasta('images/recipeOptions/pasta.png'),
  profile('images/profile.png');

  const Images(this.path);
  final String path;
}

class ImageLoader {
  Future<(XFile, Map<Images, Uint8List>)> loadImages() async {
    final imageBytes = <Images, Uint8List>{};
    for (var image in Images.values) {
      imageBytes[image] = await loadImageAsUint8List(image.path);
    }
    final imageFile = await getImageFile();
    return (imageFile, imageBytes);
  }

  Uint8List getImageBytesForReadGradient() {
    final width = 100;
    final height = 100;
    img.Image image = img.Image(width: width, height: height);
    for (int y = 0; y < height; y++) {
      for (int x = 0; x < width; x++) {
        image.setPixelRgba(x, y, 255, min(x + y * 0.24, 255), min(x + y * 0.24, 255), 255);
      }
    }

    // Encode the image to a format like PNG or JPEG and get the bytes
    // PNG is generally good for solid colors and sharp edges.
    Uint8List pngBytes = img.encodePng(image);

    return pngBytes;
  }

  Future<XFile> getImageFile() async {
    // Create an XFile from the byte data
    final XFile imageFile = XFile.fromData(
      await loadImageAsUint8List(Images.pasta.path),
      mimeType: 'text/plain', // Specify the MIME type
      name: 'hello_world.txt', // Provide a name for the file
    );
    return imageFile;
  }

  Future<Uint8List> loadImageAsUint8List(String imagePath) async {
    final ByteData data = await rootBundle.load(imagePath);
    return data.buffer.asUint8List();
  }
}
