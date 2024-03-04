import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../profile/customContainer.dart';


class drProfile extends StatefulWidget {
  const drProfile({Key? key}) : super(key: key);


  @override
  State<drProfile> createState() => _drProfileState();
}

class _drProfileState extends State<drProfile> {
  String? skills;
  String? qualifications;

  String? email;
  String? name;
  String? phone;
  String? spec;

  @override
  void initState() {
    super.initState();
    // Call the function to fetch user data when the page loads
    fetchUserData();
  }

  Future<void> fetchUserData() async {
    // Make an HTTP request to fetch user data
    final response = await http.get(Uri.parse('http://ec2-18-220-246-59.us-east-2.compute.amazonaws.com:4000/api/healtha/specialistdoctors'));

    if (response.statusCode == 200) {
      // If the request is successful, parse the JSON response
      List<dynamic> doctorsData = jsonDecode(response.body);
      if (doctorsData.isNotEmpty) {
        // Retrieve the data for the last doctor signed up
        Map<String, dynamic> userData = doctorsData.last;
        // Update the state variables with the retrieved user data
        setState(() {
          email = userData['email'];
          name=userData['username'];
          phone=userData["contactInformation"];
          spec=userData["specialization"];
          // Update other variables if needed
        });
      } else {
        // Handle the case where the list is empty
      }
    } else {
      // If the request fails, show an error message
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Error'),
          content: Text('Failed to fetch user data'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('OK'),
            ),
          ],
        ),
      );
    }
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Stack(
              children: [
                Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height / 2.1,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage("images/dr.PNG"),
                      fit: BoxFit.cover,
                    ),
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(20),
                      bottomRight: Radius.circular(20),
                    ),
                  ),
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Color(0xff7c77d1).withOpacity(1),
                          Color(0xff7c77d1).withOpacity(0.3),
                          Color(0xff7c77d1).withOpacity(0),
                        ],
                        begin: Alignment.bottomCenter,
                        end: Alignment.topCenter,
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height / 1.2,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Patients",
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          SizedBox(height: 5),
                          Text(
                            "20",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.white70,
                            ),
                          ),
                        ],
                      ),
                      // Experience widget
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Experience",
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          SizedBox(height: 5),
                          Text(
                            "5 Years",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.white70,
                            ),
                          ),
                        ],
                      ),
                      // Specialization widget
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Specialization",
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          SizedBox(height: 5),
                          Text(
                            spec??"Loading ..",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.white70,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      SizedBox(
                        height: MediaQuery.of(context).size.height / 2.1,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            "Dr. ",
                            style: TextStyle(
                              fontSize: 26,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                          Text(
                              name ?? "Loading...",
                            style: TextStyle(
                              fontSize: 26,
                              fontWeight: FontWeight.w500,
                              color: Colors.black.withOpacity(0.7),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 25,
                      ),
                      customContainer(
                        title: "email",
                        icon1: Image.asset("assets/at.png"),
                        data: email ?? "Loading...", // Display "Loading..." if email is null
                      ),

                      SizedBox(height: 15),
                      customContainer(
                        title: "Phone Number",
                        icon1: Image.asset("assets/phone-call.png"),
                        data: phone??'loading ..',
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      // New customContainers to display skills and qualifications
                      skills != null
                          ? Padding(
                            padding: const EdgeInsets.all(7.0),
                            child: customContainer(
                              title: "Skills",
                               icon1: Image.asset("images/skill.png"),
                              data: skills!,
                                                  ),
                          )
                          : SizedBox(height: 10),
                      qualifications != null
                          ? customContainer(
                        title: "Qualifications",
                         icon1: Image.asset("images/certificate2.png"),
                        data: qualifications!,
                      )
                          : SizedBox(height: 30),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ElevatedButton.icon(
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  title: Text("Complete Your Info"),
                                  content: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      TextField(
                                        onChanged: (value) {
                                          setState(() {
                                            skills = value;
                                          });
                                        },
                                        decoration: InputDecoration(
                                          labelText: "Skills",
                                          hintText: "Enter your skills",
                                        ),
                                      ),
                                      SizedBox(height: 10),
                                      TextField(
                                        onChanged: (value) {
                                          setState(() {
                                            qualifications = value;
                                          });
                                        },
                                        decoration: InputDecoration(
                                          labelText: "Qualifications",
                                          hintText: "Enter your qualifications",
                                        ),
                                      ),
                                    ],
                                  ),
                                  actions: [
                                    TextButton(
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                      child: Text("Cancel"),
                                    ),
                                    ElevatedButton(
                                      onPressed: () {
                                        // Save skills and qualifications
                                        // You can handle saving the data to your database here
                                        Navigator.of(context).pop();
                                      },
                                      child: Text("Save"),
                                    ),
                                  ],
                                );
                              },
                            );
                          },
                          icon: Icon(Icons.edit,color: Colors.white,),
                          label: Text("Complete your info",style:
                            TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 18
                            ),),
                          style: ButtonStyle(
                            backgroundColor:
                            MaterialStateProperty.all<Color>(Color(0xff7c77d1)),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
