import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:shared_preferences/shared_preferences.dart';
import '../constants/app_constants.dart';

class SocketIOService {
  IO.Socket? _socket;
  final SharedPreferences sharedPreferences;
  String? _currentWhitelabelId;
  String? _currentUserId;
  String? _currentDomain;

  // Callbacks para eventos de usuários
  Function(dynamic)? onUserUpdated;
  Function(String)? onUserRemoved;

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

      if (data != null) {
        _currentWhitelabelId = data['whitelabelId'];
        _currentUserId = data['userId'];
        _currentDomain = data['domain'];

        print('🏪 WhitelabelID: $_currentWhitelabelId');
        print('👤 UserID: $_currentUserId');
        print('🌐 Domain: $_currentDomain');

        if (data['rooms'] != null) {
          print('🚪 Rooms: ${data['rooms']}');
        }
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
      _currentWhitelabelId = null;
      _currentUserId = null;
      _currentDomain = null;
    });

    _socket!.onError((error) {
      print('❌ Erro no socket: $error');
    });

    // === EVENTOS DE USUÁRIOS ===

    _socket!.on('user:updated', (data) {
      print('🔄 Usuário atualizado: $data');
      _handleUserUpdated(data);
    });

    _socket!.on('user:removed', (data) {
      print('🗑️ Usuário removido: $data');
      _handleUserRemoved(data);
    });
  }

  // === HANDLERS DE EVENTOS ===

  void _handleUserUpdated(dynamic data) {
    if (onUserUpdated != null) {
      onUserUpdated!(data);
    }
  }

  void _handleUserRemoved(dynamic data) {
    if (data != null && data['id'] != null) {
      if (onUserRemoved != null) {
        onUserRemoved!(data['id']);
      }
    }
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
      _currentUserId = null;
      _currentDomain = null;
    }
  }

  /// Verifica se está conectado
  bool get isConnected => _socket?.connected ?? false;

  /// Obtém o whitelabelId atual
  String? get currentWhitelabelId => _currentWhitelabelId;

  /// Obtém o userId atual
  String? get currentUserId => _currentUserId;

  /// Obtém o domain atual
  String? get currentDomain => _currentDomain;
}
