class Category {
  final String id;
  final String name;
  final String description;

  Category({required this.id, required this.name, required this.description});
  
  factory Category.fromMap(Map<String, dynamic> map, String id) {
    return Category(
      id: id,
      name: map['name'] ?? 'Uncategorized',
      description: map['description'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'description': description,
    };
  }
}
