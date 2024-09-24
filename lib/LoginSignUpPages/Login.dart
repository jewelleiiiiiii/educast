import 'package:educast/LoginSignUpPages/CustomAlertDialog.dart';
import 'package:educast/services/notifications.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:educast/Home/Home4th.dart';
import 'package:educast/Home/homeg12.dart';
import 'package:educast/LoginSignUpPages/LoginSignupPage.dart';
import 'package:educast/LoginSignUpPages/Signup.dart';
import 'package:educast/services/authentication.dart';
import 'package:educast/services/snackbar.dart';
import 'package:educast/Home/homeg10.dart';
import 'package:vibration/vibration.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final AuthServices _auth = AuthServices();
  bool isLoading = false;

  void loginUsers() async {
    if (_emailController.text != "") {
      setState(() {
        isLoading = true;
      });

      try {
        String email = '${_emailController.text}@g.batstate-u.edu.ph';

        // Attempt to log in the user
        String res = await _auth.loginUser(
          email: email,
          password: _passwordController.text,
          context: context,
        );

        if (!mounted) return;

        if (res == "Success") {
          // Get the current user's UID from Firebase Auth
          User? user = FirebaseAuth.instance.currentUser;
          bool isActive = _auth.checkIfUserIsSignedIn();

          if (isActive) {
            NotificationHelper.isNotifShown = false;
            NotificationHelper.showNotification(
                title: "Location Alert",
                body:
                    "User ${user!.email} is already signed in to other account.",
                payload: "jawara.poge");
            if (await Vibration.hasVibrator() == true) {
              Vibration.vibrate(duration: 1000);
              await Future.delayed(const Duration(milliseconds: 2000));
              Vibration.vibrate(duration: 1000);
            } else {
              Vibration.cancel();
            }
          } else {
            NotificationHelper.isNotifShown = true;
            Vibration.cancel();
          }
          if (user != null) {
            String uid = user.uid;

            // Retrieve user data from Firestore using UID
            var userSnapshot = await _auth.getUserData(uid);

            if (userSnapshot != null) {
              String gradeLevel = userSnapshot['gradeLevel'];

              // Redirect based on grade level
              if (gradeLevel == 'Grade 10') {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const HomeG10(),
                  ),
                );
              } else if (gradeLevel == 'Grade 12') {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => HomeG12(),
                  ),
                );
              } else if (gradeLevel == 'Fourth-year College') {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => Home4th(),
                  ),
                );
              } else {
                // If no valid grade level is found
                showSnackBar(context, 'Grade level not recognized.');
              }
            } else {
              // Handle the case where user data is not found
              showSnackBar(context, 'User data not found.');
            }
          } else {
            showSnackBar(context, 'User not authenticated.');
          }
        } else {
          showSnackBar(context, res);
        }
      } catch (e) {
        showSnackBar(context, 'Error during login: $e');
      } finally {
        setState(() {
          isLoading = false;
        });
      }
    } else {
      showDialog(
          context: context,
          builder: (context) {
            return CustomAlertDialog(
                colorMessage: Colors.redAccent,
                actionLabel: "Close",
                title: "No Email Error",
                onPressedCloseBtn: () {
                  Navigator.of(context).pop();
                },
                child: const Text(
                    "Please enter a valid email address. It appears that no email address was provided or the entered address is not valid."));
          });
    }
  }

  void loginWithGoogle() async {
    String res = await _auth.loginWithGoogle(context);

    if (res == "Success") {
      // Get the current user's UID from Firebase Auth
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        String uid = user.uid;

        // Retrieve user data from Firestore using UID
        var userSnapshot = await _auth.getUserData(uid);

        if (userSnapshot != null) {
          String gradeLevel = userSnapshot['gradeLevel'];

          // Redirect based on grade level
          if (gradeLevel == 'Grade 10') {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => const HomeG10(),
              ),
            );
          } else if (gradeLevel == 'Grade 12') {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => HomeG12(),
              ),
            );
          } else if (gradeLevel == 'Fourth-year College') {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => Home4th(),
              ),
            );
          } else {
            // If no valid grade level is found
            showSnackBar(context, 'Grade level not recognized.');
          }
        } else {
          // Handle the case where user data is not found
          showSnackBar(context, 'User data not found.');
        }
      } else {
        showSnackBar(context, 'User not authenticated.');
      }
    } else {
      showSnackBar(context, res);
    }
  }

  void _forgotPassword() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          double _w = MediaQuery.of(context).size.width;
          return CustomAlertDialog(
              colorMessage: Colors.green,
              title: "Reset Password",
              height: 70,
              widght: _w,
              actionOkayVisibility: true,
              onPressedCloseBtn: () {
                Navigator.of(context).pop();
              },
              onPressOkay: () {
                resetPassword();
              },
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildEmailTextField(),
                ],
              ));
        });
  }

  void resetPassword() async {
    AuthServices _auth = AuthServices();

    if (_emailController.text != "") {
      String email = '${_emailController.text}@g.batstate-u.edu.ph';

      bool hasEmail = await _auth.checkEmailExists(email);

      if (hasEmail) {
        await FirebaseAuth.instance.sendPasswordResetEmail(email: email);

        // ignore: use_build_context_synchronously
        Navigator.of(context).pop();
        showDialog(
            context: context,
            builder: (context) {
              return CustomAlertDialog(
                  colorMessage: Colors.greenAccent,
                  title: "Success",
                  onPressedCloseBtn: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text(
                      "An email has been sent to your account with instructions on how to change your password. Thank you!"));
            });
      } else {
        showDialog(
            context: context,
            builder: (context) {
              return CustomAlertDialog(
                  colorMessage: Colors.redAccent,
                  actionOkayVisibility: true,
                  actionLabel: "Sign Up",
                  title: "Invalid",
                  onPressOkay: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => SignupPage(),
                      ),
                    );
                  }, //, => _signUp(MediaQuery.of(context).size.width),
                  onPressedCloseBtn: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text(
                      "The email address you entered was not found, or the user may have been deleted. Would you like to sign up?"));
            });
      }
      // ignore: use_build_context_synchronously
    } else {
      showDialog(
          context: context,
          builder: (context) {
            return CustomAlertDialog(
                colorMessage: Colors.redAccent,
                actionLabel: "Close",
                title: "No Email Error",
                onPressedCloseBtn: () {
                  Navigator.of(context).pop();
                },
                child: const Text(
                    "Please enter a valid email address. It appears that no email address was provided or the entered address is not valid."));
          });
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 159, 41, 33),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        leading: IconButton(
          icon: SizedBox(
            width: 20,
            height: 20,
            child: Image.asset('assets/back.png'),
          ),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const LoginSignupPage()),
            );
          },
        ),
      ),
      resizeToAvoidBottomInset: false,
      body: Column(
        children: [
          const Padding(
            padding: EdgeInsets.only(left: 20.0, top: 10.0, bottom: 30.0),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text.rich(
                TextSpan(
                  children: [
                    TextSpan(
                      text: 'WELCOME\n',
                      style: TextStyle(
                        fontSize: 24.0,
                        color: Colors.white,
                        height: 1.2, // Line height for text spacing
                      ),
                    ),
                    TextSpan(
                      text: 'BACK!',
                      style: TextStyle(
                        fontSize: 24.0,
                        color: Colors.white,
                        height: 1.2, // Line height for text spacing
                      ),
                    ),
                  ],
                ),
                textAlign: TextAlign.left,
              ),
            ),
          ),
          Expanded(
            flex: 7,
            child: Material(
              elevation: 5.0,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(40.0),
                topRight: Radius.circular(40.0),
              ),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(40.0),
                    topRight: Radius.circular(40.0),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 1,
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Spacer(),
                    _buildEmailTextField(),
                    const Spacer(),
                    PasswordField(
                      controller: _passwordController,
                      labelText: 'Password',
                      isPass: true,
                    ),
                    const Spacer(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        InkWell(
                          onTap: _forgotPassword,
                          child: const MouseRegion(
                            cursor: SystemMouseCursors.click,
                            child: Text(
                              'Forgot Password?',
                              style: TextStyle(
                                color: Color.fromARGB(255, 3, 3, 3),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const Spacer(flex: 2),
                    Center(
                      child: ElevatedButton(
                        onPressed: isLoading ? null : loginUsers,
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all<Color>(
                            const Color.fromARGB(255, 159, 41, 33),
                          ),
                          foregroundColor: MaterialStateProperty.all<Color>(
                            Colors.white,
                          ),
                          padding:
                              MaterialStateProperty.all<EdgeInsetsGeometry>(
                            const EdgeInsets.symmetric(
                              horizontal: 80.0,
                              vertical: 15.0,
                            ),
                          ),
                        ),
                        child: isLoading
                            ? const CircularProgressIndicator(
                                color: Colors.white,
                              )
                            : const Text('LOGIN'),
                      ),
                    ),
                    const Spacer(),
                    const Row(
                      children: [
                        Expanded(child: Divider()),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 10.0),
                          child: Text('OR CONTINUE WITH'),
                        ),
                        Expanded(child: Divider()),
                      ],
                    ),
                    const Spacer(),
                    Center(
                      child: OutlinedButton(
                        onPressed: loginWithGoogle,
                        style: ButtonStyle(
                          side: MaterialStateProperty.all(BorderSide.none),
                        ),
                        child: MouseRegion(
                          cursor: SystemMouseCursors.click,
                          child: SizedBox(
                            width: 60,
                            height: 60,
                            child: Image.asset('assets/google.png'),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmailTextField() {
    return Container(
      height: 50.0,
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 1,
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
        borderRadius: BorderRadius.circular(15.0),
      ),
      child: TextFormField(
        controller: _emailController,
        style: const TextStyle(fontSize: 15.0),
        decoration: InputDecoration(
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
          labelText: 'Email',
          labelStyle: const TextStyle(color: Colors.black),
          filled: true,
          fillColor: Colors.grey[200],
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15.0),
            borderSide: BorderSide.none,
          ),
          hintText: 'XX-XXXXX',
          hintStyle: const TextStyle(color: Colors.grey),
          suffixText: '@g.batstate-u.edu.ph',
          suffixStyle: const TextStyle(color: Colors.grey),
        ),
        keyboardType: TextInputType.emailAddress,
        inputFormatters: [EmailInputFormatter()],
      ),
    );
  }
}

class EmailInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    String newText = newValue.text.replaceAll(RegExp(r'[^0-9]'), '');

    if (newText.length > 7) {
      newText = newText.substring(0, 7);
    }

    if (newText.length > 2) {
      newText = '${newText.substring(0, 2)}-${newText.substring(2)}';
    }

    return TextEditingValue(
      text: newText,
      selection: TextSelection.collapsed(offset: newText.length),
    );
  }
}
