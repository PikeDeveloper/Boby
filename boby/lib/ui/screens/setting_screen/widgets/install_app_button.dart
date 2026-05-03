import 'dart:html' as html;
import 'package:flutter/material.dart';

class InstallAppButton extends StatefulWidget {
  const InstallAppButton({super.key});

  @override
  State<InstallAppButton> createState() => _InstallAppButtonState();
}

class _InstallAppButtonState extends State<InstallAppButton> {
  bool _canInstall = false;
  bool _isInstalled = false;
  dynamic _deferredPrompt;

  @override
  void initState() {
    super.initState();
    _checkInstallStatus();
    _listenForInstallPrompt();
  }

  void _checkInstallStatus() {
    // Verificar si la app ya está instalada
    if (html.window.matchMedia('(display-mode: standalone)').matches) {
      setState(() {
        _isInstalled = true;
      });
    }
  }

  void _listenForInstallPrompt() {
    // Escuchar el evento beforeinstallprompt
    html.window.addEventListener('beforeinstallprompt', (event) {
      event.preventDefault();
      setState(() {
        _canInstall = true;
        _deferredPrompt = event;
      });
    });

    // Escuchar cuando la app es instalada
    html.window.addEventListener('appinstalled', (event) {
      setState(() {
        _canInstall = false;
        _isInstalled = true;
        _deferredPrompt = null;
      });
    });
  }

  Future<void> _installApp() async {
    if (_deferredPrompt != null) {
      // Mostrar el prompt de instalación
      _deferredPrompt.prompt();

      // Esperar la respuesta del usuario
      final result = await _deferredPrompt.userChoice;

      if (result['outcome'] == 'accepted') {
        setState(() {
          _canInstall = false;
          _isInstalled = true;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('App installed successfully!'),
            backgroundColor: Colors.green,
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Installation cancelled'),
            backgroundColor: Colors.orange,
          ),
        );
      }

      _deferredPrompt = null;
    }
  }

  void _manualInstall() {
    // Show manual installation instructions
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Icon(Icons.download, color: Colors.blue),
            const SizedBox(width: 10),
            const Text('Install App'),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'To install Boby on your device:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 15),
            _buildInstructionStep(
                '1', 'Chrome: Tap the menu (⋮) in the corner'),
            _buildInstructionStep('2', 'Select "Add to Home Screen"'),
            _buildInstructionStep('3', 'Tap "Add" or "Install"'),
            const SizedBox(height: 15),
            const Text(
              'You can also use the address bar:',
              style: TextStyle(fontSize: 12, color: Colors.grey),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  Widget _buildInstructionStep(String number, String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 24,
            height: 24,
            decoration: BoxDecoration(
              color: Colors.blue,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Center(
              child: Text(
                number,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(fontSize: 14),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Si ya está instalada, mostrar mensaje
    if (_isInstalled) {
      return Container(
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: Colors.green.withOpacity(0.1),
          borderRadius: BorderRadius.circular(15),
          border: Border.all(color: Colors.green.withOpacity(0.3)),
        ),
        child: Row(
          children: [
            Icon(Icons.check_circle, color: Colors.green, size: 30),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                'App installed on your device',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.green,
                ),
              ),
            ),
          ],
        ),
      );
    }

    // Botón de instalación - siempre activo
    return ElevatedButton.icon(
      onPressed: _canInstall ? _installApp : _manualInstall,
      icon: const Icon(Icons.download_rounded, size: 28),
      label: const Text(
        'Install App',
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 25),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        elevation: 5,
        shadowColor: Colors.blue.withOpacity(0.5),
      ),
    );
  }
}
