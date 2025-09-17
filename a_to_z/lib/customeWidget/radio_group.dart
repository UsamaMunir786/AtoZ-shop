import 'package:flutter/material.dart';

// ignore: must_be_immutable
class RadioGrouph extends StatefulWidget {
  String groupValue;
  String label;
  List<String> items;
  Function(String) onItemSelected;

   RadioGrouph({
    super.key,
    required this.label,
    required this.items,
    required this.groupValue,
    required this.onItemSelected
    });

  @override
  State<RadioGrouph> createState() => _RadioGroupState();
}

class _RadioGroupState extends State<RadioGrouph> {
  late String groupValue;

  @override
  void initState() {
    groupValue= widget.groupValue;
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(padding: EdgeInsetsGeometry.all(8),
      child: Column(
        children: [
          Text(widget.label),

          for(int i =0; i<widget.items.length; i++)
          Row(
            children: [
              Radio(
                value: widget.items[i],
                groupValue: groupValue,
                onChanged: (value) {
                  setState(() {
                    groupValue = value!;
                  });
                  widget.onItemSelected(value!);
                },
                ),
                Text(widget.items[i])
            ],
          )
        ],
      ),
      ),
    );
  }
}