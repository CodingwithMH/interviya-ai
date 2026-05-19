import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:provider/provider.dart';
import 'package:interviya/data/models/history_model.dart';
import 'package:interviya/data/providers/history_provider.dart';

class Stats extends StatefulWidget {
  final VoidCallback onBack;
  const Stats({super.key, required this.onBack});

  @override
  State<Stats> createState() => _StatsState();
}

class _StatsState extends State<Stats> {
  @override
  Widget build(BuildContext context) {
    final historyProvider = context.watch<HistoryProvider>();

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFF),
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60),
        child: AppBar(
          backgroundColor: const Color(0xFF0A898D),
          elevation: 0,
          leading: Padding(
            padding: const EdgeInsets.only(top: 5),
            child: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.white, size: 35),
              onPressed: widget.onBack,
            ),
          ),
          title: const Padding(
            padding: EdgeInsets.only(top: 5),
            child: Text(
              "Analytics",
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(bottom: Radius.circular(25)),
          ),
        ),
      ),
      body: _buildBody(historyProvider),
    );
  }

  Widget _buildBody(HistoryProvider provider) {
    if (provider.isLoading) {
      return const Center(
        child: CircularProgressIndicator(color: Color(0xFF0A898D)),
      );
    }

    if (provider.errorMessage != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Text(
            "Error loading analytics data: ${provider.errorMessage}",
            textAlign: TextAlign.center,
            style: const TextStyle(color: Colors.redAccent),
          ),
        ),
      );
    }

    // Safely look up categorized history via our updated type-safe system
    final categorizedData = provider.getCategorizedHistory();
    
    final historyList = categorizedData.totalFilteredCount > 0 
        ? categorizedData.thisWeek + categorizedData.lastMonth + categorizedData.older
        : <HistoryModel>[];

    if (historyList.isEmpty) {
      return const Center(
        child: Text(
          "No interview history found.\nComplete an interview to see data analytics!",
          textAlign: TextAlign.center,
          style: TextStyle(color: Colors.grey, fontSize: 16),
        ),
      );
    }

    return ScrollConfiguration(
      behavior: const ScrollBehavior().copyWith(scrollbars: false),
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 10),
            _buildHireProbabilityCard(historyList),
            const SizedBox(height: 26),
            Row(
              children: [
                Expanded(
                  child: _buildSmallChartCard(
                    "Voice Tone Analysis",
                    "Voice Flow Progress",
                    _buildLineChart(historyList),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildSmallChartCard(
                    "Technical & Soft Skills",
                    "",
                    _buildBarChart(historyList),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 26),
            const Text(
              "Key Performance Indicators",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1E293B),
              ),
            ),
            const SizedBox(height: 12),
            _buildRadarChartCard(historyList.first), // Focuses metrics on the latest run
            const SizedBox(height: 26),
            _buildWeeklyActivityCard(historyList),
          ],
        ),
      ),
    );
  }

  double _parseOverallScore(String? scoreStr) {
    if (scoreStr == null || scoreStr.isEmpty) return 0.0;
    String cleanScore = scoreStr.replaceAll('%', '').trim();
    return double.tryParse(cleanScore) ?? 0.0;
  }

  double _getNestedMetric(Map<String, dynamic> data, String key, double fallback) {
    if (!data.containsKey(key) || data[key] == null) return fallback;
    final val = data[key];
    if (val is num) return val.toDouble();
    return double.tryParse(val.toString()) ?? fallback;
  }

  // 1. COMPUTE AGGREGATED RUN PROGRESS
  Widget _buildHireProbabilityCard(List<HistoryModel> history) {
    double totalScore = 0;
    for (var item in history) {
      totalScore += _parseOverallScore(item.overallScore);
    }
    double averageScore = (totalScore / history.length).clamp(0, 100);
    double remaining = 100 - averageScore;

    String status = "Needs Work";
    Color statusColor = Colors.redAccent;
    if (averageScore >= 75) {
      status = "Highly Likely";
      statusColor = Colors.teal;
    } else if (averageScore >= 50) {
      status = "Likely";
      statusColor = Colors.orange;
    }

    return _cardWrapper(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          const Text(
            "Hire\nProbability",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFF0A898D),
            ),
          ),
          SizedBox(
            height: 70,
            width: 70,
            child: PieChart(
              PieChartData(
                sectionsSpace: 0,
                centerSpaceRadius: 0,
                sections: [
                  PieChartSectionData(
                    value: averageScore == 0 ? 1 : averageScore,
                    color: const Color(0xFF0A898D),
                    radius: 35,
                    showTitle: false,
                  ),
                  PieChartSectionData(
                    value: averageScore == 0 ? 99 : remaining,
                    color: const Color(0xFFCBD5E1),
                    radius: 35,
                    showTitle: false,
                  ),
                ],
              ),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("${averageScore.toStringAsFixed(0)}%", style: const TextStyle(fontWeight: FontWeight.bold)),
              Text(
                "Status: $status",
                style: TextStyle(
                  fontSize: 10,
                  color: statusColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Text(
                "Based on aggregate history",
                style: TextStyle(fontSize: 10, color: Colors.grey),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildLineChart(List<HistoryModel> history) {
    List<HistoryModel> timeline = history.reversed.toList();
    List<FlSpot> spots = [];

    for (int i = 0; i < timeline.length; i++) {
      double confidence = _getNestedMetric(timeline[i].interviewData, 'confidence', 60.0);
      spots.add(FlSpot(i.toDouble(), confidence));
    }

    if (spots.length == 1) {
      spots.insert(0, FlSpot(0, spots[0].y));
    }

    return LineChart(
      LineChartData(
        gridData: const FlGridData(show: true, drawVerticalLine: false),
        titlesData: const FlTitlesData(show: false),
        borderData: FlBorderData(show: false),
        lineBarsData: [
          LineChartBarData(
            spots: spots,
            isCurved: true,
            color: const Color(0xFF0A898D),
            barWidth: 3,
            dotData: const FlDotData(show: false),
            belowBarData: BarAreaData(
              show: true,
              gradient: LinearGradient(
                colors: [
                  const Color(0xFF0A898D).withAlpha((0.4 * 255).toInt()),
                  const Color(0xFF0A898D).withAlpha(0),
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // 3. BAR CHART ENGINE
  Widget _buildBarChart(List<HistoryModel> history) {
    double communication = 0, confidence = 0, problemSolving = 0, knowledge = 0;

    for (var item in history) {
      communication += _getNestedMetric(item.interviewData, 'communication', 50.0);
      confidence += _getNestedMetric(item.interviewData, 'confidence', 50.0);
      problemSolving += _getNestedMetric(item.interviewData, 'problemSolving', 50.0);
      knowledge += _getNestedMetric(item.interviewData, 'knowledge', 50.0);
    }

    double total = history.length.toDouble();

    return BarChart(
      BarChartData(
        maxY: 100,
        gridData: FlGridData(
          show: true,
          drawVerticalLine: false,
          getDrawingHorizontalLine: (value) =>
              FlLine(color: Colors.grey.shade200, strokeWidth: 1),
        ),
        titlesData: FlTitlesData(
          topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              interval: 20,
              reservedSize: 25,
              getTitlesWidget: (value, meta) => Text(
                '${value.toInt()}',
                style: const TextStyle(fontSize: 9, color: Colors.grey),
              ),
            ),
          ),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (value, meta) {
                const labels = ['Comm.', 'Conf.', 'Prob.', 'Know.'];
                if (value.toInt() >= 0 && value.toInt() < labels.length) {
                  return Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: Text(
                      labels[value.toInt()],
                      style: const TextStyle(fontSize: 8, color: Colors.grey, fontWeight: FontWeight.w500),
                    ),
                  );
                }
                return const SizedBox();
              },
            ),
          ),
        ),
        borderData: FlBorderData(show: false),
        barGroups: [
          _makeBarGroup(0, communication / total),
          _makeBarGroup(1, confidence / total),
          _makeBarGroup(2, problemSolving / total),
          _makeBarGroup(3, knowledge / total),
        ],
      ),
    );
  }

  BarChartGroupData _makeBarGroup(int x, double y) {
    return BarChartGroupData(
      x: x,
      barRods: [
        BarChartRodData(
          toY: y.clamp(0, 100),
          width: 14,
          borderRadius: BorderRadius.circular(20),
          gradient: const LinearGradient(
            begin: Alignment.bottomCenter,
            end: Alignment.topCenter,
            colors: [Color(0xFF1E293B), Color(0xFF0A898D), Color(0xFF00D4FF)],
            stops: [0.0, 0.35, 1.0],
          ),
        ),
      ],
    );
  }

  // 4. MULTI-AXIS PERFORMANCE MAP ENGINE
  Widget _buildRadarChartCard(HistoryModel latestInterview) {
    final data = latestInterview.interviewData;
    
    double clarity = _getNestedMetric(data, 'clarity', 70);
    double pace = _getNestedMetric(data, 'speakingPace', 75);
    double tone = _getNestedMetric(data, 'professionalTone', 60);
    double speed = _getNestedMetric(data, 'speed', 80);
    double confidence = _getNestedMetric(data, 'confidence', 70);

    return _cardWrapper(
      child: Column(
        children: [
          const SizedBox(height: 10),
          SizedBox(
            height: 240,
            child: RadarChart(
              RadarChartData(
                radarShape: RadarShape.polygon,
                tickBorderData: const BorderSide(color: Colors.transparent),
                ticksTextStyle: const TextStyle(color: Colors.transparent, fontSize: 0),
                dataSets: [
                  RadarDataSet(
                    fillColor: const Color(0xFF0A898D).withAlpha((0.3 * 255).toInt()),
                    borderColor: const Color(0xFF0A898D),
                    entryRadius: 4,
                    dataEntries: [
                      RadarEntry(value: clarity),
                      RadarEntry(value: pace),
                      RadarEntry(value: tone),
                      RadarEntry(value: speed),
                      RadarEntry(value: confidence),
                    ],
                  ),
                ],
                radarBorderData: const BorderSide(color: Color(0xFF0A898D), width: 1.5),
                gridBorderData: BorderSide(color: const Color(0xFF0A898D).withAlpha((0.2 * 255).toInt()), width: 1),
                titlePositionPercentageOffset: 0.15,
                titleTextStyle: const TextStyle(fontSize: 10, color: Colors.grey, fontWeight: FontWeight.bold),
                getTitle: (index, angle) {
                  final labels = [
                    'Clarity\n${clarity.toStringAsFixed(0)}',
                    'Speaking Pace\n${pace.toStringAsFixed(0)}',
                    'Prof. Tone\n${tone.toStringAsFixed(0)}',
                    'Speed\n${speed.toStringAsFixed(0)}',
                    'Confidence\n${confidence.toStringAsFixed(0)}',
                  ];
                  return RadarChartTitle(text: labels[index]);
                },
              ),
            ),
          ),
          const SizedBox(height: 10),
        ],
      ),
    );
  }

  // 5. ACTIVITY HEATMAP GRID MAPPING SESSIONS
  Widget _buildWeeklyActivityCard(List<HistoryModel> history) {
    final List<String> days = ['M', 'T', 'W', 'T', 'F', 'S', 'S'];
    final DateTime now = DateTime.now();
    final Set<int> activeIndices = {};

    for (var item in history) {
      int differenceInDays = now.difference(item.timestamp).inDays;
      
      if (differenceInDays >= 0 && differenceInDays < 28) {
        int gridIndex = 27 - differenceInDays;
        if (gridIndex >= 0 && gridIndex < 28) {
          activeIndices.add(gridIndex);
        }
      }
    }

    return _cardWrapper(
      child: Row(
        children: [
          const Padding(
            padding: EdgeInsets.all(12.0),
            child: Text(
              "Weekly\nActivity",
              style: TextStyle(
                color: Color(0xFF0A898D),
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
          ),
          const Spacer(),
          Column(
            children: [
              SizedBox(
                width: 160,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: days
                      .map(
                        (day) => Text(
                          day,
                          style: const TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey,
                          ),
                        ),
                      )
                      .toList(),
                ),
              ),
              const SizedBox(height: 6),
              SizedBox(
                width: 160,
                child: GridView.builder(
                  shrinkWrap: true,
                  itemCount: 28,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 7,
                    mainAxisSpacing: 4,
                    crossAxisSpacing: 4,
                  ),
                  itemBuilder: (context, index) {
                    Color cellColor = activeIndices.contains(index) 
                        ? const Color(0xFF0A898D) 
                        : Colors.grey.shade200;

                    return Container(
                      decoration: BoxDecoration(
                        color: cellColor,
                        borderRadius: BorderRadius.circular(3),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSmallChartCard(String title, String subTitle, Widget chart) {
    return _cardWrapper(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold),
          ),
          if (subTitle.isNotEmpty)
            Text(subTitle, style: const TextStyle(fontSize: 8, color: Colors.grey)),
          const SizedBox(height: 10),
          SizedBox(height: 110, child: chart),
        ],
      ),
    );
  }

  Widget _cardWrapper({required Widget child}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: const Color(0xff1E293B).withAlpha((0.1 * 255).toInt()),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: child,
    );
  }
}