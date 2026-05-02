import 'package:flutter/material.dart';
import 'package:flutter_project/screens/interview_setup.dart';
import 'package:flutter_project/screens/feedback.dart';
import 'package:flutter_project/screens/help.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  String searchQuery = "";
  String selectedCategory = "All";

  final List<Map<String, dynamic>> allInterviews = [
    {
      "title": "Software Developer",
      "icon": Icons.laptop_mac,
      "cat": "Technical",
      "count": 32,
    },
    {
      "title": "Data Analyst",
      "icon": Icons.bar_chart_rounded,
      "cat": "Technical",
      "count": 28,
    },
    {
      "title": "HR Manager",
      "icon": Icons.people,
      "cat": "Management",
      "count": 15,
    },
    {
      "title": "Soft Skills",
      "icon": Icons.chat,
      "cat": "Behavioral",
      "count": 45,
    },
  ];

  @override
  Widget build(BuildContext context) {
    List filteredInterviews = allInterviews.where((item) {
      bool matchesSearch = item['title'].toLowerCase().contains(
        searchQuery.toLowerCase(),
      );
      bool matchesCat =
          selectedCategory == "All" || item['cat'] == selectedCategory;
      return matchesSearch && matchesCat;
    }).toList();

    return Scaffold(
      backgroundColor: Color(0xFFF8FAFF),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildHeader(context),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 15),
                  _buildSearchBar(),
                  SizedBox(height: 15),
                  _buildReadinessCard(),
                  SizedBox(height: 15),
                  _buildCategoryFilters(),
                  SizedBox(height: 15),
                  Text(
                    "Recommended Interviews",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF0A898D),
                    ),
                  ),
                  SizedBox(height: 15),
                 
                  ...filteredInterviews.map(
                    (item) => _buildInterviewCard(
                      item['title'],
                      item['icon'],
                      item['count'],
                    ),
                  ),
                  SizedBox(height: 100),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Stack(
      children: [
        Container(
          height: 100,
          width: double.infinity,
          color: Color(0xFF0A898D),
        ),

        Padding(
          padding: EdgeInsetsGeometry.fromLTRB(0, 60, 0, 0),
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            decoration: BoxDecoration(
              color: Colors.white,

              borderRadius: BorderRadius.vertical(top: Radius.circular(25)),

              boxShadow: [
                BoxShadow(
                  color: Color(0xff1E293B).withValues(alpha: 0.1),
                  blurRadius: 20,
                  offset: Offset(0, 4),
                ),
              ],
            ),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 25,
                  backgroundImage: AssetImage("assets/images/user.png"),
                ),
                SizedBox(width: 12),

                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        "Welcome Back, Zainab!",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                          color: Color(0xFF1E293B),
                        ),
                      ),
                      Text(
                        "Let's practice today",
                        style: TextStyle(color: Colors.grey, fontSize: 12),
                      ),
                    ],
                  ),
                ),

                IconButton(
                  icon: Icon(
                    Icons.notifications,
                    color: Color(0xFF94A3B8),
                    size: 22,
                  ),
                  onPressed: () {
                    
                  },
                ),

                PopupMenuButton<String>(
                  padding: EdgeInsets.zero,
                  
                  color: Colors.white,
                  elevation: 8,
                  
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  icon: Icon(
                    Icons.more_vert,
                    color: Color(0xFF94A3B8),
                    size: 22,
                  ),
                  onSelected: (value) {
                    if (value == 'feedback') {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => FeedbackScreen(),
                        ),
                      );
                    } else if (value == 'help') {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) =>  Help()),
                      );
                    }
                  },
                  itemBuilder: (context) => [
                    PopupMenuItem(
                      value: 'feedback',
                      child: Row(
                        children:  [
                          Icon(
                            Icons.feedback_outlined,
                            size: 20,
                            color: Color(0xFF0A898D),
                          ),
                          SizedBox(width: 12),
                          Text(
                            'Feedback',
                            style: TextStyle(
                              color: Color(0xFF1E293B),
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),
                    PopupMenuItem(
                      value: 'help',
                      child: Row(
                        children:  [
                          Icon(
                            Icons.help_outline_rounded,
                            size: 20,
                            color: Color(0xFF0A898D),
                          ),
                          SizedBox(width: 12),
                          Text(
                            'Help',
                            style: TextStyle(
                              color: Color(0xFF1E293B),
                              fontSize: 14,
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
        ),
      ],
    );
  }

  Widget _buildSearchBar() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Color(0xff1E293B).withValues(alpha: 0.1),
            blurRadius: 20,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: TextField(
        onChanged: (value) => setState(() => searchQuery = value),
        decoration: InputDecoration(
          hintText: "Search roles (e.g. Flutter Dev)",
          hintStyle: TextStyle(color: Colors.grey, fontSize: 14),
          prefixIcon: Icon(Icons.search, color: Colors.grey),
          suffixIcon: Icon(Icons.tune, color: Color(0xFF0A898D)),
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(vertical: 15),
        ),
      ),
    );
  }

  Widget _buildReadinessCard() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Color(0xff1A237E).withValues(alpha: 0.15),
            blurRadius: 20,
            offset: Offset(0, -10),
          ),
        ],
        gradient: LinearGradient(
          colors: [Color(0xFF0CBABF), Color(0xFF0A898D)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(25),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Current Readiness",
                style: TextStyle(color: Colors.white70, fontSize: 14),
              ),
              SizedBox(height: 5),
              Text(
                "78%",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 40,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),

          SizedBox(
            height: 70,
            width: 70,
            child: CircularProgressIndicator(
              value: 0.78,
              strokeWidth: 8,
              backgroundColor: Colors.white24,
              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryFilters() {
    final categories = ["All", "Technical", "Behavioral", "Management"];
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: categories.map((cat) {
          bool isSelected = selectedCategory == cat;
          return GestureDetector(
            onTap: () => setState(() => selectedCategory = cat),
            child: Container(
              margin: EdgeInsets.only(right: 8),
              padding: EdgeInsets.symmetric(horizontal: 18, vertical: 10),
              decoration: BoxDecoration(
                color: isSelected ? Color(0xFF0A898D) : Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: isSelected ? Colors.transparent : Colors.grey.shade200,
                ),
              ),
              child: Text(
                cat,
                style: TextStyle(
                  color: isSelected ? Colors.white : Colors.grey,
                  fontWeight: FontWeight.w600,
                  fontSize: 13,
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildInterviewCard(String title, IconData icon, int count) {
    return Container(
      margin: EdgeInsets.only(bottom: 12),
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Color(0xff1E293B).withValues(alpha: 0.1),
            blurRadius: 20,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Color(0xFFF1F5F9),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: Color(0xFF0A898D), size: 28),
          ),
          SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
              ),
              Text(
                "$count Interviews taken",
                style: TextStyle(color: Colors.grey, fontSize: 12),
              ),
            ],
          ),
          Spacer(),
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => InterviewSetup()),
              );
            },
            child: Icon(
              Icons.play_circle_fill,
              color: Color(0xFF0A898D),
              size: 40,
            ),
          ),
        ],
      ),
    );
  }
}