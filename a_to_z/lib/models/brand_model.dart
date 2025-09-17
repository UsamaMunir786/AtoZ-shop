// import 'package:a_to_z/pages/brand_page.dart';

const String brandFieldId = 'id';
const String brandFieldName = 'name';

class BrandModel {
  String? id;
  String name;

  BrandModel({
    this.id,
    required this.name
  });

  Map<String, dynamic> toJson(){
    return <String, dynamic>{
       brandFieldId: id,
       brandFieldName: name
    };
  }

factory BrandModel.fromJson(Map<String, dynamic> map) => BrandModel(
  id: map[brandFieldId],
  name: map[brandFieldName]
  );
}