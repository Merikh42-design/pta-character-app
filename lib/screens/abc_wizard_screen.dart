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

  int currentStep = 1;
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
    setState(() => currentStep = step);
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
                  _buildProgressIndicator(),
                  const SizedBox(height: 16),
                  Expanded(child: _buildCurrentStep()),
                  const SizedBox(height: 12),
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
            width: 30,
            height: 30,
            decoration: BoxDecoration(
              color: isCompleted || isActive ? Colors.brown[700] : Colors.grey[300],
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(step.toString(), style: TextStyle(color: isCompleted || isActive ? Colors.white : Colors.black54, fontWeight: FontWeight.bold, fontSize: 13)),
            ),
          ),
          const SizedBox(height: 3),
          Text(label, style: const TextStyle(fontSize: 11)),
        ],
      ),
    );
  }

  Widget _buildStepLine() {
    return Container(width: 32, height: 2, color: Colors.brown[300], margin: const EdgeInsets.symmetric(horizontal: 3));
  }

  Widget _buildCurrentStep() {
    switch (currentStep) {
      case 1: return _buildClassStep();
      case 2: return _buildAncestryStep();
      case 3: return _buildBackgroundStep();
      default: return const SizedBox.shrink();
    }
  }

  Widget _buildClassStep() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Step 1: Choose Your Class', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        Expanded(child: _buildClassGrid()),
      ],
    );
  }

  Widget _buildAncestryStep() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Step 2: Choose Your Ancestry', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        Expanded(child: _buildAncestryGrid()),
      ],
    );
  }

  Widget _buildBackgroundStep() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Step 3: Choose Your Background', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        Expanded(child: _buildBackgroundGrid()),
      ],
    );
  }

  // ==================== CLASS ====================

  Widget _buildClassGrid() {
    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.92,
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
        elevation: isSelected ? 5 : 2,
        color: isSelected ? Colors.amber[50] : Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12), side: isSelected ? const BorderSide(color: Colors.amber, width: 2) : BorderSide.none),
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2), decoration: BoxDecoration(color: Colors.brown[100], borderRadius: BorderRadius.circular(5)), child: Text(cls['category'] ?? '', style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w600))),
                  const Spacer(),
                  _buildDifficultyChip(cls['difficulty']),
                ],
              ),
              const SizedBox(height: 6),
              Text(className, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              if (cls['keywords'] != null)
                Padding(padding: const EdgeInsets.only(top: 3, bottom: 4), child: Wrap(spacing: 3, children: (cls['keywords'] as List).map((k) => Chip(label: Text(k.toString(), style: const TextStyle(fontSize: 9)), visualDensity: VisualDensity.compact, padding: EdgeInsets.zero)).toList())),
              Expanded(child: Padding(padding: const EdgeInsets.symmetric(vertical: 4), child: Image.asset(imagePath, fit: BoxFit.contain, errorBuilder: (context, error, stackTrace) => Container(decoration: BoxDecoration(color: Colors.grey[100], borderRadius: BorderRadius.circular(6)), child: const Center(child: Icon(Icons.image_outlined, color: Colors.grey, size: 28))))),
              Text(cls['description'] ?? '', maxLines: 2, overflow: TextOverflow.ellipsis, style: const TextStyle(fontSize: 11)),
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
    return Chip(label: Text(difficulty ?? '', style: const TextStyle(fontSize: 9, color: Colors.white)), backgroundColor: color, visualDensity: VisualDensity.compact, padding: EdgeInsets.zero);
  }

  // ==================== ANCESTRY ====================

  Widget _buildAncestryGrid() {
    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 1.05,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
      ),
      itemCount: _ancestries.length,
      itemBuilder: (context, index) {
        final anc = _ancestries[index];
        final isSelected = _selectedAncestry != null && _selectedAncestry!['name'] == anc['name'];
        return _buildAncestryCard(ancestry: anc, isSelected: isSelected);
      },
    );
  }

  Widget _buildAncestryCard({required Map<String, dynamic> ancestry, required bool isSelected}) {
    final name = ancestry['name'] ?? '';
    final category = ancestry['category'] ?? '';
    final description = ancestry['description'] ?? '';
    final bonuses = ancestry['bonuses'] ?? ancestry['traits'] ?? '';

    return GestureDetector(
      onTap: () => _selectAncestry(ancestry),
      child: Card(
        elevation: isSelected ? 5 : 2,
        color: isSelected ? Colors.amber[50] : Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12), side: isSelected ? const BorderSide(color: Colors.amber, width: 2) : BorderSide.none),
        child: Padding(
          padding: const EdgeInsets.all(11),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(name, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              if (category.isNotEmpty) Padding(padding: const EdgeInsets.only(top: 1, bottom: 5), child: Text(category, style: const TextStyle(fontSize: 11, color: Colors.grey, fontStyle: FontStyle.italic))),
              if (description.isNotEmpty) Expanded(child: Text(description, maxLines: 6, overflow: TextOverflow.ellipsis, style: const TextStyle(fontSize: 12.5))),
              if (bonuses.isNotEmpty) Padding(padding: const EdgeInsets.only(top: 6), child: Text('Bonuses: $bonuses', style: const TextStyle(fontSize: 11, color: Colors.green[700], fontWeight: FontWeight.w500))),
            ],
          ),
        ),
      ),
    );
  }

  // ==================== BACKGROUND ====================

  Widget _buildBackgroundStep() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Step 3: Choose Your Background', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        Expanded(child: _buildBackgroundGrid()),
      ],
    );
  }

  Widget _buildBackgroundGrid() {
    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 1.05,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
      ),
      itemCount: _backgrounds.length,
      itemBuilder: (context, index) {
        final bg = _backgrounds[index];
        final isSelected = _selectedBackground != null && _selectedBackground!['Name'] == bg['Name'];
        return _buildBackgroundCard(background: bg, isSelected: isSelected);
      },
    );
  }

  Widget _buildBackgroundCard({required Map<String, dynamic> background, required bool isSelected}) {
    final name = background['Name'] ?? background['name'] ?? '';
    final category = background['Category'] ?? background['category'] ?? '';
    final description = background['Description'] ?? background['description'] ?? '';
    final bonuses = background['Bonuses'] ?? background['bonuses'] ?? background['traits'] ?? '';

    return GestureDetector(
      onTap: () => _selectBackground(background),
      child: Card(
        elevation: isSelected ? 5 : 2,
        color: isSelected ? Colors.amber[50] : Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12), side: isSelected ? const BorderSide(color: Colors.amber, width: 2) : BorderSide.none),
        child: Padding(
          padding: const EdgeInsets.all(11),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(name, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              if (category.isNotEmpty) Padding(padding: const EdgeInsets.only(top: 1, bottom: 5), child: Text(category, style: const TextStyle(fontSize: 11, color: Colors.grey, fontStyle: FontStyle.italic))),
              if (description.isNotEmpty) Expanded(child: Text(description, maxLines: 6, overflow: TextOverflow.ellipsis, style: const TextStyle(fontSize: 12.5))),
              if (bonuses.isNotEmpty) Padding(padding: const EdgeInsets.only(top: 6), child: Text('Bonuses: $bonuses', style: const TextStyle(fontSize: 11, color: Colors.green[700], fontWeight: FontWeight.w500))),
            ],
          ),
        ),
      ),
    );
  }

  // ==================== NAVIGATION ====================

  Widget _buildNavigationButtons() {
    final canGoNext = _canProceedToNextStep();

    return Row(
      children: [
        if (currentStep > 1) Expanded(child: OutlinedButton(onPressed: () => _goToStep(currentStep - 1), style: OutlinedButton.styleFrom(minimumSize: const Size(double.infinity, 50)), child: const Text('Back', style: TextStyle(fontSize: 15)))),
        if (currentStep > 1) const SizedBox(width: 10),
        Expanded(
          child: ElevatedButton(
            onPressed: canGoNext ? () { if (currentStep == 3) { Navigator.pushNamed(context, '/character_sheet'); } else { _goToStep(currentStep + 1); } } : null,
            style: ElevatedButton.styleFrom(minimumSize: const Size(double.infinity, 50), backgroundColor: Colors.brown[700]),
            child: Text(currentStep == 3 ? 'Continue to Character Sheet' : 'Next', style: const TextStyle(fontSize: 15)),
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
}