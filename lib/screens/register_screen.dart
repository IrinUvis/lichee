// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:fluttertoast/fluttertoast.dart';
// import 'package:lichee/authentication_provider.dart';
// import 'package:lichee/screens/auth/auth_type.dart';
// import 'package:provider/provider.dart';
//
// import '../constants.dart';
//
// class RegisterScreen extends StatefulWidget {
//   const RegisterScreen({Key? key}) : super(key: key);
//
//   @override
//   RegisterScreenState createState() => RegisterScreenState();
// }
//
// class RegisterScreenState extends State<RegisterScreen> {
//   final _formKey = GlobalKey<FormState>();
//
//   final usernameEditingController = TextEditingController();
//   final emailEditingController = TextEditingController();
//   final passwordEditingController = TextEditingController();
//   final confirmPasswordEditingController = TextEditingController();
//   DateTime? selectedDateOfBirth;
//
//   AuthType authType = AuthType.login;
//   String? errorMessage;
//   bool inAsyncCall = false;
//
//   @override
//   Widget build(context) {
//     return Scaffold(
//       body: SafeArea(
//         child: SingleChildScrollView(
//           child: Container(
//             padding: const EdgeInsets.symmetric(horizontal: 15.0),
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 //buildLogo(context, deviceHeight),
//                 // buildTextFieldEmail(context),
//                 // buildTextFieldPassword(context),
//                 // buildTextFieldConfirmedPassword(context),
//                 // buildRegisterButton(context),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
//
//   // Widget buildLogo(BuildContext context, height) {
//   //   return Padding(
//   //     padding: EdgeInsets.only(bottom: height / 6),
//   //     child: const Center(
//   //       child: Text(
//   //         'Register',
//   //         style: kLicheeTextStyle,
//   //       ),
//   //     ),
//   //   );
//   // }
//   //
//   // Widget buildTextFieldEmail(context) {
//   //   return Padding(
//   //     padding: const EdgeInsets.symmetric(vertical: 10),
//   //     child: StreamBuilder(
//   //         stream: bloc.emailField,
//   //         builder: (context, snapshot) {
//   //           return TextField(
//   //             autofocus: false,
//   //             onChanged: (string) {
//   //               bloc.addEmail(string);
//   //               setState(() {
//   //                 if (snapshot.error == null) {
//   //                   validFields = false;
//   //                 } else {
//   //                   validFields = true;
//   //                 }
//   //               });
//   //             },
//   //             decoration: InputDecoration(
//   //               hintText: 'example@plug.com',
//   //               border: const OutlineInputBorder(
//   //                 borderRadius: BorderRadius.all(Radius.circular(50)),
//   //               ),
//   //               suffixIcon: const Icon(Icons.email),
//   //               errorText: snapshot.hasError ? snapshot.error.toString() : null,
//   //             ),
//   //           );
//   //         }),
//   //   );
//   // }
//   //
//   // Widget buildRegisterButton(context) {
//   //   return Container(
//   //     height: 60,
//   //     margin: const EdgeInsets.symmetric(vertical: 10),
//   //     child: ElevatedButton(
//   //       onPressed: validFields
//   //           ? () async {
//   //               if (await bloc.register()) Navigator.pop(context);
//   //             }
//   //           : null,
//   //       style: ButtonStyle(
//   //         backgroundColor: MaterialStateProperty.all(Colors.pinkAccent),
//   //         shape: MaterialStateProperty.all<RoundedRectangleBorder>(
//   //           RoundedRectangleBorder(
//   //             borderRadius: BorderRadius.circular(50),
//   //           ),
//   //         ),
//   //       ),
//   //       child: Container(
//   //         constraints: BoxConstraints(
//   //           maxWidth: MediaQuery.of(context).size.width,
//   //           minHeight: MediaQuery.of(context).size.height / 16,
//   //         ),
//   //         alignment: Alignment.center,
//   //         child: const Icon(
//   //           Icons.arrow_forward,
//   //           color: Colors.white,
//   //         ),
//   //       ),
//   //     ),
//   //   );
//   // }
//   //
//   // Widget buildTextFieldPassword(context) {
//   //   return Padding(
//   //     padding: const EdgeInsets.symmetric(vertical: 10),
//   //     child: StreamBuilder(
//   //         stream: bloc.passField,
//   //         builder: (context, snapshot) {
//   //           return TextField(
//   //             obscureText: true,
//   //             autofocus: false,
//   //             enableInteractiveSelection: true,
//   //             onChanged: (string) {
//   //               bloc.addPass(string);
//   //               setState(() {
//   //                 if (snapshot.error == null) {
//   //                   validFields = false;
//   //                 } else {
//   //                   validFields = true;
//   //                 }
//   //               });
//   //             },
//   //             decoration: InputDecoration(
//   //               hintText: 'password',
//   //               border: const OutlineInputBorder(
//   //                 borderRadius: BorderRadius.all(Radius.circular(50)),
//   //               ),
//   //               suffixIcon: Icon(Icons.password),
//   //               errorText: snapshot.hasError ? snapshot.error.toString() : null,
//   //             ),
//   //           );
//   //         }),
//   //   );
//   // }
//   //
//   // Widget buildTextFieldConfirmedPassword(context) {
//   //   return Padding(
//   //     padding: const EdgeInsets.symmetric(vertical: 10),
//   //     child: StreamBuilder(
//   //         stream: bloc.confPassField,
//   //         builder: (context, snapshot) {
//   //           return TextField(
//   //             obscureText: true,
//   //             autofocus: false,
//   //             enableInteractiveSelection: true,
//   //             onChanged: (string) {
//   //               bloc.addConfPass(string);
//   //               setState(() {
//   //                 if (snapshot.error == null) {
//   //                   validFields = false;
//   //                 } else {
//   //                   validFields = true;
//   //                 }
//   //               });
//   //             },
//   //             decoration: InputDecoration(
//   //               hintText: 'password',
//   //               border: const OutlineInputBorder(
//   //                 borderRadius: BorderRadius.all(Radius.circular(50)),
//   //               ),
//   //               suffixIcon: Icon(Icons.password),
//   //               errorText: snapshot.hasError ? snapshot.error.toString() : null,
//   //             ),
//   //           );
//   //         }),
//   //   );
//   // }
//
//   Form getAppropriateForm() {
//     final firstNameField = TextFormField(
//       autofocus: false,
//       controller: usernameEditingController,
//       keyboardType: TextInputType.name,
//       validator: (value) {
//         RegExp regex = RegExp(r'^.{3,}$');
//         if (value!.isEmpty) {
//           return ('Username cannot be empty');
//         }
//         if (!regex.hasMatch(value)) {
//           return ('Enter valid username (min. 3 characters)');
//         }
//         return null;
//       },
//       onSaved: (value) {
//         usernameEditingController.text = value!;
//       },
//       textInputAction: TextInputAction.next,
//       decoration: InputDecoration(
//         prefixIcon: const Icon(Icons.account_circle),
//         contentPadding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
//         hintText: 'Your username',
//         border: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(10),
//         ),
//       ),
//     );
//
//     final emailField = TextFormField(
//       autofocus: false,
//       controller: emailEditingController,
//       keyboardType: TextInputType.emailAddress,
//       validator: (value) {
//         if (value!.isEmpty) {
//           return ('Please enter your email');
//         }
//         if (!RegExp('^[a-zA-Z0-9+_.-]+@[a-zA-Z0-9.-]+.[a-z]').hasMatch(value)) {
//           return ('Please enter a valid email');
//         }
//         return null;
//       },
//       onSaved: (value) {
//         usernameEditingController.text = value!;
//       },
//       textInputAction: TextInputAction.next,
//       decoration: InputDecoration(
//         prefixIcon: const Icon(Icons.mail),
//         contentPadding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
//         hintText: 'Email',
//         border: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(10),
//         ),
//       ),
//     );
//
//     final dateOfBirthField = DateTimeField(
//       validator: (value) {
//         if (value == null) {
//           return ('Please enter your date of birth');
//         }
//         return null;
//       },
//       format: DateFormat('yyyy-MM-dd'),
//       onShowPicker: (context, currentValue) async {
//         DateTime? chosenDate = await showDatePicker(
//             context: context,
//             firstDate: DateTime(1900),
//             initialDate: currentValue ?? DateTime.now(),
//             lastDate: DateTime(2100));
//         selectedDateOfBirth = chosenDate;
//         return selectedDateOfBirth;
//       },
//       decoration: InputDecoration(
//         prefixIcon: const Icon(Icons.date_range),
//         contentPadding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
//         hintText: 'Date of birth',
//         border: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(10),
//         ),
//       ),
//     );
//
//     final passwordField = TextFormField(
//       autofocus: false,
//       controller: passwordEditingController,
//       obscureText: true,
//       validator: (value) {
//         RegExp regex = RegExp(r'^.{6,}$');
//         if (value!.isEmpty) {
//           return ('Please enter your password');
//         }
//         if (!regex.hasMatch(value)) {
//           return ('Enter valid password (min. 6 characters)');
//         }
//       },
//       onSaved: (value) {
//         usernameEditingController.text = value!;
//       },
//       textInputAction: TextInputAction.next,
//       decoration: InputDecoration(
//         prefixIcon: const Icon(Icons.vpn_key),
//         contentPadding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
//         hintText: 'Password',
//         border: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(10),
//         ),
//       ),
//     );
//
//     final confirmPasswordField = TextFormField(
//       autofocus: false,
//       controller: confirmPasswordEditingController,
//       obscureText: true,
//       validator: (value) {
//         if (confirmPasswordEditingController.text !=
//             passwordEditingController.text) {
//           return 'Passwords don\'t match';
//         }
//         return null;
//       },
//       onSaved: (value) {
//         confirmPasswordEditingController.text = value!;
//       },
//       textInputAction: TextInputAction.done,
//       decoration: InputDecoration(
//         prefixIcon: const Icon(Icons.vpn_key),
//         contentPadding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
//         hintText: 'Confirm password',
//         border: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(10),
//         ),
//       ),
//     );
//
//     final registerButton = Material(
//       elevation: 5,
//       borderRadius: BorderRadius.circular(30),
//       color: Colors.orangeAccent,
//       child: MaterialButton(
//         padding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
//         minWidth: MediaQuery.of(context).size.width,
//         onPressed:
//         () => signUp(),
//         child: const Text(
//           'Sign up',
//           textAlign: TextAlign.center,
//           style: TextStyle(
//             fontSize: 20,
//             color: Colors.white,
//             fontWeight: FontWeight.bold,
//           ),
//         ),
//       ),
//     );
//
//     final authorizeButton = Material(
//       elevation: 5,
//       borderRadius: BorderRadius.circular(30),
//       color: Colors.orangeAccent,
//       child: MaterialButton(
//         padding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
//         minWidth: MediaQuery.of(context).size.width,
//         onPressed:
//             authType == AuthType.register ? () => signUp() : () => logIn(),
//         child: Text(
//           authType == AuthType.register ? 'Sign up' : 'Log in',
//           textAlign: TextAlign.center,
//           style: const TextStyle(
//             fontSize: 20,
//             color: Colors.white,
//             fontWeight: FontWeight.bold,
//           ),
//         ),
//       ),
//     );
//
//     final authTypeChanger = Row(
//       mainAxisAlignment: MainAxisAlignment.center,
//       children: <Widget>[
//         authType == AuthType.register
//             ? const Text('Already have an account? ')
//             : const Text('Don\'t have an account? '),
//         GestureDetector(
//           onTap: () {
//             setState(() {
//               authType = authType == AuthType.register
//                   ? AuthType.login
//                   : AuthType.register;
//             });
//           },
//           child: Text(
//             authType == AuthType.register ? 'Log in' : 'Sign up',
//             style: const TextStyle(
//               color: Colors.orangeAccent,
//               fontWeight: FontWeight.bold,
//               fontSize: 15,
//             ),
//           ),
//         ),
//       ],
//     );
//
//     return Form(
//       key: _formKey,
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         crossAxisAlignment: CrossAxisAlignment.center,
//         children: authType == AuthType.register
//             ? <Widget>[
//                 const SizedBox(height: 40),
//                 firstNameField,
//                 const SizedBox(height: 20),
//                 emailField,
//                 const SizedBox(height: 20),
//                 dateOfBirthField,
//                 const SizedBox(height: 20),
//                 passwordField,
//                 const SizedBox(height: 20),
//                 confirmPasswordField,
//                 const SizedBox(height: 20),
//                 authorizeButton,
//                 const SizedBox(height: 15),
//                 authTypeChanger,
//               ]
//             : <Widget>[
//                 const SizedBox(height: 40),
//                 emailField,
//                 const SizedBox(height: 20),
//                 passwordField,
//                 const SizedBox(height: 20),
//                 authorizeButton,
//                 const SizedBox(height: 15),
//                 authTypeChanger,
//               ],
//       ),
//     );
//   }
//
//   void signUp() async {
//     if (_formKey.currentState!.validate()) {
//       setState(() => toggleInAsyncCall());
//       try {
//         await Provider.of<AuthenticationProvider>(context).signUp(
//           email: emailEditingController.text.trim(),
//           password: passwordEditingController.text.trim(),
//         );
//       } on FirebaseAuthException catch (error) {
//         switch (error.code) {
//           case 'invalid-email':
//             errorMessage = 'Your email address appears to be malformed.';
//             break;
//           case 'wrong-password':
//             errorMessage = 'Your password is wrong.';
//             break;
//           case 'user-not-found':
//             errorMessage = 'User with this email doesn\'t exist.';
//             break;
//           case 'user-disabled':
//             errorMessage = 'User with this email has been disabled.';
//             break;
//           case 'too-many-requests':
//             errorMessage = 'Too many requests';
//             break;
//           case 'operation-not-allowed':
//             errorMessage = 'Signing in with email and password is not enabled.';
//             break;
//           default:
//             errorMessage = 'An undefined error has occurred.';
//         }
//         Fluttertoast.showToast(msg: errorMessage!);
//       } finally {
//         setState(() => toggleInAsyncCall());
//       }
//     }
//   }
//
//   void logIn() async {
//     if (_formKey.currentState!.validate()) {
//       setState(() => toggleInAsyncCall());
//       try {
//         await Provider.of<AuthenticationProvider>(context).signIn(
//           email: emailEditingController.text.trim(),
//           password: passwordEditingController.text.trim(),
//         );
//       } on FirebaseAuthException catch (error) {
//         switch (error.code) {
//           case 'invalid-email':
//             errorMessage = 'Your email address appears to be malformed.';
//             break;
//           case 'wrong-password':
//             errorMessage = 'Your password is wrong.';
//             break;
//           case 'user-not-found':
//             errorMessage = 'User with this email doesn\'t exist.';
//             break;
//           case 'user-disabled':
//             errorMessage = 'User with this email has been disabled.';
//             break;
//           case 'too-many-requests':
//             errorMessage = 'Too many requests';
//             break;
//           case 'operation-not-allowed':
//             errorMessage = 'Signing in with email and password is not enabled.';
//             break;
//           default:
//             errorMessage = 'An undefined error has occurred.';
//         }
//         Fluttertoast.showToast(msg: errorMessage!);
//       } finally {
//         setState(() => toggleInAsyncCall());
//       }
//     }
//   }
//
//   void toggleInAsyncCall() {
//     inAsyncCall = !inAsyncCall;
//   }
// }
