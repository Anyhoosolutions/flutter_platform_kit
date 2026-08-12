import 'package:anyhoo_design_system/anyhoo_design_system.dart';
import 'package:flutter/material.dart';

/// Horizontal profile card with avatar, identity text, and a compact action.
class AnyhooProfileCard extends StatelessWidget {
  const AnyhooProfileCard({
    super.key,
    required this.name,
    required this.handle,
    this.avatar,
    this.avatarUrl,
    this.actionLabel = 'Follow',
    this.onAction,
  });

  final String name;
  final String handle;
  final Widget? avatar;
  final String? avatarUrl;
  final String actionLabel;
  final VoidCallback? onAction;

  @override
  Widget build(BuildContext context) {
    final surface = context.surface;
    final accent = context.accent;

    return AnyhooCardShell(
      padding: const EdgeInsets.all(DesignTokens.spacingMd),
      child: Row(
        children: [
          _Avatar(avatar: avatar, avatarUrl: avatarUrl),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppFonts.inter.copyWith(
                    fontSize: 14,
                    height: 20 / 14,
                    fontWeight: FontWeight.w700,
                    color: surface.primaryText,
                  ),
                ),
                Text(
                  handle,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppFonts.inter.copyWith(
                    fontSize: 14,
                    height: 20 / 14,
                    fontWeight: FontWeight.w400,
                    color: surface.secondaryText,
                  ),
                ),
              ],
            ),
          ),
          if (onAction != null) ...[
            const SizedBox(width: DesignTokens.spacingSm),
            FilledButton(
              onPressed: onAction,
              style: FilledButton.styleFrom(
                backgroundColor: accent.primaryFixed,
                foregroundColor: accent.onPrimaryFixed,
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: DesignTokens.spacingSm),
                minimumSize: const Size(48, 40),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(DesignTokens.radiusMd),
                ),
                elevation: 0,
              ),
              child: Text(
                actionLabel,
                style: AppFonts.inter.copyWith(
                  fontSize: 12,
                  height: 16 / 12,
                  fontWeight: FontWeight.w500,
                  letterSpacing: 0.5,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _Avatar extends StatelessWidget {
  const _Avatar({this.avatar, this.avatarUrl});

  final Widget? avatar;
  final String? avatarUrl;

  @override
  Widget build(BuildContext context) {
    final surface = context.surface;

    return Container(
      width: 64,
      height: 64,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: surface.containerHighest, width: 2),
        color: surface.containerHighest,
      ),
      clipBehavior: Clip.antiAlias,
      child: avatar ??
          (avatarUrl != null
              ? Image.network(avatarUrl!, fit: BoxFit.cover)
              : Icon(Icons.person, color: surface.secondaryText)),
    );
  }
}
