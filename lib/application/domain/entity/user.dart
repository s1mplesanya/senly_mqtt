import 'dart:convert';

class UserE {
  final String id;
  final bool geoStatus;
  final String displayName;
  final String? imageUrl;

  final List<String> subscribedUsers;

  UserE({
    required this.id,
    required this.geoStatus,
    required this.displayName,
    required this.subscribedUsers,
    this.imageUrl,
  });

  String toJson() => json.encode(toMap());

  factory UserE.fromJson(String source) =>
      UserE.fromMap(json.decode(source) as Map<String, dynamic>);

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'geo_status': geoStatus,
      'display_name': displayName,
      'subscribed_users': subscribedUsers,
      'image_url': imageUrl,
    };
  }

  factory UserE.fromMap(Map<String, dynamic> map) {
    return UserE(
      id: map['id'] as String,
      geoStatus: map['geo_status'] as bool,
      displayName: map['display_name'] as String,
      subscribedUsers: map.containsKey('subscribed_users')
          ? List<String>.from(map['subscribed_users'])
          : [],
      imageUrl: map.containsKey('image_url') ? map['image_url'] : null,
    );

    // при добавлении новых полей делать map.containsKey('user_scores'), чтобы если ты был зареган раньше, нормально спарсился после обновы
  }

  UserE copyWith({
    String? id,
    bool? geoStatus,
    String? displayName,
    List<String>? subscribedUsers,
    String? imageUrl,
  }) {
    return UserE(
      id: id ?? this.id,
      geoStatus: geoStatus ?? this.geoStatus,
      displayName: displayName ?? this.displayName,
      subscribedUsers: subscribedUsers ?? this.subscribedUsers,
      imageUrl: imageUrl ?? this.imageUrl,
    );
  }
}
