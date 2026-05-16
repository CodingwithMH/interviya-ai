import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:interviya/data/providers/user_provider.dart';
import 'package:interviya/screens/interview_setup.dart';
import 'package:interviya/screens/feedback.dart';
import 'package:interviya/screens/help.dart';
import 'package:interviya/screens/upload.dart';
import 'package:provider/provider.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  String searchQuery = "";
  String selectedCategory = "All";
  String userName = "User";
  String? profileImage;
  bool isLoading = true;
  List<Map<String, dynamic>> _interviews = [];
List<String> _categories = ["All"]; 
bool isDataLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchDatabaseData();
  }

  Future<void> _fetchDatabaseData() async {
    try {
      final firestore = FirebaseFirestore.instance;
      final catSnapshot = await firestore.collection('categories').get();
      Map<String, String> tempMap = {};
      for (var doc in catSnapshot.docs) {
        tempMap[doc.data()['id']] = doc.data()['name'];
      }

      final fetchedCats = tempMap.values.toList();
      final intSnapshot = await firestore.collection('interviews').get();

      final fetchedInterviews = intSnapshot.docs.map((doc) {
        Map<String, dynamic> data = doc.data();

        return {
          "id": doc.id,
          "title": data['title'] ?? 'Untitled',
          "description": data['description'] ?? 'No description available.',
          "cat": tempMap[data['categoryId']] ?? 'General',
          "icon": IconData(
            data['iconCode'] ?? Icons.work.codePoint,
            fontFamily: 'MaterialIcons',
          ),
          "count": data['count'] ?? 0,
        };
      }).toList();

      if (mounted) {
        setState(() {
          _categories = ["All", ...fetchedCats];
          _interviews = fetchedInterviews;
          isDataLoading = false;
        });
      }
    } catch (e) {
      debugPrint("Error fetching data: $e");
      if (mounted) {
        setState(() => isDataLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    final currentUser = userProvider.currentUser;

    final String displayUserName = currentUser?.fullName ?? "User";
    final String? displayProfileImage = currentUser?.avatarPath;

    List filteredInterviews = _interviews.where((item) {
      bool matchesSearch = item['title'].toLowerCase().contains(searchQuery.toLowerCase());
      bool matchesCat = selectedCategory == "All" || item['cat'] == selectedCategory;
      return matchesSearch && matchesCat;
    }).toList();

    return Scaffold(
      backgroundColor: Color(0xFFF8FAFF),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildHeader(context, displayUserName, displayProfileImage, currentUser),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 15),
                  _buildReadinessCard(),
                  SizedBox(height: 15),
                  _buildSearchBar(),
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
                    (item) => _buildInterviewCard(item),
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

  Widget _buildHeader(BuildContext context, String userName, String? profileImage, dynamic currentUser) {
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
                backgroundColor: Colors.grey.shade200,
                backgroundImage: profileImage != null 
                    ? NetworkImage(profileImage) as ImageProvider
                    : const AssetImage("assets/images/user.png"),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      "Welcome Back, $userName!",
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                        color: Color(0xFF1E293B),
                      ),
                    ),
                    const Text(
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
                    if (value=='upload'){
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => Upload(),
                        ),
                      );
                    }
                    else if (value == 'feedback') {
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
                    if (currentUser?.isAdmin ?? false) 
      const PopupMenuItem(
        value: 'upload',
        child: Row(
          children: [
            Icon(Icons.cloud_upload_outlined, size: 20, color: Color(0xFF0A898D)),
            SizedBox(width: 12),
            Text(
              'Upload Item',
              style: TextStyle(color: Color(0xFF1E293B), fontSize: 14),
            ),
          ],
        ),
      ),
                    PopupMenuItem(
                      value: 'feedback',
                      child: Row(
                        children:  [
                          Icon( Icons.feedback_outlined, size: 20, color: Color(0xFF0A898D), ),
                          SizedBox(width: 12),
                          Text( 'Feedback', style: TextStyle( color: Color(0xFF1E293B), fontSize: 14, ), ),
                        ],
                      ),
                    ),
                    PopupMenuItem(
                      value: 'help',
                      child: Row(
                        children:  [
                          Icon( Icons.help_outline_rounded, size: 20, color: Color(0xFF0A898D), ),
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
            color: Colors.black.withValues(alpha: 0.3),
            blurRadius: 10,
            offset: Offset(0, 5),
          ),
        ],
        gradient: LinearGradient(
          colors: [Color(0xFF0CBABF), Color(0xFF0A898D)],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
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
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: _categories.map((cat) {
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

Widget _buildInterviewCard(Map<String, dynamic> interview) {
  return Container(
    margin: const EdgeInsets.only(bottom: 12),
    padding: const EdgeInsets.all(12),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(20),
      boxShadow: [
        BoxShadow(
          color: const Color(0xff1E293B).withValues(alpha: 0.1),
          blurRadius: 20,
          offset: const Offset(0, 4),
        ),
      ],
    ),
    child: Row(
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: const Color(0xFFF1F5F9),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(interview['icon'], color: const Color(0xFF0A898D), size: 28),
        ),
        const SizedBox(width: 12),
        
        // 💡 1. Wrap Column in Expanded so it calculates its max width constraint properly
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min, // Keep it compact vertically
            children: [
              Text(
                interview['title'],
                // 💡 2. Add overflow behavior property styles here
                maxLines: 1, 
                overflow: TextOverflow.ellipsis, 
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
              ),
              const SizedBox(height: 2), // Tiny spacing buffer
              Text(
                "${interview['count']} Interviews taken",
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(color: Colors.grey, fontSize: 12),
              ),
            ],
          ),
        ),
        
        const SizedBox(width: 8),
        
        GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => InterviewSetup(interview: interview)),
            );
          },
          child: const Icon(
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