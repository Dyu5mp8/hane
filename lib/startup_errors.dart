import 'package:flutter/material.dart';

/// A generic error widget that displays a message and an optional retry button.
class GenericErrorWidget extends StatelessWidget {
  final String errorMessage;
  final VoidCallback? onRetry;

  const GenericErrorWidget({
    super.key,
    required this.errorMessage,
    this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, color: Colors.red, size: 60),
              const SizedBox(height: 16),
              const Text(
                'Ett fel har inträffat',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.redAccent,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                "felmeddelande: $errorMessage",
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 24),
              if (onRetry != null)
                ElevatedButton.icon(
                  onPressed: onRetry,
                  icon: const Icon(Icons.refresh),
                  label: const Text('Retry'),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

/// A widget for displaying Firestore-specific error messages.
class FirestoreErrorWidget extends StatelessWidget {
  final String errorDetails;
  final VoidCallback? onRetry;

  const FirestoreErrorWidget({
    super.key,
    required this.errorDetails,
    this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return GenericErrorWidget(
      errorMessage:
          'Firestore is currently unavailable. Please try again later.\n$errorDetails',
      onRetry: onRetry,
    );
  }
}

/// A widget for displaying authentication-specific errors.
class AuthErrorWidget extends StatelessWidget {
  final String errorDetails;
  final VoidCallback? onRetry;

  const AuthErrorWidget({super.key, required this.errorDetails, this.onRetry});

  @override
  Widget build(BuildContext context) {
    return GenericErrorWidget(
      errorMessage:
          'Authentication failed. Please check your login credentials or network connection.\n$errorDetails',
      onRetry: onRetry,
    );
  }
}

/// A widget for displaying network-related errors.
class NetworkErrorWidget extends StatelessWidget {
  final VoidCallback? onRetry;

  const NetworkErrorWidget({super.key, this.onRetry});

  @override
  Widget build(BuildContext context) {
    return GenericErrorWidget(
      errorMessage:
          'Network error. Please check your internet connection and try again.',
      onRetry: onRetry,
    );
  }
}
