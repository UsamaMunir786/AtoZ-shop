import 'dart:convert';
import 'dart:io' ;
import 'dart:io' as html;
import 'dart:typed_data';

import 'package:a_to_z/db/db_helper.dart';
import 'package:a_to_z/models/brand_model.dart';
import 'package:a_to_z/models/image_model.dart';
import 'package:a_to_z/models/telescope.dart';
import 'package:a_to_z/utils/cloudnery.dart';
import 'package:a_to_z/utils/constant.dart';
import 'package:a_to_z/utils/helper_function.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class TalescopeProvider with ChangeNotifier{

  List<BrandModel> brandList = [];
  List<Telescope> telescopeList = [];

  Future<void> addBrand(String name){
    final brand = BrandModel(name: name);
    return DbHelper.addBrand(brand);
  }

  getAllBrand(){
    DbHelper.getAllBrand().listen((snapshot){
      brandList = List.generate(snapshot.docs.length, (index) => BrandModel.fromJson(snapshot.docs[index].data()));
      notifyListeners();
    });
  }

  getAllTelescope(){
    DbHelper.getAllTelescope().listen((snapshot){
      telescopeList = List.generate(snapshot.docs.length, (index) => Telescope.fromJson(snapshot.docs[index].data()));
      notifyListeners();
    });
  }

  Telescope findTelescopeById(String id) =>
        telescopeList.firstWhere((element) => element.id == id);
  

  // add Telescope
  Future<void> addTelescope(Telescope telescope){
    return DbHelper.addTelescope(telescope);
  }
 
 //update Telescope
 Future<void> updateTelescopeField(String id, String field, dynamic value){
    return DbHelper.updateTelescopeField(id, {field: value});
 }

// for image uploading
 Future<String> uploadItemImage(Uint8List image) async {
  final url = Uri.parse("https://api.cloudinary.com/v1_1/dcuxllwmz/image/upload");
  final request = http.MultipartRequest('POST', url);
  request.fields['upload_preset'] = 'food-fyp';

  request.files.add(
    http.MultipartFile.fromBytes('file', image, filename: 'image.png'),
  );

  final response = await request.send();
  final responseString = await response.stream.bytesToString();

  if (response.statusCode == 200) {
    final jsonMap = json.decode(responseString);
    return jsonMap['secure_url'];  // <--- return URL instead of void
  } else {
    throw Exception("Cloudinary upload failed: $responseString");
  }
}

//delete image

Future<void> deleteItemImage({
  required String telescopeId,
  required ImageModel image,
  required List<ImageModel> currentImages,
}) async {
  try {

  await Future.delayed(Duration(seconds: 1));

    // remove from local list
    currentImages.removeWhere((img) => img.imageName == image.imageName);

    // update Firestore
    await updateTelescopeField(
      telescopeId,
      'additionalImage',
      toImageMapList(currentImages),
    );
  } catch (e) {
    throw Exception("Firestore delete failed: $e");
  }
}


// Future<void> deleteItemImage({
//   required ImageModel image,
//   required String telescopeId,
//   required List<ImageModel> currentImages,
// }) async {
//   try {
//     // 🔹 1. Delete from Cloudinary
//     final url = Uri.parse("https://api.cloudinary.com/v1_1/dcuxllwmz/image/destroy");

//     final request = http.MultipartRequest('POST', url);
//     request.fields['public_id'] = image.imageName;
//     request.fields['upload_preset'] = 'food-fyp'; // if needed

//     final response = await request.send();
//     final responseString = await response.stream.bytesToString();

//     if (response.statusCode == 200) {
//       // 🔹 2. Remove from Firestore
//       currentImages.removeWhere((img) => img.imageName == img.imageName);

//       await updateTelescopeField(
//         telescopeId,
//         'additionalImage',
//         toImageMapList(currentImages),
//       );
//     } else {
//       throw Exception("Cloudinary delete failed: $responseString");
//     }
//   } catch (e) {
//     throw Exception("Delete failed: $e");
//   }
// }




  // Future<ImageModel> uploadImage(String imageLocalPath) async{
  //   final String imageName = 'image${DateTime.now().microsecondsSinceEpoch}';

  //   final photoRef = FirebaseStorage.instance.ref().child('$telescopeImageDirectory$imageName');

  //   final uploadTask = photoRef.putFile(File(imageLocalPath));
  //   final snapshot = await uploadTask.whenComplete(() => null);
  //   final url = await snapshot.ref.getDownloadURL();
  //   return ImageModel(
  //     imageName: imageName, 
  //     directoryName: telescopeImageDirectory, 
  //     downloadUrl: url
  //     );
  // }

  // final _imageService = ImageProviderService();

  // ImageModel? uploadedImage;

// for web

// Future<ImageModel> pickAndUpload(html.File file) async {
//   final image = await _imageService.uploadImage(file);
//   uploadedImage = image;
//   notifyListeners();
//   return image;
// }

   
}