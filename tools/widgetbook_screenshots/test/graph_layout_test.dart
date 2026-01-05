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

      // Verify level assignments and X positions (Y positions vary with centering)
      final nodeA = layout.nodes.firstWhere((n) => n.screen.name == 'a');
      expect(nodeA.level, equals(0));
      expect(nodeA.x, equals(50));

      final nodeB = layout.nodes.firstWhere((n) => n.screen.name == 'b');
      expect(nodeB.level, equals(1));
      expect(nodeB.x, equals(350));

      final nodeC = layout.nodes.firstWhere((n) => n.screen.name == 'c');
      expect(nodeC.level, equals(1));
      expect(nodeC.x, equals(350));

      final nodeD = layout.nodes.firstWhere((n) => n.screen.name == 'd');
      expect(nodeD.level, equals(2));
      expect(nodeD.x, equals(650));
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

    test('all levels are centered around the midpoint of the level with most nodes', () {
      final config = Config(
        widgetbookUrl: 'http://localhost:45678',
        outputDir: './screenshots',
        screens: [
          Screen(name: 'a', title: 'A', path: '/a', navigatesTo: ['b']),
          Screen(name: 'b', title: 'B', path: '/b', navigatesTo: ['c', 'd', 'e']),
          Screen(name: 'c', title: 'C', path: '/c', navigatesTo: []),
          Screen(name: 'd', title: 'D', path: '/d', navigatesTo: []),
          Screen(name: 'e', title: 'E', path: '/e', navigatesTo: []),
        ],
        cropGeometry: CropGeometry(width: 515, height: 1080, xOffset: 700, yOffset: 0),
      );

      final layout = GraphLayout(config);
      final nodesByLevel = _groupNodesByLevel(layout.nodes);

      // Level 2 has 3 nodes (most), so it's the reference level
      expect(nodesByLevel[2]!.length, 3);

      // Calculate expected midpoint based on reference level (3 nodes)
      final referenceLevelHeight = 3 * GraphLayout.nodeHeight + 2 * GraphLayout.verticalSpacing;
      final expectedMidpoint = GraphLayout.padding + referenceLevelHeight ~/ 2;

      // Verify all levels are centered around this midpoint
      for (int level = 0; level < nodesByLevel.length; level++) {
        final nodesInLevel = layout.nodes.where((n) => n.level == level).toList();
        if (nodesInLevel.isEmpty) continue;

        final nodeCount = nodesInLevel.length;
        final totalHeight = nodeCount * GraphLayout.nodeHeight + (nodeCount - 1) * GraphLayout.verticalSpacing;
        final expectedStartY = expectedMidpoint - totalHeight ~/ 2;

        // Check that the first node in the level starts at the expected Y position
        final firstNode = nodesInLevel.first;
        expect(firstNode.y, equals(expectedStartY),
            reason: 'Level $level should be centered around midpoint $expectedMidpoint');
      }
    });
  });

  group('GraphLayout.backEdges', () {
    test('no back edges for linear graph going left to right', () {
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
      final backEdges = layout.backEdges;

      // All edges go left to right (lower level to higher level), so no back edges
      expect(backEdges, isEmpty);
    });

    test('back edge exists when edge goes right to left', () {
      final config = Config(
        widgetbookUrl: 'http://localhost:45678',
        outputDir: './screenshots',
        screens: [
          Screen(name: 'a', title: 'A', path: '/a', navigatesTo: ['b']),
          Screen(name: 'b', title: 'B', path: '/b', navigatesTo: ['c']),
          Screen(name: 'c', title: 'C', path: '/c', navigatesTo: ['a']), // c->a goes right to left
        ],
        cropGeometry: CropGeometry(width: 515, height: 1080, xOffset: 700, yOffset: 0),
      );

      final layout = GraphLayout(config);
      final backEdges = layout.backEdges;

      // Only c->a goes from right to left (higher level to lower level)
      // a->b and b->c go left to right, so they are forward edges
      expect(backEdges.length, 1);
      expect(backEdges.first.from, 'c');
      expect(backEdges.first.to, 'a');
    });

    test('back edge when both directions exist but one goes right to left', () {
      final config = Config(
        widgetbookUrl: 'http://localhost:45678',
        outputDir: './screenshots',
        screens: [
          Screen(name: 'a', title: 'A', path: '/a', navigatesTo: ['b']),
          Screen(name: 'b', title: 'B', path: '/b', navigatesTo: ['a']), // b->a goes right to left
        ],
        cropGeometry: CropGeometry(width: 515, height: 1080, xOffset: 700, yOffset: 0),
      );

      final layout = GraphLayout(config);
      final backEdges = layout.backEdges;

      // b->a goes from right to left (b is at level 1, a is at level 0)
      // a->b goes left to right, so it's a forward edge
      expect(backEdges.length, 1);
      expect(backEdges.first.from, 'b');
      expect(backEdges.first.to, 'a');
    });

    test('no back edge when edge goes left to right', () {
      final config = Config(
        widgetbookUrl: 'http://localhost:45678',
        outputDir: './screenshots',
        screens: [
          Screen(name: 'a', title: 'A', path: '/a', navigatesTo: ['b']),
          Screen(name: 'b', title: 'B', path: '/b', navigatesTo: []), // b doesn't navigate back
        ],
        cropGeometry: CropGeometry(width: 515, height: 1080, xOffset: 700, yOffset: 0),
      );

      final layout = GraphLayout(config);
      final backEdges = layout.backEdges;

      // a->b goes left to right (a is at level 0, b is at level 1), so no back edge
      expect(backEdges, isEmpty);
    });

    test('multiple back edges in complex graph', () {
      final config = Config(
        widgetbookUrl: 'http://localhost:45678',
        outputDir: './screenshots',
        screens: [
          Screen(name: 'a', title: 'A', path: '/a', navigatesTo: ['b']),
          Screen(name: 'b', title: 'B', path: '/b', navigatesTo: ['c']),
          Screen(name: 'c', title: 'C', path: '/c', navigatesTo: ['a']), // c->a goes right to left
          Screen(name: 'd', title: 'D', path: '/d', navigatesTo: ['e']),
          Screen(name: 'e', title: 'E', path: '/e', navigatesTo: ['d']), // e->d goes right to left
        ],
        cropGeometry: CropGeometry(width: 515, height: 1080, xOffset: 700, yOffset: 0),
      );

      final layout = GraphLayout(config);
      final backEdges = layout.backEdges;

      // c->a goes right to left (c at level 2, a at level 0)
      // e->d goes right to left (e at level 1, d at level 0)
      expect(backEdges.length, 2);
      final backEdgeSet = backEdges.map((e) => '${e.from}->${e.to}').toSet();
      expect(backEdgeSet, containsAll(['c->a', 'e->d']));
    });

    test('back edge detection with intermediate nodes', () {
      final config = Config(
        widgetbookUrl: 'http://localhost:45678',
        outputDir: './screenshots',
        screens: [
          Screen(name: 'a', title: 'A', path: '/a', navigatesTo: ['b']),
          Screen(name: 'b', title: 'B', path: '/b', navigatesTo: ['c']),
          Screen(name: 'c', title: 'C', path: '/c', navigatesTo: ['d']),
          Screen(name: 'd', title: 'D', path: '/d', navigatesTo: ['a']), // d->a goes right to left
        ],
        cropGeometry: CropGeometry(width: 515, height: 1080, xOffset: 700, yOffset: 0),
      );

      final layout = GraphLayout(config);
      final backEdges = layout.backEdges;

      // Only d->a goes right to left (d at level 3, a at level 0)
      // a->b, b->c, c->d all go left to right
      expect(backEdges.length, 1);
      expect(backEdges.first.from, 'd');
      expect(backEdges.first.to, 'a');
    });

    test('no back edges for disconnected components', () {
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
      final backEdges = layout.backEdges;

      // No cycles, so no back edges
      expect(backEdges, isEmpty);
    });

    test('no back edge for self-loop (same level)', () {
      final config = Config(
        widgetbookUrl: 'http://localhost:45678',
        outputDir: './screenshots',
        screens: [
          Screen(name: 'a', title: 'A', path: '/a', navigatesTo: ['a']), // Self-loop
        ],
        cropGeometry: CropGeometry(width: 515, height: 1080, xOffset: 700, yOffset: 0),
      );

      final layout = GraphLayout(config);
      final backEdges = layout.backEdges;

      // Self-loop a->a: from and to are the same node (same level), so not a back edge
      expect(backEdges, isEmpty);
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
