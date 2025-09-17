import 'package:flutter/material.dart';

showSingleTextInputDialog({
  required BuildContext context,
  required String title,
  String posButton = 'OK',
  String negButton = 'CLOSE',
  required Function(String) onSubmit,
}){
  final controller = TextEditingController();
  showDialog(context: context, builder: (context) => AlertDialog(
    title: Text(title),
    content: Padding(padding: EdgeInsets.all(12),
    
    child: TextField(
      controller: controller,
      autofocus: true,
      decoration: InputDecoration(
        labelText: title,
      ),
    ),
    ),
    actions: [
      TextButton(onPressed: () => Navigator.pop(context), child: Text(negButton)),
      TextButton(onPressed: (){
        if(controller.text.isEmpty)return;
        onSubmit(controller.text);
        Navigator.pop(context);
      }, child: Text(posButton)),
    ],
  ));
}

void showMsg(BuildContext context, String msg)=>
ScaffoldMessenger
.of(context)
.showSnackBar(SnackBar(content: Text(msg)));