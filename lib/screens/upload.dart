import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:interviya/data/models/interview_model.dart';
import 'package:interviya/data/models/category_model.dart';

class Upload extends StatefulWidget {
  const Upload({super.key});

  @override
  State<Upload> createState() => _UploadState();
}

class _UploadState extends State<Upload> {
  final _formKey = GlobalKey<FormState>();
  final InterviewModel _newInterview = InterviewModel();

  List<CategoryModel> _firestoreCategories = [];
bool _isLoadingCategories = true;
  
  bool _isUploading = false;
  bool _isCreatingNewCategory = false;

  final TextEditingController _newCatNameController = TextEditingController();
  Color _selectedNewCatColor = const Color(0xFF0A898D);

  final List<IconData> _availableIcons = [
    Icons.laptop_mac, Icons.bar_chart_rounded, Icons.people,
    Icons.chat, Icons.code, Icons.psychology, Icons.leaderboard, Icons.security,
  ];

  final List<Color> _categoryColors = [
    const Color(0xFF0A898D), Colors.blueAccent, Colors.orangeAccent,
    Colors.purpleAccent, Colors.pinkAccent, Colors.redAccent, Colors.greenAccent,
  ];



  Future<void> _submitData() async {
    if (!_formKey.currentState!.validate()) return;
    _formKey.currentState!.save();

    setState(() => _isUploading = true);

    try {
      final firestore = FirebaseFirestore.instance;

      if (_isCreatingNewCategory) {
        String newId = _newCatNameController.text.toLowerCase().replaceAll(' ', '_');
        
        CategoryModel newCat = CategoryModel(
          id: newId,
          name: _newCatNameController.text.trim(),
          icon: _newInterview.icon,
          color: _selectedNewCatColor,
        );

        await firestore.collection('categories').doc(newId).set(newCat.toMap());
        _newInterview.categoryId = newId;

        await _loadCategories();
      }

      await firestore.collection('interviews').add(_newInterview.toMap());

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Interview and Category saved!"), backgroundColor: Color(0xFF0A898D)),
        );
        _newCatNameController.clear();
      _formKey.currentState?.reset();
        _resetForm(); 

    Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Error: $e"), backgroundColor: Colors.red),
        );
      }
    } finally {
      if (mounted) setState(() => _isUploading = false);
    }
  }
  void _resetForm() {
  setState(() {
    _formKey.currentState?.reset();
    _newCatNameController.clear();
    _isCreatingNewCategory = false;
    // _newInterview = InterviewModel(); 
  });
}

@override
void initState() {
  super.initState();
  _loadCategories();
}

