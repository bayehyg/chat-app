import 'package:flutter/material.dart';

class ChatCard extends StatelessWidget {
  final String avatarUrl;
  final String name;
  final String message;
  final bool isCurrentUser;

  const ChatCard({
    Key? key,
    required this.avatarUrl,
    required this.name,
    required this.message,
    required this.isCurrentUser,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment:
        isCurrentUser ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: [
          if (!isCurrentUser)
            CircleAvatar(
              backgroundImage: NetworkImage(avatarUrl),
            ),
          const SizedBox(width: 8),
          Flexible(
            child: Container(
              decoration: BoxDecoration(
                color: isCurrentUser ? Colors.blue : Colors.grey[300],
                borderRadius: BorderRadius.circular(16),
              ),
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: isCurrentUser ? Colors.white : Colors.black,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    message,
                    style: TextStyle(
                      color: isCurrentUser ? Colors.white : Colors.black,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(width: 8),
          if (isCurrentUser)
            CircleAvatar(
              backgroundImage: NetworkImage(avatarUrl),
            ),
        ],
      ),
    );
  }
}
