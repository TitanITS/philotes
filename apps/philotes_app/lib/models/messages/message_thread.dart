enum MessageThreadType {
  direct,
  group,
}

class MessageParticipant {
  const MessageParticipant({
    required this.id,
    required this.displayName,
    required this.initials,
    this.isCurrentUser = false,
  });

  final String id;
  final String displayName;
  final String initials;
  final bool isCurrentUser;
}

class PhilotesMessage {
  const PhilotesMessage({
    required this.id,
    required this.senderId,
    required this.text,
    required this.sentAt,
  });

  final String id;
  final String senderId;
  final String text;
  final DateTime sentAt;
}

class MessageThread {
  MessageThread({
    required this.id,
    required this.type,
    required this.title,
    required this.participants,
    required this.messages,
    required this.latestActivity,
    this.unreadCount = 0,
  });

  final String id;
  final MessageThreadType type;
  final String title;
  final List<MessageParticipant> participants;
  final List<PhilotesMessage> messages;

  DateTime latestActivity;
  int unreadCount;

  bool get isDirect =>
      type == MessageThreadType.direct;

  bool get isGroup =>
      type == MessageThreadType.group;

  String get latestPreview {
    if (messages.isEmpty) {
      return 'Start the conversation.';
    }

    return messages.last.text;
  }
}
