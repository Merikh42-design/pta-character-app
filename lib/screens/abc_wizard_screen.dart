import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/data_service.dart';
import '../providers/character_provider.dart';

class ABCWizardScreen extends ConsumerStatefulWidget {
  const ABCWizardScreen({super.key});

  @override
  ConsumerState<ABCWizardScreen> createState() => _ABCWizardScreenState();
}

class _ABCWizardScreenState extends ConsumerState<ABCWizardScreen> {
  List<Map<String, dynamic>> _classDescriptors = [];
  List<Map<String, dynamic>> _ancestries = [];
  List<Map<String, dynamic>> _backgrounds = [];

  Map<String, dynamic>? _selectedClass;
  Map<String, dynamic>? _selectedAncestry;
  Map<String, dynamic>? _selectedBackground;

  int currentStep = 1; // 1 = Class, 2 = Ancestry, 3 = Background
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final descriptors = await DataService.loadClassDescriptors();
    final ancestries = await DataService.loadAncestries();
    final backgrounds = await DataService.loadBackgrounds();

    setState(() {
      _classDescriptors = descriptors;
      _ancestries = ancestries;
      _backgrounds = backgrounds;
      _isLoading = false;
    });
  }

  void _goToStep(int step) {
    setState(() {
      currentStep = step;
    });
  }

  Future<void> _selectClass(Map<String, dynamic> classData) async {
    final className = classData['name'] as String;
    setState(() => _selectedClass = classData);
    await ref.read(characterProvider.notifier).selectClass(className);
  }

  Future<void> _selectAncestry(Map<String, dynamic> ancestryData) async {
    final name = ancestryData['name'] as String;
    setState(() => _selectedAncestry = ancestryData);
    await ref.read(characterProvider.notifier).selectAncestry(name);
  }

  Future<void> _selectBackground(Map<String, dynamic> backgroundData) async {
    final name = backgroundData['Name'] as String;
    setState(() => _selectedBackground = backgroundData);
    await ref.read(characterProvider.notifier).selectBackground(name);
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
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  // Progress indicator (now tappable)
                  _buildProgressIndicator(),
                  const SizedBox(height: 20),

                  // Current Step Content
                  Expanded(child: _buildCurrentStep()),

                  const SizedBox(height: 16),

                  // Navigation Buttons (Next + Back)
                  _buildNavigationButtons(),
                ],
              ),
            ),
    );
  }

  Widget _buildProgressIndicator() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildStepCircle(1, 'Class'),
        _buildStepLine(),
        _buildStepCircle(2, 'Ancestry'),
        _buildStepLine(),
        _buildStepCircle(3, 'Background'),
      ],
    );
  }

  Widget _buildStepCircle(int step, String label) {
    final isActive = currentStep == step;
    final isCompleted = currentStep > step;

    return GestureDetector(
      onTap: () => _goToStep(step),
      child: Column(
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: isCompleted || isActive ? Colors.brown[700] : Colors.grey[300],
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                step.toString(),
                style: TextStyle(
                  color: isCompleted || isActive ? Colors.white : Colors.black54,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          const SizedBox(height: 4),
          Text(label, style: const TextStyle(fontSize: 12)),
        ],
      ),
    );
  }

  Widget _buildStepLine() {
    return Container(
      width: 40,
      height: 2,
      color: Colors.brown[300],
      margin: const EdgeInsets.symmetric(horizontal: 4),
    );
  }

  Widget _buildCurrentStep() {
    switch (currentStep) {
      case 1:
        return _buildClassStep();
      case 2:
        return _buildAncestryStep();
      case 3:
        return _buildBackgroundStep();
      default:
        return const SizedBox.shrink();
    }
  }

  Widget _buildClassStep() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Step 1: Choose Your Class', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
        const SizedBox(height: 12),
        Expanded(child: _buildClassGrid()),
      ],
    );
  }

  Widget _buildAncestryStep() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Step 2: Choose Your Ancestry', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
        const SizedBox(height: 12),
        Expanded(child: _buildAncestryGrid()),
      ],
    );
  }

  Widget _buildBackgroundStep() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Step 3: Choose Your Background', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
        const SizedBox(height: 12),
        Expanded(child: _buildBackgroundGrid()),
      ],
    );
  }

  Widget _buildNavigationButtons() {
    final canGoNext = _canProceedToNextStep();

    return Row(
      children: [
        // Back button
        if (currentStep > 1)
          Expanded(
            child: OutlinedButton(
              onPressed: () => _goToStep(currentStep - 1),
              style: OutlinedButton.styleFrom(
                minimumSize: const Size(double.infinity, 52),
              ),
              child: const Text('Back', style: TextStyle(fontSize: 16)),
            ),
          ),

        if (currentStep > 1) const SizedBox(width: 12),

        // Next / Continue button
        Expanded(
          child: ElevatedButton(
            onPressed: canGoNext
                ? () {
                    if (currentStep == 3) {
                      Navigator.pushNamed(context, '/character_sheet');
                    } else {
                      _goToStep(currentStep + 1);
                    }
                  }
                : null,
            style: ElevatedButton.styleFrom(
              minimumSize: const Size(double.infinity, 52),
              backgroundColor: Colors.brown[700],
            ),
            child: Text(
              currentStep == 3 ? 'Continue to Character Sheet' : 'Next',
              style: const TextStyle(fontSize: 16),
            ),
          ),
        ),
      ],
    );
  }

  bool _canProceedToNextStep() {
    if (currentStep == 1) return _selectedClass != null;
    if (currentStep == 2) return _selectedAncestry != null;
    if (currentStep == 3) return _selectedBackground != null;
    return false;
  }

  // ==================== CLASS CARDS ====================

  Widget _buildClassGrid() {
    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.95,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
      ),
      itemCount: _classDescriptors.length,
      itemBuilder: (context, index) {
        final cls = _classDescriptors[index];
        final isSelected = _selectedClass != null && _selectedClass!['name'] == cls['name'];
        return _buildClassCard(cls: cls, isSelected: isSelected);
      },
    );
  }

  Widget _buildClassCard({required Map<String, dynamic> cls, required bool isSelected}) {
    final className = cls['name'] ?? '';
    final imagePath = 'assets/images/classes/${className.toLowerCase().replaceAll(' ', '_')}.png';

    return GestureDetector(
      onTap: () => _selectClass(cls),
      child: Card(
        elevation: isSelected ? 6 : 2,
        color: isSelected ? Colors.amber[50] : Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: isSelected ? const BorderSide(color: Colors.amber, width: 2) : BorderSide.none,
        ),
        child: Padding(
          padding: const EdgeInsets.all(10),
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
                    child: Text(cls['category'] ?? '', style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600)),
                  ),
                  const Spacer(),
                  _buildDifficultyChip(cls['difficulty']),
                ],
              ),
              const SizedBox(height: 8),
              Text(className, style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold)),
              if (cls['keywords'] != null)
                Padding(
                  padding: const EdgeInsets.only(top: 4, bottom: 6),
                  child: Wrap(
                    spacing: 4,
                    children: (cls['keywords'] as List)
                        .map((k) => Chip(
                              label: Text(k.toString(), style: const TextStyle(fontSize: 10)),
                              visualDensity: VisualDensity.compact,
                              padding: EdgeInsets.zero,
                            ))
                        .toList(),
                  ),
                ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 6),
                  child: Image.asset(
                    imagePath,
                    fit: BoxFit.contain,
                    errorBuilder: (context, error, stackTrace) => Container(
                      decoration: BoxDecoration(color: Colors.grey[100], borderRadius: BorderRadius.circular(8)),
                      child: const Center(child: Icon(Icons.image_outlined, color: Colors.grey, size: 32)),
                    ),
                  ),
                ),
              ),
              Text(cls['description'] ?? '', maxLines: 3, overflow: TextOverflow.ellipsis, style: const TextStyle(fontSize: 11)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDifficultyChip(String? difficulty) {
    Color color = Colors.grey;
    if (difficulty == 'Easy') color = Colors.green;
    if (difficulty == 'Medium') color = Colors.orange;
    if (difficulty == 'Advanced') color = Colors.redAccent;
    if (difficulty == 'Extreme') color = Colors.purple;

    return Chip(
      label: Text(difficulty ?? '', style: const TextStyle(fontSize: 10, color: Colors.white)),
      backgroundColor: color,
      visualDensity: VisualDensity.compact,
      padding: EdgeInsets.zero,
    );
  }

  // ==================== ANCESTRY & BACKGROUND ====================

  Widget _buildAncestryGrid() {
    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 1.1,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
      ),
      itemCount: _ancestries.length,
      itemBuilder: (context, index) {
        final anc = _ancestries[index];
        final isSelected = _selectedAncestry != null && _selectedAncestry!['name'] == anc['name'];
        return _buildSimpleCard(title: anc['name'] ?? '', subtitle: anc['category'] ?? '', isSelected: isSelected, onTap: () => _selectAncestry(anc));
      },
    );
  }

  Widget _buildBackgroundGrid() {
    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 1.1,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
      ),
      itemCount: _backgrounds.length,
      itemBuilder: (context, index) {
        final bg = _backgrounds[index];
        final isSelected = _selectedBackground != null && _selectedBackground!['Name'] == bg['Name'];
        return _buildSimpleCard(title: bg['Name'] ?? '', subtitle: bg['Category'] ?? '', isSelected: isSelected, onTap: () => _selectBackground(bg));
      },
    );
  }

  Widget _buildSimpleCard({
    required String title,
    required String subtitle,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        elevation: isSelected ? 6 : 2,
        color: isSelected ? Colors.amber[50] : Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12), side: isSelected ? const BorderSide(color: Colors.amber, width: 2) : BorderSide.none),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              const SizedBox(height: 4),
              Text(subtitle, style: const TextStyle(fontSize: 12, color: Colors.grey)),
            ],
          ),
        ),
      ),
    );
  }
}