import 'dart:io';

import 'package:golden_screenshots/golden_screenshots.dart';
import 'package:path/path.dart' as p;
import 'package:test/test.dart';

void main() {
  test('findGoldenPngs finds png under goldens segment', () {
    final tmp = Directory.systemTemp.createTempSync('golden_screenshots_test');
    addTearDown(() => tmp.deleteSync(recursive: true));

    final pngPath = p.join(tmp.path, 'test', 'goldens', 'a.png');
    File(pngPath).createSync(recursive: true);

    final found = findGoldenPngs(tmp)
        .map((f) => p.relative(f.path, from: tmp.path).replaceAll(r'\', '/'))
        .toList();
    expect(found, ['test/goldens/a.png']);
  });

  test('collectGoldenPngs copies with hierarchy', () {
    final tmp = Directory.systemTemp.createTempSync('golden_screenshots_collect');
    addTearDown(() => tmp.deleteSync(recursive: true));

    final pngPath = p.join(tmp.path, 'pkg', 'test', 'goldens', 'x.png');
    File(pngPath).createSync(recursive: true);

    final out = Directory(p.join(tmp.path, 'out'));
    collectGoldenPngs(sourceRoot: tmp, outputDir: out, flat: false);

    final copied = File(p.join(out.path, 'pkg', 'test', 'goldens', 'x.png'));
    expect(copied.existsSync(), isTrue);
  });

  test('collectGoldenPngs flat rejects duplicate basenames', () {
    final tmp = Directory.systemTemp.createTempSync('golden_screenshots_flat');
    addTearDown(() => tmp.deleteSync(recursive: true));

    File(p.join(tmp.path, 'a', 'goldens', 'same.png')).createSync(recursive: true);
    File(p.join(tmp.path, 'b', 'goldens', 'same.png')).createSync(recursive: true);

    final out = Directory(p.join(tmp.path, 'out'));
    expect(
      () => collectGoldenPngs(sourceRoot: tmp, outputDir: out, flat: true),
      throwsStateError,
    );
  });
}
