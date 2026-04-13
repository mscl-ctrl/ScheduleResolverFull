import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/ai_schedule_service.dart';

class RecommendationScreen extends StatelessWidget {
  const RecommendationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final aiService = Provider.of<AiScheduleService>(context);
    final analysis = aiService.currentAnalysis;

    if (analysis == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Resolution Report')),
        body: const Center(child: Text('No analysis data available.')),
      );
    }

    return Scaffold(
      backgroundColor: const Color(0xFFF4F5F7),
      appBar: AppBar(
        title: const Text('AI Resolution Report'),
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.share_outlined),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(context),
            const SizedBox(height: 24),
            
            _buildSection(
              context,
              'Conflict Analysis',
              analysis.conflicts,
              const Color(0xFFFFEBE6),
              const Color(0xFFBF2600),
              Icons.warning_amber_rounded,
            ),
            
            _buildSection(
              context,
              'Operational Priority',
              analysis.rankedTasks,
              const Color(0xFFEAE6FF),
              const Color(0xFF403294),
              Icons.format_list_numbered,
            ),
            
            _buildSection(
              context,
              'Optimized Schedule',
              analysis.recommendedSchedule,
              const Color(0xFFE3F2FD),
              const Color(0xFF0052CC),
              Icons.calendar_today,
            ),
            
            _buildSection(
              context,
              'Strategic Explanation',
              analysis.explanation,
              const Color(0xFFE3FCEF),
              const Color(0xFF006644),
              Icons.lightbulb_outline,
            ),
            
            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(Icons.check),
                label: const Text('Apply Recommendations'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF0052CC),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
              ),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: const Color(0xFF0052CC).withOpacity(0.1),
            borderRadius: BorderRadius.circular(4),
          ),
          child: const Text(
            'AI-GENERATED INSIGHTS',
            style: TextStyle(
              color: Color(0xFF0052CC),
              fontWeight: FontWeight.bold,
              fontSize: 12,
              letterSpacing: 1.2,
            ),
          ),
        ),
        const SizedBox(height: 12),
        const Text(
          'Resource Optimization Strategy',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Color(0xFF172B4D),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          'Report generated based on current queue and priorities.',
          style: TextStyle(color: Colors.grey.shade600),
        ),
      ],
    );
  }

  Widget _buildSection(
    BuildContext context,
    String title,
    String content,
    Color bgColor,
    Color accentColor,
    IconData icon,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: bgColor.withOpacity(0.3),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(12),
                topRight: Radius.circular(12),
              ),
            ),
            child: Row(
              children: [
                Icon(icon, color: accentColor, size: 24),
                const SizedBox(width: 12),
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: accentColor,
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              content,
              style: const TextStyle(
                fontSize: 15,
                height: 1.6,
                color: Color(0xFF42526E),
              ),
            ),
          ),
        ],
      ),
    );
  }
}