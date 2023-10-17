class User {
  String? name;
  String? username;
  String? password;
  String? created_at;

  User(String name, String username, String password, String? created_at) {
    this.name = name;
    this.username = username;
    this.password = password;
    this.created_at = (created_at != null)
        ? created_at
        : DateTime.timestamp().millisecondsSinceEpoch.toString();
  }

  Map<String, dynamic> toJson() => {
        'name': name,
        'username': username,
        'password': password,
        'created_at': created_at
      };
}
