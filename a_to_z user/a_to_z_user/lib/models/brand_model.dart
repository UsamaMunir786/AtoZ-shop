import 'package:freezed_annotation/freezed_annotation.dart';

part 'brand_model.freezed.dart';
part 'brand_model.g.dart';

@unfreezed
class BrandModel with _$BrandModel{
  factory BrandModel({
    String? id,
    required String name,
  }) = _BrandModel;

  factory BrandModel.fromJson(Map<String, dynamic> json) =>
  _$BrandModelFromJson(json);
}