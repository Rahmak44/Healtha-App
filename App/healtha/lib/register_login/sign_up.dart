import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:google_fonts/google_fonts.dart';
import '../home/home_screen.dart';
import 'log_in.dart';

class SignUp extends StatefulWidget {
  @override
  _SignUpState createState() => _SignUpState();
}
int ? patientId;
class _SignUpState extends State<SignUp> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController dateOfBirthController = TextEditingController();
  bool isMale = false; // New state for gender selection
  bool isFemale = false; // New state for gender selection
  final TextEditingController contactInformationController =
  TextEditingController();

  // New state for password visibility
  bool isPasswordVisible = false;

  Future<int?> signUp(BuildContext context) async {
    String healthaIP='http://ec2-18-220-246-59.us-east-2.compute.amazonaws.com:4000/api/healtha/patients';

    final url = healthaIP;
    try {
      final response = await http.post(
        Uri.parse(url),
        body: jsonEncode({
          'username': usernameController.text,
          'password': passwordController.text,
          'email': emailController.text,
          'dateOfBirth': dateOfBirthController.text,
          'gender': isMale ? 'Male' : 'Female',
          'contactInformation': contactInformationController.text,
        }),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 201) {

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: SizedBox(
              height: 60,
              child: Row(
                children: [
                  Icon(Icons.check_circle, color: Colors.green),
                  SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      'Account created successfully, \nWELCOME ${usernameController.text} TO HEALTHA !',
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            backgroundColor: Colors.white,
            elevation: 8,
            behavior: SnackBarBehavior.floating,
          ),
        );
        // Patient created successfully, parse response JSON to get the patient ID
        final parsedResponse = jsonDecode(response.body);
        patientId = parsedResponse['userid']; // Access the auto-generated ID
        print(patientId);

        // Navigate to the home screen immediately after displaying the SnackBar
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (context) => HomeScreen(),
          ),
              (route) => false,
        );
        return patientId;

      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Sign-up failed. Please try again ..',
              style: TextStyle(
                color: Colors.red,
                fontWeight: FontWeight.bold,
              ),
            ),
            backgroundColor: Colors.grey,
          ),
        );
      }
    } catch (e) {
      print('Error: $e');
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff7c77d1),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.all(70),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    'images/healtha1.png',
                    color: Colors.white,
                    width: 70.0,
                    height: 70.0,
                  ),
                  SizedBox(width: 10.0),
                  Text(
                    'Healtha',
                    style: GoogleFonts.dancingScript(
                      textStyle: TextStyle(
                        fontSize: 40,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
         //   SizedBox(height: 20),
            Container(
              height: 1000,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
              ),
              child: SingleChildScrollView(
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(height: 40),
                      Text(
                        'Sign Up',
                        style: TextStyle(
                          fontSize: 30.0,
                          fontWeight: FontWeight.w700,
                          color: Color(0xff7c77d1),
                        ),
                      ),
                      SizedBox(height: 20),
                      buildTextFormField(
                        controller: usernameController,
                        labelText: 'Name',
                        suffixIcon: Icons.person,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please enter your Username';
                          }
                          return null;
                        },
                      ),
                      buildTextFormField(
                        controller: emailController,
                        labelText: 'Email',
                        suffixIcon: Icons.email_outlined,
                        keyboardType: TextInputType.emailAddress,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please enter your Email';
                          } else if (!RegExp(r'^\w+@[a-zA-Z_]+?\.[a-zA-Z]{2,3}$')
                              .hasMatch(value)) {
                            return 'Please enter a valid email address';
                          }
                          return null;
                        },
                      ),
                      buildTextFormField(
                        controller: passwordController,
                        labelText: 'Password',
                        suffixIcon: isPasswordVisible
                            ? Icons.visibility
                            : Icons.visibility_off,
                        obscureText: !isPasswordVisible,
                        keyboardType: TextInputType.text,
                        validator: (value) {
                          if (value!.length < 8 ||
                              !RegExp(r'^(?=.*?[a-z])(?=.*?[A-Z])(?=.*?[0-9])')
                                  .hasMatch(value)) {
                            return 'Password must be at least 8 characters with a mix of uppercase, lowercase, and numbers';
                          }
                          return null;
                        },
                        onTapSuffix: () {
                          setState(() {
                            isPasswordVisible = !isPasswordVisible;
                          });
                        },
                      ),
                      buildTextFormField(
                        controller: dateOfBirthController,
                        labelText: 'Date of Birth',
                        suffixIcon: Icons.date_range_outlined,
                        keyboardType: TextInputType.datetime,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please enter your birth date';
                          }
                          return null;
                        },
                        onTapSuffix: () async {
                          DateTime? selectedDate = await showDatePicker(
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime(1900),
                            lastDate: DateTime.now(),
                          );

                          if (selectedDate != null &&
                              selectedDate != DateTime.now()) {
                            setState(() {
                              dateOfBirthController.text =
                              selectedDate.toLocal().toString().split(' ')[0];
                            });
                          }
                        },
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                        child: Row(
                          children: [
                            Text('Gender'),
                            Checkbox(
                              value: isMale,
                              onChanged: (bool? newValue) {
                                setState(() {
                                  isMale = newValue!;
                                  if (isMale) {
                                    isFemale = false;
                                  }
                                });
                              },
                            ),
                            Text('Male'),
                            Checkbox(
                              value: isFemale,
                              onChanged: (bool? newValue) {
                                setState(() {
                                  isFemale = newValue!;
                                  if (isFemale) {
                                    isMale = false;
                                  }
                                });
                              },
                            ),
                            Text('Female'),
                          ],
                        ),
                      ),
                      buildTextFormField(
                        controller: contactInformationController,
                        labelText: 'Contact Info',
                        suffixIcon: Icons.phone,
                        keyboardType: TextInputType.phone,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please enter your number';
                          } else if (value.length != 11) {
                            return 'Phone number must be 11 digits';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 20),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 10, horizontal: 20),
                        child: Container(
                          width: double.infinity,
                          height: 55,
                          decoration: BoxDecoration(
                            color: Color(0xff7c77d1),
                            borderRadius: BorderRadius.circular(50.0),
                          ),
                          child: MaterialButton(
                            child: Text(
                              'Sign Up',
                              style: TextStyle(
                                fontSize: 20.0,
                                color: Colors.white,
                              ),
                            ),
                            onPressed: () {
                              if (_formKey.currentState!.validate()) {
                                signUp(context);
                              }
                            },
                          ),
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text("Have an account?"),
                          TextButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => Login(),
                                ),
                              );
                            },
                            child: Text(
                              'Log in',
                              style: TextStyle(color: Color(0xFF7165D6)),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildTextFormField({
    required TextEditingController controller,
    required String labelText,
    required IconData suffixIcon,
    TextInputType? keyboardType,
    bool obscureText = false,
    String? Function(String?)? validator,
    VoidCallback? onTapSuffix,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      child: TextFormField(
        controller: controller,
        validator: validator,
        obscureText: obscureText,
        keyboardType: keyboardType,
        decoration: InputDecoration(
          suffixIcon: GestureDetector(
            onTap: onTapSuffix,
            child: Icon(suffixIcon),
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(50.0),
          ),
          labelText: labelText,
        ),
      ),
    );
  }
}