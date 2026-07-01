class CheckIn {
  final String id;
  final String seniorProfileId;
  final String date; // YYYY-MM-DD
  final String mood; // Masaya / Okay lang / Malungkot
  final List<String> activities;
  final String? note;
  final String? voiceNoteUrl;
  final DateTime createdAt;

  CheckIn({
    required this.id,
    required this.seniorProfileId,
    required this.date,
    required this.mood,
    required this.activities,
    this.note,
    this.voiceNoteUrl,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'seniorProfileId': seniorProfileId,
      'date': date,
      'mood': mood,
      'activities': activities,
      'note': note,
      'voiceNoteUrl': voiceNoteUrl,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory CheckIn.fromMap(Map<String, dynamic> map) {
    return CheckIn(
      id: map['id'] ?? '',
      seniorProfileId: map['seniorProfileId'] ?? '',
      date: map['date'] ?? '',
      mood: map['mood'] ?? 'Okay lang',
      activities: List<String>.from(map['activities'] ?? []),
      note: map['note'],
      voiceNoteUrl: map['voiceNoteUrl'],
      createdAt: map['createdAt'] != null ? DateTime.parse(map['createdAt']) : DateTime.now(),
    );
  }
}
