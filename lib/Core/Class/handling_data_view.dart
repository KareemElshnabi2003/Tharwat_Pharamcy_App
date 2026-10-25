// handling data by status request to show appropriate widget
import 'package:flutter/material.dart';
import 'package:tharwat_pharmacy/Core/Class/status_request.dart';

/// Centralized widget that handles the various states of an API request.
/// Shows loading, error, no-internet, or the actual content widget.
class HandlingDataRequest extends StatelessWidget {
  final StatuesRequest statuesRequest;
  final Widget widget;
  final VoidCallback? onRetry;

  const HandlingDataRequest({
    super.key,
    required this.statuesRequest,
    required this.widget,
    this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    switch (statuesRequest) {
      case StatuesRequest.loading:
        return const Center(child: CircularProgressIndicator());

      case StatuesRequest.socketException:
        return _ErrorState(
          icon: Icons.wifi_off_rounded,
          message: 'No internet connection.\nPlease check your connection and try again.',
          onRetry: onRetry,
        );

      case StatuesRequest.timeoutException:
        return _ErrorState(
          icon: Icons.timer_off_outlined,
          message: 'The request timed out.\nPlease try again.',
          onRetry: onRetry,
        );

      case StatuesRequest.serverError:
      case StatuesRequest.serverException:
        return _ErrorState(
          icon: Icons.cloud_off_rounded,
          message: 'Server error. Please try again later.',
          onRetry: onRetry,
        );

      case StatuesRequest.unauthorizedException:
        return _ErrorState(
          icon: Icons.lock_outline_rounded,
          message: 'Unauthorized. Please log in again.',
          onRetry: onRetry,
        );

      case StatuesRequest.success:
      case StatuesRequest.none:
        return widget;

      default:
        return _ErrorState(
          icon: Icons.error_outline_rounded,
          message: 'Something went wrong. Please try again.',
          onRetry: onRetry,
        );
    }
  }
}

class _ErrorState extends StatelessWidget {
  final IconData icon;
  final String message;
  final VoidCallback? onRetry;

  const _ErrorState({
    required this.icon,
    required this.message,
    this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 56, color: Colors.grey.shade400),
            const SizedBox(height: 16),
            Text(
              message,
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: Colors.grey.shade600,
                height: 1.5,
              ),
            ),
            if (onRetry != null) ...[
              const SizedBox(height: 20),
              ElevatedButton.icon(
                onPressed: onRetry,
                icon: const Icon(Icons.refresh_rounded),
                label: const Text('Retry'),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
