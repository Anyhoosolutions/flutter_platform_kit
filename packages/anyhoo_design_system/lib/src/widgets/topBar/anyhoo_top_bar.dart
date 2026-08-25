import 'package:anyhoo_design_system/anyhoo_design_system.dart';
import 'package:flutter/material.dart';

enum _AvatarMenuAction { settings, profile, logout }

class AnyhooTopBar extends StatelessWidget implements PreferredSizeWidget {
  const AnyhooTopBar({
    super.key,
    this.topBarTitle,
    this.topBarSubtitle,
    this.avatarUrl,
    this.onSettingsTap,
    this.onProfileTap,
    this.showBackButton = false,
    this.onBackTap,
    this.logoAssetPath,
    this.onLogoutClick,
  });

  final String? topBarTitle;
  final String? topBarSubtitle;
  final String? logoAssetPath;
  final String? avatarUrl;
  final VoidCallback? onSettingsTap;
  final VoidCallback? onProfileTap;
  final bool showBackButton;
  final VoidCallback? onBackTap;

  final VoidCallback? onLogoutClick;

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
                      // key: keys.topBar.backButton,
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
                  _getMenu(appBar),
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

  PopupMenuButton _getMenu(AppBarColors appBar) {
    return PopupMenuButton<_AvatarMenuAction>(
      offset: const Offset(0, 48),
      onSelected: (action) {
        switch (action) {
          case _AvatarMenuAction.settings:
            onSettingsTap?.call();
          case _AvatarMenuAction.profile:
            onProfileTap?.call();
          case _AvatarMenuAction.logout:
            onLogoutClick?.call();
        }
      },
      itemBuilder: (context) => [
        const PopupMenuItem(
          value: _AvatarMenuAction.settings,
          child: ListTile(
            contentPadding: EdgeInsets.zero,
            leading: Icon(Icons.settings_outlined),
            title: Text('Settings'),
          ),
        ),
        const PopupMenuItem(
          value: _AvatarMenuAction.profile,
          child: ListTile(contentPadding: EdgeInsets.zero, leading: Icon(Icons.person_outline), title: Text('Profile')),
        ),
        const PopupMenuItem(
          value: _AvatarMenuAction.logout,
          child: ListTile(contentPadding: EdgeInsets.zero, leading: Icon(Icons.logout), title: Text('Log out')),
        ),
      ],
      child: _Avatar(avatarUrl: avatarUrl, avatarColor: appBar.avatarColor),
    );
  }
}

class _Avatar extends StatelessWidget {
  const _Avatar({required this.avatarColor, this.avatarUrl});

  final String? avatarUrl;
  final Color avatarColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(shape: BoxShape.circle),
      clipBehavior: Clip.antiAlias,
      child: avatarUrl != null
          ? Image.network(avatarUrl!, fit: BoxFit.cover)
          : ColoredBox(
              color: context.surface.containerHighest,
              child: Icon(Icons.person, color: avatarColor),
            ),
    );
  }
}
