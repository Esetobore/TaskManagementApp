import 'package:dufil/config/constants/app_constants.dart';
import 'package:dufil/data/providers/task_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class TaskFilter extends StatelessWidget {
  const TaskFilter({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<TaskProvider>(
      builder: (context, taskProvider, _) {
        return SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            children: [
              _buildFilterPill(
                context: context,
                label: 'Pending',
                count: taskProvider.statistics['pending'] ?? 0,
                status: 'pending',
                isSelected: taskProvider.filterStatus == 'pending',
                textColor: Colors.black,
                countColor: Colors.grey,
              ),
              const SizedBox(width: 8),
              _buildFilterPill(
                context: context,
                label: 'In Progress',
                count: taskProvider.statistics['in_progress'] ?? 0,
                status: 'in_progress',
                isSelected: taskProvider.filterStatus == 'in_progress',
                textColor: Colors.black,
                countColor: Colors.blue,
              ),
              const SizedBox(width: 8),
              _buildFilterPill(
                context: context,
                label: 'On Hold',
                count: taskProvider.statistics['on_hold'] ?? 0,
                status: 'on_hold',
                isSelected: taskProvider.filterStatus == 'on_hold',
                textColor: Colors.black,
                countColor: Colors.orange,
              ),
              const SizedBox(width: 8),
              _buildFilterPill(
                context: context,
                label: 'Complete',
                count: taskProvider.statistics['completed'] ?? 0,
                status: 'completed',
                isSelected: taskProvider.filterStatus == 'completed',
                textColor: Colors.black,
                countColor: Colors.green,
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildFilterPill({
    required BuildContext context,
    required String label,
    required int count,
    required String status,
    required bool isSelected,
    required Color textColor,
    required Color countColor,
  }) {
    return GestureDetector(
      onTap: () {
        final taskProvider = context.read<TaskProvider>();
        taskProvider.setFilter(isSelected ? null : status);
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? kPrimaryAppColor : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: Colors.grey.shade300,
            width: 1,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              label,
              style: TextStyle(
                color: isSelected ? Colors.white : textColor,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                color: countColor.withAlpha(50),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                count.toString(),
                style: TextStyle(
                  color: countColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
