import 'dart:js_interop';

import 'package:a_to_z/models/brand_model.dart';
import 'package:a_to_z/models/telescope.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DbHelper {
  static final FirebaseFirestore _db = FirebaseFirestore.instance;
  static const String collestionAdmin = 'admin';
  static const String collestionBrand = 'brand';
  static const String collestionTelescope = 'telescope';

  static Future<bool> isAdmin(String uid) async{
    final snapshot = await _db.collection(collestionAdmin).doc(uid).get();
    return snapshot.exists;
  }

  // add method
  static  Future<void> addBrand(BrandModel brand){
    final doc = _db.collection(collestionBrand).doc();
    brand.id = doc.id;
    return doc.set(brand.toJson());
  } 

  //get method
  static Stream<QuerySnapshot<Map<String, dynamic>>> getAllBrand() =>
    _db.collection(collestionBrand).snapshots();

  static Stream<QuerySnapshot<Map<String, dynamic>>> getAllTelescope() =>
    _db.collection(collestionTelescope).snapshots();

  static Future<void> addTelescope(Telescope telescope) async {
    final doc = _db.collection(collestionTelescope).doc();
    telescope.id = doc.id;
    return doc.set(telescope.toJson());
  }

  static Future<void> updateTelescopeField(String id, Map<String, dynamic> map) async {
    return _db.collection(collestionTelescope).doc(id)
            .update(map);
  }
    // return getAllBrand();
  }
