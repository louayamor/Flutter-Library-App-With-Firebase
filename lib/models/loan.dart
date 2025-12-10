class Loan {
  final String id;
  final String bookId;
  final String userId;
  final DateTime borrowedAt;
  final DateTime? returnDate;

  Loan({
    required this.id,
    required this.bookId,
    required this.userId,
    required this.borrowedAt,
    this.returnDate,
  });

  Map<String, dynamic> toMap() => {
    "bookId": bookId,
    "userId": userId,
    "borrowedAt": borrowedAt.toIso8601String(),
    "returnDate": returnDate?.toIso8601String(),
  };

  factory Loan.fromMap(Map<String, dynamic> data, String id) {
    return Loan(
      id: id,
      bookId: data["bookId"],
      userId: data["userId"],
      borrowedAt: DateTime.parse(data["borrowedAt"]),
      returnDate: data["returnDate"] != null
          ? DateTime.parse(data["returnDate"])
          : null,
    );
  }
}
