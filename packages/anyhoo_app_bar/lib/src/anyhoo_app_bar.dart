import 'package:anyhoo_app_bar/src/action_button_info.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:logging/logging.dart';
import 'package:anyhoo_shimmer/anyhoo_shimmer.dart';

class AnyhooAppBar extends StatefulWidget {
  const AnyhooAppBar({
    super.key,
    required this.hasBackButton,
    required this.title,
    required this.imageUrl,
    required this.actionButtons,
    this.scrollController,
    this.backButtonIcon,
    this.isLoading = false,
    this.backgroundColor,
    this.iconColor,
  });
  final bool hasBackButton;
  final String? title;
  final String? imageUrl;
  final List<ActionButtonInfo> actionButtons;
  final IconData? backButtonIcon;
  final ScrollController? scrollController;
  final bool isLoading;
  final Color? backgroundColor;
  final Color? iconColor;
  @override
  State<AnyhooAppBar> createState() => _AnyhooAppBarState();
}

class _AnyhooAppBarState extends State<AnyhooAppBar> {
  // ignore: unused_field
  final _log = Logger('CustomAppBar');

  final collapsedHeight = 40.0;
  final expandedHeight = 300.0;
  bool showTitleText = false;
  final collapsedPosition = 245;
  bool _listenerAdded = false;
  bool _retryScheduled = false;
  ScrollController? _currentController;

