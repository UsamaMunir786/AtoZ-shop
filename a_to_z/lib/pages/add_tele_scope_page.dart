import 'dart:convert';
import 'dart:io';

import 'package:a_to_z/customeWidget/radio_group.dart';
import 'package:a_to_z/db/db_helper.dart';
import 'package:a_to_z/models/brand_model.dart';
import 'package:a_to_z/models/image_model.dart';
import 'package:a_to_z/models/telescope.dart';
import 'package:a_to_z/providers/talescope_provider.dart';
import 'package:a_to_z/utils/constant.dart';
import 'package:a_to_z/utils/widget_function.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class AddTeleScopePage extends StatefulWidget {
  static const String routeName = 'addtelescope';
  const AddTeleScopePage({super.key});

  @override
  State<AddTeleScopePage> createState() => _AddTeleScopePageState();
}

class _AddTeleScopePageState extends State<AddTeleScopePage> {
  final _formKey = GlobalKey<FormState>();
  final _modelController = TextEditingController();
  final _dimensionController = TextEditingController();
  final _lenesDiameterController = TextEditingController();
  final _weightController = TextEditingController();
  final _priceController = TextEditingController();
  final _stockController = TextEditingController();
 
  
  BrandModel? brand;
  String? imageLocalPath;
  DateTime? dateTime;
  String mountDescription = TelescopeUtils.mountList.first;
  String focusType = TelescopeUtils.focusList.first;
  String telescopeType = TelescopeUtils.typeList.first;

  Uint8List? imageUrl;

  String itemUrl = '';

