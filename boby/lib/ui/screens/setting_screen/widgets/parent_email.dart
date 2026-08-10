import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:boby/services/storage_service.dart';
import 'package:boby/services/firebase_service.dart';
import 'package:boby/models/parent_info.dart';

class ParentEmail extends StatefulWidget {
  const ParentEmail({super.key});

  @override
  State<ParentEmail> createState() => _ParentEmailState();
}

class _ParentEmailState extends State<ParentEmail> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  bool _isSaving = false;
  bool _hasSavedData = false;

  @override
  void initState() {
    super.initState();
    _loadSavedData();
  }

  void _loadSavedData() {
    final savedEmail = StorageService.instance.getParentEmail();
    final savedName = StorageService.instance.getChildName();
    
    if (savedEmail != null && savedEmail.isNotEmpty) {
      _emailController.text = savedEmail;
    }
    if (savedName != null && savedName.isNotEmpty) {
      _nameController.text = savedName;
    }
    
    // Mark as saved if either name or email exists
    _hasSavedData = (savedEmail != null && savedEmail.isNotEmpty) || 
                     (savedName != null && savedName.isNotEmpty);
  }

  Future<void> _saveData() async {
    final name = _nameController.text.trim();
    final email = _emailController.text.trim();
    
    if (name.isEmpty) {
      _showErrorSnackBar('Please enter your name');
      return;
    }
    
    if (email.isEmpty) {
      _showErrorSnackBar('Please enter an email address');
      return;
    }
    
    if (!GetUtils.isEmail(email)) {
      _showErrorSnackBar('Please enter a valid email address');
      return;
    }
    
    setState(() {
      _isSaving = true;
    });
    
    try {
      // Save data locally
      await StorageService.instance.saveParentEmail(email);
      await StorageService.instance.saveChildName(name);
      
      // Verify the save worked
      final savedEmail = StorageService.instance.getParentEmail();
      final savedName = StorageService.instance.getChildName();
      
      if (savedEmail == email && savedName == name) {
        setState(() {
          _hasSavedData = true;
        });
        
        // Save parent info to Firestore
        try {
          final parentInfo = ParentInfo(
            email: email,
            name: name,
            emailEnabled: true,
          );
          await FirebaseService().saveParentInfo(parentInfo);
        } catch (e) {
          print('Error saving parent info to Firestore: $e');
        }
        
        // Send welcome email
        try {
          await FirebaseService().sendWelcomeEmail(email, name);
          _showSuccessSnackBar('Data saved! Welcome email sent to your parent.');
        } catch (e) {
          print('Error sending welcome email: $e');
          _showErrorSnackBar('Error sending welcome email: $e');
        }
      } else {
        _showErrorSnackBar('Error saving data locally');
      }
    } catch (e) {
      print('Error saving data: $e');
      _showErrorSnackBar('Error saving data: $e');
    } finally {
      setState(() {
        _isSaving = false;
      });
    }
  }

  void _showSuccessSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.green,
        duration: const Duration(seconds: 3),
      ),
    );
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Name Label
        const Padding(
          padding: EdgeInsets.only(left: 8.0, bottom: 8.0),
          child: Text(
            'Enter your name',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: Colors.black87,
            ),
          ),
        ),
        
        // Name Input Field
        Container(
          decoration: BoxDecoration(
            color: Colors.grey.shade50,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey.shade300),
          ),
          child: TextField(
            controller: _nameController,
            decoration: InputDecoration(
              hintText: 'Your name',
              prefixIcon: Icon(Icons.person, color: Colors.blue.shade600),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 14,
              ),
            ),
          ),
        ),
        
        const SizedBox(height: 16),
        
        // Email Label
        const Padding(
          padding: EdgeInsets.only(left: 8.0, bottom: 8.0),
          child: Text(
            'Enter your parent\'s email',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: Colors.black87,
            ),
          ),
        ),
        
        // Email Input Field
        Container(
          decoration: BoxDecoration(
            color: Colors.grey.shade50,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey.shade300),
          ),
          child: TextField(
            controller: _emailController,
            keyboardType: TextInputType.emailAddress,
            decoration: InputDecoration(
              hintText: 'parent@example.com',
              prefixIcon: Icon(Icons.email, color: Colors.blue.shade600),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 14,
              ),
            ),
          ),
        ),
        
        const SizedBox(height: 12),
        
        // Save/Update Button
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: _isSaving ? null : _saveData,
            style: ElevatedButton.styleFrom(
              backgroundColor: _hasSavedData ? Colors.orange.shade600 : Colors.blue.shade600,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 2,
            ),
            child: _isSaving
                ? const SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(
                      color: Colors.white,
                      strokeWidth: 2,
                    ),
                  )
                : Text(
                    _hasSavedData ? 'Update' : 'Save',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
          ),
        ),
      ],
    );
  }
}