  @override
  void initState() {
    super.initState();
    showTitleText = widget.imageUrl == null;

    // Try to attach listener after the first frame
    if (widget.scrollController != null) {
      _currentController = widget.scrollController;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _tryAttachListener();
      });
    }
  }

  void _tryAttachListener() {
    if (!mounted || widget.scrollController == null) {
      return;
    }

    // Only add listener if not already added to this controller
    if (_listenerAdded && _currentController == widget.scrollController) {
      return;
    }

    if (widget.scrollController!.hasClients) {
      // Remove listener from previous controller if it changed
      if (_listenerAdded && _currentController != null && _currentController != widget.scrollController) {
        try {
          _currentController!.removeListener(_onScroll);
        } catch (e) {
          // Ignore errors when removing from disposed controller
        }
      }

      // Add listener to current controller
      if (!_listenerAdded || _currentController != widget.scrollController) {
        try {
          widget.scrollController!.addListener(_onScroll);
          _listenerAdded = true;
          _currentController = widget.scrollController;
          _retryScheduled = false;
        } catch (e) {
          // Ignore errors
        }
      }
    } else {
      // Retry after the next frame, but only if we haven't already scheduled a retry
      if (!_retryScheduled) {
        _retryScheduled = true;
        WidgetsBinding.instance.addPostFrameCallback((_) {
          _retryScheduled = false;
          if (mounted) {
            _tryAttachListener();
          }
        });
      }
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Also try here in case the controller gets attached during build
    if (widget.scrollController != null && !_listenerAdded) {
      _tryAttachListener();
    }
  }

  @override
  void didUpdateWidget(AnyhooAppBar oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Handle scrollController changes
    if (oldWidget.scrollController != widget.scrollController) {
      // Remove listener from old controller
      if (_listenerAdded && oldWidget.scrollController != null) {
        try {
          oldWidget.scrollController!.removeListener(_onScroll);
        } catch (e) {
          // Ignore errors when removing from disposed controller
        }
        _listenerAdded = false;
      }
      _currentController = widget.scrollController;
      _retryScheduled = false;
      // Add listener to new controller
      if (widget.scrollController != null) {
        _tryAttachListener();
      }
    } else if (widget.scrollController != null && !_listenerAdded) {
      // Controller is the same but listener wasn't added, try again
      _tryAttachListener();
    }
  }

  @override
  void dispose() {
    if (_listenerAdded && widget.scrollController != null) {
      widget.scrollController!.removeListener(_onScroll);
    }
    super.dispose();
  }

  void _onScroll() {
    if (widget.imageUrl == null) {
      return;
    }
    if (widget.scrollController!.position.pixels > collapsedPosition) {
      if (!showTitleText) {
        setState(() {
          showTitleText = true;
        });
      }
    } else {
      if (showTitleText) {
        setState(() {
          showTitleText = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final backgroundColor = widget.backgroundColor ?? Theme.of(context).colorScheme.primary;
    return SliverAppBar(
      expandedHeight: _getExpandedHeight(),
      pinned: true,
      backgroundColor: backgroundColor,
      surfaceTintColor: Colors.transparent,
      scrolledUnderElevation: 0,
      leading: _getBackButton(context),
      actions: _getActionButtons(),
      flexibleSpace: AnyhooShimmer(
        child: FlexibleSpaceBar(centerTitle: true, title: _getTitle(), background: _getBackgroundImage()),
      ),

      // TODO: Add a line at the bottom?
    );
  }

  double _getExpandedHeight() {
    if (widget.imageUrl == null) {
      return collapsedHeight;
    }
    return expandedHeight;
  }

  Widget? _getBackButton(BuildContext context) {
    if (!widget.hasBackButton) {
      return Container();
    }

    return IconButton(
      icon: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(color: Colors.black.withValues(alpha: 0.3), shape: BoxShape.circle),
        child: Icon(widget.backButtonIcon ?? Icons.arrow_back, color: Colors.white),
      ),
      onPressed: () => GoRouter.of(context).pop(),
    );
  }

  List<Widget> _getActionButtons() {
    return [..._getNonOverflowActionButtons(), if (_getOverflowActionButtons() != null) _getOverflowActionButtons()!];
  }

  List<Widget> _getNonOverflowActionButtons() {
    return widget.actionButtons
        .whereType<NormalActionButtonInfo>()
        .map(
          (ab) => Semantics(
            label: ab.name,
            child: IconButton(
              icon: Container(
                padding: const EdgeInsets.all(8),
                child: Icon(ab.icon, color: widget.iconColor ?? Theme.of(context).colorScheme.onPrimaryContainer),
              ),
              onPressed: ab.onTap,
            ),
          ),
        )
        .toList();
  }

  Widget? _getOverflowActionButtons() {
    if (widget.actionButtons.whereType<OverflowActionButtonInfo>().isEmpty) {
      return null;
    }

    final entries = widget.actionButtons
        .where((ab) => ab is OverflowActionButtonInfo || ab is DividerActionButtonInfo)
        .map((ab) => createPopupMenuEntry(ab))
        .toList();

    return PopupMenuButton<String>(
      icon: const Icon(Icons.more_vert, color: Colors.black), // TDOO: Should pick the color from the theme
      onSelected: (String result) {
        final actionButton = widget.actionButtons.whereType<OverflowActionButtonInfo>().firstWhere(
          (ab) => ab.title == result,
        );
        actionButton.onTap();
        return;
      },
      itemBuilder: (BuildContext context) => entries,
    );
  }

  PopupMenuEntry<String> createPopupMenuEntry(ActionButtonInfo ab) {
    if (ab is OverflowActionButtonInfo) {
      return PopupMenuItem<String>(
        value: ab.title,
        child: Semantics(
          label: ab.title,
          child: Row(children: [Icon(ab.icon), SizedBox(width: 8), Text(ab.title)]),
        ),
      );
    }
    if (ab is DividerActionButtonInfo) {
      return PopupMenuDivider();
    }
    throw Exception('Unknown action button type: ${ab.runtimeType}');
  }

  Widget? _getTitle() {
    if (widget.isLoading && widget.imageUrl == null) {
      return ShimmerShapes.text(width: 200);
    }
    if (widget.title == null || !showTitleText) {
      return null;
    }
    return Text(widget.title!, style: TextStyle(color: Theme.of(context).colorScheme.onSurface));
  }

  Widget? _getBackgroundImage() {
    if (widget.imageUrl == null) {
      return null;
    }
    if (widget.isLoading) {
      // TODO: What height should this be?
      return ShimmerShapes.image(
        height: 40,
        borderRadius: BorderRadius.only(bottomLeft: Radius.circular(16), bottomRight: Radius.circular(16)),
      );
    }
    if (widget.imageUrl != null) {
      if (widget.imageUrl!.startsWith('assets/')) {
        return Image.asset(
          widget.imageUrl!,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) {
            return _getFallbackBackground();
          },
        );
      }
      return Image.network(
        widget.imageUrl!,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return _getFallbackBackground();
        },
      );
    }
    return _getFallbackBackground();
  }

  Widget _getFallbackBackground() {
    return Container(color: Colors.red);
  }
}
