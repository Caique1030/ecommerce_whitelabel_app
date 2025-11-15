import 'package:flutter/foundation.dart';
import 'package:flutter_ecommerce/features/client/domain/usecases/GetClientConfig.dart';
import '../../domain/entities/client.dart';

class WhitelabelProvider with ChangeNotifier {
  final GetClientConfig getClientConfig;

  Client? _client;
  bool _isLoading = false;
  String? _errorMessage;

  WhitelabelProvider({required this.getClientConfig});

  Client? get client => _client;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Future<void> loadClientConfig() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    final result = await getClientConfig();

    result.fold(
      (failure) {
        _errorMessage = failure.message;
        _isLoading = false;
        notifyListeners();
      },
      (client) {
        _client = client;
        _isLoading = false;
        notifyListeners();
      },
    );
  }

  void updateClient(Client client) {
    _client = client;
    notifyListeners();
  }
}
