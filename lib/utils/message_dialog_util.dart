import 'package:consultation_app/utils/sizes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

import 'constants.dart';

class MessageDialogUtil {
  static Future<dynamic> showErrorMessageDialog(
      BuildContext context, String e) {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Error'),
          content: Text('Failed to login: $e'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  static Future<dynamic> showQuestionDialog({
    required BuildContext context,
    required String title,
    required String message,
    required void Function() okButton,
    required void Function() cancelButton,
  }) {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: okButton,
              child: const Text('OK'),
            ),
            TextButton(
              onPressed: cancelButton,
              child: const Text('Cancel'),
            ),
          ],
        );
      },
    );
  }

  static Future<double?> showRatingDialog(BuildContext context) {
    return showDialog<double>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        double rating = 4;
        return AlertDialog(
          title: const Text('Feedback'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'How was your consultation?',
                style: kRegularTextStyle,
              ),
              kSizedBoxHeight_5,
              RatingBar.builder(
                initialRating: rating,
                minRating: 1,
                direction: Axis.horizontal,
                allowHalfRating: true,
                itemCount: 5,
                itemSize: 30.0,
                itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
                itemBuilder: (context, _) => const Icon(
                  Icons.star,
                  color: Colors.amber,
                ),
                onRatingUpdate: (newRating) {
                  rating = newRating;
                },
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(rating);
              },
              child: const Text('Submit'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(0.0);
              },
              child: const Text('Cancel'),
            ),
          ],
        );
      },
    );
  }
}
