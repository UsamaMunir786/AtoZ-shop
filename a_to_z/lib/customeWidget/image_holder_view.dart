import 'package:a_to_z/models/image_model.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class ImageHolderView extends StatelessWidget {
  final ImageModel imageModel;
  final VoidCallback onImagePressed;

  const ImageHolderView({super.key, required this.imageModel, required this.onImagePressed});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(8),
      width: 80,
      height: 80,
      decoration: BoxDecoration(
        border: Border.all(width: 1.5, color: Colors.grey),
      ),

      child: InkWell(
        onTap: onImagePressed,
        child:  CachedNetworkImage(
                        width: double.infinity,
                        height: 200,
                        fit: BoxFit.contain,
                        imageUrl: imageModel.downloadUrl,
                        placeholder: (context, url) => 
                        Center(child: CircularProgressIndicator(),),
                        errorWidget: (context, url, error) => Icon(Icons.error),
                        ),
      ),
    );
  }
}