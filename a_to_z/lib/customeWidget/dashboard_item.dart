import 'package:a_to_z/models/dashboard_model.dart';
import 'package:flutter/material.dart';

class DashboardItem extends StatelessWidget {
  final DashboardModel model;
  final Function(String) onPress;
  const DashboardItem({super.key, required this.model, required this.onPress});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        onPress(model.routeName);
      },
      child: Card(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(model.iconData, size: 25, color: Colors.black,),
              SizedBox(height: 10,),
              Text(model.title, style: Theme.of(context).textTheme.titleLarge,)
            ],
          ),
        ),
      ),
    );
  }
}