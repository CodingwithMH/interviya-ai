import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class Stats extends StatefulWidget {
  const Stats({super.key});

  @override
  State<Stats> createState() => _StatsState();
}

class _StatsState extends State<Stats> {
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
              "Analytics",
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
      body: ScrollConfiguration(
        behavior: ScrollBehavior().copyWith(scrollbars: false),
        child: SingleChildScrollView(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 10),
              _buildHireProbabilityCard(),
              SizedBox(height: 26),
              Row(
                children: [
                  Expanded(
                    child: _buildSmallChartCard(
                      "Voice Tone Analysis",
                      "Voice Flow",
                      _buildLineChart(),
                    ),
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child: _buildSmallChartCard(
                      "Technical & Soft Skills",
                      "",
                      _buildBarChart(),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 26),

              Text(
                "Key Performance Indicators",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1E293B),
                ),
              ),
              SizedBox(height: 12),
              _buildRadarChartCard(),
              SizedBox(height: 26),

              _buildWeeklyActivityCard(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHireProbabilityCard() {
    return _cardWrapper(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Text(
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
                    value: 70,
                    color: Color(0xFF0A898D),
                    radius: 35,
                    showTitle: false,
                  ),
                  PieChartSectionData(
                    value: 30,
                    color: Color(0xFFCBD5E1),
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
              Text("70%", style: TextStyle(fontWeight: FontWeight.bold)),
              Text(
                "Status: Highly Likely",
                style: TextStyle(
                  fontSize: 10,
                  color: Colors.teal,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                "Accuracy: 94%",
                style: TextStyle(fontSize: 10, color: Colors.grey),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildLineChart() {
    return LineChart(
      LineChartData(
        gridData: FlGridData(show: true, drawVerticalLine: false),
        titlesData: FlTitlesData(show: false),
        borderData: FlBorderData(show: false),
        lineBarsData: [
          LineChartBarData(
            spots: [FlSpot(0, 70), FlSpot(1, 30), FlSpot(2, 55), FlSpot(3, 5)],
            isCurved: true,
            color: Color(0xFF0A898D),
            barWidth: 3,
            dotData: FlDotData(show: false),
            belowBarData: BarAreaData(
              show: true,
              gradient: LinearGradient(
                colors: [
                  Color(0xFF0A898D).withValues(alpha: 0.4),
                  Color(0xFF0A898D).withValues(alpha: 0.0),
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

  Widget _buildBarChart() {
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
          topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              interval: 20,
              reservedSize: 25,
              getTitlesWidget: (value, meta) => Text(
                '${value.toInt()}',
                style: TextStyle(fontSize: 9, color: Colors.grey),
              ),
            ),
          ),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (value, meta) {
                const labels = ['Comm.', 'Confid.', 'Problem', 'Knowl.'];
                if (value.toInt() >= 0 && value.toInt() < labels.length) {
                  return Padding(
                    padding: EdgeInsets.only(top: 8),
                    child: Text(
                      labels[value.toInt()],
                      style: TextStyle(fontSize: 7, color: Colors.grey),
                    ),
                  );
                }
                return SizedBox();
              },
            ),
          ),
        ),
        borderData: FlBorderData(show: false),
        barGroups: [
          _makeBarGroup(0, 50),
          _makeBarGroup(1, 75),
          _makeBarGroup(2, 78),
          _makeBarGroup(3, 68),
        ],
      ),
    );
  }

  BarChartGroupData _makeBarGroup(int x, double y) {
    return BarChartGroupData(
      x: x,
      barRods: [
        BarChartRodData(
          toY: y,
          width: 14,
          borderRadius: BorderRadius.circular(20),
          gradient: LinearGradient(
            begin: Alignment.bottomCenter,
            end: Alignment.topCenter,
            colors: [Color(0xFF1E293B), Color(0xFF0A898D), Color(0xFF00D4FF)],
            stops: [0.0, 0.35, 1.0],
          ),
        ),
      ],
    );
  }

  Widget _buildRadarChartCard() {
    return _cardWrapper(
      child: Column(
        children: [
          SizedBox(height: 10),
          SizedBox(
            height: 240,
            child: RadarChart(
              RadarChartData(
                radarShape: RadarShape.polygon,
                dataSets: [
                  RadarDataSet(
                    fillColor: Color(0xFF0A898D).withValues(alpha: 0.6),
                    borderColor: Color(0xFF0A898D),
                    entryRadius: 4,
                    dataEntries: [
                      RadarEntry(value: 80),
                      RadarEntry(value: 85),
                      RadarEntry(value: 60),
                      RadarEntry(value: 90),
                      RadarEntry(value: 70),
                    ],
                  ),
                ],

                radarBorderData: BorderSide(
                  color: Color(0xFF0A898D),
                  width: 1.5,
                ),
                gridBorderData: BorderSide(
                  color: Color(0xFF0A898D).withValues(alpha: 0.2),
                  width: 1,
                ),

                tickCount: 1,
                ticksTextStyle: TextStyle(color: Color(0xFF0A898D)),

                titlePositionPercentageOffset: 0.15,
                titleTextStyle: TextStyle(
                  fontSize: 10,
                  color: Colors.grey,
                  fontWeight: FontWeight.bold,
                ),

                getTitle: (index, angle) {
                  const labels = [
                    'Clarity\n80',
                    'Speaking Pace\n85',
                    'Prof. Tone\n60',
                    'Speed\n90',
                    'Confidence\n70',
                  ];
                  return RadarChartTitle(text: labels[index]);
                },
              ),
            ),
          ),
          SizedBox(height: 10),
        ],
      ),
    );
  }

  Widget _buildWeeklyActivityCard() {
    final List<String> days = ['M', 'T', 'W', 'T', 'F', 'S', 'S'];
    return _cardWrapper(
      child: Row(
        children: [
          Text(
            "Weekly\nActivity",
            style: TextStyle(
              color: Color(0xFF0A898D),
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
          ),
          Spacer(),
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
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey,
                          ),
                        ),
                      )
                      .toList(),
                ),
              ),
              SizedBox(height: 6),
              SizedBox(
                width: 160,
                child: GridView.builder(
                  shrinkWrap: true,
                  itemCount: 28,
                  physics: NeverScrollableScrollPhysics(),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 7,
                    mainAxisSpacing: 4,
                    crossAxisSpacing: 4,
                  ),
                  itemBuilder: (context, index) {
                    Color cellColor = Colors.grey.shade200;
                    if (index % 4 == 0) {
                      cellColor = Color(0xFF0A898D);
                    } else if (index % 3 == 0) {
                      cellColor = Color(0xFF0A898D).withValues(alpha: 0.4);
                    }
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
            style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold),
          ),
          if (subTitle.isNotEmpty)
            Text(subTitle, style: TextStyle(fontSize: 8, color: Colors.grey)),
          SizedBox(height: 10),
          SizedBox(height: 110, child: chart),
        ],
      ),
    );
  }

  Widget _cardWrapper({required Widget child}) {
    return Container(
      width: double.infinity,
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
      child: child,
    );
  }
}
