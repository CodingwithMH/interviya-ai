import 'package:flutter/material.dart';
import 'package:interviya/data/models/history_model.dart';
import 'package:interviya/data/services/auth_service.dart';
import 'package:interviya/screens/history_item_summary.dart';
import 'package:interviya/widgets/custom_appbar.dart';
import 'package:intl/intl.dart';
import 'package:shimmer/shimmer.dart';

class History extends StatefulWidget {
  final VoidCallback onBack;
  const History({super.key, required this.onBack});

  @override
  State<History> createState() => _HistoryState();
}

class _HistoryState extends State<History> {
  bool isCompleted = true;
  bool showAll = false;
  final ScrollController _scrollController = ScrollController();

  String _calculatePeriod(DateTime date) {
    DateTime now = DateTime.now();
    int differenceInDays = now.difference(date).inDays;
    
    if (differenceInDays <= 7) {
      return "This Week";
    } else if (differenceInDays <= 30) {
      return "Last Month";
    } else {
      return "Older Tasks";
    }
  }

  void _handleScroll() {
    if (showAll) {
      Future.delayed(const Duration(milliseconds: 200), () {
        if (_scrollController.hasClients) {
          _scrollController.animateTo(
            _scrollController.position.maxScrollExtent,
            duration: const Duration(milliseconds: 500),
            curve: Curves.easeOut,
          );
        }
      });
    } else {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          0,
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeIn,
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFF),
      appBar: CustomAppbar(text: "History", onBack: widget.onBack),
      body: StreamBuilder<List<HistoryModel>>(
        stream: AuthService().getUserHistoryStream(),
        builder: (context, snapshot) {
          // 💡 Catch the initial waiting state early to keep layout boundaries clean
          final bool isStreamLoading = snapshot.connectionState == ConnectionState.waiting;
          
          if (snapshot.hasError) {
            return Center(child: Text("Error loading data: ${snapshot.error}"));
          }

          final allTasks = snapshot.data ?? [];

          final List<HistoryModel> thisWeekAll = [];
          final List<HistoryModel> lastMonthAll = [];
          final List<HistoryModel> olderAll = [];

          // Only sort tasks if we are not actively waiting for data stream chunk initialization
          if (!isStreamLoading) {
            for (final task in allTasks) {
              final int score = task.completionPercentage;
              final bool matchesTab = isCompleted ? (score == 100) : (score < 100);

              if (matchesTab) {
                final period = _calculatePeriod(task.timestamp);
                if (period == "This Week") {
                  thisWeekAll.add(task);
                } else if (period == "Last Month") {
                  lastMonthAll.add(task);
                } else {
                  olderAll.add(task);
                }
              }
            }
          }

          final int totalFilteredCount = thisWeekAll.length + lastMonthAll.length + olderAll.length;

          final thisWeekDisplay = showAll ? thisWeekAll : thisWeekAll.take(2).toList();
          final lastMonthDisplay = showAll ? lastMonthAll : lastMonthAll.take(2).toList();
          final olderDisplay = showAll ? olderAll : olderAll.take(2).toList();

          return ScrollConfiguration(
            behavior: ScrollConfiguration.of(context).copyWith(scrollbars: false),
            child: SingleChildScrollView(
              controller: _scrollController,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 25.0),
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
                            color: const Color(0xff1E293B).withValues(alpha: 0.1),
                            blurRadius: 20,
                            offset: const Offset(0, 4),
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
                    const SizedBox(height: 30),

                    // 💡 STREAM LOADING SKELETON TREE INNER BLOCK
                    if (isStreamLoading) ...[
                      _buildSectionTitle("This Week"),
                      _buildHistoryCardSkeleton(),
                      _buildHistoryCardSkeleton(),
                      const SizedBox(height: 15),
                      _buildSectionTitle("Last Month"),
                      _buildHistoryCardSkeleton(),
                    ] 
                    
                    // ACTIVE DATA RENDER PIPELINE BLOCK
                    else ...[
                      if (thisWeekAll.isNotEmpty) ...[
                        _buildSectionTitle("This Week"),
                        ...thisWeekDisplay.map((task) => _buildHistoryCard(context ,task)),
                        const SizedBox(height: 15),
                      ],

                      if (lastMonthAll.isNotEmpty) ...[
                        _buildSectionTitle("Last Month"),
                        ...lastMonthDisplay.map((task) => _buildHistoryCard(context ,task)),
                        const SizedBox(height: 15),
                      ],

                      if (olderAll.isNotEmpty) ...[
                        _buildSectionTitle("Older History"),
                        ...olderDisplay.map((task) => _buildHistoryCard(context ,task)),
                        const SizedBox(height: 15),
                      ],

                      if (totalFilteredCount == 0)
                        const Center(
                          child: Padding(
                            padding: EdgeInsets.only(top: 50),
                            child: Text("No Interview to display.", style: TextStyle(color: Color(0xff94A3B8))),
                          ),
                        ),

                      const SizedBox(height: 10),

                      if (totalFilteredCount > 2)
                        SizedBox(
                          width: double.infinity,
                          height: 55,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF0A898D),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            onPressed: () {
                              setState(() {
                                showAll = !showAll;
                              });
                              _handleScroll();
                            },
                            child: Text(
                              showAll ? "View Less History" : "View All History",
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 17,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                    ],
                    const SizedBox(height: 30),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildTabButton(String title, bool active) {
    return GestureDetector(
      onTap: () {
        setState(() {
          isCompleted = (title == "Completed");
          showAll = false;
        });
      },
      child: Container(
        margin: const EdgeInsets.all(6),
        decoration: BoxDecoration(
          color: active ? const Color(0xFF0A898D) : Colors.transparent,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Center(
          child: Text(
            title,
            style: TextStyle(
              color: active ? Colors.white : const Color(0xFF0A898D),
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
      padding: const EdgeInsets.only(bottom: 15),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Color(0xFF1E293B),
        ),
      ),
    );
  }

Widget _buildHistoryCard(BuildContext context, HistoryModel task) {
  IconData displayIcon = Icons.assignment;
  
  // Icon fallback selector based on mode strings
  final String mode = task.mode.toLowerCase();
  if (mode.contains('developer') || mode.contains('software')) {
    displayIcon = Icons.laptop_mac;
  } else if (mode.contains('security')) {
    displayIcon = Icons.security;
  } else if (mode.contains('analyst') || mode.contains('data')) {
    displayIcon = Icons.bar_chart;
  } else if (mode.contains('design') || mode.contains('ui') || mode.contains('ux')) {
    displayIcon = Icons.brush;
  }

  final String formattedDate = DateFormat('MMM dd, yyyy').format(task.timestamp);

  final int scoreDisplayValue = int.tryParse(task.overallScore ?? '') ?? task.completionPercentage;

  return GestureDetector(
    onTap: () {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => HistoryItemSummary(history: task),
        ),
      );
    },
    child: Container(
      margin: const EdgeInsets.only(bottom: 15),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: const Color(0xff1E293B).withValues(alpha: 0.08),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFF0A898D),
              borderRadius: BorderRadius.circular(15),
            ),
            child: Icon(displayIcon, color: Colors.white, size: 28),
          ),
          const SizedBox(width: 15),
          
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  task.interviewTitle.isNotEmpty ? task.interviewTitle : 'Interview Session',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: Color(0xFF1E293B),
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  formattedDate,
                  style: const TextStyle(color: Color(0xff94A3B8), fontSize: 13),
                ),
              ],
            ),
          ),
          const SizedBox(width: 15),
          
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: const Color(0xFF0A898D),
              border: Border.all(color: Colors.white, width: 2),
            ),
            child: Center(
              child: Text(
                "$scoreDisplayValue%",
                style: const TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    ),
  );
}

  Widget _buildHistoryCardSkeleton() {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade200,
      highlightColor: Colors.grey.shade50,
      child: Container(
        margin: const EdgeInsets.only(bottom: 15),
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          children: [
            // Icon Square Block Mask
            Container(
              width: 52,
              height: 52,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),
              ),
            ),
            const SizedBox(width: 15),
            // Text Meta Info Masks
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: double.infinity,
                    height: 15,
                    color: Colors.white,
                  ),
                  const SizedBox(height: 8),
                  Container(
                    width: 100,
                    height: 11,
                    color: Colors.white,
                  ),
                ],
              ),
            ),
            const SizedBox(width: 25),
            // Percentage Circle Mask
            Container(
              width: 48,
              height: 48,
              decoration: const BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
              ),
            ),
          ],
        ),
      ),
    );
  }
  }