  Future<void> pickImage() async {
    final pickedImage = await ImagePicker().pickImage(
      source: ImageSource.gallery,
    );

    if (kIsWeb) {
      imageUrl = await pickedImage!.readAsBytes();
    }
    setState(() {});
  }

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




  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add telescope'),
        actions: [
          IconButton(
            onPressed: (){
                _savaTelescope();
            }, 
            icon: Icon(Icons.done)
            )
        ],
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: EdgeInsets.all(15),
          children: [
            Card(
  child: Column(
    children: [
      Center(
        child: imageUrl == null
            ? Icon(Icons.photo, size: 105)
            : kIsWeb
                ? Image.memory(
                    imageUrl!,
                    height: 150,
                    width: 150,
                    fit: BoxFit.cover,
                  )
                : Image.file(
                    File(imageLocalPath!),
                    height: 150,
                    width: 150,
                    fit: BoxFit.cover,
                  ),
      ),
      Text('Select Telescope image\nfrom...'),
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          TextButton.icon(
            onPressed: () {},
            icon: Icon(Icons.camera),
            label: Text('Camera'),
          ),
         TextButton.icon(
      onPressed: () async {
        final picker = ImagePicker();
        final pickedFile = await picker.pickImage(source: ImageSource.gallery);
        if (pickedFile != null) {
          if (kIsWeb) {
            imageUrl = await pickedFile.readAsBytes();
            imageLocalPath = pickedFile.path;
          } else {
            imageLocalPath = pickedFile.path;
            imageUrl = await File(pickedFile.path).readAsBytes();
          }
          setState(() {});
        }
      },
      icon: Icon(Icons.browse_gallery),
      label: Text('Gallery'),
    ),
        ],
      )
    ],
  ),
),

        
          Card(
            child: Padding(
              padding: EdgeInsets.all(8),
            child: Consumer<TalescopeProvider>(
              builder: (context, provider, child){
              return  DropdownButtonFormField<BrandModel>(
                decoration: InputDecoration(
        
                ),
                hint: Text('select item'),
                isExpanded: true,
                value: brand,
                validator: (value) {
                  if(value == null){
                    return 'Please select a brand';
                  }
                  return null;
                },
                items: provider.brandList.map((item) => DropdownMenuItem<BrandModel>(
                  value: item,
                  child: Text(item.name))).toList(),
                onChanged: (value){
                  setState(() {
                    brand = value;
                  });
                },
              );
              }
              ),
            ),
          ),
        
           RadioGrouph(
            label: 'select talescope type', 
            items: TelescopeUtils.typeList, 
            groupValue: telescopeType, 
            onItemSelected: (value){
             setState(() {
                telescopeType = value;
             });
            }
            ),
           RadioGrouph(
            label: 'select FocusType type', 
            items: TelescopeUtils.focusList, 
            groupValue: focusType, 
            onItemSelected: (value){
              setState(() {
                focusType = value;
              });
            }
            ),
           RadioGrouph(
            label: 'select MountList type', 
            items: TelescopeUtils.mountList, 
            groupValue: mountDescription, 
            onItemSelected: (value){
              mountDescription = value;
            }
            ),
        
          Padding(
            padding: EdgeInsets.all(4),
            child: TextFormField(
              controller: _modelController,
              decoration: InputDecoration(
                border: InputBorder.none,
                filled: true,
                labelText: 'Model',
              ),
              validator: (value){
                if(value == null || value.isEmpty){
                    return 'this field not be empty';
                }
                return null;
              },
            ),
            ),
          Padding(
            padding: EdgeInsets.all(4),
            child: TextFormField(
              controller: _dimensionController,
              decoration: InputDecoration(
                border: InputBorder.none,
                filled: true,
                labelText: 'Dimension',
              ),
              validator: (value){
                if(value == null || value.isEmpty){
                    return 'this field not be empty';
                }
                return null;
              },
            ),
            ),
            Padding(
            padding: EdgeInsets.all(4),
            child: TextFormField(
              controller: _lenesDiameterController,
              decoration: InputDecoration(
                border: InputBorder.none,
                filled: true,
                labelText: 'LeneseDiameter',
              ),
              validator: (value){
                if(value == null || value.isEmpty){
                    return 'this field not be empty';
                }
                return null;
              },
            ),
            ),
          Padding(
            padding: EdgeInsets.all(4),
            child: TextFormField(
              controller: _weightController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                border: InputBorder.none,
                filled: true,
                labelText: 'Weight',
              ),
              validator: (value){
                if(value == null || value.isEmpty){
                    return 'this field not be empty';
                }
                return null;
              },
            ),
            ),
          Padding(
            padding: EdgeInsets.all(4),
            child: TextFormField(
              controller: _priceController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                border: InputBorder.none,
                filled: true,
                labelText: 'Price',
              ),
              validator: (value){
                if(value == null || value.isEmpty){
                    return 'this field not be empty';
                }
                return null;
              },
            ),
            ),
          Padding(
            padding: EdgeInsets.all(4),
            child: TextFormField(
              controller: _stockController,
              decoration: InputDecoration(
                border: InputBorder.none,
                filled: true,
                labelText: 'Stock',
              ),
              validator: (value){
                if(value == null || value.isEmpty){
                    return 'this field not be empty';
                }
                return null;
              },
            ),
            ),
         
          ]  
        ),
      )
    );
  }



  

  void dispose(){
    super.dispose();
    _modelController.dispose();
    _dimensionController.dispose();
    _lenesDiameterController.dispose();
    _weightController.dispose();
    _priceController.dispose();
    _stockController.dispose();
  }


  void _savaTelescope() async{
      if(imageLocalPath == null){
        showMsg(context, 'please select a telescope image');
        return;
      }

      if(_formKey.currentState!.validate()){
        EasyLoading.show(status: 'please wait');
        try{
             final uploadImageUrl = await uploadItemImage(imageUrl!);

             final telescope = Telescope(
              model: _modelController.text, 
              brand: brand!, 
              type: telescopeType, 
              dimension: _dimensionController.text, 
              weightInPound: num.parse(_weightController.text), 
              focustype: focusType, 
              lensDiameterInMM: num.parse(_lenesDiameterController.text), 
              mountDescription: mountDescription, 
              price: num.parse(_priceController.text), 
              stock: num.parse(_stockController.text), 
              thumbnail: ImageModel(
                imageName: 'image${DateTime.now().microsecondsSinceEpoch}', 
                directoryName: telescopeImageDirectory, 
                downloadUrl: uploadImageUrl, ),
              additionalImage: []
              );
              await DbHelper.addTelescope(telescope);

              // await Provider.of<TalescopeProvider>(context, listen: false)
              // .addTelescope(telescope);
              EasyLoading.dismiss();
              showMsg(context, 'saved');

              _resetField();
        }
        catch(e){
          EasyLoading.dismiss();
          print(e.toString());
        }
      }
  }
  
  void _resetField() {
    setState(() {
      _modelController.clear();
      _dimensionController.clear();
      _weightController.clear();
      _lenesDiameterController.clear();
      _stockController.clear();_priceController.clear();
      brand = null;
      imageLocalPath = null;
      imageUrl = null;
      mountDescription = TelescopeUtils.mountList.first;
      focusType = TelescopeUtils.focusList.first;
      telescopeType = TelescopeUtils.typeList.first;
    });
  }

//   Future<String?> pickImage() async {
//   final ImagePicker picker = ImagePicker();

//   // On web, this will open file chooser (no camera access yet)
//   final XFile? pickedFile = await picker.pickImage(source: ImageSource.gallery);

//   if (pickedFile != null) {
//     if (kIsWeb) {
//       // On web, you get bytes not a File
//       return pickedFile.path; // You can also use pickedFile.readAsBytes()
//     } else {
//       return File(pickedFile.path).path;
//     }
//   }
//   return null;
// }
}