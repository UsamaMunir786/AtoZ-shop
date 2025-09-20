import 'package:a_to_z/providers/talescope_provider.dart';
import 'package:a_to_z/utils/constant.dart';
import 'package:a_to_z/utils/widget_function.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:provider/provider.dart';

class DescriptionPage extends StatefulWidget {
  static const String routeName = 'description';
  final String id;
  const DescriptionPage({super.key, required this.id});

  @override
  State<DescriptionPage> createState() => _DescriptionPageState();
}

class _DescriptionPageState extends State<DescriptionPage> {


  final controller = TextEditingController();
  String? description;

  @override
  void didChangeDependencies() {
    description = Provider.of<TalescopeProvider>(context, listen: false).findTelescopeById(widget.id).description;
    if(description != null){
      controller.text = description!;
    }
    super.didChangeDependencies();
  }

  // @override
  // void initState() {
  //   controller.text = telescopeDescription;
  //   super.initState();
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Description'),

        actions: [
          IconButton(
            onPressed: (){
              saveDescription();
            }, 
            icon: Icon(Icons.save)
            )
        ],
      ),

      body: Container(
        padding: EdgeInsets.all(8),
        color: Colors.grey,
        child: TextField(
          controller: controller,
          maxLines: 500,
          autofocus: true,
          decoration: InputDecoration(
            border: OutlineInputBorder()
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
  
  void saveDescription() {
    if(controller.text.isEmpty){
      showMsg(context, 'field is empty');
      return;
    }
    EasyLoading.show(status: 'please wait');
    Provider.of<TalescopeProvider>(context, listen: false).
    updateTelescopeField(widget.id, 'description', controller.text).
    then((value){
      showMsg(context, 'updated description');
      EasyLoading.dismiss();
    }).
    catchError(
        (error){
          EasyLoading.dismiss();
        }  
    );

  }
}