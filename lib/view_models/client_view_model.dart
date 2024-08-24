import 'package:consultation_app/services/client_service.dart';
import 'package:consultation_app/utils/constants.dart';
import 'package:consultation_app/utils/message_dialog_util.dart';
import 'package:consultation_app/utils/snackbar_util.dart';
import 'package:consultation_app/views/login_screen.dart';
import 'package:flutter/material.dart';
import '../models/client.dart';

class ClientViewModel extends ChangeNotifier {
  final ClientService _clientService = ClientService();

  Client? _client;
  bool _isLoading = false;

  bool get isLoading => _isLoading;
  Client? get getClient => _client;

  Future<void> getClientData(int clientId) async {
    _isLoading = true;
    notifyListeners();
    try {
      _client = await _clientService.getClientData(clientId);
    } catch (e) {
      throw Exception(e);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> registerClient(BuildContext context, Client client) async {
    try {
      await _clientService.createClient(client);

      Navigator.pop(context);
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => LoginScreen()));
      SnackbarUtil.showSnackbar(
        context,
        'Register successfully, you can login in now!',
        kMainColor,
      );
    } catch (e) {
      Navigator.pop(context);
      MessageDialogUtil.showErrorMessageDialog(context, e.toString());
    }
  }

  Future<void> updateClient(Client client) async {
    try {
      await _clientService.updateClient(client);
    } catch (e) {
      throw Exception(e);
    }
  }
}
