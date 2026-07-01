class TrustedCircleMember {
  final String id;
  final String seniorProfileId;
  final String name;
  final String relationship; // e.g. Anak, Apo, Volunteer
  final String phoneNumber;
  final String? fcmToken;
  final String role; // family or volunteer

  TrustedCircleMember({
    required this.id,
    required this.seniorProfileId,
    required this.name,
    required this.relationship,
    required this.phoneNumber,
    this.fcmToken,
    required this.role,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'seniorProfileId': seniorProfileId,
      'name': name,
      'relationship': relationship,
      'phoneNumber': phoneNumber,
      'fcmToken': fcmToken,
      'role': role,
    };
  }

  factory TrustedCircleMember.fromMap(Map<String, dynamic> map) {
    return TrustedCircleMember(
      id: map['id'] ?? '',
      seniorProfileId: map['seniorProfileId'] ?? '',
      name: map['name'] ?? '',
      relationship: map['relationship'] ?? '',
      phoneNumber: map['phoneNumber'] ?? '',
      fcmToken: map['fcmToken'],
      role: map['role'] ?? 'family',
    );
  }
}
