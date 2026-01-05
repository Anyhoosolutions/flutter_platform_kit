import 'package:widgetbook_screenshots/src/config.dart';

/// Represents a positioned node in the graph
class PositionedNode {
  final Screen screen;
  final int x;
  final int y;
  final int level; // Which column/level this node is in (0 = leftmost)

  PositionedNode({
    required this.screen,
    required this.x,
    required this.y,
    required this.level,
  });
}

/// Represents an edge/arrow between two nodes
class Edge {
  final String from;
  final String to;

  Edge({required this.from, required this.to});
}

/// Graph layout algorithm for left-to-right hierarchical layout
class GraphLayout {
  final Config config;
  final Map<String, PositionedNode> nodesMap = {};
  final List<Edge> _edges = [];

  // Layout constants
  static const int nodeWidth = 200;
  static const int nodeHeight = 400;
  static const int horizontalSpacing = 100; // Space between levels
  static const int verticalSpacing = 50; // Space between nodes in same level
  static const int branchSpacing = 300; // Extra spacing between different branches (increased for better separation)
  static const int branchLaneOffset = 40; // Horizontal offset per branch lane for visual separation
  static const int padding = 50; // Padding around entire graph
  static const int textHeight = 20; // Height for text labels below screenshots
  static const int textPadding = 10; // Space between screenshot and text

  GraphLayout(this.config) {
    _buildGraph();
  }

  void _buildGraph() {
    // Build edges from navigation relationships
    // Use a set to track unique edges and avoid duplicates
    final edgeSet = <String>{};
    for (final screen in config.screens) {
      for (final targetName in screen.navigatesTo) {
        final edgeKey = '${screen.name}->$targetName';
        // Only add edge if we haven't seen it before (handles duplicate navigatesTo entries)
        if (!edgeSet.contains(edgeKey)) {
          edgeSet.add(edgeKey);
          _edges.add(Edge(from: screen.name, to: targetName));
        }
      }
    }

    // Calculate levels using topological sort (handles cycles by breaking them)
    final levels = _calculateLevels();

    // Identify separate branches from root nodes for better visual separation
    final branchMap = _identifyBranches();

    // Assign lane numbers to branches for horizontal separation
    final branchLanes = _assignBranchLanes(branchMap);

    // Find the level with the most nodes to use as reference for centering
    int maxNodeCount = 0;
    int referenceLevelIndex = -1;
    for (int i = 0; i < levels.length; i++) {
      if (levels[i].length > maxNodeCount) {
        maxNodeCount = levels[i].length;
        referenceLevelIndex = i;
      }
    }

    // Calculate the midpoint Y position based on the reference level
    // This will be the center point around which all levels are aligned
    int graphMidpoint;
    if (referenceLevelIndex >= 0 && maxNodeCount > 0) {
      final referenceLevelHeight = maxNodeCount * nodeHeight + (maxNodeCount - 1) * verticalSpacing;
      // The midpoint is at the center of the reference level's total height
      // This represents the vertical center of the level with most nodes
      graphMidpoint = padding + referenceLevelHeight ~/ 2;
    } else {
      // Fallback if no levels exist
      graphMidpoint = padding + nodeHeight ~/ 2;
    }

    // Position nodes based on levels, grouped by branches for better separation
    int currentX = padding;
    for (int level = 0; level < levels.length; level++) {
      final nodesInLevel = levels[level];
      if (nodesInLevel.isEmpty) continue;

      // Group nodes by branch
      final nodesByBranch = <String, List<String>>{};
      for (final nodeName in nodesInLevel) {
        final branch = branchMap[nodeName] ?? 'default';
        nodesByBranch.putIfAbsent(branch, () => []).add(nodeName);
      }

      // Sort branches for consistent ordering
      final sortedBranches = nodesByBranch.keys.toList()..sort();

      // Calculate total height including branch spacing
      int totalHeight = 0;
      for (final branch in sortedBranches) {
        final branchNodes = nodesByBranch[branch]!;
        if (totalHeight > 0) {
          totalHeight += branchSpacing; // Add spacing between branches
        }
        totalHeight += branchNodes.length * nodeHeight + (branchNodes.length - 1) * verticalSpacing;
      }

      // Center this level around the reference midpoint
      int currentY = graphMidpoint - totalHeight ~/ 2;

      // Position nodes grouped by branch
      for (final branch in sortedBranches) {
        final branchNodes = nodesByBranch[branch]!..sort(); // Sort within branch for consistency

        // Add spacing before this branch (except first)
        if (currentY > graphMidpoint - totalHeight ~/ 2) {
          currentY += branchSpacing;
        }

        for (final screenName in branchNodes) {
          final screen = config.screens.firstWhere((s) => s.name == screenName);
          final branch = branchMap[screenName] ?? 'default';
          final laneNumber = branchLanes[branch] ?? 0;
          // Add horizontal offset based on lane number to create parallel tracks
          final xOffset = laneNumber * branchLaneOffset;
          nodesMap[screenName] = PositionedNode(
            screen: screen,
            x: currentX + xOffset,
            y: currentY,
            level: level,
          );
          currentY += nodeHeight + verticalSpacing;
        }
      }

      currentX += nodeWidth + horizontalSpacing;
    }
  }

