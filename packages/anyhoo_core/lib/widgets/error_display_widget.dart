import 'package:flutter/material.dart';

/// A custom error widget that displays detailed error information on screen
/// This is especially useful for debugging Maestro tests and production issues
class ErrorDisplayWidget extends StatelessWidget {
  final FlutterErrorDetails errorDetails;

  const ErrorDisplayWidget({super.key, required this.errorDetails});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: Colors.red[900],
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                Container(
                  padding: const EdgeInsets.all(16.0),
                  decoration: BoxDecoration(
                    color: Colors.black87,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.error_outline,
                        color: Colors.red[300],
                        size: 48,
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'ERROR CAUGHT',
                              style: TextStyle(
                                color: Colors.red[300],
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'App encountered an error',
                              style: TextStyle(
                                color: Colors.grey[400],
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),

                // Exception
                _buildSection(
                  title: 'EXCEPTION',
                  content: errorDetails.exception.toString(),
                  icon: Icons.warning_amber,
                ),

                // Context
                if (errorDetails.context != null) ...[
                  const SizedBox(height: 12),
                  _buildSection(
                    title: 'CONTEXT',
                    content: errorDetails.context.toString(),
                    icon: Icons.info_outline,
                  ),
                ],

                // Library
                if (errorDetails.library != null) ...[
                  const SizedBox(height: 12),
                  _buildSection(
                    title: 'LIBRARY',
                    content: errorDetails.library!,
                    icon: Icons.library_books_outlined,
                  ),
                ],

                // Stack Trace
                if (errorDetails.stack != null) ...[
                  const SizedBox(height: 12),
                  _buildSection(
                    title: 'STACK TRACE',
                    content: errorDetails.stack.toString(),
                    icon: Icons.list_alt,
                    isMonospace: true,
                  ),
                ],

                // Summary
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.all(12.0),
                  decoration: BoxDecoration(
                    color: Colors.orange[900],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.help_outline,
                        color: Colors.orange[100],
                        size: 20,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          'Screenshot this screen to share error details',
                          style: TextStyle(
                            color: Colors.orange[100],
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSection({
    required String title,
    required String content,
    required IconData icon,
    bool isMonospace = false,
  }) {
    return Container(
      padding: const EdgeInsets.all(12.0),
      decoration: BoxDecoration(
        color: Colors.black87,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.red[700]!, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: Colors.red[300], size: 20),
              const SizedBox(width: 8),
              Text(
                title,
                style: TextStyle(
                  color: Colors.red[300],
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.all(8.0),
            decoration: BoxDecoration(
              color: Colors.grey[900],
              borderRadius: BorderRadius.circular(4),
            ),
            child: SelectableText(
              content,
              style: TextStyle(
                color: Colors.grey[300],
                fontSize: 12,
                fontFamily: isMonospace ? 'monospace' : null,
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// A simpler error widget for non-FlutterErrorDetails errors
class SimpleErrorDisplayWidget extends StatelessWidget {
  final Object error;
  final StackTrace? stackTrace;

  const SimpleErrorDisplayWidget({
    super.key,
    required this.error,
    this.stackTrace,
  });

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: Colors.red[900],
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(16.0),
                  decoration: BoxDecoration(
                    color: Colors.black87,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.error_outline,
                        color: Colors.red[300],
                        size: 48,
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Text(
                          'ERROR',
                          style: TextStyle(
                            color: Colors.red[300],
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.all(12.0),
                  decoration: BoxDecoration(
                    color: Colors.black87,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: SelectableText(
                    error.toString(),
                    style: TextStyle(color: Colors.grey[300], fontSize: 14),
                  ),
                ),
                if (stackTrace != null) ...[
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.all(12.0),
                    decoration: BoxDecoration(
                      color: Colors.black87,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'STACK TRACE',
                          style: TextStyle(
                            color: Colors.red[300],
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        SelectableText(
                          stackTrace.toString(),
                          style: TextStyle(
                            color: Colors.grey[300],
                            fontSize: 12,
                            fontFamily: 'monospace',
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
