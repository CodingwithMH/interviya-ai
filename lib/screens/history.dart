import 'package:flutter/material.dart';

class History extends StatefulWidget {
    const History({super.key});

  @override
  State<History> createState() => _HistoryState();
}

class _HistoryState extends State<History> {
  bool isCompleted = true;

  
  final List<Map<String, dynamic>> allTasks = [
   
    {
      "role": "Software Developer",
      "date": "22 April 2026",
      "score": 100, 
      "icon": Icons.laptop_mac,
      "period": "This Week"
    },
    {
      "role": "Cyber Security",
      "date": "24 April 2026",
      "score": 100, 
      "icon": Icons.security,
      "period": "This Week"
    },
    {
      "role": "Data Analyst",
      "date": "Running",
      "score": 86, 
      "icon": Icons.bar_chart,
      "period": "This Week"
    },
    {
      "role": "Machine Learning",
      "date": "Running",
      "score": 30, 
      "icon": Icons.psychology,
      "period": "This Week"
    },

    
    {
      "role": "UI/UX Designer",
      "date": "12 March 2026",
      "score": 100, 
      "icon": Icons.brush,
      "period": "Last Month"
    },
    {
      "role": "Cloud Architect",
      "date": "20 March 2026",
      "score": 100, 
      "icon": Icons.cloud_done,
      "period": "Last Month"
    },
    {
      "role": "Flutter Developer",
      "date": "Running",
      "score": 88, 
      "icon": Icons.code,
      "period": "Last Month"
    },
    {
      "role": "Project Manager",
      "date": "Running",
      "score": 65, 
      "icon": Icons.assignment_ind,
      "period": "Last Month"
    },
  ];

  @override
  Widget build(BuildContext context) {
   
    final tabFilteredList = allTasks.where((task) {
      return isCompleted ? (task['score'] == 100) : (task['score'] < 100);
    }).toList();


    final thisWeekList = tabFilteredList.where((t) => t['period'] == "This Week").toList();
    final lastMonthList = tabFilteredList.where((t) => t['period'] == "Last Month").toList();

    return Scaffold(
      backgroundColor:   Color(0xFFF8FAFF),
      appBar: PreferredSize(
        preferredSize:   Size.fromHeight(80),
        child: AppBar(
          backgroundColor:   Color(0xFF0A898D),
          elevation: 0,
          centerTitle: false,
          leading: Padding(
            padding:   EdgeInsets.only(top: 10),
            child: IconButton(
              icon:   Icon(Icons.arrow_back, color: Colors.white, size: 35),
              onPressed: () => Navigator.pop(context),
            ),
          ),
          title:   Padding(
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
          shape:   RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(bottom: Radius.circular(25)),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding:   EdgeInsets.symmetric(horizontal: 20.0, vertical: 25.0),
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
                      color:   Color(0xff1E293B).withValues(alpha: 0.1),
                      blurRadius: 20,
                      offset:   Offset(0, 4),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Expanded(child: _buildTabButton("Completed", isCompleted)),
                    Expanded(child: _buildTabButton("In Progress", !isCompleted)),
                  ],
                ),
              ),
                SizedBox(height: 30),

             
              if (thisWeekList.isNotEmpty) ...[
                _buildSectionTitle("This Week"),
                ...thisWeekList.map((task) => _buildHistoryCard(task)),
                  SizedBox(height: 15),
              ],

              
              if (lastMonthList.isNotEmpty) ...[
                _buildSectionTitle("Last Month"),
                ...lastMonthList.map((task) => _buildHistoryCard(task)),
              ],

              if (thisWeekList.isEmpty && lastMonthList.isEmpty)
                  Center(
                  child: Padding(
                    padding: EdgeInsets.only(top: 50),
                    child: Text("No tasks to display."),
                  ),
                ),

                SizedBox(height: 20),

              SizedBox(
                width: double.infinity,
                height: 55,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor:   Color(0xFF0A898D),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: () {},
                  child:   Text(
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

 

  Widget _buildTabButton(String title, bool active) {
    return GestureDetector(
      onTap: () {
        setState(() {
          isCompleted = (title == "Completed");
        });
      },
      child: Container(
        margin:   EdgeInsets.all(6),
        decoration: BoxDecoration(
          color: active ?   Color(0xFF0A898D) : Colors.transparent,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Center(
          child: Text(
            title,
            style: TextStyle(
              color: active ? Colors.white :   Color(0xFF0A898D),
              fontWeight: FontWeight.bold,
              fontSize: 15,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding:   EdgeInsets.only(bottom: 15),
      child: Text(
        title,
        style:   TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Color(0xFF1E293B),
        ),
      ),
    );
  }

  Widget _buildHistoryCard(Map<String, dynamic> task) {
    return Container(
      margin:   EdgeInsets.only(bottom: 15),
      padding:   EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color:   Color(0xff1E293B).withValues(alpha: 0.08),
            blurRadius: 15,
            offset:   Offset(0, 5),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding:   EdgeInsets.all(12),
            decoration: BoxDecoration(
              color:   Color(0xFF0A898D),
              borderRadius: BorderRadius.circular(15),
            ),
            child: Icon(task['icon'], color: Colors.white, size: 28),
          ),
            SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  task['role'],
                  style:   TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: Color(0xFF1E293B),
                  ),
                ),
                  SizedBox(height: 5),
                Text(
                  task['date'],
                  style:   TextStyle(color: Color(0xff94A3B8), fontSize: 13),
                ),
              ],
            ),
          ),
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color:   Color(0xFF0A898D),
              border: Border.all(color: Colors.white, width: 2),
            ),
            child: Center(
              child: Text(
                "${task['score']}%",
                style:   TextStyle(
                  fontSize: 11,
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
}
