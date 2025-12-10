import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../../models/book.dart';
import '../../models/loan.dart';
import '../../models/user.dart'; // Your AppUser model

class LoanBookScreen extends StatefulWidget {
  static const String routeName = "/loan_book";

  final Book book;

  const LoanBookScreen({super.key, required this.book});

  @override
  State<LoanBookScreen> createState() => _LoanBookScreenState();
}

class _LoanBookScreenState extends State<LoanBookScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  AppUser? currentUser;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadUser();
  }

  Future<void> _loadUser() async {
    final userId = _auth.currentUser!.uid;
    final doc = await _firestore.collection('users').doc(userId).get();
    if (doc.exists) {
      setState(() {
        currentUser = AppUser.fromMap(doc.data()!, doc.id);
      });
    }
  }

  Future<void> loanBook() async {
    if (currentUser == null) return;

    setState(() => isLoading = true);

    // Check if user already borrowed this book
    final existingLoan = await _firestore
        .collection('loans')
        .where('bookId', isEqualTo: widget.book.id)
        .where('userId', isEqualTo: currentUser!.id)
        .get();

    if (existingLoan.docs.isNotEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("You already borrowed this book")),
      );
      setState(() => isLoading = false);
      return;
    }

    // Create new loan
    final loanRef = _firestore.collection('loans').doc();
    final newLoan = Loan(
      id: loanRef.id,
      bookId: widget.book.id,
      userId: currentUser!.id,
      borrowedAt: DateTime.now(),
    );

    await loanRef.set(newLoan.toMap());

    // Optional: update user's borrowedBooks list
    currentUser!.borrowedBooks.add(widget.book.id);
    await _firestore.collection('users').doc(currentUser!.id).update({
      'borrowedBooks': currentUser!.borrowedBooks,
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("You borrowed '${widget.book.title}'")),
    );

    setState(() => isLoading = false);
    Navigator.pop(context); // Go back after loaning
  }

  @override
  Widget build(BuildContext context) {
    final book = widget.book;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Loan Book"),
        backgroundColor: Colors.blue.shade600,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (book.image != null && book.image!.isNotEmpty)
              Image(
                image: book.image!.startsWith('http')
                    ? NetworkImage(book.image!) as ImageProvider
                    : AssetImage(book.image!),
                height: 250,
                fit: BoxFit.cover,
              ),
            const SizedBox(height: 20),
            Text(
              book.title,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              "By ${book.author}",
              style: const TextStyle(fontSize: 16, color: Colors.grey),
            ),
            const SizedBox(height: 16),
            Text(
              book.description,
              style: const TextStyle(fontSize: 15),
            ),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: isLoading ? null : loanBook,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  backgroundColor: Colors.blue,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                child: isLoading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text("Loan Book", style: TextStyle(fontSize: 18)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
