import 'package:dufil/data/models/task.dart';
import 'package:dufil/data/providers/task_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class TaskFormSheet extends StatefulWidget {
  final Task? task;

  const TaskFormSheet({super.key, this.task});

  @override
  State<TaskFormSheet> createState() => _TaskFormSheetState();
}

class _TaskFormSheetState extends State<TaskFormSheet> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _titleController;
  late TextEditingController _descriptionController;
  late DateTime _selectedDate;
  List<String> _tags = [];
  String _status = 'pending';

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.task?.title);
    _descriptionController = TextEditingController(text: widget.task?.description);
    _selectedDate = widget.task?.dueDate ?? DateTime.now();
    _tags = widget.task?.tags ?? [];
    _status = widget.task?.status ?? 'pending';
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              widget.task == null ? 'Create Task' : 'Edit Task',
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _titleController,
              decoration: const InputDecoration(
                labelText: 'Title',
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value?.isEmpty ?? true) {
                  return 'Please enter a title';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _descriptionController,
              decoration: const InputDecoration(
                labelText: 'Description',
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
            ),
            const SizedBox(height: 16),
            if (widget.task != null) _buildStatusDropdown(),
            const SizedBox(height: 16),
            _buildDatePicker(),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _submitForm,
              child: Text(widget.task == null ? 'Create' : 'Update'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusDropdown() {
    return DropdownButtonFormField<String>(
      value: _status,
      decoration: const InputDecoration(
        labelText: 'Status',
        border: OutlineInputBorder(),
      ),
      items: const [
        DropdownMenuItem(value: 'pending', child: Text('Pending')),
        DropdownMenuItem(value: 'in_progress', child: Text('In Progress')),
        DropdownMenuItem(value: 'completed', child: Text('Completed')),
        DropdownMenuItem(value: 'on_hold', child: Text('On Hold')),
      ],
      onChanged: (value) {
        setState(() {
          _status = value!;
        });
      },
    );
  }

  Widget _buildDatePicker() {
    return InkWell(
      onTap: () async {
        final date = await showDatePicker(
          context: context,
          initialDate: _selectedDate,
          firstDate: DateTime.now(),
          lastDate: DateTime.now().add(const Duration(days: 365)),
        );
        if (date != null) {
          setState(() {
            _selectedDate = date;
          });
        }
      },
      child: InputDecorator(
        decoration: const InputDecoration(
          labelText: 'Due Date',
          border: OutlineInputBorder(),
        ),
        child: Text(
          '${_selectedDate.day}/${_selectedDate.month}/${_selectedDate.year}',
        ),
      ),
    );
  }

  void _submitForm() {
    if (_formKey.currentState?.validate() ?? false) {
      final taskProvider = context.read<TaskProvider>();
      final task = Task(
        id: widget.task?.id ?? '',
        title: _titleController.text,
        description: _descriptionController.text,
        status: _status,
        dueDate: _selectedDate,
        tags: _tags,
      );

      if (widget.task == null) {
        taskProvider.createTask(task);
      } else {
        taskProvider.updateTask(task);
      }

      Navigator.pop(context);
    }
  }
}
