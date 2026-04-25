import 'package:flutter/material.dart';
class History extends StatefulWidget {
  const History({super.key});
  @override
  State<History> createState() => _HistoryState();
}
class _HistoryState extends State<History> {
  bool isCompleted = true;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF8FAFF),
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(80.0),
        child: AppBar(
          backgroundColor: Color(0xFF0A898D),
          elevation: 0,
          leading: Padding(
            padding: EdgeInsets.only(top: 10),
            child: IconButton(
              icon: Icon(Icons.arrow_back, color: Colors.white, size: 40),
              onPressed: () => Navigator.pop(context),
            ),
          ),
          title: Padding(
            padding: EdgeInsets.only(top: 20),
            child: Text(
              "History",
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(bottom: Radius.circular(25)),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding:  EdgeInsets.symmetric(horizontal: 20.0, vertical: 25.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: double.infinity,
                height: 55,
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
                child: Row(
                  children: [
                    Expanded(child: _buildTabButton("Completed", isCompleted)),
                    Expanded(
                      child: _buildTabButton("In Progress", !isCompleted),
                    ),
                  ],
                ),
              ),
               SizedBox(height: 30),
              _buildSectionTitle("This Week"),
              _buildHistoryCard(
                "Software Developer",
                "3 October 2025",
                "86%",
                Icons.laptop_mac,
              ),
              _buildHistoryCard(
                "Data Analyst",
                "18 November 2025",
                "86%",
                Icons.bar_chart,
              ),
               SizedBox(height: 15),
              _buildSectionTitle("Last Month"),
              _buildHistoryCard(
                "UI/UX Designer",
                "12 September 2025",
                "92%",
                Icons.brush,
              ),
              _buildHistoryCard(
                "Flutter Developer",
                "05 September 2025",
                "88%",
                Icons.code,
              ),
              SizedBox(height: 25),
              SizedBox(
                width: double.infinity,
                height: 55,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor:  Color(0xFF0A898D),
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: () {},
                  child:  Text(
                    "View All History",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 17,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
               SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: EdgeInsets.only(bottom: 15),
      child: Text(
        title,
        style:  TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Color(0xFF1E293B),
        ),
      ),
    );
  }

  Widget _buildHistoryCard(
    String role,
    String date,
    String score,
    IconData icon,
  ) {
    return Container(
      margin:  EdgeInsets.only(bottom: 15),
      padding:  EdgeInsets.all(15),
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
            padding: EdgeInsets.all(12),
            decoration: BoxDecoration(
              color:  Color(0xFF0A898D),
              borderRadius: BorderRadius.circular(15),
            ),
            child: Icon(icon, color:  Colors.white, size: 30),
          ),
           SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  role,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: Color(0xFF1E293B),
                  ),
                ),
                 SizedBox(height: 5),
                Text(
                  date,
                  style:  TextStyle(color: Color(0xff94A3B8), fontSize: 13),
                ),
              ],
            ),
          ),
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Color(0xFF0A898D),
              border: Border.all(color:  Color(0xFF0A898D), width: 2.5),
            ),
            child: Center(
              child: Text(
                score,
                style:  TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTabButton(String title, bool active) {
    return GestureDetector(
      onTap: () {
        setState(() {
          isCompleted = (title == "Completed");
        });
      },
      child: Container(
        margin:  EdgeInsets.all(6),
        decoration: BoxDecoration(
          color: active ?] Color(0xFF0A898D) : Colors.transparent,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Center(
          child: Text(
            title,
            style: TextStyle(
              color: active ? Colors.white :  Color(0xFF0A898D),
              fontWeight: FontWeight.bold,
              fontSize: 15,
            ),
          ),
        ),
      ),
    );
  }
}

