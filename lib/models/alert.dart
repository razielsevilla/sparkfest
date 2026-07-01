class Alert {
  final String id;
  final String seniorProfileId;
  final String type; // scam_detected / missed_checkin / mood_decline
  final String message;
  final List<String> recipientIds;
  final String? relatedDocId; // scamCheckId or checkInId
  final DateTime createdAt;
  final bool resolved;

  Alert({
    required this.id,
    required this.seniorProfileId,
    required this.type,
    required this.message,
    required this.recipientIds,
    this.relatedDocId,
    required this.createdAt,
    required this.resolved,
  });

  Alert copyWith({
    String? id,
    String? seniorProfileId,
    String? type,
    String? message,
    List<String>? recipientIds,
    String? relatedDocId,
    DateTime? createdAt,
    bool? resolved,
  }) {
    return Alert(
      id: id ?? this.id,
      seniorProfileId: seniorProfileId ?? this.seniorProfileId,
      type: type ?? this.type,
      message: message ?? this.message,
      recipientIds: recipientIds ?? this.recipientIds,
      relatedDocId: relatedDocId ?? this.relatedDocId,
      createdAt: createdAt ?? this.createdAt,
      resolved: resolved ?? this.resolved,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'seniorProfileId': seniorProfileId,
      'type': type,
      'message': message,
      'recipientIds': recipientIds,
      'relatedDocId': relatedDocId,
      'createdAt': createdAt.toIso8601String(),
      'resolved': resolved,
    };
  }

  factory Alert.fromMap(Map<String, dynamic> map) {
    return Alert(
      id: map['id'] ?? '',
      seniorProfileId: map['seniorProfileId'] ?? '',
      type: map['type'] ?? '',
      message: map['message'] ?? '',
      recipientIds: List<String>.from(map['recipientIds'] ?? []),
      relatedDocId: map['relatedDocId'],
      createdAt: map['createdAt'] != null ? DateTime.parse(map['createdAt']) : DateTime.now(),
      resolved: map['resolved'] ?? false,
    );
  }
}
