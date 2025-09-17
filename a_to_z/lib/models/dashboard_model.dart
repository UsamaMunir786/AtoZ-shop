import 'package:a_to_z/pages/add_tele_scope_page.dart';
import 'package:a_to_z/pages/brand_page.dart';
import 'package:a_to_z/pages/view_tele_scope_page.dart';
import 'package:flutter/material.dart';

class DashboardModel {
  final String title;
  final IconData iconData;
  final String routeName;

  const DashboardModel(
    {
    required this.title, 
    required  this.iconData, 
    required this.routeName
    }
    );
}

const List<DashboardModel> dashboardList = [
  DashboardModel(title: 'Add telescope', iconData: Icons.add, routeName: AddTeleScopePage.routeName),
  DashboardModel(title: 'View telescope', iconData: Icons.inventory, routeName: ViewTeleScopePage.routeName),
  DashboardModel(title: 'Brands', iconData: Icons.category, routeName: BrandPage.routeName),
];
