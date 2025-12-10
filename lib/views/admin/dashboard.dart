import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../auth/sign_in_screen.dart';

class DashboardScreen extends StatelessWidget {
  static const String routeName = "/dashboard";

  const DashboardScreen({super.key});

  Future<int> getCollectionCount(String collection) async {
    final snapshot = await FirebaseFirestore.instance.collection(collection).get();
    return snapshot.docs.length;
  }

  Future<List<String>> getPreview(String collection) async {
  final snapshot = await FirebaseFirestore.instance
      .collection(collection)
      .limit(3)
      .get();

  return snapshot.docs.map<String>((doc) {
    final data = doc.data();

    switch (collection) {
      case "users":
        return data['name']?.toString() ?? "Unknown User";
      case "books":
        return data['title']?.toString() ?? "Unknown Book";
      case "categories":
        return data['name']?.toString() ?? "Unknown Category";
      default:
        return "Item";
    }
  }).toList();
}


  Widget buildCollectionCard({
    required String title,
    required int count,
    required List<String> preview,
    required VoidCallback onViewFullList,
    required Color color,
  }) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title,
                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 6),
            Text("Total: $count", style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 16),

            // PREVIEW LIST
            ...preview.map(
              (item) => Padding(
                padding: const EdgeInsets.only(bottom: 4),
                child: Row(
                  children: [
                    const Icon(Icons.circle, size: 8, color: Colors.grey),
                    const SizedBox(width: 8),
                    Expanded(child: Text(item)),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),
            Center(
              child: ElevatedButton(
                onPressed: onViewFullList,
                style: ElevatedButton.styleFrom(
                  backgroundColor: color,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text("View Full List"),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _logout(BuildContext context) async {
    await FirebaseAuth.instance.signOut();
    Navigator.pushReplacementNamed(context, SignInScreen.routeName);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Dashboard"),
        backgroundColor: Colors.blue.shade600,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => _logout(context),
            tooltip: "Logout",
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: FutureBuilder(
          future: Future.wait([
            getCollectionCount('users'),
            getPreview('users'),
            getCollectionCount('books'),
            getPreview('books'),
            getCollectionCount('categories'),
            getPreview('categories'),
          ]),
          builder: (context, AsyncSnapshot<List<dynamic>> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            if (!snapshot.hasData) {
              return const Center(child: Text("Failed to load data"));
            }

            final data = snapshot.data!;

            final usersCount = data[0];
            final usersPreview = data[1] as List<String>;

            final booksCount = data[2];
            final booksPreview = data[3] as List<String>;

            final categoriesCount = data[4];
            final categoriesPreview = data[5] as List<String>;

            return ListView(
              children: [
                buildCollectionCard(
                  title: "Users",
                  count: usersCount,
                  preview: usersPreview,
                  onViewFullList: () {
                    Navigator.pushNamed(context, '/admin_users');
                  },
                  color: Colors.orange,
                ),
                const SizedBox(height: 16),

                buildCollectionCard(
                  title: "Books",
                  count: booksCount,
                  preview: booksPreview,
                  onViewFullList: () {
                    Navigator.pushNamed(context, '/admin_books');
                  },
                  color: Colors.green,
                ),
                const SizedBox(height: 16),

                buildCollectionCard(
                  title: "Categories",
                  count: categoriesCount,
                  preview: categoriesPreview,
                  onViewFullList: () {
                    Navigator.pushNamed(context, '/admin_categories');
                  },
                  color: Colors.purple,
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
