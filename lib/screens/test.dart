// import 'package:flutter/material.dart';

// class FormScreen extends StatefulWidget {
//   const FormScreen({Key? key}) : super(key: key);

//   @override
//   State<FormScreen> createState() => _FormScreenState();
// }

// class _FormScreenState extends State<FormScreen> {
//   final _formKey = GlobalKey<FormState>();
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//         appBar: AppBar(),
//         body: Container(
//           child: Form(
//             key: _formKey,
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 TextFormField(
//                   autovalidateMode: AutovalidateMode.onUserInteraction,
//                   // The validator receives the text that the user has entered.
//                   validator: (value) {
//                     if (value == null || value.isEmpty) {
//                       return 'Please enter some text';
//                     } else if (value.length < 5) {
//                       return 'Please ent';
//                     } else {
//                       return null;
//                     }
//                   },
//                 ),
//                 Padding(
//                   padding: const EdgeInsets.symmetric(vertical: 16.0),
//                   child: ElevatedButton(
//                     onPressed: () {
//                       // Validate returns true if the form is valid, or false otherwise.
//                       if (_formKey.currentState!.validate()) {
//                         // If the form is valid, display a snackbar. In the real world,
//                         // you'd often call a server or save the information in a database.
//                         ScaffoldMessenger.of(context).showSnackBar(
//                           const SnackBar(content: Text('Processing Data')),
//                         );
//                       }
//                     },
//                     child: const Text('Submit'),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ));
//   }
// }
