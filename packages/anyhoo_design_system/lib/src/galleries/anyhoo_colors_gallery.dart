import 'package:anyhoo_design_system/anyhoo_design_system.dart';
import 'package:anyhoo_widget_extension_methods/anyhoo_widget_extension_methods.dart';
import 'package:flutter/material.dart';

class AnyhooColorsGallery extends StatelessWidget {
  const AnyhooColorsGallery({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        child: ColoredBox(
          color: context.surface.scaffoldBackground,
          child: Column(
            spacing: 4,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              'Colors'.display(size: DisplaySize.medium).pad(b: DesignTokens.spacingSm),

              ..._surfaceColors(context),
              const SizedBox(height: 8),

              ..._accentColors(context),
              const SizedBox(height: 8),

              ..._statusColors(context),
              const SizedBox(height: 8),

              ..._shimmerColors(context),
              const SizedBox(height: 8),

              ..._appBarColors(context),
              const SizedBox(height: 8),

              ...controlsColors(context),
              const SizedBox(height: 8),
            ],
          ).pad(h: 16),
        ),
      ),
    );
  }

  List<Widget> _surfaceColors(BuildContext context) {
    final surface = context.surface;

    return [
      'Surface Colors'.headline(size: HeadlineSize.small).pad(b: DesignTokens.spacingSm),

      _colors('scaffoldBackground', surface.scaffoldBackground),
      _colors('lowContrastBackground', surface.lowContrastBackground),
      _colors('primaryText', surface.primaryText),
      _colors('secondaryText', surface.secondaryText),
      _colors('containerHigh', surface.containerHigh),
      _colors('containerLow', surface.containerLow),
      _colors('containerHighest', surface.containerHighest),
      _colors('containerLowest', surface.containerLowest),
      _colors('outline', surface.outline),
      _colors('secondaryContainer', surface.secondaryContainer),
      _colors('onSecondaryContainer', surface.onSecondaryContainer),
      _colors('inverseSurface', surface.inverseSurface),
      _colors('inverseOnSurface', surface.inverseOnSurface),
    ];
  }

  List<Widget> _appBarColors(BuildContext context) {
    final appBar = context.appBar;

    return [
      'App bar Colors'.headline(size: HeadlineSize.small).pad(b: DesignTokens.spacingSm),

      _colors('topBarBackground', appBar.topBarBackground),
      _colors('topBarBorder', appBar.topBarBorder),
      _colors('topBarText', appBar.topBarText),
      _colors('backButtonColor', appBar.backButtonColor),
      _colors('avatarColor', appBar.avatarColor),
      _colors('bottomBarBackground', appBar.bottomBarBackground),
      _colors('bottomBarIconColors', appBar.bottomBarIconColors),
      _colors('bottomBarIndicatorColor', appBar.bottomBarIndicatorColor),
      _colors('bottomBarBorderColor', appBar.bottomBarBorderColor),
    ];
  }

  List<Widget> _accentColors(BuildContext context) {
    final accent = context.accent;

    return [
      'Accent Colors'.headline(size: HeadlineSize.small).pad(b: DesignTokens.spacingSm),

      _colors('primaryFixed', accent.primaryFixed),
      _colors('onPrimaryFixed', accent.onPrimaryFixed),
      _colors('primaryDisabled', accent.primaryDisabled),
      _colors('onPrimaryDisabled', accent.onPrimaryDisabled),
      _colors('primaryContainer', accent.primaryContainer),
      _colors('onPrimaryContainer', accent.onPrimaryContainer),
      _colors('headline', accent.headline),
      _colors('inversePrimary', accent.inversePrimary),
    ];
  }

  List<Widget> _statusColors(BuildContext context) {
    final status = context.status;

    return [
      'Status Colors'.headline(size: HeadlineSize.small).pad(b: DesignTokens.spacingSm),

      _colors('error', status.error),
      _colors('errorContainer', status.errorContainer),
      _colors('warning', status.warning),
      _colors('success', status.success),
    ];
  }

  List<Widget> _shimmerColors(BuildContext context) {
    final shimmer = context.shimmer;

    return [
      'Shimmer Colors'.headline(size: HeadlineSize.small).pad(b: DesignTokens.spacingSm),

      _colors('baseColor', shimmer.baseColor),
      _colors('highlightColor', shimmer.highlightColor),
    ];
  }

  List<Widget> controlsColors(BuildContext context) {
    return [
      'Controls Colors'.headline(size: HeadlineSize.small).pad(b: DesignTokens.spacingSm),

      'Switch Colors'.headline(size: HeadlineSize.tiny).pad(b: DesignTokens.spacingSm),
      _colors('background', context.controls.switchColors.background),
      _colors('button', context.controls.switchColors.button),

      'Card Colors'.headline(size: HeadlineSize.tiny).pad(b: DesignTokens.spacingSm),
      _colors('background', context.controls.cardColors.background),
      _colors('cardBorder', context.controls.cardColors.borderColor),

      'Segment Colors'.headline(size: HeadlineSize.tiny).pad(b: DesignTokens.spacingSm),
      _colors('regular background', context.controls.segmentColors.regular.background),
      _colors('regular foreground', context.controls.segmentColors.regular.foreground),
      _colors('selected background', context.controls.segmentColors.selected.background),
      _colors('selected foreground', context.controls.segmentColors.selected.foreground),
    ];
  }

  Widget _colors(String name, Color? color) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(name, style: TextStyle(fontSize: 11)),
        Container(
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(4),
            border: Border.all(color: Colors.black, width: 0.75),
          ),
          width: 100,
          height: 20,
          child: color != null ? Text('Not set') : null,
        ),
      ],
    );
  }
}
