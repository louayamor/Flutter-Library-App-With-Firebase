import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../controllers/book_controller.dart';
import '../../controllers/category_controller.dart';
import '../../controllers/auth_controller.dart';
import '../../models/book.dart';
import '../auth/sign_in_screen.dart';
import '../book/book_details.dart';

class HomeScreen extends StatefulWidget {
  static String routeName = "/home";

  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController searchController = TextEditingController();
  String searchQuery = "";

  final Map<String, String> categoryImages = const {
    "Fiction": "assets/images/fiction.jpg",
    "Science": "assets/images/science.jpg",
    "History": "assets/images/history.jpg",
    "Fantasy": "assets/images/fantasy.jpg",
    "Biography": "assets/images/biography.jpg",
    "Self-Help": "assets/images/selfhelp.jpg",
    "Mystery": "assets/images/mystery.jpg",
    "Romance": "assets/images/romance.jpg",
    "Thriller": "assets/images/thriller.jpg",
    "Poetry": "assets/images/poetry.jpg",
    "Philosophy": "assets/images/philosophy.jpg",
  };

  @override
  Widget build(BuildContext context) {
    final bookController = Provider.of<BookController>(context);
    final categoryController = Provider.of<CategoryController>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Library App'),
        centerTitle: true,
        elevation: 2,
        backgroundColor: Colors.blue.shade600,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await AuthController().logout();
              if (!context.mounted) return;
              Navigator.pushNamedAndRemoveUntil(
                  context, SignInScreen.routeName, (route) => false);
            },
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.blue.shade50, Colors.blue.shade100],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Top Container with search
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Colors.blue.shade600, Colors.blue.shade400],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Find your next favorite book",
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 16),
                      TextField(
                        controller: searchController,
                        decoration: InputDecoration(
                          hintText: "Search books...",
                          fillColor: Colors.white,
                          filled: true,
                          prefixIcon: const Icon(Icons.search),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide.none,
                          ),
                        ),
                        onChanged: (value) {
                          setState(() => searchQuery = value);
                        },
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                // Books Section
                const Text(
                  "Books",
                  style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87),
                ),
                const SizedBox(height: 12),
                SizedBox(
                  height: 300,
                  child: StreamBuilder<List<Book>>(
                    stream: bookController.allBooks,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      }
                      if (!snapshot.hasData || snapshot.data!.isEmpty) {
                        return const Center(child: Text("No books found."));
                      }

                      final filteredBooks = snapshot.data!
                          .where((book) => book.title
                              .toLowerCase()
                              .contains(searchQuery.toLowerCase()))
                          .toList();

                      if (filteredBooks.isEmpty) {
                        return const Center(child: Text("No matching books."));
                      }

                      return ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: filteredBooks.length,
                        itemBuilder: (context, index) {
                          final book = filteredBooks[index];
                          return GestureDetector(
                            onTap: () => Navigator.pushNamed(
                              context,
                              BookDetailsScreen.routeName,
                              arguments: book.id,
                            ),
                            child: Card(
                              elevation: 3,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16)),
                              margin:
                                  const EdgeInsets.symmetric(horizontal: 8),
                              child: Container(
                                width: 160,
                                padding: const EdgeInsets.all(8),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Expanded(
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(12),
                                        child: book.image != null
                                            ? Image.network(
                                                book.image!,
                                                width: double.infinity,
                                                fit: BoxFit.cover,
                                                errorBuilder:
                                                    (context, error, stackTrace) =>
                                                        Container(
                                                            color: Colors
                                                                .grey.shade300),
                                              )
                                            : Container(
                                                color: Colors.grey.shade300,
                                              ),
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      book.title,
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    Text(
                                      book.author,
                                      style: const TextStyle(
                                          fontSize: 12, color: Colors.grey),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      );
                    },
                  ),
                ),
                const SizedBox(height: 24),

                // Categories Section
                const Text(
                  "Categories",
                  style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87),
                ),
                const SizedBox(height: 12),
                categoryController.isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : GridView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          childAspectRatio: 3 / 2,
                          crossAxisSpacing: 12,
                          mainAxisSpacing: 12,
                        ),
                        itemCount: categoryController.categories.length,
                        itemBuilder: (context, index) {
                          final category =
                              categoryController.categories[index];
                          final imagePath = categoryImages[category.name] ??
                              "assets/images/fiction.jpg";
                          return Card(
                            elevation: 3,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16)),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                Expanded(
                                  child: ClipRRect(
                                    borderRadius: const BorderRadius.vertical(
                                        top: Radius.circular(16)),
                                    child: Image.asset(
                                      imagePath,
                                      fit: BoxFit.cover,
                                      errorBuilder: (context, error, stackTrace) =>
                                          Container(color: Colors.grey.shade300),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    category.name,
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