Future<void> _loadCategories() async {
  try {
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser != null) {
      await currentUser.getIdToken(true); // Force refresh token
    }

    final snapshot = await FirebaseFirestore.instance
        .collection('categories')
        .get()
        .timeout(const Duration(seconds: 5));
        
    final docs = snapshot.docs.map((doc) => CategoryModel.fromMap(doc.data())).toList();
    
    setState(() {
      _firestoreCategories = docs;
      _isLoadingCategories = false;
    });
  } catch (e) {
    setState(() => _isLoadingCategories = false);
    debugPrint("Firestore Error encountered: $e");
    
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Connection timeout or permissions denied: $e"), 
          backgroundColor: Colors.red
        ),
      );
    }
  }
}

  @override
  Widget build(BuildContext context) {
    Color activeColor = _selectedNewCatColor;
    if (!_isCreatingNewCategory) {
    try {
      activeColor = _firestoreCategories
          .firstWhere((cat) => cat.id == _newInterview.categoryId)
          .color;
    } catch (_) {
      activeColor = const Color(0xFF0A898D);
    }
  }
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFF),
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(60),
        child: AppBar(
          backgroundColor: Color(0xFF0A898D),
          elevation: 0,
          leading: Padding(
            padding: EdgeInsets.only(top:5),
            child: IconButton(
              icon: Icon(Icons.arrow_back, color: Colors.white, size: 35),
              onPressed: ()=>Navigator.pop(context),
            ),
          ),
          title: Padding(
            padding: EdgeInsets.only(top: 5),
            child: Text(
              "Upload",
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(bottom: Radius.circular(25)),
          ),
        ),
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSectionHeader("Basic Information"),
                  const SizedBox(height: 15),
                  _buildTextField(
                    label: "Interview Title",
                    hint: "e.g. Senior Flutter Developer",
                    onSaved: (val) => _newInterview.title = val ?? '',
                  ),
                  const SizedBox(height: 20),
                  _buildTextField(
                    label: "Description",
                    hint: "What is this interview about?",
                    maxLines: 2,
                    onSaved: (val) => _newInterview.description = val ?? '',
                  ),
                  
                  const SizedBox(height: 30),
                  _buildCategorySelectionHeader(),
                  const SizedBox(height: 15),
                  
                  if (_isCreatingNewCategory) 
                    _buildNewCategoryForm() 
                  else 
                    _buildCategoryPicker(activeColor),

                  const SizedBox(height: 30),
                  _buildSectionHeader("Select Display Icon"),
                  const SizedBox(height: 15),
                  _buildIconPicker(activeColor),
                  
                  const SizedBox(height: 40),
                  _buildSubmitButton(activeColor),
                ],
              ),
            ),
          ),
          if (_isUploading)
            Container(color: Colors.black26, child: const Center(child: CircularProgressIndicator(color: Color(0xFF0A898D)))),
        ],
      ),
    );
  }

  Widget _buildCategorySelectionHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _buildSectionHeader(_isCreatingNewCategory ? "New Category Details" : "Select Category"),
        TextButton.icon(
          onPressed: () => setState(() => _isCreatingNewCategory = !_isCreatingNewCategory),
          icon: Icon(_isCreatingNewCategory ? Icons.list : Icons.add_circle_outline, size: 18, color: const Color(0xFF0A898D)),
          label: Text(_isCreatingNewCategory ? "Use Existing" : "Create New", style: const TextStyle(color: Color(0xFF0A898D))),
        )
      ],
    );
  }

  Widget _buildNewCategoryForm() {
    return Column(
      children: [
        _buildTextField(
          label: "Category Name",
          hint: "e.g. System Design",
          onSaved: (val) {},
          controller: _newCatNameController,
        ),
        const SizedBox(height: 15),
        const Text("Pick Category Color", style: TextStyle(color: Colors.grey, fontSize: 14)),
        const SizedBox(height: 10),
        SizedBox(
          height: 40,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: _categoryColors.length,
            separatorBuilder: (_, __) => const SizedBox(width: 10),
            itemBuilder: (context, index) {
              bool isSelected = _selectedNewCatColor == _categoryColors[index];
              return GestureDetector(
                onTap: () => setState(() => _selectedNewCatColor = _categoryColors[index]),
                child: CircleAvatar(
                  backgroundColor: _categoryColors[index],
                  radius: 18,
                  child: isSelected ? const Icon(Icons.check, color: Colors.white, size: 18) : null,
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildCategoryPicker(Color activeColor) {
  if (_isLoadingCategories) {
    return const Center(child: CircularProgressIndicator());
  }

  if (_firestoreCategories.isEmpty) {
    return const Padding(
      padding: EdgeInsets.symmetric(vertical: 10),
      child: Text("No categories found. Create one above!", 
        style: TextStyle(color: Colors.grey, fontStyle: FontStyle.italic)),
    );
  }

  return Wrap(
    spacing: 10,
    runSpacing: 10,
    children: _firestoreCategories.map((cat) {
      bool isSelected = _newInterview.categoryId == cat.id;
      return ChoiceChip(
        avatar: Icon(cat.icon, size: 18, color: isSelected ? Colors.white : cat.color),
        label: Text(cat.name),
        selected: isSelected,
        onSelected: (selected) => setState(() => _newInterview.categoryId = cat.id),
        selectedColor: cat.color,
        labelStyle: TextStyle(color: isSelected ? Colors.white : Colors.black87),
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      );
    }).toList(),
  );
}

  Widget _buildIconPicker(Color activeColor) {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(15)),
      child: Wrap(
        alignment: WrapAlignment.center,
        spacing: 15,
        runSpacing: 15,
        children: _availableIcons.map((icon) {
          bool isSelected = _newInterview.icon == icon;
          return GestureDetector(
            onTap: () => setState(() => _newInterview.icon = icon),
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: isSelected ? activeColor.withOpacity(0.1) : Colors.transparent,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: isSelected ? activeColor : Colors.grey.shade200, width: 2),
              ),
              child: Icon(icon, color: isSelected ? activeColor : Colors.grey, size: 28),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildTextField({required String label, required String hint, int maxLines = 1, required Function(String?) onSaved, TextEditingController? controller}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(color: Colors.grey, fontSize: 14)),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(15),
            boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 4))],
          ),
          child: TextFormField(
            controller: controller,
            maxLines: maxLines,
            decoration: InputDecoration(hintText: hint, border: InputBorder.none, contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15)),
            validator: (val) => val == null || val.isEmpty ? "Required field" : null,
            onSaved: onSaved,
          ),
        ),
      ],
    );
  }

  Widget _buildSectionHeader(String title) {
    return Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF1E293B)));
  }

  Widget _buildSubmitButton(Color activeColor) {
    return SizedBox(
      width: double.infinity,
      height: 55,
      child: ElevatedButton(
        onPressed: _submitData,
        style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF0A898D), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15))),
        child: const Text("Upload Interview", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
      ),
    );
  }
}