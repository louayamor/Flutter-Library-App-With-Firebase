import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../controllers/book_controller.dart';
import '../../controllers/category_controller.dart';
import '../../controllers/auth_controller.dart';
import '../../models/book.dart';
import '../auth/sign_in_screen.dart';
import '../book/book_details.dart';

class HomeScreen extends StatefulWidget {
  static const String routeName = "/home";

  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = "";

  final Map<String, String> _categoryImages = const {
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
    final bookController = context.watch<BookController>();
    final categoryController = context.watch<CategoryController>();
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Library"),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: _logout,
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSearchSection(theme),
              const SizedBox(height: 32),

              _buildSectionTitle("Books"),
              const SizedBox(height: 12),
              _buildBooksList(bookController),
              const SizedBox(height: 32),

              _buildSectionTitle("Categories"),
              const SizedBox(height: 12),
              _buildCategoriesGrid(categoryController),
            ],
          ),
        ),
      ),
    );
  }

  // ================= UI SECTIONS =================

  Widget _buildSearchSection(ThemeData theme) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            theme.colorScheme.primary,
            theme.colorScheme.primary.withOpacity(0.85),
          ],
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Find your next favorite book",
            style: theme.textTheme.headlineMedium?.copyWith(
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _searchController,
            onChanged: (value) => setState(() => _searchQuery = value),
            decoration: const InputDecoration(
              hintText: "Search books...",
              prefixIcon: Icon(Icons.search),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBooksList(BookController controller) {
    return SizedBox(
      height: 300,
      child: StreamBuilder<List<Book>>(
        stream: controller.allBooks,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final books = snapshot.data ?? [];
          final filtered = books
              .where((b) =>
                  b.title.toLowerCase().contains(_searchQuery.toLowerCase()))
              .toList();

          if (filtered.isEmpty) {
            return const Center(child: Text("No books found"));
          }

          return ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: filtered.length,
            separatorBuilder: (_, __) => const SizedBox(width: 12),
            itemBuilder: (context, index) {
              final book = filtered[index];
              return _BookCard(book: book);
            },
          );
        },
      ),
    );
  }

  Widget _buildCategoriesGrid(CategoryController controller) {
    if (controller.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: controller.categories.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 3 / 2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
      ),
      itemBuilder: (context, index) {
        final category = controller.categories[index];
        final image =
            _categoryImages[category.name] ?? "assets/images/fiction.jpg";

        return Card(
          clipBehavior: Clip.antiAlias,
          child: Column(
            children: [
              Expanded(
                child: Image.asset(
                  image,
                  fit: BoxFit.cover,
                  width: double.infinity,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8),
                child: Text(
                  category.name,
                  style: Theme.of(context).textTheme.labelLarge,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: Theme.of(context).textTheme.headlineSmall,
    );
  }

  // ================= ACTIONS =================

  Future<void> _logout() async {
    await AuthController().logout();
    if (!mounted) return;
    Navigator.pushNamedAndRemoveUntil(
      context,
      SignInScreen.routeName,
      (_) => false,
    );
  }
}

// ================= BOOK CARD =================

class _BookCard extends StatelessWidget {
  final Book book;

  const _BookCard({required this.book});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.pushNamed(
        context,
        BookDetailsScreen.routeName,
        arguments: book.id,
      ),
      child: SizedBox(
        width: 160,
        child: Card(
          clipBehavior: Clip.antiAlias,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: book.image != null
                    ? Image.network(
                        book.image!,
                        width: double.infinity,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) =>
                            Container(color: Colors.grey.shade300),
                      )
                    : Container(color: Colors.grey.shade300),
              ),
              Padding(
                padding: const EdgeInsets.all(8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      book.title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.labelLarge,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      book.author,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
