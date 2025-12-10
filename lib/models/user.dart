class AppUser {
  final String id;
  final String email;
  final String name;
  final String role; 
  List<String> borrowedBooks;

  AppUser({
    required this.id,
    required this.email,
    required this.name,
    required this.role,
    required this.borrowedBooks,
  });

  factory AppUser.fromMap(Map<String, dynamic> data, String id) {
    return AppUser(
      id: id,
      email: data['email'],
      name: data['name'],
      role: data['role'] ?? 'user', 
      borrowedBooks: List<String>.from(data['borrowedBooks'] ?? []),
    );
  }

  Map<String, dynamic> toMap() => {
        'email': email,
        'name': name,
        'role': role,
        'borrowedBooks': borrowedBooks,
      };
}
