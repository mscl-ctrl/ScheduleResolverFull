import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/schedule_provider.dart';
import '../services/ai_schedule_service.dart';
import '../models/task_model.dart';
import 'task_input_screen.dart';
import 'recommendation_screen.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final scheduleProvider = Provider.of<ScheduleProvider>(context);
    final aiService = Provider.of<AiScheduleService>(context);

    final sortedTasks = List<TaskModel>.from(scheduleProvider.task);
    sortedTasks.sort((a, b) =>
        a.startTime.hour * 60 + a.startTime.minute - (b.startTime.hour * 60 + b.startTime.minute));

    return Scaffold(
      backgroundColor: const Color(0xFFF4F5F7),
      appBar: AppBar(
        title: const Text(
          'Tech Operations Dashboard',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.account_circle_outlined),
            onPressed: () {},
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Summary Section
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(24.0),
            decoration: const BoxDecoration(
              color: Color(0xFF0747A6),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(32),
                bottomRight: Radius.circular(32),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Welcome, Tech Manager',
                  style: TextStyle(color: Colors.white70, fontSize: 16),
                ),
                const SizedBox(height: 8),
                Text(
                  'Daily Schedule Overview',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildStatItem('Total Tasks', sortedTasks.length.toString()),
                    _buildStatItem('Pending', sortedTasks.length.toString()),
                    _buildStatItem('Resolved', '0'),
                  ],
                ),
              ],
            ),
          ),

          Padding(
            padding: const EdgeInsets.fromLTRB(20, 24, 20, 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Upcoming Queue',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Colors.blueGrey.shade800,
                      ),
                ),
              ],
            ),
          ),

          if (aiService.errorMessage != null)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.red.shade50,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.red.shade200),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.error_outline, color: Colors.red),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'AI Error: ${aiService.errorMessage}',
                        style: const TextStyle(color: Colors.red, fontSize: 13),
                      ),
                    ),
                  ],
                ),
              ),
            ),

          if (aiService.currentAnalysis != null)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              child: InkWell(
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const RecommendationScreen()),
                ),
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: const Color(0xFFE3F2FD),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.blue.shade200),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.auto_awesome, color: Color(0xFF0052CC)),
                      const SizedBox(width: 12),
                      const Expanded(
                        child: Text(
                          'AI Analysis Complete: Conflicts Resolved',
                          style: TextStyle(
                            color: Color(0xFF0747A6),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      const Icon(Icons.arrow_forward_ios, size: 16, color: Color(0xFF0747A6)),
                    ],
                  ),
                ),
              ),
            ),

          Expanded(
            child: sortedTasks.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.inventory_2_outlined, size: 64, color: Colors.grey.shade400),
                        const SizedBox(height: 16),
                        Text(
                          'No tasks in your queue today.',
                          style: TextStyle(color: Colors.grey.shade600, fontSize: 16),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: sortedTasks.length,
                    itemBuilder: (context, index) {
                      final task = sortedTasks[index];
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 8.0),
                        child: Card(
                          child: ListTile(
                            leading: Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: _getCategoryColor(task.category).withOpacity(0.1),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Icon(
                                _getCategoryIcon(task.category),
                                color: _getCategoryColor(task.category),
                              ),
                            ),
                            title: Text(
                              task.title,
                              style: const TextStyle(fontWeight: FontWeight.bold),
                            ),
                            subtitle: Text(
                              '${task.startTime.hour.toString().padLeft(2, '0')}:${task.startTime.minute.toString().padLeft(2, '0')} • ${task.category}',
                            ),
                            trailing: IconButton(
                              icon: const Icon(Icons.close, size: 20),
                              onPressed: () => scheduleProvider.removeTask(task.id),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
      floatingActionButton: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (sortedTasks.isNotEmpty)
            FloatingActionButton.extended(
              heroTag: 'resolve_ai',
              onPressed: aiService.isLoading
                  ? null
                  : () => aiService.analyzeSchedule(scheduleProvider.task),
              label: Text(aiService.isLoading ? 'Processing...' : 'Resolve Conflicts with AI'),
              icon: aiService.isLoading
                  ? const SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                    )
                  : const Icon(Icons.bolt),
              backgroundColor: const Color(0xFF0747A6),
              foregroundColor: Colors.white,
            ),
          const SizedBox(height: 12),
          FloatingActionButton.extended(
            heroTag: 'add_task',
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const TaskInputScreen()),
            ),
            label: const Text('Add Task'),
            icon: const Icon(Icons.add),
            backgroundColor: const Color(0xFF0052CC),
            foregroundColor: Colors.white,
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,
          style: const TextStyle(
            color: Colors.white70,
            fontSize: 12,
          ),
        ),
      ],
    );
  }

  Color _getCategoryColor(String category) {
    switch (category.toLowerCase()) {
      case 'incident': return Colors.redAccent;
      case 'meeting': return Colors.blueAccent;
      case 'deployment': return Colors.orangeAccent;
      default: return Colors.greenAccent;
    }
  }

  IconData _getCategoryIcon(String category) {
    switch (category.toLowerCase()) {
      case 'incident': return Icons.bug_report_outlined;
      case 'meeting': return Icons.groups_outlined;
      case 'deployment': return Icons.cloud_upload_outlined;
      default: return Icons.task_alt;
    }
  }
}