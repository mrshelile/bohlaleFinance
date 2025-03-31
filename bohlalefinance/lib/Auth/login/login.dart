import 'package:bohlalefinance/Home/pages/background.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:wc_form_validators/wc_form_validators.dart';


class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _DeptScreen();
}

class _DeptScreen extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool isObscure = true;
  bool isLoading = false;
  var error = '';
  @override
  Widget build(
    BuildContext context,
  ) {
    final snackBar = SnackBar(
      content: Text(error.toString()),
      action: SnackBarAction(
        label: 'Done',
        onPressed: () {
          // Some code to undo the change.
        },
      ),
    );
    final width = MediaQuery.of(context).copyWith().size.width;
    //final height = MediaQuery.of(context).copyWith().size.height;
    return Scaffold(
      body: Stack(
        children: [
          const Background(),
          SafeArea(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                //Logo and app name
                Text(
                  "I Tour".toUpperCase(),
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontFamily: "Worksans",
                      ),
                ),
                // const SizedBox(
                //   height: 5,
                // ),
                //Form
                isLoading
                    ? Padding(
                        padding: EdgeInsets.only(
                          top: MediaQuery.of(context).copyWith().size.height *
                              0.01,
                          // left: MediaQuery.of(context).copyWith().size.width * 0.5
                        ),
                        child: const SpinKitFoldingCube(
                          color: Color.fromARGB(255, 35, 104, 136),
                          size: 150,
                          // duration: Duration(milliseconds: 1000),
                        ))
                    : Container(
                        width: width * 0.9,
                        padding: EdgeInsets.only(left: width * 0.1),
                        child: Form(
                          key: _formKey,
                          child: Column(
                            children: [
                              TextFormField(
                                keyboardType: TextInputType.emailAddress,
                                validator: Validators.compose([
                                  Validators.required('Email is required'),
                                  Validators.email('wrong email format'),
                                ]),
                                controller: emailController,
                                decoration: const InputDecoration(
                                  labelText: "Email Address",
                                ),
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                              TextFormField(
                                validator: Validators.compose([
                                  Validators.required('Passoword is required'),
                                ]),
                                controller: passwordController,
                                obscureText: isObscure,
                                decoration: InputDecoration(
                                  suffixIcon: IconButton(
                                    icon: Icon(isObscure
                                        ? Icons.visibility
                                        : Icons.visibility_off),
                                    onPressed: () {
                                      setState(() {
                                        isObscure = !isObscure;
                                      });
                                    },
                                  ),
                                  labelText: "Password",
                                  // enabledBorder: OutlineInputBorder(
                                  //   borderSide: BorderSide(),
                                  // ),
                                  // focusedBorder: OutlineInputBorder(
                                  //   borderSide: BorderSide(),
                                  // ),
                                ),
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                              //login button
                              TextButton(
                                style: TextButton.styleFrom(
                                    backgroundColor: const Color.fromARGB(
                                        255, 80, 158, 189)),
                                onPressed: () async {
                                  
                                },
                                //style: ElevatedButton.styleFrom(),
                                child: const Text(
                                  "Login",
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                              // SizedBox(height: height*0.01,),
                              TextButton(
                                // style: TextButton.styleFrom(
                                //     backgroundColor:
                                //         Color.fromARGB(255, 80, 158, 189)),
                                onPressed: () {
                                 
                                },
                                //style: ElevatedButton.styleFrom(),
                                child: const Text(
                                  "Not have an account? Register",
                                  style: TextStyle(color: Colors.blue),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}