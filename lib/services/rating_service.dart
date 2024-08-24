import 'dart:convert';

import '../models/rating.dart';
import 'package:http/http.dart' as http;

class RatingService {
  final String _apiUrl = 'http://consultationapp.runasp.net/api/rating';

  Future<void> postRating(Rating rating) async {
    final response = await http.post(
      Uri.parse(_apiUrl),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(rating.toJson()),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to post a new rating');
    }
  }
}
