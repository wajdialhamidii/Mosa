import 'dart:convert';
import '../models/client.dart';
import 'package:http/http.dart' as http;

class ClientService {
  final String _apiUrl = 'http://consultationapp.runasp.net/api/client';

  Future<Client> getClientData(int clientId) async {
    final response = await http.get(Uri.parse('$_apiUrl/$clientId'));

    if (response.statusCode == 200) {
      final dynamic body = json.decode(response.body);
      return Client.fromJson(body);
    } else {
      throw Exception('Failed to load client data: ${response.reasonPhrase}');
    }
  }

  Future<void> createClient(Client client) async {
    final response = await http.post(Uri.parse(_apiUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(client.toJson()));

    if (response.statusCode != 200) {
      throw Exception('Failed to create an account: ${response.reasonPhrase}');
    }
  }

  Future<void> updateClient(Client client) async {
    final response = await http.put(Uri.parse('$_apiUrl/${client.id}'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(client.toJson()));

    if (response.statusCode != 200) {
      throw Exception('Failed to update account: ${response.reasonPhrase}');
    }
  }
}
