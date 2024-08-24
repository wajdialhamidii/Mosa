import 'package:consultation_app/services/rating_service.dart';
import 'package:flutter/cupertino.dart';

import '../models/rating.dart';

class RatingViewModel extends ChangeNotifier {
  final RatingService _ratingService = RatingService();

  Future<void> postRating(Rating rating) async {
    try {
      await _ratingService.postRating(rating);
    } catch (e) {
      throw Exception(e);
    }
  }
}
