import 'package:flutter/material.dart';
import '../services/data_service.dart';

/// ABC Creation Wizard - focused on Class selection for immediate testing
/// Uses real data from class_descriptors.json
/// Ancestry and Background are prepared as stubs for future data.
class ABCWizardScreen extends StatefulWidget {
  const ABCWizardScreen({super.key});

  @override
  State<ABCWizardScreen> createState() => _ABCWizardScreenState();
}

class _ABCWizardScreenState extends State<ABCWizardScreen> {
  List<Map<String, dynamic>> _classDescriptors = [];
  Map<String, dynamic>? _selectedClass;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final descriptors = await DataService.loadClassDescriptors();
    setState(() {
      _classDescriptors = descriptors;
      _isLoading = false;
    });
  }

  void _selectClass(Map<String, dynamic> classData) {
    setState(() {
      _selectedClass = classData;
    });

    // Future: Load matching starting stats from classes.json and show preview
    // final startingStats = await DataService.getClassByName(classData['name']);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Character - ABC Wizard'),
        backgroundColor: Colors.brown[700],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Step 3: Choose Your Class',
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Ancestry and Background coming soon. Class picker is live with your real data.',
                    style: TextStyle(color: Colors.grey),
                  ),
                  const SizedBox(height: 20),

                  Expanded(
                    child: GridView.builder(
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        childAspectRatio: 1.15,
                        crossAxisSpacing: 12,
                        mainAxisSpacing: 12,
                      ),
                      itemCount: _classDescriptors.length,
                      itemBuilder: (context, index) {
                        final cls = _classDescriptors[index];
                        final isSelected = _selectedClass != null &&
                            _selectedClass!['name'] == cls['name'];

                        return GestureDetector(
                          onTap: () => _selectClass(cls),
                          child: Card(
                            elevation: isSelected ? 6 : 2,
                            color: isSelected ? Colors.amber[50] : Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                              side: isSelected
                                  ? const BorderSide(color: Colors.amber, width: 2)
                                  : BorderSide.none,
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(12),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                        decoration: BoxDecoration(
                                          color: Colors.brown[100],
                                          borderRadius: BorderRadius.circular(6),
                                        ),
                                        child: Text(
                                          cls['category'] ?? '',
                                          style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600),
                                        ),
                                      ),
                                      const Spacer(),
                                      _buildDifficultyChip(cls['difficulty']),
                                    ],
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    cls['name'] ?? '',
                                    style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
                                  ),
                                  if (cls['keywords'] != null)
                                    Padding(
                                      padding: const EdgeInsets.only(top: 4, bottom: 6),
                                      child: Wrap(
                                        spacing: 4,
                                        runSpacing: -4,
                                        children: (cls['keywords'] as List)
                                            .map((k) => Chip(
                                                  label: Text(k.toString(), style: const TextStyle(fontSize: 9)),
                                                  visualDensity: VisualDensity.compact,
                                                  padding: EdgeInsets.zero,
                                                ))
                                            .toList(),
                                      ),
                                    ),
                                  const Spacer(),
                                  Text(
                                    cls['description'] ?? '',
                                    maxLines: 3,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(fontSize: 11, color: Colors.black87),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),

                  if (_selectedClass != null) ...[
                    const SizedBox(height: 12),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: Colors.green[50],
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: Colors.green.shade300),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Selected: ${_selectedClass!['name']}",
                            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 4),
                          const Text(
                            'Starting stats from classes.json + full class features will apply here in the next iteration.',
                            style: TextStyle(fontSize: 12),
                          ),
                        ],
                      ),
                    ),
                  ],
                ],
              ),
            ),
    );
  }

  Widget _buildDifficultyChip(String? difficulty) {
    Color color;
    switch (difficulty) {
      case 'Easy':
        color = Colors.green;
        break;
      case 'Medium':
        color = Colors.orange;
        break;
      case 'Advanced':
        color = Colors.redAccent;
        break;
      case 'Extreme':
        color = Colors.purple;
        break;
      default:
        color = Colors.grey;
    }
    return Chip(
      label: Text(difficulty ?? '', style: const TextStyle(fontSize: 10, color: Colors.white)),
      backgroundColor: color,
      visualDensity: VisualDensity.compact,
      padding: EdgeInsets.zero,
    );
  }
}