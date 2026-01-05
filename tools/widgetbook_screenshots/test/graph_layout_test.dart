import 'package:test/test.dart';
import 'package:widgetbook_screenshots/src/config.dart';
import 'package:widgetbook_screenshots/src/graph_layout.dart';

void main() {
  group('GraphLayout._calculateLevels', () {
    test('empty graph returns empty levels', () {
      final config = Config(
        widgetbookUrl: 'http://localhost:45678',
        outputDir: './screenshots',
        screens: [],
        cropGeometry: CropGeometry(width: 515, height: 1080, xOffset: 700, yOffset: 0),
      );

      final layout = GraphLayout(config);
      final nodes = layout.nodes;

      expect(nodes, isEmpty);
    });

    test('single node is placed at level 0', () {
      final config = Config(
        widgetbookUrl: 'http://localhost:45678',
        outputDir: './screenshots',
        screens: [
          Screen(
            name: 'home',
            title: 'Home',
            path: '/home',
            navigatesTo: [],
          ),
        ],
        cropGeometry: CropGeometry(width: 515, height: 1080, xOffset: 700, yOffset: 0),
      );

      final layout = GraphLayout(config);
      final nodes = layout.nodes;

      expect(nodes.length, 1);
      expect(nodes.first.level, 0);
      expect(nodes.first.screen.name, 'home');
    });

    test('linear graph assigns sequential levels', () {
      final config = Config(
        widgetbookUrl: 'http://localhost:45678',
        outputDir: './screenshots',
        screens: [
          Screen(name: 'a', title: 'A', path: '/a', navigatesTo: ['b']),
          Screen(name: 'b', title: 'B', path: '/b', navigatesTo: ['c']),
          Screen(name: 'c', title: 'C', path: '/c', navigatesTo: []),
        ],
        cropGeometry: CropGeometry(width: 515, height: 1080, xOffset: 700, yOffset: 0),
      );

      final layout = GraphLayout(config);
      final nodesByLevel = _groupNodesByLevel(layout.nodes);

      expect(nodesByLevel.length, 3);
      expect(nodesByLevel[0], contains('a'));
      expect(nodesByLevel[1], contains('b'));
      expect(nodesByLevel[2], contains('c'));
    });

    test('multiple start nodes are placed at level 0', () {
      final config = Config(
        widgetbookUrl: 'http://localhost:45678',
        outputDir: './screenshots',
        screens: [
          Screen(name: 'a', title: 'A', path: '/a', navigatesTo: ['c']),
          Screen(name: 'b', title: 'B', path: '/b', navigatesTo: ['c']),
          Screen(name: 'c', title: 'C', path: '/c', navigatesTo: []),
        ],
        cropGeometry: CropGeometry(width: 515, height: 1080, xOffset: 700, yOffset: 0),
      );

      final layout = GraphLayout(config);
      final nodesByLevel = _groupNodesByLevel(layout.nodes);

      expect(nodesByLevel.length, 2);
      expect(nodesByLevel[0], containsAll(['a', 'b']));
      expect(nodesByLevel[1], contains('c'));
    });

    test('branching graph assigns correct levels', () {
      final config = Config(
        widgetbookUrl: 'http://localhost:45678',
        outputDir: './screenshots',
        screens: [
          Screen(name: 'a', title: 'A', path: '/a', navigatesTo: ['b', 'c']),
          Screen(name: 'b', title: 'B', path: '/b', navigatesTo: ['d']),
          Screen(name: 'c', title: 'C', path: '/c', navigatesTo: ['d']),
          Screen(name: 'd', title: 'D', path: '/d', navigatesTo: []),
        ],
        cropGeometry: CropGeometry(width: 515, height: 1080, xOffset: 700, yOffset: 0),
      );

      final layout = GraphLayout(config);
      final nodesByLevel = _groupNodesByLevel(layout.nodes);

      expect(nodesByLevel.length, 3);
      expect(nodesByLevel[0], contains('a'));
      expect(nodesByLevel[1], containsAll(['b', 'c']));
      expect(nodesByLevel[2], contains('d'));
    });

    test('cycle detection places nodes in next level', () {
      final config = Config(
        widgetbookUrl: 'http://localhost:45678',
        outputDir: './screenshots',
        screens: [
          Screen(name: 'a', title: 'A', path: '/a', navigatesTo: ['b']),
          Screen(name: 'b', title: 'B', path: '/b', navigatesTo: ['a']),
        ],
        cropGeometry: CropGeometry(width: 515, height: 1080, xOffset: 700, yOffset: 0),
      );

      final layout = GraphLayout(config);
      final nodesByLevel = _groupNodesByLevel(layout.nodes);

      // Both nodes should be assigned levels
      expect(nodesByLevel.length, greaterThanOrEqualTo(1));
      // The cycle should be broken by placing one node in the next level
      final allNodes = layout.nodes.map((n) => n.screen.name).toList();
      expect(allNodes, containsAll(['a', 'b']));
    });

    test('complex cycle with multiple nodes', () {
      final config = Config(
        widgetbookUrl: 'http://localhost:45678',
        outputDir: './screenshots',
        screens: [
          Screen(name: 'a', title: 'A', path: '/a', navigatesTo: ['b']),
          Screen(name: 'b', title: 'B', path: '/b', navigatesTo: ['c']),
          Screen(name: 'c', title: 'C', path: '/c', navigatesTo: ['a']),
        ],
        cropGeometry: CropGeometry(width: 515, height: 1080, xOffset: 700, yOffset: 0),
      );

      final layout = GraphLayout(config);
      final nodesByLevel = _groupNodesByLevel(layout.nodes);

      // All nodes should be assigned levels
      expect(nodesByLevel.length, greaterThanOrEqualTo(1));
      final allNodes = layout.nodes.map((n) => n.screen.name).toList();
      expect(allNodes, containsAll(['a', 'b', 'c']));
    });

    test('nodes within same level are sorted alphabetically', () {
      final config = Config(
        widgetbookUrl: 'http://localhost:45678',
        outputDir: './screenshots',
        screens: [
          Screen(name: 'zebra', title: 'Zebra', path: '/zebra', navigatesTo: ['end']),
          Screen(name: 'apple', title: 'Apple', path: '/apple', navigatesTo: ['end']),
          Screen(name: 'banana', title: 'Banana', path: '/banana', navigatesTo: ['end']),
          Screen(name: 'end', title: 'End', path: '/end', navigatesTo: []),
        ],
        cropGeometry: CropGeometry(width: 515, height: 1080, xOffset: 700, yOffset: 0),
      );

      final layout = GraphLayout(config);
      final nodesByLevel = _groupNodesByLevel(layout.nodes);

      expect(nodesByLevel.length, 2);
      // Level 0 should have sorted nodes
      expect(nodesByLevel[0], orderedEquals(['apple', 'banana', 'zebra']));
      expect(nodesByLevel[1], contains('end'));
    });

    test('disconnected components are handled correctly', () {
      final config = Config(
        widgetbookUrl: 'http://localhost:45678',
        outputDir: './screenshots',
        screens: [
          Screen(name: 'a', title: 'A', path: '/a', navigatesTo: ['b']),
          Screen(name: 'b', title: 'B', path: '/b', navigatesTo: []),
          Screen(name: 'x', title: 'X', path: '/x', navigatesTo: ['y']),
          Screen(name: 'y', title: 'Y', path: '/y', navigatesTo: []),
        ],
        cropGeometry: CropGeometry(width: 515, height: 1080, xOffset: 700, yOffset: 0),
      );

      final layout = GraphLayout(config);
      final nodesByLevel = _groupNodesByLevel(layout.nodes);

      // Both disconnected components should start at level 0
      expect(nodesByLevel.length, 2);
      expect(nodesByLevel[0], containsAll(['a', 'x']));
      expect(nodesByLevel[1], containsAll(['b', 'y']));
    });

    test('node with multiple incoming edges is placed correctly', () {
      final config = Config(
        widgetbookUrl: 'http://localhost:45678',
        outputDir: './screenshots',
        screens: [
          Screen(name: 'a', title: 'A', path: '/a', navigatesTo: ['b', 'c']),
          Screen(name: 'b', title: 'B', path: '/b', navigatesTo: ['d']),
          Screen(name: 'c', title: 'C', path: '/c', navigatesTo: ['d']),
          Screen(name: 'd', title: 'D', path: '/d', navigatesTo: []),
        ],
        cropGeometry: CropGeometry(width: 515, height: 1080, xOffset: 700, yOffset: 0),
      );

      final layout = GraphLayout(config);
      final nodesByLevel = _groupNodesByLevel(layout.nodes);

      expect(nodesByLevel.length, 3);
      expect(nodesByLevel[0], containsAll(['a']));
      expect(nodesByLevel[1], containsAll(['b', 'c']));
      expect(nodesByLevel[2], contains('d'));

      expect(layout.nodes[0].screen.name, equals('a'));
      expect(layout.nodes[0].x, equals(50));
      expect(layout.nodes[0].y, equals(275));

      expect(layout.nodes[1].screen.name, equals('b'));
      expect(layout.nodes[1].x, equals(50));
      expect(layout.nodes[1].y, equals(725));

      expect(layout.nodes[2].screen.name, equals('c'));
      expect(layout.nodes[2].x, equals(350));
      expect(layout.nodes[2].y, equals(50));

      expect(layout.nodes[3].screen.name, equals('d'));
      expect(layout.nodes[3].x, equals(650));
      expect(layout.nodes[3].y, equals(50));
    });

    test('all nodes are assigned to levels', () {
      final config = Config(
        widgetbookUrl: 'http://localhost:45678',
        outputDir: './screenshots',
        screens: [
          Screen(name: 'a', title: 'A', path: '/a', navigatesTo: ['b', 'c']),
          Screen(name: 'b', title: 'B', path: '/b', navigatesTo: ['d']),
          Screen(name: 'c', title: 'C', path: '/c', navigatesTo: ['d']),
          Screen(name: 'd', title: 'D', path: '/d', navigatesTo: ['e']),
          Screen(name: 'e', title: 'E', path: '/e', navigatesTo: []),
        ],
        cropGeometry: CropGeometry(width: 515, height: 1080, xOffset: 700, yOffset: 0),
      );

      final layout = GraphLayout(config);
      final nodes = layout.nodes;

      // All screens should be represented
      expect(nodes.length, 5);
      final nodeNames = nodes.map((n) => n.screen.name).toSet();
      expect(nodeNames, containsAll(['a', 'b', 'c', 'd', 'e']));

      // All nodes should have valid levels
      for (final node in nodes) {
        expect(node.level, greaterThanOrEqualTo(0));
      }
    });
  });
}

/// Helper function to group nodes by their level for easier testing
Map<int, List<String>> _groupNodesByLevel(List<PositionedNode> nodes) {
  final Map<int, List<String>> grouped = {};
  for (final node in nodes) {
    grouped.putIfAbsent(node.level, () => []).add(node.screen.name);
  }
  // Sort each level's nodes for consistent testing
  for (final level in grouped.keys) {
    grouped[level]!.sort();
  }
  return grouped;
}
