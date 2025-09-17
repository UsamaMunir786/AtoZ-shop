import 'package:a_to_z/customeWidget/image_holder_view.dart';
import 'package:a_to_z/models/image_model.dart';
import 'package:a_to_z/models/telescope.dart';
import 'package:a_to_z/providers/talescope_provider.dart';
import 'package:a_to_z/utils/constant.dart';
import 'package:a_to_z/utils/helper_function.dart';
import 'package:a_to_z/utils/widget_function.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class TelescopeDetailePage extends StatefulWidget {
  static const String routeName = 'telescopeDetaile';
  final String id;

  const TelescopeDetailePage({super.key, required this.id});

  @override
  State<TelescopeDetailePage> createState() => _TelescopeDetailePageState();
}

class _TelescopeDetailePageState extends State<TelescopeDetailePage> {
  late Telescope telescope;
  late TalescopeProvider prov;

  @override
  void didChangeDependencies() {
    prov = Provider.of<TalescopeProvider>(context);
    telescope = prov.findTelescopeById(widget.id);
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          telescope.model,
        ),
      ),
      body: ListView(
        children: [
          Center(
            child: CachedNetworkImage(
              width: double.infinity,
              height: 200,
              fit: BoxFit.contain,
              imageUrl: telescope.thumbnail.downloadUrl,
              placeholder: (context, url) => Center(
                child: CircularProgressIndicator(),
              ),
              errorWidget: (context, url, error) => Icon(Icons.error),
            ),
          ),
          SizedBox(
            width: MediaQuery.of(context).size.width,
            height: 100,
            child: Card(
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: [
                  FloatingActionButton.small(
                    onPressed: () {
                      getImage();
                    },
                    tooltip: 'add additional image!',
                    child: Icon(Icons.add),
                  ),
                  if (telescope.additionalImage.isEmpty)
                    Padding(
                      padding: EdgeInsets.only(left: 16),
                      child: Center(
                        child: Text(
                          'Add other images',
                          style: Theme.of(context)
                              .textTheme
                              .titleLarge
                              ?.copyWith(color: Colors.grey),
                        ),
                      ),
                    ),
                  ...telescope.additionalImage.map((e) => ImageHolderView(
                      imageModel: e,
                      onImagePressed: () {
                        _showImageOnDialog(e);
                      }))
                ],
              ),
            ),
          ),
          ElevatedButton(
              onPressed: () {},
              child: Text(telescope.description == null
                  ? 'Add Description'
                  : 'Show Description')),
          ListTile(
            title: Text(telescope.brand.name),
            subtitle: Text(telescope.model),
          ),
          ListTile(
            title: Text(
                'sales price (with discount): $currencySymbol${priceAfterDiscount(telescope.price, telescope.discount)}'),
            subtitle: Text('Original price: $currencySymbol${telescope.price}'),
            trailing: IconButton(
                onPressed: () {
                  showSingleTextInputDialog(
                      context: context,
                      title: 'Edit Price',
                      onSubmit: (value) {
                        EasyLoading.show(status: 'please wait');
                      });
                },
                icon: Icon(Icons.edit)),
          ),
          ListTile(
            title: Text('Discount: ${telescope.discount}%'),
            trailing: IconButton(
                onPressed: () {
                  showSingleTextInputDialog(
                      context: context,
                      title: 'Edit Discount',
                      onSubmit: (value) {
                        EasyLoading.show(status: 'please wait');
                      });
                },
                icon: Icon(Icons.edit)),
          ),
          ListTile(
            title: Text('Stock: ${telescope.stock}'),
            trailing: IconButton(
                onPressed: () {
                  showSingleTextInputDialog(
                      context: context,
                      title: 'Enter Stock',
                      onSubmit: (value) {
                        EasyLoading.show(status: 'please wait..');
                      });
                },
                icon: Icon(Icons.edit)),
          )
        ],
      ),
    );
  }

  void getImage() async {
    final pickedImage = await ImagePicker().pickImage(
      source: ImageSource.gallery,
    );

    if (pickedImage == null) return;

    EasyLoading.show(status: 'uploading..');

    try {
      //read as bytes
      Uint8List imageBytes = await pickedImage.readAsBytes();

      //provider function call for upload cloudinary
      final imageUrl = await prov.uploadItemImage(imageBytes);

      final newImage = ImageModel(
        imageName: DateTime.now().microsecondsSinceEpoch.toString(),
        directoryName: telescopeImageDirectory,
        downloadUrl: imageUrl,
      );

      //addTelescope Additional list
      telescope.additionalImage.add(newImage);
      prov.updateTelescopeField(telescope.id!, 'additionalImage',
          toImageMapList(telescope.additionalImage));

      EasyLoading.dismiss();
      setState(() {});

      showMsg(context, 'image upload successfully');
    } catch (e) {
      EasyLoading.dismiss();
      showMsg(context, 'upload fail: $e');
    }
  }

  void _showImageOnDialog(ImageModel e) {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              content: CachedNetworkImage(
                fit: BoxFit.cover,
                height: MediaQuery.of(context).size.height / 2,
                imageUrl: e.downloadUrl,
                placeholder: (context, url) => Center(
                  child: CircularProgressIndicator(),
                ),
                errorWidget: (context, url, error) => Icon(Icons.error),
              ),
              actions: [
                IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: Icon(Icons.close)),
                IconButton(
                    onPressed: () async {
                      Navigator.pop(context);
                      EasyLoading.show(
                        status: 'Deleating..',
                      );

                      try {
                        await prov.deleteItemImage(
                            // publicId: e.imageName,
                            telescopeId: telescope.id!,
                            currentImages: telescope.additionalImage,
                            image: e);
// await Future.delayed(Duration(seconds: 2));
                        EasyLoading.dismiss();
                        setState(() {});

                        showMsg(context, 'image deleted successfully');
                      } catch (e) {
                        EasyLoading.dismiss();
                        showMsg(context, 'faild to delete');
                      }
                    },
                    icon: Icon(Icons.delete)),
              ],
            ));
  }
}
