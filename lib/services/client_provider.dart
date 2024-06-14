import 'package:flutter/foundation.dart';

class ClientProvider with ChangeNotifier {
  int? _clientId;
  int? get clientId => _clientId;

  void setClientId(int clientId) {
    _clientId = clientId;
    notifyListeners();
  }
}