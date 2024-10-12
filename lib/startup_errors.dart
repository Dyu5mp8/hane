import 'package:flutter/material.dart';

/// A generic error widget that displays a message and an optional retry button.
class GenericErrorWidget extends StatelessWidget {
  final String errorMessage;
  final VoidCallback? onRetry;

  const GenericErrorWidget({
    Key? key,
    required this.errorMessage,
    this.onRetry,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.error_outline, color: Colors.red, size: 60),
              SizedBox(height: 16),
              Text(
                'An error occurred',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.redAccent,
                ),
              ),
              SizedBox(height: 16),
              
              Text(
                errorMessage,
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 24),
              if (onRetry != null)
                ElevatedButton.icon(
                  onPressed: onRetry,
                  icon: Icon(Icons.refresh),
                  label: Text('Retry'),
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
    Key? key,
    required this.errorDetails,
    this.onRetry,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GenericErrorWidget(
      errorMessage: 'Firestore is currently unavailable. Please try again later.\n$errorDetails',
      onRetry: onRetry,
    );
  }
}

/// A widget for displaying authentication-specific errors.
class AuthErrorWidget extends StatelessWidget {
  final String errorDetails;
  final VoidCallback? onRetry;

  const AuthErrorWidget({
    Key? key,
    required this.errorDetails,
    this.onRetry,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GenericErrorWidget(
      errorMessage: 'Authentication failed. Please check your login credentials or network connection.\n$errorDetails',
      onRetry: onRetry,
    );
  }
}

/// A widget for displaying network-related errors.
class NetworkErrorWidget extends StatelessWidget {
  final VoidCallback? onRetry;

  const NetworkErrorWidget({
    Key? key,
    this.onRetry,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GenericErrorWidget(
      errorMessage: 'Network error. Please check your internet connection and try again.',
      onRetry: onRetry,
    );
  }
}