import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import '../models/message.dart';

class ChatProvider extends ChangeNotifier {
  List<List<Message>> _allChats = [[]];
  List<String> _chatTitles = ['Chat 1'];
  int _activeChat = 0;

  final String _apiKey = "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";
  final String _baseUrl = "https://openrouter.ai/api/v1/chat/completions";
  final String _model = "gpt-3.5-turbo"; // you can change model here

  List<Message> get messages => _allChats[_activeChat];
  List<String> get chatTitles => _chatTitles;
  String get activeChatTitle => _chatTitles[_activeChat];

  void createNewChat() {
    _allChats.add([]);
    _chatTitles.add('Chat ${_allChats.length}');
    notifyListeners();
  }

  void setActiveChat(int index) {
    _activeChat = index;
    notifyListeners();
  }

  void renameChat(int index, String newName) {
    if (newName.isNotEmpty) {
      _chatTitles[index] = newName;
      notifyListeners();
    }
  }

  Future<void> sendMessage(String text) async {
    _allChats[_activeChat].add(Message(text: text, isUser: true));
    notifyListeners();

    try {
      final response = await http.post(
        Uri.parse(_baseUrl),
        headers: {
          "Authorization": "Bearer $_apiKey",
          "Content-Type": "application/json",
        },
        body: jsonEncode({
          "model": _model,
          "messages": [
            {"role": "system", "content": "You are a helpful AI assistant."},
            {"role": "user", "content": text},
          ],
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final reply = data['choices'][0]['message']['content'];

        _allChats[_activeChat].add(Message(text: reply.trim(), isUser: false));
      } else {
        _allChats[_activeChat].add(
          Message(
            text: "⚠️ Error: ${response.statusCode}\n${response.body}",
            isUser: false,
          ),
        );
      }
    } catch (e) {
      _allChats[_activeChat].add(
        Message(text: "❌ Error: $e", isUser: false),
      );
    }

    notifyListeners();
  }
}
