import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:boby/controllers/app_controller.dart';
import 'package:boby/services/firebase_service.dart';
import 'package:boby/models/parent_info.dart';

class ParentSetupScreen extends StatefulWidget {
  const ParentSetupScreen({super.key});

  @override
  State<ParentSetupScreen> createState() => _ParentSetupScreenState();
}

class _ParentSetupScreenState extends State<ParentSetupScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _childNameController = TextEditingController();
  final _childAgeController = TextEditingController();
  
  String _frequency = 'weekly';
  bool _isLoading = false;
  
  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _childNameController.dispose();
    _childAgeController.dispose();
    super.dispose();
  }

  Future<void> _saveSetup() async {
    if (!_formKey.currentState!.validate()) return;
    
    setState(() {
      _isLoading = true;
    });
    
    try {
      final appController = Get.find<AppController>();
      final firebaseService = FirebaseService();
      
      // Crear información del padre
      final parentInfo = ParentInfo(
        email: _emailController.text.trim(),
        name: _nameController.text.trim(),
        emailEnabled: true,
        frequency: _frequency,
      );
      
      // Guardar información del padre
      await firebaseService.saveParentInfo(parentInfo);
      
      // Crear información del niño
      final childData = {
        'name': _childNameController.text.trim(),
        'age': int.tryParse(_childAgeController.text) ?? 0,
      };
      
      // Guardar información del niño y obtener el ID
      final childDocRef = await firebaseService.childrenCollection.add({
        'parentId': parentInfo.email,
        ...childData,
        'createdAt': FieldValue.serverTimestamp(),
      });
      
      // Configurar el perfil en el controlador
      appController.setupChildProfile(
        childDocRef.id,
        _childNameController.text.trim(),
        _emailController.text.trim(),
      );
      
      // Mostrar mensaje de éxito
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('¡Configuración guardada exitosamente!'),
            backgroundColor: Colors.green,
          ),
        );
        Get.back();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error al guardar configuración: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Configuración para Padres'),
        backgroundColor: Colors.blue.shade600,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Header
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.blue.shade400, Colors.purple.shade400],
                  ),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  children: [
                    Icon(
                      Icons.family_restroom,
                      size: 60,
                      color: Colors.white,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Configura el perfil',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Recibe reportes del progreso de tu hijo',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.white.withValues(alpha: 0.9),
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
              
              const SizedBox(height: 32),
              
              // Parent Information Section
              _buildSectionTitle('Información del Padre'),
              const SizedBox(height: 16),
              
              TextFormField(
                controller: _nameController,
                decoration: _buildInputDecoration('Nombre completo', Icons.person),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Por favor ingresa tu nombre';
                  }
                  return null;
                },
              ),
              
              const SizedBox(height: 16),
              
              TextFormField(
                controller: _emailController,
                decoration: _buildInputDecoration('Correo electrónico', Icons.email),
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Por favor ingresa tu correo';
                  }
                  if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
                    return 'Por favor ingresa un correo válido';
                  }
                  return null;
                },
              ),
              
              const SizedBox(height: 24),
              
              // Child Information Section
              _buildSectionTitle('Información del Niño'),
              const SizedBox(height: 16),
              
              TextFormField(
                controller: _childNameController,
                decoration: _buildInputDecoration('Nombre del niño', Icons.child_care),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Por favor ingresa el nombre del niño';
                  }
                  return null;
                },
              ),
              
              const SizedBox(height: 16),
              
              TextFormField(
                controller: _childAgeController,
                decoration: _buildInputDecoration('Edad', Icons.cake),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Por favor ingresa la edad';
                  }
                  final age = int.tryParse(value);
                  if (age == null || age < 1 || age > 18) {
                    return 'Por favor ingresa una edad válida (1-18)';
                  }
                  return null;
                },
              ),
              
              const SizedBox(height: 24),
              
              // Email Frequency Section
              _buildSectionTitle('Frecuencia de Reportes'),
              const SizedBox(height: 16),
              
              _buildFrequencySelector(),
              
              const SizedBox(height: 32),
              
              // Save Button
              ElevatedButton(
                onPressed: _isLoading ? null : _saveSetup,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue.shade600,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: _isLoading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text(
                        'Guardar Configuración',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
              ),
              
              const SizedBox(height: 16),
              
              // Skip Button
              TextButton(
                onPressed: () {
                  Get.back();
                },
                child: Text(
                  'Saltar por ahora',
                  style: TextStyle(
                    color: Colors.grey.shade600,
                    fontSize: 16,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 8.0),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Colors.blue.shade700,
        ),
      ),
    );
  }

  InputDecoration _buildInputDecoration(String label, IconData icon) {
    return InputDecoration(
      labelText: label,
      prefixIcon: Icon(icon, color: Colors.blue.shade600),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.grey.shade300),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.grey.shade300),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.blue.shade600, width: 2),
      ),
      filled: true,
      fillColor: Colors.grey.shade50,
    );
  }

  Widget _buildFrequencySelector() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(12),
        color: Colors.grey.shade50,
      ),
      child: Column(
        children: [
          RadioListTile<String>(
            title: const Text('Diario'),
            subtitle: const Text('Recibe reportes todos los días'),
            value: 'daily',
            groupValue: _frequency,
            onChanged: (value) {
              if (value != null) {
                setState(() {
                  _frequency = value;
                });
              }
            },
            activeColor: Colors.blue.shade600,
          ),
          RadioListTile<String>(
            title: const Text('Semanal'),
            subtitle: const Text('Recibe reportes una vez por semana'),
            value: 'weekly',
            groupValue: _frequency,
            onChanged: (value) {
              if (value != null) {
                setState(() {
                  _frequency = value;
                });
              }
            },
            activeColor: Colors.blue.shade600,
          ),
          RadioListTile<String>(
            title: const Text('Mensual'),
            subtitle: const Text('Recibe reportes una vez al mes'),
            value: 'monthly',
            groupValue: _frequency,
            onChanged: (value) {
              if (value != null) {
                setState(() {
                  _frequency = value;
                });
              }
            },
            activeColor: Colors.blue.shade600,
          ),
        ],
      ),
    );
  }
}