import 'package:anyhoo_design_system/anyhoo_design_system.dart';
import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;
import 'package:widgetbook_workspace/helpers/design_system_device_frame_wrapper.dart';

@widgetbook.UseCase(name: 'Default', type: AnyhooHeaderCard, path: 'anyhoo_design_system/cards')
Widget buildAnyhooHeaderCard(BuildContext context) {
  final title = context.knobs.string(label: 'Title', initialValue: 'Header Card');
  final showIcon = context.knobs.boolean(label: 'Show leading icon', initialValue: true);
  final body = context.knobs.string(
    label: 'Body',
    initialValue:
        'A card featuring a distinct header background color to establish strong visual hierarchy or denote special status.',
  );

  return DesignSystemDeviceFrameWrapper.wrapInDeviceFrame(
    context,
    _AnyhooHeaderCardShowcase(
      title: title,
      leadingIcon: showIcon ? Icons.star_outline : null,
      body: body,
    ),
  );
}

class _AnyhooHeaderCardShowcase extends StatelessWidget {
  const _AnyhooHeaderCardShowcase({
    required this.title,
    required this.body,
    this.leadingIcon,
  });

  final String title;
  final String body;
  final IconData? leadingIcon;

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: context.surface.scaffoldBackground,
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(DesignTokens.marginMobile),
          child: AnyhooHeaderCard(
            title: title,
            leadingIcon: leadingIcon,
            child: Text(body),
          ),
        ),
      ),
    );
  }
}
