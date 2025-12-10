class Book {
  final String id;
  final String title;
  final String author;
  final String description;
  final String categoryId;         
  final double? rating;
  final String? image;
  final bool isAvailable; // new field

  Book({
    required this.id,
    required this.title,
    required this.author,
    required this.description,
    required this.categoryId,
    this.rating,
    this.image,
    this.isAvailable = true, // default to true
  });

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'author': author,
      'description': description,
      'categoryId': categoryId,
      'rating': rating,
      'image': image,
      'isAvailable': isAvailable, // include in map
    };
  }

  factory Book.fromMap(Map<String, dynamic> data, String documentId) {
    return Book(
      id: documentId,
      title: data['title'] ?? '',
      author: data['author'] ?? '',
      description: data['description'] ?? '',
      categoryId: data['categoryId'] ?? '',
      rating: data['rating'] != null ? (data['rating'] as num).toDouble() : null,
      image: data['image'],
      isAvailable: data['isAvailable'] ?? true, 
    );
  }
}
