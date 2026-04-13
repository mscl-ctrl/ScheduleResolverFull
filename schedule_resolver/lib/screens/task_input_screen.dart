import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/schedule_provider.dart';

class TaskInputScreen extends StatefulWidget {
  const TaskInputScreen({super.key});
  @override
  State<TaskInputScreen> createState() => _TaskInputScreenState();
}

class _TaskInputScreenState extends State<TaskInputScreen> {
  final _formKey = GlobalKey<FormState>();

  String _title = '';
  String _category = 'Meeting';
  DateTime _date = DateTime.now();
  TimeOfDay _startTime = TimeOfDay.now();
  TimeOfDay _endTime = TimeOfDay.now().replacing(hour: (TimeOfDay.now().hour + 1) % 24);
  double _urgency = 3, _importance = 3, _effort = 1.0;
  String _energy = 'Medium';

  final List<String> _cats = ['Incident', 'Meeting', 'Deployment', 'Maintenance', 'Documentation', 'Other'];
  final List<String> _energies = ['Low', 'Medium', 'High'];

  Future<void> _pickTime(bool isStart) async {
    final picked = await showTimePicker(
      context: context,
      initialTime: isStart ? _startTime : _endTime,
    );
    if (picked != null) setState(() => isStart ? _startTime = picked : _endTime = picked);
  }

  void _submit() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      Provider.of<ScheduleProvider>(context, listen: false).addTask(
        title: _title,
        category: _category,
        date: _date,
        startTime: _startTime,
        endTime: _endTime,
        urgency: _urgency.toInt(),
        importance: _importance.toInt(),
        estimatedEffortHours: _effort,
        energyLevel: _energy,
      );
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F5F7),
      appBar: AppBar(
        title: const Text('Log New Operation/Task'),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                'Task Details',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF0747A6)),
              ),
              const SizedBox(height: 16),
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Operation Title',
                  hintText: 'e.g., Server Migration, Sprint Planning',
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                  prefixIcon: const Icon(Icons.title),
                ),
                validator: (value) => value == null || value.isEmpty ? 'Please enter a title' : null,
                onSaved: (value) => _title = value!,
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: _category,
                decoration: InputDecoration(
                  labelText: 'Priority Category',
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                  prefixIcon: const Icon(Icons.category_outlined),
                ),
                items: _cats.map((c) => DropdownMenuItem(value: c, child: Text(c))).toList(),
                onChanged: (val) => setState(() => _category = val!),
              ),
              const SizedBox(height: 24),
              const Text(
                'Time Scheduling',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF0747A6)),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () => _pickTime(true),
                      icon: const Icon(Icons.access_time),
                      label: Text("Start: ${_startTime.format(context)}"),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.all(16),
                        backgroundColor: Colors.white,
                        side: BorderSide(color: Colors.grey.shade400),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () => _pickTime(false),
                      icon: const Icon(Icons.access_time_filled),
                      label: Text("End: ${_endTime.format(context)}"),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.all(16),
                        backgroundColor: Colors.white,
                        side: BorderSide(color: Colors.grey.shade400),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              const Text(
                'Matrix Assessment',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF0747A6)),
              ),
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.grey.shade300),
                ),
                child: Column(
                  children: [
                    _buildSliderRow('Urgency', _urgency, (val) => setState(() => _urgency = val)),
                    const Divider(height: 32),
                    _buildSliderRow('Importance', _importance, (val) => setState(() => _importance = val)),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: _energy,
                decoration: InputDecoration(
                  labelText: 'Energy Level Required',
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                  prefixIcon: const Icon(Icons.bolt),
                ),
                items: _energies.map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
                onChanged: (val) => setState(() => _energy = val!),
              ),
              const SizedBox(height: 40),
              ElevatedButton(
                onPressed: _submit,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF0052CC),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
                child: const Text('Commit to Schedule', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSliderRow(String label, double value, ValueChanged<double> onChanged) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label, style: const TextStyle(fontWeight: FontWeight.w500)),
            Text(value.toInt().toString(), style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF0052CC))),
          ],
        ),
        Slider(
          value: value,
          min: 1,
          max: 5,
          divisions: 4,
          activeColor: const Color(0xFF0052CC),
          onChanged: onChanged,
        ),
      ],
    );
  }
}