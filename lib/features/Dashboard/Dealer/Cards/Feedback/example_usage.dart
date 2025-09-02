import 'package:flutter/material.dart';
import 'screens/feedback_screen.dart';

// Example of how to navigate to FeedbackScreen with customerId
class ExampleUsage {
  static void navigateToFeedback(BuildContext context, {int? customerId}) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => FeedbackScreen(customerId: customerId),
      ),
    );
  }
}

// Example usage:
// ExampleUsage.navigateToFeedback(context, customerId: 38590);