import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../auth/sign_in_screen.dart';
import '../../theme.dart';

class DashboardScreen extends StatelessWidget {
  static const String routeName = "/dashboard";

  const DashboardScreen({super.key});

  // Fetch total documents in a collection
  Future<int> getCollectionCount(String collection) async {
    final snapshot = await FirebaseFirestore.instance.collection(collection).get();
    return snapshot.docs.length;
  }

  // Fetch first 3 items for preview
  Future<List<String>> getPreview(String collection) async {
    final snapshot = await FirebaseFirestore.instance.collection(collection).limit(3).get();

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

  // Card widget for each collection
  Widget buildCollectionCard({
    required String title,
    required int count,
    required List<String> preview,
    required VoidCallback onViewFullList,
    required Color color,
    required IconData icon,
  }) {
    return Card(
      color: AppTheme.surface,
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      shadowColor: Colors.black12,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, size: 28, color: color),
                const SizedBox(width: 12),
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.textPrimary,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              "Total: $count",
              style: const TextStyle(fontSize: 16, color: AppTheme.textSecondary),
            ),
            const Divider(height: 24, thickness: 1),
            if (preview.isEmpty)
              SizedBox(
                height: 60,
                child: Center(
                  child: Text(
                    "No items found",
                    style: TextStyle(
                      color: Colors.grey.shade500,
                      fontStyle: FontStyle.italic,
                      fontSize: 14,
                    ),
                  ),
                ),
              )
            else
              ...preview.map(
                (item) => Padding(
                  padding: const EdgeInsets.only(bottom: 6),
                  child: Row(
                    children: [
                      const Icon(Icons.circle, size: 8, color: Colors.grey),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          item,
                          style: const TextStyle(color: AppTheme.textPrimary),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: onViewFullList,
                style: ElevatedButton.styleFrom(
                  backgroundColor: color,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  "View Full List",
                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
                ),
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
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        title: const Text("Admin Dashboard"),
        backgroundColor: AppTheme.primary,
        foregroundColor: Colors.white,
        centerTitle: true,
        elevation: 2,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: "Logout",
            onPressed: () => _logout(context),
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
                  onViewFullList: () => Navigator.pushNamed(context, '/admin_users'),
                  color: AppTheme.primary,
                  icon: Icons.person,
                ),
                const SizedBox(height: 16),
                buildCollectionCard(
                  title: "Books",
                  count: booksCount,
                  preview: booksPreview,
                  onViewFullList: () => Navigator.pushNamed(context, '/admin_books'),
                  color: AppTheme.secondary,
                  icon: Icons.book,
                ),
                const SizedBox(height: 16),
                buildCollectionCard(
                  title: "Categories",
                  count: categoriesCount,
                  preview: categoriesPreview,
                  onViewFullList: () => Navigator.pushNamed(context, '/admin_categories'),
                  color: Colors.purple,
                  icon: Icons.category,
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
