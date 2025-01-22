import 'package:dufil/data/providers/task_provider.dart';
import 'package:dufil/presentation/widgets/statistics/stats_card.dart';
import 'package:dufil/presentation/widgets/statistics/task_statistics_chart.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class StatisticsScreen extends StatelessWidget {
  const StatisticsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<TaskProvider>(
        builder: (context, taskProvider, child) {
          return SafeArea(
            child: RefreshIndicator(
              onRefresh: () => taskProvider.fetchTaskStatistics(),
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Task Stats',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    GridView.count(
                      crossAxisCount: 2,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                      children: [
                        StatsCard(
                          title: 'In Progress',
                          value: taskProvider.statistics['in_progress']?.toString() ?? '0',
                          color: Colors.blue,
                          icon: Icons.trending_up,
                        ),
                        StatsCard(
                          title: 'Completed',
                          value: taskProvider.statistics['completed']?.toString() ?? '0',
                          color: Colors.green,
                          icon: Icons.check_circle,
                        ),
                        StatsCard(
                          title: 'On Hold',
                          value: taskProvider.statistics['on_hold']?.toString() ?? '0',
                          color: Colors.orange,
                          icon: Icons.pause_circle,
                        ),
                        StatsCard(
                          title: 'Yet to Start',
                          value: taskProvider.statistics['pending']?.toString() ?? '0',
                          color: Colors.grey,
                          icon: Icons.schedule,
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    TaskStatisticsChart(statistics: taskProvider.statistics),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
