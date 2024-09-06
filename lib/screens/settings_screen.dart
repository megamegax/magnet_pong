import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gravity_pong/widgets/neon_button.dart';
import 'package:gravity_pong/widgets/neon_text.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsScreen extends ConsumerStatefulWidget {
  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {
  late TextEditingController _nameController;
  String? _savedName;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _loadName();
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  Future<void> _loadName() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _savedName = prefs.getString('playerName');
      _nameController.text = _savedName ?? '';
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.colorScheme.background, // Háttér szín a témából
      appBar: AppBar(
        title: Text('Settings', style: theme.textTheme.titleLarge),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            NeonText('Player Name:', style: theme.textTheme.titleLarge),
            SizedBox(height: 10),
            _buildNeonTextField(_nameController, theme),
            SizedBox(height: 20),
            Center(
              child: NeonButton(
                  text: 'Save',
                  onPressed: () {
                    _savePlayerName();
                  }),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNeonTextField(
      TextEditingController controller, ThemeData theme) {
    return TextField(
      controller: controller,
      style:
          theme.textTheme.bodyLarge?.copyWith(color: theme.colorScheme.primary),
      decoration: InputDecoration(
        filled: true,
        fillColor: theme.colorScheme.surface,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.0),
          borderSide: BorderSide(color: theme.colorScheme.primary),
        ),
      ),
    );
  }

  void _savePlayerName() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('playerName', _nameController.text);
  }
}
