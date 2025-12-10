import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../controllers/book_controller.dart';
import '../../controllers/category_controller.dart';
import '../../models/book.dart';
import '../../models/category.dart';

class AddBookScreen extends StatefulWidget {
  static const String routeName = "/add_book";

  const AddBookScreen({super.key});

  @override
  State<AddBookScreen> createState() => _AddBookScreenState();
}

class _AddBookScreenState extends State<AddBookScreen> {
  final _formKey = GlobalKey<FormState>();

  String title = '';
  String author = '';
  String description = '';
  double? rating;
  String? imageUrl;
  String? selectedCategoryId;
  bool isAvailable = true;

  @override
  Widget build(BuildContext context) {
    final bookController = Provider.of<BookController>(context, listen: false);
    final categoryController = Provider.of<CategoryController>(context);
    final categories = categoryController.categories;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Add New Book"),
        backgroundColor: Colors.blue.shade700,
        centerTitle: true,
        elevation: 3,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _pageTitle(),

              const SizedBox(height: 20),

              _buildFormCard(categories),

              const SizedBox(height: 100),
            ],
          ),
        ),
      ),

      // floating bottom button
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: SizedBox(
            height: 55,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue.shade700,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16)),
              ),
              onPressed: _submit(bookController),
              child: const Text(
                "Add Book",
                style: TextStyle(
                    fontSize: 18, fontWeight: FontWeight.w600),
              ),
            ),
          ),
        ),
      ),
    );
  }

  // --------------------------
  // MARK: UI COMPONENTS
  // --------------------------

  Widget _pageTitle() {
    return Text(
      "Create a New Book",
      style: TextStyle(
        fontSize: 26,
        fontWeight: FontWeight.bold,
        color: Colors.blue.shade900,
      ),
    );
  }

  Widget _sectionTitle(String text) {
    return Text(
      text,
      style: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w700,
        color: Colors.blue.shade700,
      ),
    );
  }

  Widget _buildFormCard(List<Category> categories) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _sectionTitle("Basic Information"),
              const SizedBox(height: 12),

              _textField(
                label: "Title",
                validator: _required("Please enter the title"),
                onSaved: (v) => title = v!.trim(),
              ),
              const SizedBox(height: 16),

              _textField(
                label: "Author",
                validator: _required("Please enter the author"),
                onSaved: (v) => author = v!.trim(),
              ),
              const SizedBox(height: 25),

              _sectionTitle("Details"),
              const SizedBox(height: 12),

              _textField(
                label: "Description",
                validator: _required("Please enter the description"),
                onSaved: (v) => description = v!.trim(),
                maxLines: 4,
              ),
              const SizedBox(height: 16),

              _textField(
                label: "Rating (0–5)",
                inputType: TextInputType.number,
                validator: (v) {
                  if (v == null || v.isEmpty) return "Enter rating";
                  final parsed = double.tryParse(v);
                  if (parsed == null || parsed < 0 || parsed > 5) {
                    return "Enter a valid rating (0–5)";
                  }
                  return null;
                },
                onSaved: (v) => rating = double.tryParse(v!),
              ),
              const SizedBox(height: 25),

              _sectionTitle("Category & Availability"),
              const SizedBox(height: 12),

              _categoryDropdown(categories),
              const SizedBox(height: 20),

              _availabilitySwitch(),
              const SizedBox(height: 25),

              _sectionTitle("Image"),
              const SizedBox(height: 10),

              _textField(
                label: "Image URL (optional)",
                validator: (_) => null,
                onSaved: (v) => imageUrl = v!.trim(),
              ),
              const SizedBox(height: 16),

              if (imageUrl != null && imageUrl!.isNotEmpty)
                _imagePreview(),
            ],
          ),
        ),
      ),
    );
  }

  // text field builder
  Widget _textField({
    required String label,
    required FormFieldValidator<String> validator,
    required FormFieldSetter<String> onSaved,
    int maxLines = 1,
    TextInputType inputType = TextInputType.text,
  }) {
    return TextFormField(
      validator: validator,
      onSaved: onSaved,
      maxLines: maxLines,
      keyboardType: inputType,
      decoration: InputDecoration(
        labelText: label,
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none,
        ),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: Colors.blue.shade400, width: 2),
        ),
      ),
    );
  }

  Widget _categoryDropdown(List<Category> categories) {
    return DropdownButtonFormField<String>(
      initialValue: selectedCategoryId,
      items: categories
          .map((c) =>
              DropdownMenuItem(value: c.id, child: Text(c.name)))
          .toList(),
      decoration: _dropdownDecoration(),
      onChanged: (value) => setState(() => selectedCategoryId = value),
      validator: (v) => v == null ? "Please choose a category" : null,
    );
  }

  Widget _availabilitySwitch() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text(
          "Available",
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        Switch(
          value: isAvailable,
          onChanged: (v) => setState(() => isAvailable = v),
        ),
      ],
    );
  }

  Widget _imagePreview() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: Image.network(
        imageUrl!,
        height: 130,
        width: double.infinity,
        fit: BoxFit.cover,
      ),
    );
  }

  InputDecoration _dropdownDecoration() {
    return InputDecoration(
      filled: true,
      fillColor: Colors.white,
      labelText: "Category",
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide(color: Colors.grey.shade300),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide(color: Colors.blue.shade400, width: 2),
      ),
      contentPadding:
          const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
    );
  }

  // --------------------------
  // MARK: FORM VALIDATION & SUBMIT
  // --------------------------

  FormFieldValidator<String> _required(String message) {
    return (v) => (v == null || v.trim().isEmpty) ? message : null;
  }

  VoidCallback _submit(BookController controller) {
    return () {
      if (!_formKey.currentState!.validate()) return;

      _formKey.currentState!.save();

      final finalImage =
          (imageUrl == null || imageUrl!.isEmpty)
              ? "assets/images/book-blue.jpg"
              : imageUrl!;

      controller.addBook(
        Book(
          id: '',
          title: title,
          author: author,
          description: description,
          categoryId: selectedCategoryId!,
          rating: rating,
          image: finalImage,
          isAvailable: isAvailable,
        ),
      );

      Navigator.pop(context);
    };
  }
}
