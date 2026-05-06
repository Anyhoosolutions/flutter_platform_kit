import 'dart:io';

import 'package:path/path.dart' as p;
import 'package:flutter_test/flutter_test.dart';
import 'package:screenshot_kit/screenshot_kit.dart';

void main() {
  test('findScreenshotPngs finds png under goldens segment', () {
    final tmp = Directory.systemTemp.createTempSync('screenshot_kit_png');
    addTearDown(() => tmp.deleteSync(recursive: true));

    final pngPath = p.join(tmp.path, 'test', 'goldens', 'a.png');
    File(pngPath).createSync(recursive: true);

    final found = findScreenshotPngs(tmp)
        .map((f) => p.relative(f.path, from: tmp.path).replaceAll(r'\', '/'))
        .toList();
    expect(found, ['test/goldens/a.png']);
  });

  test('collectScreenshotPngs copies with hierarchy', () {
    final tmp = Directory.systemTemp.createTempSync('screenshot_kit_collect');
    addTearDown(() => tmp.deleteSync(recursive: true));

    final pngPath = p.join(tmp.path, 'pkg', 'test', 'goldens', 'x.png');
    File(pngPath).createSync(recursive: true);

    final out = Directory(p.join(tmp.path, 'out'));
    collectScreenshotPngs(sourceRoot: tmp, outputDir: out, flat: false);

    final copied = File(p.join(out.path, 'pkg', 'test', 'goldens', 'x.png'));
    expect(copied.existsSync(), isTrue);
  });

  test('collectScreenshotPngs flat rejects duplicate basenames', () {
    final tmp = Directory.systemTemp.createTempSync('screenshot_kit_flat');
    addTearDown(() => tmp.deleteSync(recursive: true));

    File(p.join(tmp.path, 'a', 'goldens', 'same.png')).createSync(recursive: true);
    File(p.join(tmp.path, 'b', 'goldens', 'same.png')).createSync(recursive: true);

    final out = Directory(p.join(tmp.path, 'out'));
    expect(
      () => collectScreenshotPngs(sourceRoot: tmp, outputDir: out, flat: true),
      throwsStateError,
    );
  });
}
