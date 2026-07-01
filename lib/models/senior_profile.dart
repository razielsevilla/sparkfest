class SeniorProfile {
  final String id;
  final String fullName;
  final int age;
  final String? photoUrl;
  final String barangay;
  final String primaryContactPhone;
  final String? pinCode;
  final DateTime createdAt;
  final DateTime? lastCheckInDate;

  SeniorProfile({
    required this.id,
    required this.fullName,
    required this.age,
    this.photoUrl,
    required this.barangay,
    required this.primaryContactPhone,
    this.pinCode,
    required this.createdAt,
    this.lastCheckInDate,
  });

  SeniorProfile copyWith({
    String? id,
    String? fullName,
    int? age,
    String? photoUrl,
    String? barangay,
    String? primaryContactPhone,
    String? pinCode,
    DateTime? createdAt,
    DateTime? lastCheckInDate,
  }) {
    return SeniorProfile(
      id: id ?? this.id,
      fullName: fullName ?? this.fullName,
      age: age ?? this.age,
      photoUrl: photoUrl ?? this.photoUrl,
      barangay: barangay ?? this.barangay,
      primaryContactPhone: primaryContactPhone ?? this.primaryContactPhone,
      pinCode: pinCode ?? this.pinCode,
      createdAt: createdAt ?? this.createdAt,
      lastCheckInDate: lastCheckInDate ?? this.lastCheckInDate,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'fullName': fullName,
      'age': age,
      'photoUrl': photoUrl,
      'barangay': barangay,
      'primaryContactPhone': primaryContactPhone,
      'pinCode': pinCode,
      'createdAt': createdAt.toIso8601String(),
      'lastCheckInDate': lastCheckInDate?.toIso8601String(),
    };
  }

  factory SeniorProfile.fromMap(Map<String, dynamic> map) {
    return SeniorProfile(
      id: map['id'] ?? '',
      fullName: map['fullName'] ?? '',
      age: map['age']?.toInt() ?? 0,
      photoUrl: map['photoUrl'],
      barangay: map['barangay'] ?? '',
      primaryContactPhone: map['primaryContactPhone'] ?? '',
      pinCode: map['pinCode'],
      createdAt: map['createdAt'] != null ? DateTime.parse(map['createdAt']) : DateTime.now(),
      lastCheckInDate: map['lastCheckInDate'] != null ? DateTime.parse(map['lastCheckInDate']) : null,
    );
  }
}
