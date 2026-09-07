class AppUser {
  final String email;
  final bool isAdmin;

  const AppUser({required this.email, required this.isAdmin});

  Map<String, String> toMap() => {'email': email, 'isAdmin': isAdmin.toString()};

  factory AppUser.fromMap(Map<String, String> map) => AppUser(
        email: map['email']!,
        isAdmin: map['isAdmin'] == 'true',
      );
}