  /// Calculate node levels using BFS, handling cycles
  List<List<String>> _calculateLevels() {
    final Map<String, int> levels = {};
    final Map<String, List<String>> graph = {};
    final Map<String, int> inDegree = {};

    // Initialize
    for (final screen in config.screens) {
      graph[screen.name] = [];
      inDegree[screen.name] = 0;
    }

    // Build graph and calculate in-degrees
    for (final edge in _edges) {
      graph[edge.from]!.add(edge.to);
      inDegree[edge.to] = (inDegree[edge.to] ?? 0) + 1;
    }

    // Find start nodes (nodes with no incoming edges)
    final queue = <String>[];
    for (final screen in config.screens) {
      if (inDegree[screen.name] == 0) {
        queue.add(screen.name);
        levels[screen.name] = 0;
      }
    }

    // If no start nodes (all nodes are in cycles), pick first screen
    if (queue.isEmpty && config.screens.isNotEmpty) {
      final firstScreen = config.screens.first.name;
      queue.add(firstScreen);
      levels[firstScreen] = 0;
    }

    // BFS to assign levels
    // Use a set to track which nodes need processing to avoid duplicates
    final processingSet = <String>{};
    final processedNodes = <String>{}; // Track nodes that have been fully processed
    int iterations = 0;
    const maxIterations = 10000; // Safety limit

    while (queue.isNotEmpty && iterations < maxIterations) {
      iterations++;
      final current = queue.removeAt(0);
      processingSet.remove(current);
      final currentLevel = levels[current]!;

      for (final neighbor in graph[current] ?? []) {
        final newLevel = currentLevel + 1;
        if (!levels.containsKey(neighbor)) {
          // First time seeing this neighbor
          levels[neighbor] = newLevel;
          if (!processingSet.contains(neighbor)) {
            queue.add(neighbor);
            processingSet.add(neighbor);
          }
        } else {
          final neighborLevel = levels[neighbor]!;
          if (neighborLevel == currentLevel) {
            // Cycle detected (back edge to same level) - break it by placing neighbor in next level
            // Don't re-queue to avoid infinite loops in tight cycles
            levels[neighbor] = currentLevel + 1;
          } else if (neighborLevel < newLevel && !processedNodes.contains(neighbor)) {
            // Longer path found - update level and re-process neighbors
            // Only re-queue if we haven't fully processed this node yet
            levels[neighbor] = newLevel;
            if (!processingSet.contains(neighbor)) {
              queue.add(neighbor);
              processingSet.add(neighbor);
            }
          }
          // If neighborLevel >= newLevel or already processed, no update needed
        }
      }

      // Mark current node as fully processed
      processedNodes.add(current);
    }

    if (iterations >= maxIterations) {
      throw StateError('Infinite loop detected in level calculation. Graph may have complex cycles.');
    }

    // Assign levels to any remaining nodes (part of cycles)
    for (final screen in config.screens) {
      if (!levels.containsKey(screen.name)) {
        final maxLevel = levels.values.isEmpty ? 0 : levels.values.reduce((a, b) => a > b ? a : b);
        levels[screen.name] = maxLevel + 1;
      }
    }

    // Group nodes by level
    final maxLevel = levels.values.isEmpty ? 0 : levels.values.reduce((a, b) => a > b ? a : b);
    final result = List<List<String>>.generate(maxLevel + 1, (_) => []);

    for (final screen in config.screens) {
      final level = levels[screen.name]!;
      result[level].add(screen.name);
    }

    // Sort nodes within each level for better layout
    for (final level in result) {
      level.sort();
    }

    return result;
  }

