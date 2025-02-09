import 'package:flutter/material.dart';

class PrivacyPolicyPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Privacy Policy", style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.black,
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color.fromARGB(255, 62, 62, 62),
              Color.fromARGB(255, 0, 0, 0)
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: ListView(
            children: [
              Text("Privacy Policy", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white)),
              SizedBox(height: 10),
              Text("MUSIAX values your privacy and is committed to protecting your personal data.", style: TextStyle(color: Colors.white)),
              SizedBox(height: 10),
              _buildSection("1. Information We Collect", "We may collect personal, usage, and device information to enhance your experience."),
              _buildSection("2. How We Use Your Information", "We use data to personalize your experience, improve features, and send updates."),
              _buildSection("3. Third-Party Services", "We may use third-party services for analytics and ads."),
              _buildSection("4. Security & Data Protection", "We implement security measures to protect your data."),
              _buildSection("5. Your Rights & Choices", "You can access, update, or delete your account information."),
              _buildSection("6. Updates to This Policy", "We may update this Privacy Policy from time to time."),
              SizedBox(height: 20),
              Text("📩 Contact Us: support@musiax.com", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSection(String title, String content) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
        SizedBox(height: 5),
        Text(content, style: TextStyle(color: Colors.white)),
        SizedBox(height: 10),
      ],
    );
  }
}

class SocialPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Follow Us", style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.black,
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color.fromARGB(255, 62, 62, 62),
              Color.fromARGB(255, 0, 0, 0)
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: ListView(
            children: [
              Text("Connect with MUSIAX!", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white)),
              SizedBox(height: 10),
              _buildSocialLink("Facebook", "facebook.com/musiaxapp"),
              _buildSocialLink("Instagram", "instagram.com/musiaxapp"),
              _buildSocialLink("Twitter/X", "twitter.com/musiaxapp"),
              _buildSocialLink("YouTube", "youtube.com/musiaxapp"),
              SizedBox(height: 20),
              Text("💬 Join our community to share music and get updates!", style: TextStyle(color: Colors.white)),
              SizedBox(height: 20),
              Text("📩 Contact: social@musiax.com", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSocialLink(String platform, String url) {
    return ListTile(
      leading: Icon(Icons.link, color: Colors.blue),
      title: Text(platform, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
      subtitle: Text(url, style: TextStyle(color: Colors.blue)),
      onTap: () {},
    );
  }
}
