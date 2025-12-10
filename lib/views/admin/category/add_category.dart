import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../controllers/category_controller.dart';
import '../../../models/category.dart';

class AddCategoryScreen extends StatefulWidget {
  static const String routeName = "/add_category";
  const AddCategoryScreen({super.key});

  @override
  State<AddCategoryScreen> createState() => _AddCategoryScreenState();
}

class _AddCategoryScreenState extends State<AddCategoryScreen> {
  final _formKey = GlobalKey<FormState>();

  String name = '';
  String description = '';

  @override
  Widget build(BuildContext context) {
    final categoryController =
        Provider.of<CategoryController>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Add New Category"),
        backgroundColor: Colors.orange.shade600,
        elevation: 2,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Add a New Category",
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.orange.shade700,
                  ),
                ),
                const SizedBox(height: 24),

                // Name
                _buildTextField(
                  label: 'Category Name',
                  onSaved: (v) => name = v!.trim(),
                  validator: (v) =>
                      v!.isEmpty ? 'Please enter the category name' : null,
                ),
                const SizedBox(height: 16),

                // Description
                _buildTextField(
                  label: 'Description',
                  onSaved: (v) => description = v!.trim(),
                  validator: (v) =>
                      v!.isEmpty ? 'Please enter a description' : null,
                  maxLines: 4,
                ),
                const SizedBox(height: 32),

                // Add Category Button
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange.shade600,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      elevation: 3,
                    ),
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        _formKey.currentState!.save();

                        // Create new Category object
                        final newCategory = Category(
                          id: '',
                          name: name,
                          description: description,
                        );

                        // Add to controller
                        categoryController.addCategory(newCategory);

                        Navigator.pop(context);
                      }
                    },
                    child: const Text(
                      'Add Category',
                      style: TextStyle(fontSize: 18),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required String label,
    required FormFieldSetter<String> onSaved,
    required FormFieldValidator<String> validator,
    int maxLines = 1,
    TextInputType inputType = TextInputType.text,
  }) {
    return TextFormField(
      onSaved: onSaved,
      validator: validator,
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
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: Colors.orange.shade400, width: 2),
        ),
      ),
    );
  }
}
