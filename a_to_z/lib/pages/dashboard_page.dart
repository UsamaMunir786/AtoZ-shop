import 'package:a_to_z/auth/auth_services.dart';
import 'package:a_to_z/customeWidget/dashboard_item.dart';
import 'package:a_to_z/models/dashboard_model.dart';
import 'package:a_to_z/pages/login_page.dart';
import 'package:a_to_z/providers/talescope_provider.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class DashboardPage extends StatefulWidget {
  static const String routeName = '/';
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {

@override
  void didChangeDependencies() {
    
    super.didChangeDependencies();
    Provider.of<TalescopeProvider>(context, listen: false).getAllBrand();
    Provider.of<TalescopeProvider>(context, listen: false).getAllTelescope();
  }
  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Dashboard'),
        actions: [
          
          GestureDetector(
            onTap: () {
              AuthServices.logOut().then((value) => context.goNamed(LoginPage.routeName));
            },
            child: Icon(Icons.logout))
        ],
      ),
      body: GridView.builder(
        itemCount: dashboardList.length,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2
          ), 
        itemBuilder: (context, index){
          final route = dashboardList[index];

          return DashboardItem(model: route, onPress: (value){
            context.goNamed(value);
          });
        }
        ),
    );
  }
}