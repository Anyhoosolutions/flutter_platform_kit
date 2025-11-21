import 'package:flutter/material.dart';

class WaitingPage extends StatelessWidget {
  const WaitingPage({
    super.key,
    this.message = "We're fetching an latest information for you.",
    this.onCancel,
  });

  final String message;
  final VoidCallback? onCancel;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Center(
      child: Theme(
        data: ThemeData(colorScheme: colorScheme),
        child: Container(
          margin: const EdgeInsets.all(24),
          constraints: BoxConstraints(
            maxWidth: 340,
            maxHeight: MediaQuery.sizeOf(context).height * 0.9,
          ),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.1),
                blurRadius: 20,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          clipBehavior: Clip.hardEdge,
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 40),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Geometric Shapes Icon Placeholder
                  SizedBox(
                    height: 120,
                    width: 120,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        // Dashed circle (simplified as a light grey circle for now)
                        Container(
                          width: 100,
                          height: 100,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: Colors.grey.withValues(alpha: 0.3),
                              width: 1,
                              style: BorderStyle.solid, // Flutter doesn't support dashed border natively easily without package
                            ),
                          ),
                        ),
                        // Blue Triangle
                        Positioned(
                          top: 20,
                          left: 20,
                          child: Icon(Icons.change_history, size: 48, color: Colors.blue.shade400),
                        ),
                        // Red Square (rotated slightly)
                        Positioned(
                          top: 30,
                          right: 20,
                          child: Transform.rotate(
                            angle: 0.2,
                            child: Container(
                              width: 36,
                              height: 36,
                              decoration: BoxDecoration(
                                color: Colors.red.shade400,
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                          ),
                        ),
                        // Yellow Circle
                        Positioned(
                          bottom: 20,
                          child: Container(
                            width: 32,
                            height: 32,
                            decoration: BoxDecoration(
                              color: Colors.amber.shade300,
                              shape: BoxShape.circle,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 32),

                  // Title
                  Text(
                    'Please Wait...',
                    style: theme.textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.w800,
                      color: Colors.grey.shade900,
                      fontSize: 24,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),

                  // Subtitle
                  Text(
                    message,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: Colors.grey.shade600,
                      height: 1.5,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 32),

                  // Progress Bar
                  Container(
                    height: 12,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade200,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(6),
                      child: const LinearProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
                        backgroundColor: Colors.transparent,
                        minHeight: 12,
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Cancel Button
                  if (onCancel != null)
                    TextButton(
                      onPressed: onCancel,
                      child: Text(
                        'Cancel',
                        style: TextStyle(
                          color: Colors.blue.shade600,
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
