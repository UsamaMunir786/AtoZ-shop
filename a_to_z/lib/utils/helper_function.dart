import 'package:a_to_z/models/image_model.dart';

num priceAfterDiscount(num price, num discount){
  return price - (price * discount / 100);
}

List<Map<String, dynamic>> toImageMapList(List<ImageModel> imageModel) {
  return List.generate(imageModel.length, (index) => imageModel[index].toJson());
}