import 'package:flutter/material.dart';

class AboutPage extends StatelessWidget {
  AboutPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'About This App',
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white),
        ),
        backgroundColor: Color.fromARGB(255, 159, 41, 33), // Custom color for professionalism
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            Text(
              'This application is a capstone project developed by a group of students known as A3J. It serves as a platform to provide feedback and assessment tools tailored for the Batangas State University community.',
              style: TextStyle(fontSize: 16, height: 1.5), // Added line height for readability
            ),
            SizedBox(height: 24), // Increased spacing for better separation
            Text(
              'Target Audience:',
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.black), // Color for emphasis
            ),
            SizedBox(height: 8),
            Text(
              'The app focuses on Grade 10, Grade 12, and 4th-year college students who seek recommendations on choosing the best career paths based on their interests, IQ, and skills.',
              style: TextStyle(fontSize: 16, height: 1.5),
            ),
            SizedBox(height: 24),
            Text(
              'Questionnaires:',
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.black),
            ),
            SizedBox(height: 8),
            Text(
              'The questionnaires within the application are validated by registered psychometricians from Batangas State University, ensuring the accuracy and relevance of the assessments.',
              style: TextStyle(fontSize: 15, height: 1.5),
            ),
            SizedBox(height: 24),
            Text(
              'Developers:',
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.black),
            ),
            SizedBox(height: 8),
            Text(
              '1. Dimapilis, Jose Gabrielle M.\n'
                  '2. Guevarra, Joice Dian R.\n'
                  '3. Lat, Ma. Anna Guada G.\n'
                  '4. Tabbada, Jewel Lei L.\n',
              style: TextStyle(fontSize: 14, height: 1.5),
            ),
            SizedBox(height: 10),
            Text(
              'Contact Us:',
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.black),
            ),
            SizedBox(height: 8),
            Text(
              'Email: batstateu.tneu.educast@gmail.com\n',
              style: TextStyle(fontSize: 13, height: 1.5),
            ),
            SizedBox(height: 24),
            Text(
              'Version: 1.0.0',
              style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Colors.blueAccent),
            ),
            SizedBox(height: 8),


          ],
        ),
      ),
    );
  }
}
