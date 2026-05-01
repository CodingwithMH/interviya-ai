import 'package:flutter/material.dart';

class Profile extends StatefulWidget {
    const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF8FAFF),
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(80),
        child: AppBar(
          backgroundColor: Color(0xFF0A898D),
          elevation: 0,
          leading: Padding(
            padding: EdgeInsets.only(top: 10),
            child: IconButton(
              icon: Icon(Icons.arrow_back, color: Colors.white, size: 35),
              onPressed: () => Navigator.pop(context),
            ),
          ),
          title: Padding(
            padding: EdgeInsets.only(top: 20),
            child: Text(
              "Profile",
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(bottom: Radius.circular(25)),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 30),
           
            Center(
              child: Stack(
                alignment: Alignment.center,
                children: [
              
                  Container(
                    width: 155, 
                    height: 155,
                    decoration:   BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [Color(0xFF0A898D), Color(0xFF032627)],
                      ),
                    ),
                    child: Container(
                      margin:   EdgeInsets.all(12), 
                      decoration:   BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white,
                      ),
                      child:   CircleAvatar(
                        radius: 60,
                        backgroundImage: AssetImage("assets/images/user.png"),
                      ),
                    ),
                  ),

               
                  Positioned(
                    bottom: 8,
                    right: 8,
                    child: Container(
                      padding:   EdgeInsets.all(5),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            blurRadius: 5,
                            color: Colors.black.withValues(alpha: 0.2),
                            offset:   Offset(0, 2),
                          ),
                        ],
                      ),
                      child:   Icon(
                        Icons.edit,
                        color: Colors.orange,
                        size: 22,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 15),
            Text(
              "Personal Details",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1E293B),
              ),
            ),
            SizedBox(height: 25),

            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  Container(
                    padding: EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(25),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.05),
                          blurRadius: 15,
                          offset: Offset(0, 5),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        _buildDetailRow("Full Name:", "Muhammad Hammad"),
                        _buildDetailRow(
                          "Education:",
                          "BS Software Engineering",
                        ),
                        _buildDetailRow("Target Role:", "Flutter Developer"),
                        _buildDetailRow("Location:", "Faisalabad, Pakistan"),
                        _buildDetailRow("Experience Level:", "Beginner"),
                        _buildDetailRow(
                          "Email:",
                          "hammadtheta@gmail.com",
                          isLast: true,
                        ),
                      ],
                    ),
                  ),
                  Positioned(
                    bottom: -25,
                    right: 20,
                    child: FloatingActionButton.small(
                      onPressed: () {},
                      backgroundColor: Color(0xFF0A898D),
                      child: Icon(Icons.edit, color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(height: 50),

   
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Container(
                padding: EdgeInsets.all(20),
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(25),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.05),
                      blurRadius: 15,
                      offset: Offset(0, 5),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Skill Badges",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF1E293B),
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Row(
                            children: [
                              Icon(
                                Icons.verified,
                                color: Color(0xFF0A898D),
                                size: 20,
                              ),
                              SizedBox(width: 4),
                              Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: Colors.grey.shade200,
                                ),

                                child: Text(
                                  " AI Verified",
                                  style: TextStyle(fontSize: 10),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 15),
                    Wrap(
                      spacing: 10,
                      runSpacing: 10,
                      children: [
                        _buildBadge("Problem Solver", Color(0xFF0A898D)),
                        _buildBadge("Clean Coder", Color(0xFF0A898D)),
                        _buildBadge("Fast Communicator", Color(0xFF0A898D)),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value, {bool isLast = false}) {
    return Padding(
      padding: EdgeInsets.only(bottom: isLast ? 0 : 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontWeight: FontWeight.w600,
              color: Color(0xff1E293B),
              fontSize: 13,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Color(0xff94A3B8),
              fontSize: 13,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBadge(String label, Color color) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: color,
          fontWeight: FontWeight.bold,
          fontSize: 13,
        ),
      ),
    );
  }
}
