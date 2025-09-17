import 'package:a_to_z/auth/auth_services.dart';
import 'package:a_to_z/pages/add_tele_scope_page.dart';
import 'package:a_to_z/pages/brand_page.dart';
import 'package:a_to_z/pages/dashboard_page.dart';
import 'package:a_to_z/pages/login_page.dart';
import 'package:a_to_z/pages/telescope_detaile_page.dart';
import 'package:a_to_z/pages/view_tele_scope_page.dart';
import 'package:a_to_z/providers/talescope_provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:a_to_z/firebase_options.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
);
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (context) => TalescopeProvider(),)
    ],
    child: MyApp()));
}

class MyApp extends StatelessWidget {
     MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      builder: EasyLoading.init(),
      theme: ThemeData(
        
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),

      routerConfig: _router,
      
    );
    
    
  }

  final _router = GoRouter(
    initialLocation: DashboardPage.routeName,
    redirect: (context, state) {
      if(AuthServices.user == null){
        return LoginPage.routeName;
      }
      return null;
    },
      routes: [
        
        GoRoute(
          path: DashboardPage.routeName,
          name: DashboardPage.routeName,
          builder: (context, state) => DashboardPage(),
          routes: [
            GoRoute(
              path: AddTeleScopePage.routeName,
              name: AddTeleScopePage.routeName,
              builder: (context, state) => AddTeleScopePage(),
              ),
            GoRoute(
              path: ViewTeleScopePage.routeName,
              name: ViewTeleScopePage.routeName,
              builder: (context, state) => ViewTeleScopePage(),
              routes: [
                GoRoute(
                  path: TelescopeDetailePage.routeName,
                  name: TelescopeDetailePage.routeName,
                  builder: (context, state) => TelescopeDetailePage(id: state.extra! as String),
                  )
              ]
              ),
            GoRoute(
              path: BrandPage.routeName,
              name: BrandPage.routeName,
              builder: (context, state) => BrandPage(),
              ),
            
          ]
          ),
        GoRoute(
          path: LoginPage.routeName,
          name: LoginPage.routeName,
          builder: (context, state) => LoginPage(),
          ),
      ]
    );
}

