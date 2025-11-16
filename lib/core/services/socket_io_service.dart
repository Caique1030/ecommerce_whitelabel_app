import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:shared_preferences/shared_preferences.dart';
import '../constants/app_constants.dart';

class SocketIOService {
  IO.Socket? _socket;
  final SharedPreferences sharedPreferences;
  String? _currentWhitelabelId;

  SocketIOService({required this.sharedPreferences});

  /// Conecta ao Socket.IO
  Future<void> connect() async {
    final token = sharedPreferences.getString(AppConstants.accessTokenKey);

    if (token == null) {
      print('❌ Token não encontrado, não é possível conectar ao Socket.IO');
      return;
    }

    // Fecha conexão anterior se existir
    disconnect();

    // URL base sem o /api
    final baseUrl = AppConstants.baseUrl.replaceAll('/api', '');
    final socketUrl = '$baseUrl/${AppConstants.wsNamespace}';

    print('🔌 Conectando ao Socket.IO: $socketUrl');

    _socket = IO.io(
      socketUrl,
      IO.OptionBuilder()
          .setTransports(['websocket'])
          .enableAutoConnect()
          .enableReconnection()
          .setReconnectionDelay(1000)
          .setReconnectionDelayMax(5000)
          .setReconnectionAttempts(5)
          .setAuth({
            'token': token,
          })
          .setExtraHeaders({
            'Authorization': 'Bearer $token',
          })
          .build(),
    );

    _setupEventListeners();
  }

  void _setupEventListeners() {
    if (_socket == null) return;

    // Evento de conexão bem-sucedida
    _socket!.on('connected', (data) {
      print('✅ Conectado ao Socket.IO com sucesso!');
      print('📦 Dados de conexão: $data');

      if (data != null && data['whitelabelId'] != null) {
        _currentWhitelabelId = data['whitelabelId'];
        print('🏪 WhitelabelID: $_currentWhitelabelId');
      }
    });

    // Evento de erro de autenticação
    _socket!.on('auth_error', (data) {
      print('❌ Erro de autenticação: $data');
    });

    // Eventos de conexão/desconexão
    _socket!.onConnect((_) {
      print('✅ Socket conectado');
    });

    _socket!.onDisconnect((_) {
      print('❌ Socket desconectado');
    });

    _socket!.onError((error) {
      print('❌ Erro no socket: $error');
    });

    // === EVENTOS DE PRODUTOS ===

    _socket!.on('product:created', (data) {
      print('🆕 Novo produto criado: $data');
      _handleProductCreated(data);
    });

    _socket!.on('product:updated', (data) {
      print('🔄 Produto atualizado: $data');
      _handleProductUpdated(data);
    });

    _socket!.on('product:removed', (data) {
      print('🗑️ Produto removido: $data');
      _handleProductRemoved(data);
    });

    // === EVENTOS DE FORNECEDORES ===

    _socket!.on('supplier:created', (data) {
      print('🆕 Novo fornecedor criado: $data');
      _handleSupplierCreated(data);
    });

    _socket!.on('supplier:updated', (data) {
      print('🔄 Fornecedor atualizado: $data');
      _handleSupplierUpdated(data);
    });

    _socket!.on('supplier:removed', (data) {
      print('🗑️ Fornecedor removido: $data');
      _handleSupplierRemoved(data);
    });
  }

  // === HANDLERS DE EVENTOS ===

  void _handleProductCreated(dynamic data) {
    // Implemente a lógica para atualizar a UI quando um produto é criado
    // Por exemplo: adicionar ao BLoC ou notificar listeners
  }

  void _handleProductUpdated(dynamic data) {
    // Implemente a lógica para atualizar a UI quando um produto é atualizado
  }

  void _handleProductRemoved(dynamic data) {
    // Implemente a lógica para atualizar a UI quando um produto é removido
  }

  void _handleSupplierCreated(dynamic data) {
    // Implemente a lógica para quando um fornecedor é criado
  }

  void _handleSupplierUpdated(dynamic data) {
    // Implemente a lógica para quando um fornecedor é atualizado
  }

  void _handleSupplierRemoved(dynamic data) {
    // Implemente a lógica para quando um fornecedor é removido
  }

  /// Emite um evento personalizado
  void emit(String event, dynamic data) {
    _socket?.emit(event, data);
  }

  /// Adiciona um listener para um evento específico
  void on(String event, Function(dynamic) callback) {
    _socket?.on(event, callback);
  }

  /// Remove um listener de um evento
  void off(String event) {
    _socket?.off(event);
  }

  /// Desconecta do Socket.IO
  void disconnect() {
    if (_socket != null) {
      print('🔌 Desconectando Socket.IO...');
      _socket!.disconnect();
      _socket!.dispose();
      _socket = null;
      _currentWhitelabelId = null;
    }
  }

  /// Verifica se está conectado
  bool get isConnected => _socket?.connected ?? false;

  /// Obtém o whitelabelId atual
  String? get currentWhitelabelId => _currentWhitelabelId;
}
