import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hammas/Homepage.dart';
import 'package:hammas/singup.dart';
import 'package:google_sign_in/google_sign_in.dart';

class Loginpage extends StatefulWidget {
  const Loginpage({super.key});

  @override
  State<Loginpage> createState() => _LoginpageState();
}

class _LoginpageState extends State<Loginpage> {
  final TextEditingController EmailController = TextEditingController();
  final TextEditingController PasswordController = TextEditingController();

  login() async {
    try {
      final credential = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: EmailController.text.trim(),
        password: PasswordController.text.trim(),
      );
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const Homepage()),
      );
    } on FirebaseAuthException catch (e) {
      String errorMessage = '';
      print("Error ========== > ${e.code}");
      switch (e.code) {
        case 'invalid-email':
          errorMessage = 'Please enter a valid email address';
          break;
        case 'No-user-found':
          errorMessage = 'No user found for that email';
          break;
        case 'wrong-password':
          errorMessage = 'Wrong password provided for that user';
          break;
        default:
          errorMessage = 'An error occurred. Please try again.';
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(errorMessage)),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('$e')),
      );
    }
  }

  singInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      final GoogleSignInAuthentication? googleAuth =
          await googleUser?.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );
      final UserCredential userCredential =
          await FirebaseAuth.instance.signInWithCredential(credential);
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const Homepage()),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error signing in with Google: $e')),
      );
    }
  }

  bool obscureText = true;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
      height: double.infinity,
      decoration: const BoxDecoration(
          gradient: LinearGradient(colors: [
        Color.fromARGB(255, 14, 90, 81),
        Color.fromARGB(185, 229, 180, 112),
      ])),
      child: SingleChildScrollView(
        child: Column(children: [
          const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: EdgeInsets.only(top: 50),
                child: Text(
                  'Login',
                  style: TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.w500,
                      color: Colors.white),
                ),
              )
            ],
          ),
          const SizedBox(
            height: 60,
          ),
          const Row(
            children: [
              Padding(
                padding: EdgeInsets.only(left: 30),
                child: Text('Email Address'),
              ),
            ],
          ),
          const SizedBox(
            height: 10,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: TextField(
              controller: EmailController,
              decoration: InputDecoration(
                  focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide:
                          const BorderSide(color: Colors.black, width: 0)),
                  enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide:
                          const BorderSide(color: Colors.black, width: 0)),
                  hintText: 'Enter your email',
                  prefixIcon: const Icon(
                    Icons.email,
                    color: Colors.black,
                  ),
                  hintStyle: const TextStyle(color: Colors.grey)),
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          const Row(
            children: [
              Padding(
                padding: EdgeInsets.only(left: 30),
                child: Text('Password'),
              ),
            ],
          ),
          const SizedBox(
            height: 7,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: TextField(
              controller: PasswordController,
              obscureText: obscureText,
              decoration: InputDecoration(
                  focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide:
                          const BorderSide(color: Colors.black, width: 0)),
                  enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide:
                          const BorderSide(color: Colors.black, width: 0)),
                  hintText: 'Enter your Password',
                  prefixIcon: const Icon(
                    Icons.lock,
                    color: Colors.black,
                  ),
                  suffixIcon: IconButton(
                      onPressed: () {
                        setState(() {
                          obscureText = !obscureText;
                        });
                      },
                      icon: Icon(
                        obscureText ? Icons.visibility : Icons.visibility_off,
                        color: Colors.black,
                      )),
                  hintStyle: const TextStyle(color: Colors.grey)),
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          const Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Padding(
                padding: EdgeInsets.only(right: 20),
                child: Text(
                  "Forget Password?",
                  style:
                      TextStyle(fontWeight: FontWeight.w500, color: Colors.red),
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 10,
          ),
          SizedBox(
            width: 200,
            height: 50,
            child: ElevatedButton(
                onPressed: () async {
                  await login();
                },
                style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(188, 14, 11, 11)),
                child: const Text(
                  "Login",
                  style: TextStyle(color: Colors.white),
                )),
          ),
          const SizedBox(
            height: 10,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text("Don't have an account?"),
              TextButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (Context) => const Singup()));
                  },
                  child: const Text(
                    'Sign Up',
                    style: TextStyle(color: Color.fromARGB(255, 255, 255, 255)),
                  ))
            ],
          ),
          const SizedBox(
            height: 30,
          ),
          const Row(
            children: [
              Expanded(
                child: Divider(
                  thickness: 0.5,
                  color: Colors.black,
                ),
              ),
              Text('Or continue with'),
              Expanded(
                child: Divider(
                  thickness: 0.5,
                  color: Colors.black,
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 80,
          ),
          InkWell(
            onTap: () {
              singInWithGoogle();
            },
            child: Card(
              elevation: 12,
              child: Container(
                height: 55,
                width: 300,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(17),
                ),
                child: Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 10),
                      child: Image.asset(
                        'images/assets/Google__G__logo.svg.webp',
                        height: 30,
                      ),
                    ),
                    const SizedBox(
                      width: 45,
                    ),
                    const Text(
                      'Continue with google',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          InkWell(
            onTap: () {},
            child: Card(
              elevation: 12,
              child: Container(
                height: 55,
                width: 300,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(17),
                ),
                child: Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 10),
                      child: Image.asset(
                        'images/assets/Logo_of_Twitter.svg.png',
                        height: 30,
                      ),
                    ),
                    const SizedBox(
                      width: 45,
                    ),
                    const Text(
                      'Continue with twitter',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ]),
      ),
    ));
  }
}
