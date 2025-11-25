import 'package:anyhoo_app_bar/src/action_button_info.dart';
import 'package:flutter/material.dart';
import 'package:logging/logging.dart';

class AnyhooAppBar extends StatefulWidget {
  const AnyhooAppBar({
    super.key,
    required this.hasBackButton,
    required this.title,
    required this.imageUrl,
    required this.actionButtons,
    this.scrollController,
    this.alwaysCollapsed = false,
    this.backButtonIcon,
    this.isLoading = false,
  });
  final bool hasBackButton;
  final String? title;
  final String? imageUrl;
  final List<ActionButtonInfo> actionButtons;
  final bool alwaysCollapsed;
  final IconData? backButtonIcon;
  final ScrollController? scrollController;
  final bool isLoading;

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

  @override
  void initState() {
    super.initState();
    if (widget.scrollController != null) {
      widget.scrollController!.addListener(_onScroll);
    }

    showTitleText = widget.alwaysCollapsed;
  }

  void _onScroll() {
    if (widget.alwaysCollapsed) {
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
    return SliverAppBar(
      expandedHeight: _getExpandedHeight(),
      pinned: true,
      leading: _getBackButton(context),
      actions: _getActionButtons(),
      flexibleSpace: DefaultShimmer(
        child: FlexibleSpaceBar(centerTitle: true, title: _getTitle(), background: _getBackgroundImage()),
      ),
    );
  }

  double _getExpandedHeight() {
    if (widget.alwaysCollapsed) {
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
      onPressed: () => context.pop(),
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
                child: Icon(ab.icon, color: Colors.black),
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
        .whereType<OverflowActionButtonInfo>()
        .map(
          (ab) => PopupMenuItem<String>(
            value: ab.title,
            child: Semantics(
              label: ab.title,
              child: Row(children: [Icon(ab.icon), SizedBox(width: 8), Text(ab.title)]),
            ),
          ),
        )
        .toList();

    return PopupMenuButton<String>(
      icon: const Icon(Icons.more_vert), // The standard overflow icon
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

  Widget? _getTitle() {
    if (widget.isLoading && widget.imageUrl == null) {
      return ShimmerShapes.text(width: 200);
    }
    if (widget.title == null || !showTitleText) {
      return null;
    }
    return Text(widget.title!, style: TextStyle(color: AppTheme.appBarTextColor));
  }

  Widget? _getBackgroundImage() {
    if (widget.alwaysCollapsed) {
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
    return Container(
      color: Colors.grey[300],
      child: const Icon(Icons.restaurant, size: 64, color: Colors.grey),
    );
  }
}
