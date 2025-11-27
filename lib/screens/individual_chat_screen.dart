import 'package:flutter/material.dart';
import 'package:physioapp/models/chat/chat_message.dart';
import 'package:physioapp/screens/chat/components/chat_bubble.dart';
import 'package:physioapp/screens/chat/components/chat_input_field.dart';
import 'package:physioapp/services/auth/auth.dart';
import 'package:physioapp/services/chat/chat_controller.dart';
import 'package:provider/provider.dart';

class IndividualChatScreen extends StatelessWidget {
  final String patientName;
  final String patientId;
  final ImageProvider? patientImage;

  const IndividualChatScreen({
    super.key,
    required this.patientName,
    required this.patientId,
    this.patientImage,
  });

  @override
  Widget build(BuildContext context) {
    final myId = UserDataCache().id;


    return ChangeNotifierProvider(
      create: (_) => ChatController()..initChat(patientId),
      child: Scaffold(
        backgroundColor: const Color(0xFFEFEFEF),
        appBar: AppBar(
          elevation: 1,
          backgroundColor: Colors.white,
          leadingWidth: 40,
          titleSpacing: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () => Navigator.of(context).pop(),
          ),
          title: Row(
            children: [
              CircleAvatar(
                radius: 18,
                backgroundColor: Colors.grey[300],
                backgroundImage: patientImage,
                child: patientImage == null
                    ? const Icon(Icons.person, color: Colors.white, size: 20)
                    : null,
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      patientName,
                      style: const TextStyle(
                          fontSize: 16, color: Colors.black, fontWeight: FontWeight.w600),
                      overflow: TextOverflow.ellipsis,
                    ),
                    //Consumer<ChatController>(
                    //  builder: (_, controller, __) => Text(
                    //    controller.isConnected ? 'Online' : 'Conectando...',
                    //    style: TextStyle(
                    //      fontSize: 12,
                    //      color: controller.isConnected ? Colors.green : Colors.grey,
                    //    ),
                    //  ),
                    //),
                  ],
                ),
              ),
            ],
          ),
          actions: [
            IconButton(
              onPressed: () {},
              icon: const Icon(Icons.videocam, color: Colors.blueGrey),
            ),
            IconButton(
              onPressed: () {},
              icon: const Icon(Icons.call, color: Colors.blueGrey),
            ),
          ],
        ),
        body: Column(
          children: [
            Expanded(
              child: Consumer<ChatController>(
                builder: (context, controller, _) {
                  if (controller.isLoading) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (controller.hasNoAppointment) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.calendar_today_outlined, size: 60, color: Colors.grey[400]),
                          const SizedBox(height: 16),
                          const Text(
                            'Nenhuma consulta ativa.',
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold, color: Colors.grey),
                          ),
                          const Padding(
                            padding: EdgeInsets.symmetric(horizontal: 32.0, vertical: 8),
                            child: Text(
                              'O chat só é habilitado quando existe uma consulta agendada entre vocês.',
                              textAlign: TextAlign.center,
                              style: TextStyle(color: Colors.grey),
                            ),
                          ),
                        ],
                      ),
                    );
                  }

                  return ListView.builder(
                    reverse: true,
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    itemCount: controller.messages.length,
                    itemBuilder: (context, index) {
                      final ChatMessage msg = controller.messages[index];
                      final bool isMe = msg.senderId == myId;

                      debugPrint(' ----   chat buddle created with message ${msg.id}');

                      return ChatBubble(
                        message: msg,
                        isMe: isMe,
                      );
                    },
                  );
                },
              ),
            ),
            Consumer<ChatController>(
              builder: (context, controller, _) {
                return ChatInputField(
                  onSend: (text) => controller.sendMessage(text),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
