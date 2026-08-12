import 'package:anyhoo_design_system/anyhoo_design_system.dart';
import 'package:anyhoo_widget_extension_methods/anyhoo_widget_extension_methods.dart';
import 'package:flutter/material.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;
import 'package:widgetbook_workspace/helpers/design_system_device_frame_wrapper.dart';

@widgetbook.UseCase(name: 'Gallery', type: AnyhooStandardCard, path: 'anyhoo_design_system/cards')
Widget buildAnyhooCardsGallery(BuildContext context) {
  return DesignSystemDeviceFrameWrapper.wrapInDeviceFrame(context, const _AnyhooCardsGallery());
}

class _AnyhooCardsGallery extends StatelessWidget {
  const _AnyhooCardsGallery();

  static const _profileAvatarUrl =
      'https://lh3.googleusercontent.com/aida-public/AB6AXuDRmKZplnRud88a8ceX2MHP4Ic8exPxsfZwUYXFF_lAObPGk13ID13PkR1ID7StDXEmrMLCL3217Q9sE0j5RBjNybefW4vn3D9DVTVOnibcQWNZV8d05oSChfVPTBtlCWl1w6dsO98u1X2LE-q9og93beJ1TCMdyYhck5fBX52Q1lg2ZbEbwe93ihGZbsFEmLwWnEbKVOlrtjJmanfZiZ0tjpIYRm9Ydb7E502wjYfLFxBQfMR1As60';

  static const _mediaImageUrl =
      'https://lh3.googleusercontent.com/aida-public/AB6AXuBu61BqIudp21wkNQFibvZ0CJtT9yU83rsxYTIGm1tNLeT-NiciuqD9P8vfwvosR9wDpu9ItIN4vWKo7lXcxSf5a-BHlU3FxUgORvTfohM6LT9GHlmnNVUCwkm9BaagZhqi8bCSZuvLB7csK9AJkK7UvhZcJxJ56Z1iON75UIRinkYSVQWVGwTkO7nCL9Q0yb5_G6kKwpUl4gGDpyoYkXpP4xFk_Cxt2gfDLMjCviGuQie1iaIgTTpg';

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: ColoredBox(
        color: context.surface.scaffoldBackground,
        child: ListView(
          padding: const EdgeInsets.all(DesignTokens.marginMobile),
          children: [
            'Standard card'.headline(size: HeadlineSize.small).pad(b: 4),
            AnyhooStandardCard(
              title: 'Standard Card',
              actionLabel: 'Action',
              onAction: () {},
              child: const Text(
                'This is a simple elevated card with standard padding. It uses Level 1 elevation to lift slightly off the background.',
              ),
            ),
            const SizedBox(height: DesignTokens.spacingMd),
            AnyhooStandardCard(
              prefixIcon: Icons.palette,
              title: 'Standard Card with icon',
              actionLabel: 'Action',
              onAction: () {},
              child: const Text(
                'This is a simple elevated card with standard padding. It uses Level 1 elevation to lift slightly off the background.',
              ),
            ),
            const SizedBox(height: DesignTokens.spacingLg),

            'Different background color'.headline(size: HeadlineSize.tiny).pad(b: 4),
            AnyhooErrorCard(
              title: 'Warning',
              child: const Text(
                'This is a simple elevated card with standard padding. It uses Level 1 elevation to lift slightly off the background.',
              ),
            ),
            const SizedBox(height: DesignTokens.spacingLg),

            'Header card'.headline(size: HeadlineSize.small).pad(b: 4),
            const AnyhooHeaderCard(
              title: 'Header Card',
              leadingIcon: Icons.star_outline,
              child: Text(
                'A card featuring a distinct header background color to establish strong visual hierarchy or denote special status.',
              ),
            ),
            const SizedBox(height: DesignTokens.spacingLg),

            'Profile card'.headline(size: HeadlineSize.small).pad(b: 4),
            AnyhooProfileCard(
              name: 'Alex Rivera',
              handle: '@arivera_design',
              avatarUrl: _profileAvatarUrl,
              onAction: () {},
            ),
            const SizedBox(height: DesignTokens.spacingLg),

            'Header card'.headline(size: HeadlineSize.small).pad(b: 4),
            AnyhooMediaCard(
              title: 'Architectural Integration',
              imageUrl: _mediaImageUrl,
              primaryActionLabel: 'Read Article',
              onPrimaryAction: () {},
              secondaryActionLabel: 'Save',
              onSecondaryAction: () {},
              child: const Text(
                'A showcase of how structural elements seamlessly blend with organic environments, maintaining clean lines while embracing natural forms. This card utilizes a 16:9 hero image for maximum visual impact.',
              ),
            ),
            const SizedBox(height: DesignTokens.spacingLg),

            'Metric card'.headline(size: HeadlineSize.small).pad(b: 4),
            const AnyhooMetricCard(label: 'Engagement', value: '84.2k', badgeLabel: '+12%'),
            const SizedBox(height: DesignTokens.spacingLg),
          ],
        ),
      ),
    );
  }
}