  /// Identify separate branches from root nodes for visual grouping
  /// Returns a map from node name to branch identifier
  Map<String, String> _identifyBranches() {
    final Map<String, String> branchMap = {};
    final Map<String, List<String>> graph = {};
    final Map<String, int> inDegree = {};

    // Build graph and calculate in-degrees
    for (final screen in config.screens) {
      graph[screen.name] = [];
      inDegree[screen.name] = 0;
    }

    for (final edge in _edges) {
      graph[edge.from]!.add(edge.to);
      inDegree[edge.to] = (inDegree[edge.to] ?? 0) + 1;
    }

    // Find root nodes (nodes with no incoming edges)
    final rootNodes = <String>[];
    for (final screen in config.screens) {
      if (inDegree[screen.name] == 0) {
        rootNodes.add(screen.name);
      }
    }

    // If no root nodes, use first screen as root
    if (rootNodes.isEmpty && config.screens.isNotEmpty) {
      rootNodes.add(config.screens.first.name);
    }

    // For each root node, identify its branches
    for (final root in rootNodes) {
      branchMap[root] = root; // Root nodes are their own branch

      // Get direct children of root (first-level branches)
      final directChildren = graph[root] ?? [];

      // Traverse from each direct child to assign all descendants to that branch
      // Use BFS to assign nodes to the branch that reaches them first (shortest path)
      for (final branchStart in directChildren) {
        final branchId = branchStart;
        final queue = <String>[branchStart];
        final visited = <String>{branchStart};

        while (queue.isNotEmpty) {
          final current = queue.removeAt(0);

          // Assign current node to this branch if not already assigned to another branch
          // This ensures nodes are assigned to the first branch that reaches them
          if (!branchMap.containsKey(current)) {
            branchMap[current] = branchId;
          }

          // Process children
          for (final child in graph[current] ?? []) {
            // Only process if not already visited (prevents infinite loops in cycles)
            if (!visited.contains(child)) {
              visited.add(child);
              queue.add(child);
            }
            // If child is already visited, skip it (cycle detected and already processed)
          }
        }
      }
    }

    // Assign any remaining nodes (part of cycles or unreachable) to a default branch
    for (final screen in config.screens) {
      if (!branchMap.containsKey(screen.name)) {
        branchMap[screen.name] = 'default';
      }
    }

    return branchMap;
  }

  /// Assign lane numbers to branches for horizontal separation
  /// Returns a map from branch identifier to lane number (0, 1, 2, ...)
  Map<String, int> _assignBranchLanes(Map<String, String> branchMap) {
    final Map<String, int> branchLanes = {};
    final uniqueBranches = branchMap.values.toSet().toList()..sort();

    // Assign lane numbers starting from 0, centered around 0
    // For example: 3 branches -> lanes -1, 0, 1 (centered)
    //              4 branches -> lanes -1, 0, 1, 2 (slightly off-center)
    int laneNumber = 0;
    if (uniqueBranches.length > 1) {
      // Center lanes around 0
      final centerOffset = -(uniqueBranches.length - 1) ~/ 2;
      for (final branch in uniqueBranches) {
        branchLanes[branch] = centerOffset + laneNumber;
        laneNumber++;
      }
    } else {
      // Single branch gets lane 0
      branchLanes[uniqueBranches.first] = 0;
    }

    return branchLanes;
  }

  List<PositionedNode> get nodes => nodesMap.values.toList();
  List<Edge> get edges => _edges;

  /// Get back edges: forward edges that go from right to left in the layout
  /// (i.e., edges where the source node is at a higher level than the target node)
  List<Edge> get backEdges {
    final backEdgesList = <Edge>[];

    for (final edge in _edges) {
      final fromNode = nodesMap[edge.from];
      final toNode = nodesMap[edge.to];

      // Skip if nodes don't exist (shouldn't happen, but safety check)
      if (fromNode == null || toNode == null) {
        continue;
      }

      // Back edge: source node is to the right of target node (higher level)
      if (fromNode.level > toNode.level) {
        backEdgesList.add(edge);
      }
    }

    return backEdgesList;
  }

  /// Get the total dimensions needed for the canvas
  (int width, int height) getDimensions() {
    if (nodesMap.isEmpty) {
      return (padding * 2, padding * 2);
    }

    int maxX = 0;
    int maxY = 0;
    int minY = double.maxFinite.toInt();

    for (final node in nodesMap.values) {
      final nodeRight = node.x + nodeWidth;
      // Account for screenshot height + text padding + text height
      final nodeBottom = node.y + nodeHeight + textPadding + textHeight;
      if (nodeRight > maxX) maxX = nodeRight;
      if (nodeBottom > maxY) maxY = nodeBottom;
      if (node.y < minY) minY = node.y;
    }

    // Account for back-edge arrows that extend below nodes
    // Calculate how much extra space we need based on number of back edges
    final backEdgesList = backEdges;
    final baseOffset = 30;
    final offsetPerLevel = 40; // Additional offset per overlapping level
    final maxOffset = baseOffset + (backEdgesList.isNotEmpty ? offsetPerLevel * (backEdgesList.length - 1) : 0);
    final extraBottomSpace = backEdgesList.isNotEmpty ? maxOffset + 20 : 0; // Add some padding

    return (maxX + padding, maxY + padding + extraBottomSpace);
  }
}
