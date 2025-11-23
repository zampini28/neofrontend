import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:physioapp/models/chat_message.dart';
import 'package:physioapp/services/auth/auth.dart';
import 'package:physioapp/services/chat_socket_service.dart';

class IndividualChatScreen extends StatefulWidget {
  final String patientName;
  final String patientId;
  bool _isLoading = true;

  String get physioId => UserDataCache().id;

  IndividualChatScreen({
    super.key,
    required this.patientName,
    required this.patientId,
  });

  @override
  State<IndividualChatScreen> createState() => _IndividualChatScreenState();
}

class _IndividualChatScreenState extends State<IndividualChatScreen> {
  String? _userToken;
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  final String _myUserId = UserDataCache().id;

  late final String _chatRoomId;

  final List<ChatMessage> _messages = [];
  late ChatSocketService _chatService;
  bool _isConnected = false;

  Future<void> _init() async {
    _loadMockMessages();

    _chatRoomId = widget.patientId;

    final token = await getToken();

    setState(() {
      _userToken = token;
    });

    _chatService = ChatSocketService(
      onConnectCallback: _onSocketConnect,
      onMessageReceivedCallback: _onMessageReceived,
      userToken: token!,
    );

    _chatService.connect();

    await _loadMessageHistory();

    if (mounted) {
      setState(() {
        widget._isLoading = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _init();
  }

  Future<void> _loadMessageHistory() async {
    final url = Uri.parse('http://localhost:8080/api/chat/history/$_chatRoomId');

    final headers = {
      'Authorization': 'Bearer $_userToken',
    };

    try {
      final response = await http.get(url, headers: headers);

      if (response.statusCode == 200) {
        final List<dynamic> historyData =
            json.decode(utf8.decode(response.bodyBytes)) as List<dynamic>;

        final historyMessages = historyData.map((data) {
          return ChatMessage(
            messageId: data['messageId'] as String,
            text: data['text'] as String,
            senderId: data['senderId'] as String,
            timestamp: DateTime.parse(data['timestamp'] as String),
          );
        }).toList();

        // 6. Atualizar o estado da UI com as mensagens
        setState(() {
          _messages.addAll(historyMessages);
        });

        // 7. Rolar para o fim após carregar
        _scrollToBottom(jump: true); // 'jump' para ir direto, sem animação
      } else {
        // Tratar erros de API (ex: 401, 404, 500)
        print('Falha ao carregar histórico: ${response.statusCode}');
      }
    } catch (e) {
      // Tratar erros de rede (ex: sem conexão)
      print('Erro de rede ao carregar histórico: $e');
    }
  }

  void _onSocketConnect() {
    print('Conectado ao WebSocket! Se inscrevendo no tópico...');
    _chatService.subscribeToChat(_chatRoomId);
    setState(() {
      _isConnected = true;
    });
  }

  void _onMessageReceived(ChatMessage message) {
    print('Mensagem recebida de volta do servidor: ${message.text}');
    setState(() {
      _messages.add(message);
    });
    _scrollToBottom();
  }

  void _loadMockMessages() {
    setState(() {
      _messages.addAll([
        ChatMessage(
            messageId: '1',
            text: 'Olá! Como você está se sentindo hoje?',
            senderId: widget.physioId,
            timestamp: DateTime.now().subtract(const Duration(minutes: 10))),
        ChatMessage(
            messageId: '2',
            text: 'Estou bem, um pouco de dor no joelho ainda.',
            senderId: widget.patientId,
            timestamp: DateTime.now().subtract(const Duration(minutes: 5))),
        ChatMessage(
            messageId: '3',
            text: 'Entendido. Vamos focar nos exercícios de fortalecimento.',
            senderId: widget.physioId,
            timestamp: DateTime.now().subtract(const Duration(minutes: 2))),
      ]);
    });
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    _chatService.disconnect();
    super.dispose();
  }

  void _sendMessage() {
    final text = _messageController.text;
    
    print('Tentando enviar: $text. Conectado? $_isConnected');

    if (text.trim().isEmpty || !_isConnected) return;

    _chatService.sendMessage(
      _chatRoomId,
      text,
      _myUserId,
    );

    _messageController.clear();
    
    print('Mensagem enviada para o socket!');

    _scrollToBottom();
  }

  void _scrollToBottom({bool jump = false}) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        final position = _scrollController.position.maxScrollExtent;
        if (jump) {
          _scrollController.jumpTo(position);
        } else {
          _scrollController.animateTo(
            position,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeOut,
          );
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.patientName),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 20.0),
            child: Icon(
              Icons.circle,
              color: _isConnected ? Colors.green : Colors.red,
              size: 12,
            ),
          )
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.all(8.0),
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final message = _messages[index];
                final isSentByMe = message.senderId == _myUserId;
                return _ChatBubble(message: message, isSentByMe: isSentByMe);
              },
            ),
          ),
          _buildInputArea(),
        ],
      ),
    );
  }

  Widget _buildInputArea() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 12.0),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        boxShadow: [
          BoxShadow(
            offset: const Offset(0, -1),
            blurRadius: 4,
            color: Colors.black.withOpacity(0.05),
          ),
        ],
      ),
      child: SafeArea(
        child: Row(
          children: [
            Expanded(
              child: TextField(
                controller: _messageController,
                decoration: const InputDecoration(
                  hintText: 'Digite uma mensagem...',
                  border: InputBorder.none,
                  filled: false,
                ),
                onSubmitted: (value) => _sendMessage(),
              ),
            ),
            IconButton(
              icon: Icon(Icons.send,
                  color: _isConnected ? Theme.of(context).primaryColor : Colors.grey),
              onPressed: _isConnected ? _sendMessage : null,
            ),
          ],
        ),
      ),
    );
  }
}

class _ChatBubble extends StatelessWidget {
  final ChatMessage message;
  final bool isSentByMe;

  const _ChatBubble({
    required this.message,
    required this.isSentByMe,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      alignment: isSentByMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.75,
        ),
        padding: const EdgeInsets.symmetric(horizontal: 14.0, vertical: 10.0),
        margin: const EdgeInsets.symmetric(vertical: 4.0),
        decoration: BoxDecoration(
            color: isSentByMe ? theme.primaryColorLight : theme.canvasColor,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                offset: const Offset(0, 1),
                blurRadius: 2,
                color: Colors.black.withOpacity(0.1),
              ),
            ]),
        child: Text(
          message.text,
          style: TextStyle(
            color: isSentByMe ? theme.primaryColorDark : theme.textTheme.bodyLarge?.color,
          ),
        ),
      ),
    );
  }
}
