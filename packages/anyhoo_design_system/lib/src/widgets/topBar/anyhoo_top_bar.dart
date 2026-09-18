import 'package:anyhoo_design_system/anyhoo_design_system.dart';
import 'package:anyhoo_design_system/src/widgets/topBar/keys.dart';
import 'package:flutter/material.dart';

class AnyhooTopBar extends StatelessWidget implements PreferredSizeWidget {
  const AnyhooTopBar({
    super.key,
    this.topBarTitle,
    this.topBarSubtitle,
    this.avatarUrl,
    this.showBackButton = false,
    this.onBackTap,
    this.logoAssetPath,
    this.overflowMenuIcon,
    this.overflowMenuIconColor,
    this.menuItems,
    this.buttonItems,
  });

  final String? topBarTitle;
  final String? topBarSubtitle;
  final String? logoAssetPath;
  final String? avatarUrl;
  final bool showBackButton;
  final VoidCallback? onBackTap;
  final List<AnyhooTopBarMenuItem>? menuItems;
  final List<AnyhooTopBarButtonItem>? buttonItems;
  final IconData? overflowMenuIcon;
  final Color? overflowMenuIconColor;

  @override
  Size get preferredSize => const Size.fromHeight(64);

  @override
  Widget build(BuildContext context) {
    final appBar = context.appBar;

    return Material(
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: appBar.topBarBackground,
          border: Border(bottom: BorderSide(color: appBar.topBarBorder)),
        ),
        child: SafeArea(
          bottom: false,
          child: SizedBox(
            height: 64,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: DesignTokens.marginMobile),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (showBackButton)
                    IconButton(
                      key: keys.topBar.backButton,
                      onPressed: () {
                        onBack(context);
                      },
                      icon: Icon(Icons.arrow_back, color: appBar.backButtonColor),
                    )
                  else if (logoAssetPath != null)
                    Image.asset(logoAssetPath!),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        if (topBarTitle != null) topBarTitle!.headline(),
                        if (topBarSubtitle != null) topBarSubtitle!.headline(size: HeadlineSize.small),
                      ],
                    ),
                  ),
                  ..._buttons(appBar) ?? [],
                  ?_getMenu(appBar),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void onBack(BuildContext context) {
    if (onBackTap != null) {
      onBackTap!();
    }
  }

  List<Widget>? _buttons(AppBarColors appBar) {
    if (buttonItems == null) {
      return null;
    }
    return buttonItems!
        .map(
          (item) => IconButton(
            key: item.key,
            onPressed: () {},
            icon: Icon(item.icon, color: item.color ?? appBar.backButtonColor),
          ),
        )
        .toList();
  }

  PopupMenuButton? _getMenu(AppBarColors appBar) {
    if (menuItems == null) {
      return null;
    }
    return PopupMenuButton<AnyhooTopBarMenuItem>(
      offset: const Offset(0, 48),
      onSelected: (item) => item.onTap(),
      itemBuilder: (context) =>
          menuItems
              ?.map(
                (item) => PopupMenuItem(
                  key: item.key,
                  value: item,
                  child: ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: item.icon != null ? Icon(item.icon) : null,
                    title: Text(item.label),
                  ),
                ),
              )
              .toList() ??
          [],
      child: _Avatar(
        avatarUrl: avatarUrl,
        overflowMenuIcon: overflowMenuIcon,
        overflowMenuIconColor: appBar.avatarColor,
      ),
    );
  }
}

class _Avatar extends StatelessWidget {
  const _Avatar({this.avatarUrl, this.overflowMenuIcon, this.overflowMenuIconColor});

  final String? avatarUrl;
  final IconData? overflowMenuIcon;
  final Color? overflowMenuIconColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      key: keys.topBar.avatar,
      width: 40,
      height: 40,
      decoration: BoxDecoration(shape: BoxShape.circle),
      clipBehavior: Clip.antiAlias,
      child: avatarUrl != null
          ? Image.network(avatarUrl!, fit: BoxFit.cover)
          : ColoredBox(
              color: context.surface.containerHighest,
              child: Icon(overflowMenuIcon ?? Icons.person, color: overflowMenuIconColor),
            ),
    );
  }
}
