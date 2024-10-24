import 'package:educast/LoginSignUpPages/LoginSignupPage.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SettingsPage extends StatefulWidget {
  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool _notificationsEnabled = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Settings'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: ListView(
        padding: EdgeInsets.all(16.0),
        children: [
          // Notification Switch
          SwitchListTile(
            title: Text('Enable Notifications'),
            value: _notificationsEnabled,
            onChanged: (bool value) {
              setState(() {
                _notificationsEnabled = value;
                // Implement your notification logic here
              });
            },
            secondary: Icon(_notificationsEnabled
                ? Icons.notifications_active
                : Icons.notifications_off),
          ),
          Divider(),

          // Account Settings Section
          ListTile(
            leading: Icon(Icons.person),
            title: Text('Account Settings'),
            onTap: () {
              // Navigate to Account Settings Page
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AccountSettingsPage()),
              );
            },
          ),
          Divider(),

          // Privacy Policy Section
          ListTile(
            leading: Icon(Icons.privacy_tip),
            title: Text('Privacy Policy'),
            onTap: () {
              // Navigate to Privacy Policy Page
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => PrivacyPolicyPage()),
              );
            },
          ),
          Divider(),
        ],
      ),
    );
  }
}

class AccountSettingsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Account Settings'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ElevatedButton.icon(
              onPressed: () {
                _showConfirmationDialog(
                  context,
                  "Deactivate Account",
                  "Are you sure you want to deactivate your account? You can reactivate it later by logging in again.",
                  _deactivateAccount,
                  Icons.person_off,
                );
              },
              icon: Icon(Icons.person_off),
              label: Text('Deactivate Account'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.grey[300],
                padding: EdgeInsets.symmetric(vertical: 12.0),
                textStyle: TextStyle(fontSize: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                elevation: 2, // Add some elevation for a subtle shadow
              ),
            ),
            SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: () {
                _showConfirmationDialog(
                  context,
                  "Remove Account",
                  "Are you sure you want to permanently remove your account? This action cannot be undone.",
                  _removeAccount,
                  Icons.delete_forever,
                );
              },
              icon: Icon(Icons.delete_forever),
              label: Text('Remove Account'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red[100],
                padding: EdgeInsets.symmetric(vertical: 12.0),
                textStyle: TextStyle(fontSize: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                elevation: 2, // Add some elevation for a subtle shadow
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _deactivateAccount(BuildContext context) async {
    try {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const LoginSignupPage(),
        ),
      );
      await FirebaseAuth.instance.signOut();

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Account deactivated successfully.")),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: Unable to deactivate account.")),
      );
    }
  }

  Future<void> _removeAccount(BuildContext context) async {
    User? user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      try {
        await FirebaseAuth.instance.signOut();
        await user.delete();
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const LoginSignupPage(),
          ),
        );
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Account removed successfully.")),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Error: Unable to remove account.")),
        );
      }
    }
  }

  void _showConfirmationDialog(BuildContext context, String title,
      String message, Function onConfirm, IconData icon) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Row(
            children: [
              Icon(icon, color: Colors.blue),
              SizedBox(width: 8),
              Text(title, style: TextStyle(fontSize: 20)),
            ],
          ),
          content: SingleChildScrollView(
            child: Container(
              width: MediaQuery.of(context).size.width * 0.9, // Adjust width
              child: Text(message),
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text("Cancel"),
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
            ),
            TextButton(
              child: Text("Confirm"),
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
                onConfirm(context); // Execute the confirmed action
              },
            ),
          ],
        );
      },
    );
  }
}

class PrivacyPolicyPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Privacy Policy'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Your privacy is important to us. This privacy policy explains how we collect, use, and share your information when you use our app.\n\n'
                    '1. Information We Collect: We collect information that you provide directly to us, such as your name, email address, and other details.\n\n'
                    '2. How We Use Your Information: We use the information we collect to provide and improve our services, communicate with you, and respond to your inquiries.\n\n'
                    '3. Sharing Your Information: We do not share your personal information with third parties without your consent, except as required by law.\n\n'
                    '4. Security: We take reasonable measures to protect your information from unauthorized access, but no security measures are perfect.\n\n'
                    '5. Changes to This Policy: We may update this privacy policy from time to time, and we will notify you of any changes by posting the new policy on this page.\n\n'
                    'If you have any questions about this privacy policy, please contact us.',
                style: TextStyle(fontSize: 16),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
