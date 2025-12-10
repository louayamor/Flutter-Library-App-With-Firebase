import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:library_app/models/book.dart';
import 'package:library_app/models/category.dart';
import 'package:library_app/views/loan/loan_book.dart';

class BookDetailsScreen extends StatelessWidget {
  static String routeName = "/details";

  const BookDetailsScreen({super.key});

  Future<Book?> fetchBook(String id) async {
    final doc = await FirebaseFirestore.instance.collection("books").doc(id).get();
    if (!doc.exists) return null;
    return Book.fromMap(doc.data()!, doc.id);
  }

  Future<Category?> fetchCategory(String categoryId) async {
    final doc = await FirebaseFirestore.instance.collection("categories").doc(categoryId).get();
    if (!doc.exists) return null;
    return Category.fromMap(doc.data()!, doc.id);
  }

  @override
  Widget build(BuildContext context) {
    final String bookId = ModalRoute.of(context)!.settings.arguments as String;

    return FutureBuilder<Book?>(
      future: fetchBook(bookId),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(body: Center(child: CircularProgressIndicator()));
        }

        if (!snapshot.hasData || snapshot.data == null) {
          return const Scaffold(body: Center(child: Text("Book not found")));
        }

        final book = snapshot.data!;

        return FutureBuilder<Category?>(
          future: fetchCategory(book.categoryId),
          builder: (context, categorySnapshot) {
            final category = categorySnapshot.data;

            return Scaffold(
              extendBody: true,
              extendBodyBehindAppBar: true,
              backgroundColor: book.isAvailable ? Colors.green.shade50 : Colors.red.shade50,
              appBar: AppBar(
                backgroundColor: Colors.transparent,
                elevation: 0,
                leading: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    style: ElevatedButton.styleFrom(
                      shape: const CircleBorder(),
                      padding: EdgeInsets.zero,
                      elevation: 0,
                      backgroundColor: Colors.white,
                    ),
                    child: const Icon(Icons.arrow_back_ios_new, color: Colors.black, size: 20),
                  ),
                ),
                actions: [
                  Container(
                    margin: const EdgeInsets.only(right: 10),
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Row(
                      children: [
                        Text(
                          book.rating?.toStringAsFixed(1) ?? "0.0",
                          style: const TextStyle(fontSize: 14, color: Colors.black, fontWeight: FontWeight.w600),
                        ),
                        const SizedBox(width: 4),
                        SvgPicture.asset("assets/icons/Star Icon.svg", height: 16),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.favorite_border, color: Colors.red),
                    onPressed: () {
                      // TODO: Add favorite logic
                    },
                  ),
                ],
              ),
              body: ListView(
                padding: EdgeInsets.zero,
                children: [
                  // Book Image
                  if (book.image != null && book.image!.isNotEmpty)
                    Container(
                      height: 300,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: book.image!.startsWith('http')
                              ? NetworkImage(book.image!)
                              : AssetImage(book.image!) as ImageProvider,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  const SizedBox(height: 20),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(24),
                        topRight: Radius.circular(24),
                      ),
                      border: Border.all(
                        color: book.isAvailable ? Colors.green.shade300 : Colors.red.shade300,
                        width: 2,
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(book.title, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                        const SizedBox(height: 8),
                        Text("By ${book.author}", style: const TextStyle(fontSize: 16, color: Colors.grey)),
                        const SizedBox(height: 16),

                        // Category
                        if (category != null)
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                            decoration: BoxDecoration(
                              color: Colors.blue.shade50,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              category.name,
                              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                            ),
                          ),
                        const SizedBox(height: 16),

                        // Availability Status
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: book.isAvailable ? Colors.green.shade100 : Colors.red.shade100,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            book.isAvailable ? "Available" : "Already Loaned",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: book.isAvailable ? Colors.green.shade800 : Colors.red.shade800,
                              fontSize: 14,
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),

                        const Text("Description", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                        const SizedBox(height: 8),
                        Text(book.description, style: const TextStyle(fontSize: 15, color: Colors.black87)),
                      ],
                    ),
                  ),
                ],
              ),
              bottomNavigationBar: Container(
                padding: const EdgeInsets.all(20),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(topLeft: Radius.circular(24), topRight: Radius.circular(24)),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: book.isAvailable ? () {} : null, // disable if not available
                        icon: const Icon(Icons.shopping_cart_outlined),
                        label: const Text("Add to Cart"),
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          backgroundColor: book.isAvailable ? Colors.orange : Colors.grey,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: book.isAvailable
                            ? () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => LoanBookScreen(book: book),
                                  ),
                                );
                              }
                            : null, // disable if not available
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          backgroundColor: book.isAvailable ? Colors.blue : Colors.grey,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                        ),
                        child: const Text("Loan", style: TextStyle(fontSize: 16)),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}
