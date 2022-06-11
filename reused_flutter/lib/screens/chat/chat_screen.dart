import 'package:flutter/material.dart';

class UserChatScreen extends StatefulWidget {
  static const routeName = "/user_chat";
  const UserChatScreen({Key? key}) : super(key: key);

  @override
  State<UserChatScreen> createState() => _UserChatScreenState();
}

class _UserChatScreenState extends State<UserChatScreen> {
  final bool _hasMessages = false;
  final _messageController = TextEditingController();
  final _textFocusNode = FocusNode();

  void _sendMessage() {
    // do something

    _messageController.text = '';
  }

  @override
  Widget build(BuildContext context) {
    final routeArgs =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    final String username = routeArgs['username']!;
    return Scaffold(
      appBar: AppBar(
        title: Text(username),
      ),
      body: Column(
        children: [
          Expanded(
            child: GestureDetector(
              onTap: () => _textFocusNode.unfocus(),
              behavior: HitTestBehavior.translucent,
              child: _hasMessages
                  ? SingleChildScrollView(
                      child: Container(),
                      // have messages here, listview builder, i guess
                    )
                  : const Center(child: Text('No messages here yet!')),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: InkWell(
                    onTap: () => _textFocusNode.attach(context),
                    child: TextField(
                      decoration: const InputDecoration.collapsed(
                        hintText: 'Enter your message...',
                        focusColor: null,
                        filled: false,
                      ),
                      maxLines: 10,
                      minLines: 1,
                      controller: _messageController,
                      focusNode: _textFocusNode,
                      autofocus: true,
                      keyboardType: TextInputType.multiline,
                      // onSubmitted: null,
                      onChanged: (_) {
                        setState(() {
                          /* _controller updates and the send button updates too */
                        });
                      },
                    ),
                  ),
                ),
                ElevatedButton(
                  onPressed:
                      _messageController.text.isEmpty ? null : _sendMessage,
                  child: const Text("Send"),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
