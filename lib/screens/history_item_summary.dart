import 'package:flutter/material.dart';
import 'package:interviya/data/models/history_model.dart';
import 'package:intl/intl.dart';

class HistoryItemSummary extends StatelessWidget {
  final HistoryModel history;

  const HistoryItemSummary({super.key, required this.history});

  @override
  Widget build(BuildContext context) {
    final String formattedDate = DateFormat(
      'd MMMM yyyy',
    ).format(history.timestamp);

    final int? rawScore = history.interviewData['score_out_of_hundred'] as int?;
    final bool isComplete = rawScore != null;
    
    final int calculatedScore = rawScore ?? history.completionPercentage;
    final double confidenceMetric =
        (history.interviewData['confidence'] as num?)?.toDouble() ?? 0.0;
    final double accuracyMetric =
        (history.interviewData['technical_accuracy'] as num?)?.toDouble() ??
        0.0;
    final double communicationMetric =
        (history.interviewData['communication'] as num?)?.toDouble() ?? 0.0;

    final String aiInsights =
        history.interviewData['ai_insights'] ??
        "No structural review evaluation text present.";

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFF),
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(70),
        child: AppBar(
          backgroundColor: const Color(0xFF0A898D),
          elevation: 0,
          automaticallyImplyLeading: false,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white, size: 28),
            onPressed: () => Navigator.pop(context),
          ),
          title: const Text(
            "Course Summary",
            style: TextStyle(
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(bottom: Radius.circular(25)),
          ),
        ),
      ),
      body: ScrollConfiguration(
        behavior: const ScrollBehavior().copyWith(scrollbars: false),
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 1. Title Meta Specifications Card Wrapper
              _buildCardWrapper(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      history.interviewTitle.isNotEmpty
                          ? history.interviewTitle
                          : 'Web Development Interview',
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1E293B),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        _buildDot(),
                        const SizedBox(width: 6),
                        Text(
                          formattedDate,
                          style: TextStyle(
                            color: Colors.grey.shade500,
                            fontWeight: FontWeight.w500,
                            fontSize: 13,
                          ),
                        ),
                        const SizedBox(width: 14),
                        _buildDot(),
                        const SizedBox(width: 6),
                        Text(
                          history.difficulty,
                          style: TextStyle(
                            color: Colors.grey.shade500,
                            fontWeight: FontWeight.w500,
                            fontSize: 13,
                          ),
                        ),
                        const SizedBox(width: 14),
                        _buildDot(),
                        const SizedBox(width: 6),
                        Text(
                          "${(history.duration / 60).round()} min",
                          style: TextStyle(
                            color: Colors.grey.shade500,
                            fontWeight: FontWeight.w500,
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              Text(
                isComplete ? "Your Score" : "Interview Status",
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1E293B),
                ),
              ),
              const SizedBox(height: 12),
              _buildCardWrapper(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    if (isComplete) ...[
                      Text(
                        "$calculatedScore/100",
                        style: const TextStyle(
                          fontSize: 36,
                          fontWeight: FontWeight.w800,
                          color: Color(0xFF0A898D),
                        ),
                      ),
                      Container(
                        height: 52,
                        width: 52,
                        decoration: const BoxDecoration(
                          color: Color(0xFFD2EFF0),
                          shape: BoxShape.circle,
                        ),
                        child: const Center(
                          child: Icon(
                            Icons.workspace_premium_rounded,
                            color: Color(0xFF0A898D),
                            size: 30,
                          ),
                        ),
                      ),
                    ] else ...[
                      // Beautiful UI State for Incomplete Sessions
                      const Text(
                        "Incomplete",
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFFEF4444), // Crimson Alert Red
                        ),
                      ),
                      Container(
                        height: 52,
                        width: 52,
                        decoration: const BoxDecoration(
                          color: Color(0xFFFEE2E2),
                          shape: BoxShape.circle,
                        ),
                        child: const Center(
                          child: Icon(
                            Icons.assignment_late_rounded,
                            color: Color(0xFFEF4444),
                            size: 26,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // 3. Performance Metrics Linear Progress Mapping Sections
              const Text(
                "Performance",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1E293B),
                ),
              ),
              const SizedBox(height: 12),
              _buildCardWrapper(
                child: Column(
                  children: [
                    _buildMetricRow("Confidence", confidenceMetric),
                    const SizedBox(height: 16),
                    _buildMetricRow("Technical Accuracy", accuracyMetric),
                    const SizedBox(height: 16),
                    _buildMetricRow("Communication", communicationMetric),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // 4. Clean Structural Consolidated AI Insights Block Display
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: const Color(0xFFEBF7F8),
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(
                    color: const Color(0xFF0A898D),
                    width: 1.5,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(
                          Icons.psychology_rounded,
                          color: Color(0xFF0A898D),
                          size: 24,
                        ),
                        const SizedBox(width: 8),
                        const Text(
                          "AI Insights",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF1E293B),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 14),
                    Text(
                      aiInsights,
                      style: const TextStyle(
                        fontSize: 14,
                        color: Color(0xFF1E293B),
                        height: 1.5,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCardWrapper({required Widget child}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 15,
            spreadRadius: 1,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: child,
    );
  }

  Widget _buildDot() {
    return Container(
      height: 7,
      width: 7,
      decoration: const BoxDecoration(
        color: Color(0xFF0A898D),
        shape: BoxShape.circle,
      ),
    );
  }

  Widget _buildMetricRow(String label, double value) {
    // Convert 0.0-1.0 proportional value scales into human friendly percentage formats
    final int displayPercentage = (value * 100).round().clamp(0, 100);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1E293B),
              ),
            ),
            Text(
              "$displayPercentage%",
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Color(0xFF0A898D),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: LinearProgressIndicator(
            value: value.clamp(0.0, 1.0),
            minHeight: 7,
            backgroundColor: const Color(0xFFE2E8F0),
            valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFF0A898D)),
          ),
        ),
      ],
    );
  }
}
