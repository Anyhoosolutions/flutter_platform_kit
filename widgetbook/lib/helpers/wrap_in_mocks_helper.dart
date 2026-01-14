import 'dart:math';
import 'dart:typed_data';

import 'package:anyhoo_auth/cubit/anyhoo_auth_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:widgetbook/widgetbook.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_workspace/helpers/device_frame_wrapper.dart';
// import 'package:widgetbook_workspace/helpers/image_loader.dart';
import 'package:widgetbook_workspace/helpers/mock_generator.dart';
import 'package:image/image.dart' as img;
import 'package:anyhoo_core/extensions/color_extensions.dart';
import 'package:cross_file/cross_file.dart';

class WrapInMocksHelper {
  Widget wrapInMocks(BuildContext context, Widget child) {
    final colorSchemeOptions = ['green', 'purple', 'red', 'lightblue', 'brown'];
    // ignore: deprecated_member_use
    final colorScheme = context.knobs.list(label: 'Color scheme', options: colorSchemeOptions, initialOption: 'purple');

    final mockGenerator = MockGenerator();

    // final isLoading = context.knobs.boolean(label: 'Show shimmer', initialValue: false);
    final deviceFrameWrapper = DeviceFrameWrapper.wrapInDeviceFrame(context, child);

    return Theme(
      data: ThemeData(colorScheme: getColorScheme(colorScheme)),
      child: MultiBlocProvider(
        providers: [BlocProvider<AnyhooAuthCubit>(create: (context) => mockGenerator.getMockAuthCubit())],
        child: deviceFrameWrapper,
      ),
    );
    //   },
    // );
  }
}

Uint8List getImageBytes() {
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

XFile getImageFile() {
  // Create an XFile from the byte data
  final XFile imageFile = XFile.fromData(
    getImageBytes(),
    mimeType: 'text/plain', // Specify the MIME type
    name: 'hello_world.txt', // Provide a name for the file
  );
  return imageFile;
}

ColorScheme getColorScheme(String colorScheme) {
  final cs = switch (colorScheme) {
    'red' => ColorScheme.fromSeed(seedColor: Colors.red),
    'green' => ColorScheme.fromSeed(seedColor: Colors.green),
    'purple' => ColorScheme.fromSeed(seedColor: Colors.purple),
    'lightblue' => ColorScheme.fromSeed(seedColor: Colors.lightBlue),
    'brown' => ColorScheme.fromSeed(seedColor: Colors.brown, onPrimaryContainer: Colors.blue),
    _ => ColorScheme.fromSeed(seedColor: Colors.white),
  };
  print('colorScheme: ${cs.primary.toHexString()}');
  return cs;
}
