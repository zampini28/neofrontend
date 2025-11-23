import 'dart:io';

import 'package:flutter/material.dart';
import 'package:physioapp/components/physiotherapist/chat/list_patient.dart';
import 'package:physioapp/components/physiotherapist/chat/search_patient.dart';
import 'package:physioapp/components/physiotherapist/chat/select_patient_photo.dart';
import 'package:physioapp/models/conversation_preview.dart';
import 'package:physioapp/screens/individual_chat_screen.dart';

class ChatPagePhysio extends StatefulWidget {
  const ChatPagePhysio({super.key});

  @override
  State<ChatPagePhysio> createState() => _ChatPagePhysioState();
}

class _ChatPagePhysioState extends State<ChatPagePhysio> {
  // 3. Lista de dados (por enquanto, mock)
  // No futuro, isso virá do seu backend
  final List<ConversationPreview> conversations = [
    ConversationPreview(
      patientId: 'a0eebc99-9c0b-4ef8-bb6d-6aa9bd380a11',
      patientName: 'Davi Ferreira da Silva',
      lastMessage: 'Ok, obrigado!',
      lastMessageTime: DateTime.now().subtract(const Duration(minutes: 5)),
      unreadCount: 2,
    ),
    ConversationPreview(
      patientId: 'a0eebc99-9c0b-4ef8-bb6d-6bb9bd380a11',
      patientName: 'Maria Souza',
      lastMessage: 'Já fiz os exercícios de hoje.',
      lastMessageTime: DateTime.now().subtract(const Duration(hours: 1)),
      unreadCount: 0,
    ),
    ConversationPreview(
      patientId: 'a0eebc99-9c0b-4ef8-bb6d-6cc9bd380a11',
      patientName: 'Carlos Andrade',
      lastMessage: 'Estou com um pouco de dor no joelho.',
      lastMessageTime: DateTime.now().subtract(const Duration(days: 1)),
      unreadCount: 1,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chat'),
      ),
      body: SafeArea(
        child: Column(
          children: [
            const SearchPatient(),

            SelectPatientPhoto(
              imagePatient: File(''),
              patientCount: 15,
            ),

            Expanded(
              child: ListView.builder(
                itemCount: conversations.length,

                itemBuilder: (context, index) {
                  final convo = conversations[index];

                  return ListPatient(
                    namePatient: convo.patientName,
                    message: convo.lastMessage,
                    dateTime: convo.lastMessageTime,
                    messageQuantity: convo.unreadCount,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => IndividualChatScreen(
                            patientName: convo.patientName,
                            patientId: convo.patientId,
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
