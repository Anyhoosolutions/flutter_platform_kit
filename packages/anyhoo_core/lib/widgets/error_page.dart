import 'package:flutter/material.dart';

class ErrorPage extends StatefulWidget {
  const ErrorPage({super.key, required this.errorMessage, this.detailedError, this.onGoHome});

  final String errorMessage;
  final String? detailedError;
  final VoidCallback? onGoHome;

  @override
  State<ErrorPage> createState() => _ErrorPageState();
}

class _ErrorPageState extends State<ErrorPage> {
  bool _showDetails = true;

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
            maxWidth: 400,
            maxHeight: MediaQuery.sizeOf(context).height * 0.9,
          ),
          height: 550,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(color: Colors.black.withValues(alpha: 0.1), blurRadius: 10, offset: const Offset(0, 4)),
            ],
          ),
          clipBehavior: Clip.hardEdge,
          child: LayoutBuilder(
            builder: (context, constraints) {
              return Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Error icon
                    Container(
                      width: 64,
                      height: 64,
                      decoration: const BoxDecoration(color: Colors.red, shape: BoxShape.circle),
                      child: const Icon(Icons.close, color: Colors.white, size: 32),
                    ),
                    const SizedBox(height: 24),

                    // Title
                    Text(
                      'Oops! Something went wrong',
                      style: theme.textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Colors.grey.shade800,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 12),

                    // General error message
                    Text(
                      widget.errorMessage,
                      style: theme.textTheme.bodyMedium?.copyWith(color: Colors.grey.shade700),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 24),

                    // Details section
                    if (widget.detailedError != null) ...[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Details',
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: colorScheme.primary,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          Switch(
                            value: _showDetails,
                            onChanged: (value) {
                              setState(() {
                                _showDetails = value;
                              });
                            },
                            activeColor: colorScheme.primary,
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),

                      // Detailed error message
                      if (_showDetails)
                        Flexible(
                          child: Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: Colors.grey.shade100,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: SingleChildScrollView(
                              child: Text(
                                widget.detailedError!,
                                style: theme.textTheme.bodySmall?.copyWith(
                                  color: Colors.grey.shade800,
                                  fontFamily: 'monospace',
                                ),
                              ),
                            ),
                          ),
                        ),
                      const SizedBox(height: 24),
                    ],

                    // Action buttons
                    Row(
                      children: [
                        // GO HOME button
                        Expanded(
                          child: ElevatedButton(
                            onPressed:
                                widget.onGoHome ??
                                () {
                                  Navigator.of(context).popUntil((route) => route.isFirst);
                                },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: colorScheme.primary,
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                            ),
                            child: const Text(
                              'GO HOME',
                              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
