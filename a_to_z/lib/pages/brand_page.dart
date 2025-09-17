import 'package:a_to_z/providers/talescope_provider.dart';
import 'package:a_to_z/utils/widget_function.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:provider/provider.dart';


class BrandPage extends StatefulWidget {
  static const String routeName = 'brand';
  const BrandPage({super.key});

  @override
  State<BrandPage> createState() => _BrandPageState();
}

class _BrandPageState extends State<BrandPage> {
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text('All Brands'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showSingleTextInputDialog(
            context: context, 
            title: 'Add Brand', 
            onSubmit: (value){
              EasyLoading.show(status: 'please wait');
              Provider.of<TalescopeProvider>(context, listen: false)
              .addBrand(value)
              .then((value){
              EasyLoading.dismiss();
              showMsg(context, 'brand added');
              });
            
            }
            );
        },
        child: Icon(Icons.add),
        ),
      body: Consumer<TalescopeProvider>(
        builder: (context, provider, child) =>
          provider.brandList.isEmpty 
        ?  Center(child: Text('No data Found!'),) 
        : ListView.builder(
          itemCount: provider.brandList.length,
            itemBuilder: (context, index){
             final brand = provider.brandList[index];

             return ListTile(
              title: Text(brand.name),
             );
          })
      
        ),
    );
  }
}