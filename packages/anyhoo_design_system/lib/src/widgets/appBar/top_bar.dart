import 'package:anyhoo_design_system/anyhoo_design_system.dart';
import 'package:flutter/material.dart';

class TopBar extends StatelessWidget implements PreferredSizeWidget {
  const TopBar({
    super.key,
    this.topBarText,
    this.avatarUrl,
    this.onSettingsTap,
    this.showBackButton = false,
    this.onBackTap,
    this.useAvatar = false,
    this.onAvatarTap,
    this.showLogoutButton = false,
    this.onLogoutClick,
  });

  final String? topBarText;
  final String? avatarUrl;
  final VoidCallback? onSettingsTap;
  final bool showBackButton;
  final VoidCallback? onBackTap;
  final bool useAvatar;
  final VoidCallback? onAvatarTap;
  final bool showLogoutButton;
  final VoidCallback? onLogoutClick;

  @override
  Size get preferredSize => const Size.fromHeight(64);

  @override
  Widget build(BuildContext context) {
    final accent = context.accent;
    final surface = context.surface;

    return Material(
      child: DecoratedBox(
        decoration: BoxDecoration(
          border: Border(bottom: BorderSide(color: surface.cardBorder)),
        ),
        child: SafeArea(
          bottom: false,
          child: SizedBox(
            height: 64,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: DesignTokens.marginMobile),
              child: Row(
                children: [
                  if (showBackButton)
                    IconButton(
                      // key: keys.topBar.backButton,
                      onPressed: () {
                        onBack(context);
                      },
                      icon: Icon(Icons.arrow_back, color: surface.secondaryText),
                    )
                  else if (useAvatar)
                    _Avatar(avatarUrl: avatarUrl, borderColor: accent.primaryFixed, onAvatarTap: onAvatarTap),

                  Expanded(
                    child: Text(
                      topBarText ?? '',
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                        color: accent.primaryFixed,
                        fontStyle: FontStyle.italic,
                        letterSpacing: -0.5,
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: onSettingsTap,
                    icon: Icon(Icons.settings_outlined, color: surface.secondaryText),
                    selectedIcon: Icon(Icons.settings, color: accent.primaryFixed),
                  ),
                  if (showLogoutButton)
                    IconButton(
                      onPressed: onLogoutClick,
                      icon: Icon(Icons.logout, color: surface.secondaryText),
                    ),
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
}

class _Avatar extends StatelessWidget {
  const _Avatar({required this.borderColor, required this.onAvatarTap, this.avatarUrl});

  final String? avatarUrl;
  final Color borderColor;
  final VoidCallback? onAvatarTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        onAvatarTap?.call();
      },
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: borderColor),
        ),
        clipBehavior: Clip.antiAlias,
        child: avatarUrl != null
            ? Image.network(avatarUrl!, fit: BoxFit.cover)
            : ColoredBox(
                color: context.surface.containerHighest,
                child: Icon(Icons.person, color: context.surface.secondaryText),
              ),
      ),
    );
  }
}
