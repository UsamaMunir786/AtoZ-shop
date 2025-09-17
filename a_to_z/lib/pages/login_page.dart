import 'package:a_to_z/auth/auth_services.dart';
import 'package:a_to_z/pages/dashboard_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:go_router/go_router.dart';

class LoginPage extends StatefulWidget {
  static const String routeName = '/login';
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  String _errMsg = '';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
    
      body: Center(
        child: Form(
          key: _formKey,
          child: ListView(
            shrinkWrap: true,
            padding: EdgeInsets.all(24),
            children: [
                 Padding(padding: EdgeInsets.all(4),
                 child: TextFormField(
                  controller: emailController,
                  keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                        labelText: 'Enter email',
                        prefix: Icon(Icons.email, size: 14,),
                        filled: true,
                      ),
                      validator: (value) {
                        if(value == null || value.isEmpty){
                          return 'please enter  email';
                        }
                        return null;
                      },

                 ),
                ),
SizedBox(height: 10,),
                Padding(padding: EdgeInsets.all(4),
                 child: TextFormField(
                  
                  obscureText: true,
                  controller: passwordController,
                  keyboardType: TextInputType.phone,
                      decoration: InputDecoration(
                        labelText: 'Enter password',
                        prefix: Icon(Icons.lock, size: 14,),
                        filled: true,
                        
                      ),
                      validator: (value) {
                        if(value == null || value.isEmpty){
                          return 'please enter  password';
                        }
                        return null;
                      },

                 ),
                ),
SizedBox(height: 20,),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.all(10)
                  ),
                  onPressed: (){
                    _authenticate();
                  }, 
                  child: Text('login as Admin')
                  ),

                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(_errMsg, style: TextStyle(color: Colors.red, fontSize: 18),),
                )
            ],
          
          ),
        )
      ),
    );
  }

  @override
  void dispose(){
    super.dispose();
    emailController.dispose();
    passwordController.dispose();

  }
  
  void _authenticate() async{
    if(_formKey.currentState!.validate()){
        EasyLoading.show(status: 'Please wait');
        final email = emailController.text;
        final password = passwordController.text;
        try{
            final status =await  AuthServices.loginAdmin(email, password);
            EasyLoading.dismiss();
            if(status){
                 context.goNamed(DashboardPage.routeName);
            }
            else{
              await  AuthServices.logOut();
              setState(() {            
              _errMsg = 'Not enter admin credential';
            });
              
            }
           
        }on FirebaseAuthException catch(error){
          EasyLoading.dismiss();
          setState(() {
            _errMsg = error.message!;
          });
        }
    }
  }
}