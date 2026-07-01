class ScamCheck {
  final String id;
  final String seniorProfileId;
  final String submittedBy; // memberId or "self"
  final String rawMessageText;
  final String? senderNumber;
  final String riskLevel; // Mataas / Katamtaman / Mababa
  final String reasoning;
  final String recommendedAction;
  final DateTime createdAt;

  ScamCheck({
    required this.id,
    required this.seniorProfileId,
    required this.submittedBy,
    required this.rawMessageText,
    this.senderNumber,
    required this.riskLevel,
    required this.reasoning,
    required this.recommendedAction,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'seniorProfileId': seniorProfileId,
      'submittedBy': submittedBy,
      'rawMessageText': rawMessageText,
      'senderNumber': senderNumber,
      'riskLevel': riskLevel,
      'reasoning': reasoning,
      'recommendedAction': recommendedAction,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory ScamCheck.fromMap(Map<String, dynamic> map) {
    return ScamCheck(
      id: map['id'] ?? '',
      seniorProfileId: map['seniorProfileId'] ?? '',
      submittedBy: map['submittedBy'] ?? '',
      rawMessageText: map['rawMessageText'] ?? '',
      senderNumber: map['senderNumber'],
      riskLevel: map['riskLevel'] ?? 'Katamtaman',
      reasoning: map['reasoning'] ?? '',
      recommendedAction: map['recommendedAction'] ?? '',
      createdAt: map['createdAt'] != null ? DateTime.parse(map['createdAt']) : DateTime.now(),
    );
  }
}
