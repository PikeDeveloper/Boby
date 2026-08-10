import 'dart:io';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/child_stats.dart';
import '../models/parent_info.dart';

class FirebaseService {
  static final FirebaseService _instance = FirebaseService._internal();
  factory FirebaseService() => _instance;
  FirebaseService._internal();

  FirebaseFirestore get firestore => FirebaseFirestore.instance;
  FirebaseAuth get auth => FirebaseAuth.instance;

  Future<void> initialize() async {
    try {
      // Para macOS, intentamos inicializar con el project ID directamente
      if (Platform.isMacOS) {
        await Firebase.initializeApp(
          options: const FirebaseOptions(
            apiKey: 'AIzaSyBs_xKAKdBWmT6Tn0lDFT5AbW4oXKWCgvM',
            appId: '1:673016140281:ios:407d2061369a086d126d28',
            messagingSenderId: '673016140281',
            projectId: 'boby-ingles',
            storageBucket: 'boby-ingles.firebasestorage.app',
          ),
        );
      } else {
        await Firebase.initializeApp();
      }
    } catch (e) {
      print('Firebase initialization error: $e');
      rethrow;
    }
  }

  // Referencias a colecciones
  CollectionReference get childrenCollection => firestore.collection('children');
  CollectionReference get parentsCollection => firestore.collection('parents');
  CollectionReference get statsCollection => firestore.collection('stats');

  // Guardar información de padres
  Future<void> saveParentInfo(ParentInfo parentInfo) async {
    try {
      await parentsCollection.doc(parentInfo.email).set(parentInfo.toMap());
    } catch (e) {
      print('Error saving parent info: $e');
      rethrow;
    }
  }

  // Guardar información de niño
  Future<void> saveChildInfo(String parentId, Map<String, dynamic> childData) async {
    try {
      await childrenCollection.add({
        'parentId': parentId,
        ...childData,
        'createdAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      print('Error saving child info: $e');
      rethrow;
    }
  }

  // Guardar estadísticas diarias
  Future<void> saveDailyStats(ChildStats stats) async {
    try {
      final today = DateTime.now();
      final dateKey = '${today.year}-${today.month}-${today.day}';
      
      await statsCollection
          .doc(stats.childId)
          .collection('daily_stats')
          .doc(dateKey)
          .set(stats.toMap());
    } catch (e) {
      print('Error saving daily stats: $e');
      rethrow;
    }
  }

  // Obtener estadísticas de un niño
  Future<ChildStats?> getChildStats(String childId) async {
    try {
      final today = DateTime.now();
      final dateKey = '${today.year}-${today.month}-${today.day}';
      
      final doc = await statsCollection
          .doc(childId)
          .collection('daily_stats')
          .doc(dateKey)
          .get();
      
      if (doc.exists) {
        return ChildStats.fromMap(doc.data() as Map<String, dynamic>);
      }
      return null;
    } catch (e) {
      print('Error getting child stats: $e');
      return null;
    }
  }

  // Actualizar estadísticas en tiempo real
  Future<void> updateStats(String childId, {
    int? wordsLearned,
    int? levelsCompleted,
    String? currentLevel,
    int? score,
  }) async {
    try {
      final today = DateTime.now();
      final dateKey = '${today.year}-${today.month}-${today.day}';
      
      final docRef = statsCollection
          .doc(childId)
          .collection('daily_stats')
          .doc(dateKey);
      
      await firestore.runTransaction((transaction) async {
        final doc = await transaction.get(docRef);
        
        Map<String, dynamic> data = {};
        if (doc.exists) {
          data = doc.data() as Map<String, dynamic>;
        } else {
          data = {
            'childId': childId,
            'date': FieldValue.serverTimestamp(),
            'wordsLearned': 0,
            'levelsCompleted': 0,
            'currentLevel': 'Bronze',
            'score': 0,
          };
        }
        
        if (wordsLearned != null) {
          data['wordsLearned'] = (data['wordsLearned'] ?? 0) + wordsLearned;
        }
        if (levelsCompleted != null) {
          data['levelsCompleted'] = (data['levelsCompleted'] ?? 0) + levelsCompleted;
        }
        if (currentLevel != null) {
          data['currentLevel'] = currentLevel;
        }
        if (score != null) {
          data['score'] = (data['score'] ?? 0) + score;
        }
        
        transaction.set(docRef, data);
      });
    } catch (e) {
      print('Error updating stats: $e');
      rethrow;
    }
  }
  
  // Enviar correo de bienvenida al padre
  Future<void> sendWelcomeEmail(String parentEmail, String childName) async {
    try {
      print('Attempting to queue welcome email for $parentEmail');
      
      // Guardar en una colección de correos pendientes para que la Cloud Function los procese
      final docRef = await firestore.collection('pending_emails').add({
        'to': parentEmail,
        'type': 'welcome',
        'childName': childName,
        'createdAt': FieldValue.serverTimestamp(),
        'status': 'pending',
      });
      
      print('Welcome email queued successfully with ID: ${docRef.id}');
      print('Document created in pending_emails collection');
    } catch (e) {
      print('Error queuing welcome email: $e');
      print('Error details: ${e.toString()}');
      rethrow;
    }
  }
}