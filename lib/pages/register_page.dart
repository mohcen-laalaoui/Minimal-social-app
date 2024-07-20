import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:socialmediaapp/auth/login_or_register.dart';
import 'package:socialmediaapp/components/button.dart';
import 'package:socialmediaapp/components/textField.dart';
import 'package:socialmediaapp/helper/helper_function.dart';
import 'package:firebase_auth/firebase_auth.dart';

class RegisterPage extends StatefulWidget {
  void Function()? onTap;
  RegisterPage({super.key, required this.onTap});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  TextEditingController userNameController = TextEditingController();

  TextEditingController emailController = TextEditingController();

  TextEditingController passwordController = TextEditingController();

  TextEditingController confirmPasswordController = TextEditingController();

  //register method
  void register() async {
    //show loading circle
    showDialog(
        context: context,
        builder: (context) => const Center(
              child: CircularProgressIndicator(),
            ));
    //make sure passwords match
    if (passwordController.text != confirmPasswordController.text) {
      //pop loading circle
      Navigator.pop(context);
      //show error message to user
      displayMessageToUser("Password don't match", context);
    }
    //if password do match
    else {
      //try creating the user
      try {
        UserCredential? userCredential = await FirebaseAuth.instance
            .createUserWithEmailAndPassword(
                email: emailController.text, password: passwordController.text);

        //create user documents and add tp firestore
        createUserDocument(userCredential);
        Navigator.pop(context);
      } on FirebaseAuthException catch (e) {
        Navigator.pop(context);

        displayMessageToUser(e.code, context);
      }
    }
  }

  Future<void> createUserDocument(UserCredential? userCredential) async {
    if (userCredential != null && userCredential.user != null) {
      await FirebaseFirestore.instance
          .collection("Users")
          .doc(userCredential.user!.email)
          .set({
        'email': userCredential.user!.email,
        'username': userNameController.text,
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(25.0),
              child: Column(
                children: [
                  //logo
                  Icon(
                    Icons.person,
                    size: 80,
                    color: Theme.of(context).colorScheme.inversePrimary,
                  ),
                  const SizedBox(
                    height: 25,
                  ),
                  //app name
                  const Text(
                    'Social Media',
                    style: TextStyle(fontSize: 20),
                  ),
                  const SizedBox(
                    height: 50.0,
                  ),
                  //username

                  MyTextField(
                      hintText: "Username",
                      obscureText: false,
                      controller: userNameController),
                  const SizedBox(
                    height: 10.0,
                  ),
                  //textfield for email
                  MyTextField(
                      hintText: "E-mail",
                      obscureText: false,
                      controller: emailController),
                  const SizedBox(
                    height: 10.0,
                  ),

                  //textfield for password
                  MyTextField(
                      hintText: "Password",
                      obscureText: true,
                      controller: passwordController),
                  const SizedBox(
                    height: 10.0,
                  ),
                  //confirm password
                  MyTextField(
                      hintText: "Confirm password",
                      obscureText: true,
                      controller: confirmPasswordController),

                  const SizedBox(
                    height: 10.0,
                  ),

                  //forgot password
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        'Forgot password ?',
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.secondary,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(
                    height: 25.0,
                  ),

                  //register button
                  MyButton(text: "Register", onTap: register),

                  const SizedBox(
                    height: 25.0,
                  ),

                  //Already have account ? Login here
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Already have account? ",
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.inversePrimary,
                        ),
                      ),
                      GestureDetector(
                        onTap: widget.onTap,
                        child: const Text(
                          "Login here",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
