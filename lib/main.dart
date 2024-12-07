import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({
    super.key,
  });

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final txt1 = TextEditingController();
  final txt2 = TextEditingController();
  String? verificationId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('home page'),
      ),
      body: Column(
        children: [
          TextField(
            controller: txt1,
          ),
          const SizedBox(
            height: 20,
          ),
          FilledButton(
              onPressed: () async {
                try {

                  // final UserCredential credential= await FirebaseAuth.instance.();
                  // credential.credential.
                  // final confirmResult =
                  //     await FirebaseAuth.instance.verifyPhoneNumber(
                  //   phoneNumber: txt1.text,
                  //   verificationCompleted:
                  //       (PhoneAuthCredential credential) async {
                  //     final userCredential = await FirebaseAuth.instance
                  //         .signInWithCredential(credential);
                  //     // completer.complete(Right(userCredential));
                  //   },
                  //   verificationFailed: (FirebaseAuthException e) {
                  //     print(e);
                  //     // completer.complete(Left(e.message ?? 'Verification Failed'));
                  //   },
                  //   codeSent: (String verId, int? resendToken) {
                  //     verificationId = verId;
                  //     // this.resendToken = resendToken;
                  //     // completer.complete(Left('OTP Sent'));
                  //   },
                  //   codeAutoRetrievalTimeout: (String verId) {
                  //     verificationId = verId;
                  //   },
                  // );

                  print(verificationId);
                } catch (e) {
                  print(e);
                }
              },
              child: const Text('send phone')),
          const SizedBox(
            height: 20,
          ),
          // TextField(
          //   controller: txt2,
          // ),
          // const SizedBox(
          //   height: 20,
          // ),
          // FilledButton(
          //     onPressed: () {
          //       // try {
          //       //   var credential = PhoneAuthProvider.credential(
          //       //       verificationId: verificationId!, smsCode: txt2.text);
          //       //
          //       //   FirebaseAuth.instance.signInWithCredential(credential).then(
          //       //     (value) {
          //       //       print(value);
          //       //     },
          //       //   );
          //       // } catch (e) {
          //       //   print(e);
          //       // }
          //     },
          //     child: const Text('ok')),
        ],
      ),
    );
  }
}
