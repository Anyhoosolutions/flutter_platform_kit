import 'package:anyhoo_design_system/anyhoo_design_system.dart';
import 'package:flutter/material.dart';

/// Simple card-shelled data table with string headers and mixed cell content.
///
/// Each cell may be a [String] or a [Widget].
class AnyhooDataTable extends StatelessWidget {
  const AnyhooDataTable({
    super.key,
    required this.columns,
    required this.rows,
  });

  final List<String> columns;

  /// Rows of cells; each cell is a [String] or [Widget].
  final List<List<Object>> rows;

  @override
  Widget build(BuildContext context) {
    final surface = context.surface;

    return AnyhooCardShell(
      padding: EdgeInsets.zero,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          ColoredBox(
            color: surface.containerLow,
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: DesignTokens.spacingMd,
                vertical: DesignTokens.spacingSm,
              ),
              child: Row(
                children: [
                  for (final header in columns)
                    Expanded(
                      child: Text(
                        header.toUpperCase(),
                        style: AnyhooTypography.label(LabelSize.medium).copyWith(
                          color: surface.secondaryText,
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
          for (var i = 0; i < rows.length; i++) ...[
            if (i > 0)
              Divider(
                height: 1,
                thickness: 1,
                color: surface.cardBorder.withValues(alpha: 0.3),
              ),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: DesignTokens.spacingMd,
                vertical: DesignTokens.spacingMd,
              ),
              child: Row(
                children: [
                  for (var c = 0; c < columns.length; c++)
                    Expanded(
                      child: _cell(
                        context,
                        c < rows[i].length ? rows[i][c] : '',
                      ),
                    ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _cell(BuildContext context, Object value) {
    if (value is Widget) return value;
    return Text(
      value.toString(),
      style: AnyhooTypography.body(BodySize.medium).copyWith(
        color: context.surface.primaryText,
      ),
    );
  }
}
