import 'package:flutter/material.dart';
import 'package:dynamic_icon_plus/dynamic_icon_plus.dart';

void main() {
  runApp(const DynamicIconExampleApp());
}

class DynamicIconExampleApp extends StatelessWidget {
  const DynamicIconExampleApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'DynamicIconPlus Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorSchemeSeed: const Color(0xFF6366F1),
        useMaterial3: true,
        brightness: Brightness.light,
      ),
      darkTheme: ThemeData(
        colorSchemeSeed: const Color(0xFF818CF8),
        useMaterial3: true,
        brightness: Brightness.dark,
      ),
      themeMode: ThemeMode.system,
      home: const IconSwitcherScreen(),
    );
  }
}

class IconSwitcherScreen extends StatefulWidget {
  const IconSwitcherScreen({super.key});

  @override
  State<IconSwitcherScreen> createState() => _IconSwitcherScreenState();
}

class _IconSwitcherScreenState extends State<IconSwitcherScreen> {
  bool _isSupported = false;
  String? _currentIcon;
  bool _isLoading = false;

  final List<IconThemeOption> _iconThemes = [
    IconThemeOption(
      id: null,
      name: 'Default Classic',
      description: 'Standard brand icon (Sapphire Blue)',
      color: Color(0xFF0284C7),
      iconData: Icons.shield_rounded,
    ),
    IconThemeOption(
      id: 'dark_icon',
      name: 'Midnight Dark',
      description: 'Deep obsidian and violet for night mode',
      color: Color(0xFF8B5CF6),
      iconData: Icons.dark_mode_rounded,
    ),
    IconThemeOption(
      id: 'gold_icon',
      name: 'Gold VIP Luxury',
      description: 'Premium gold accent for VIP subscribers',
      color: Color(0xFFF59E0B),
      iconData: Icons.workspace_premium_rounded,
    ),
    IconThemeOption(
      id: 'neon_icon',
      name: 'Neon Emerald',
      description: 'Vibrant futuristic glowing neon theme',
      color: Color(0xFF10B981),
      iconData: Icons.bolt_rounded,
    ),
  ];

  @override
  void initState() {
    super.initState();
    _loadIconStatus();
  }

  Future<void> _loadIconStatus() async {
    setState(() => _isLoading = true);
    try {
      final supported = await DynamicIconPlus.supportsAlternateIcons;
      final current = await DynamicIconPlus.getAlternateIconName();

      setState(() {
        _isSupported = supported;
        _currentIcon = current;
      });
    } catch (e) {
      debugPrint('Error loading icon status: $e');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _switchIcon(String? iconName) async {
    setState(() => _isLoading = true);
    try {
      if (iconName == null) {
        await DynamicIconPlus.reset(showAlert: false);
      } else {
        await DynamicIconPlus.setIcon(iconName, showAlert: false);
      }

      final updated = await DynamicIconPlus.getAlternateIconName();
      setState(() => _currentIcon = updated);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              iconName == null
                  ? 'App icon restored to Default!'
                  : 'App icon switched to "$iconName"!',
            ),
            behavior: SnackBarBehavior.floating,
            backgroundColor: const Color(0xFF10B981),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to switch icon: $e'),
            behavior: SnackBarBehavior.floating,
            backgroundColor: const Color(0xFFEF4444),
          ),
        );
      }
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('🎭 DynamicIconPlus Demo'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadIconStatus,
            tooltip: 'Refresh status',
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              padding: const EdgeInsets.all(20),
              children: [
                // Status Header Card
                Card(
                  elevation: 0,
                  color: Theme.of(context).colorScheme.primaryContainer.withValues(alpha: 0.3),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                    side: BorderSide(
                      color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.2),
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Icon(
                              _isSupported ? Icons.check_circle : Icons.warning_rounded,
                              color: _isSupported ? Colors.green : Colors.orange,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              _isSupported
                                  ? 'Dynamic Icons Supported'
                                  : 'Alternate Icons Not Supported',
                              style: const TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                        const Divider(height: 24),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text('Active Icon:'),
                            Chip(
                              label: Text(
                                _currentIcon ?? 'Default Classic',
                                style: const TextStyle(fontWeight: FontWeight.bold),
                              ),
                              backgroundColor: Colors.blue.withValues(alpha: 0.15),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 24),

                const Text(
                  'Choose App Launcher Icon:',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 12),

                // Icon Grid / List
                ..._iconThemes.map((theme) {
                  final isSelected = _currentIcon == theme.id;
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: InkWell(
                      onTap: () => _switchIcon(theme.id),
                      borderRadius: BorderRadius.circular(16),
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: isSelected ? theme.color : Colors.grey.withValues(alpha: 0.2),
                            width: isSelected ? 2.5 : 1,
                          ),
                          color: isSelected
                              ? theme.color.withValues(alpha: 0.08)
                              : Theme.of(context).cardColor,
                        ),
                        child: Row(
                          children: [
                            Container(
                              width: 52,
                              height: 52,
                              decoration: BoxDecoration(
                                color: theme.color.withValues(alpha: 0.15),
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(color: theme.color.withValues(alpha: 0.4)),
                              ),
                              child: Icon(theme.iconData, color: theme.color, size: 28),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    theme.name,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    theme.description,
                                    style: Theme.of(context).textTheme.bodySmall,
                                  ),
                                ],
                              ),
                            ),
                            if (isSelected)
                              Icon(Icons.check_circle_rounded, color: theme.color, size: 24)
                            else
                              const Icon(Icons.chevron_right_rounded, color: Colors.grey),
                          ],
                        ),
                      ),
                    ),
                  );
                }),
              ],
            ),
    );
  }
}

class IconThemeOption {
  final String? id;
  final String name;
  final String description;
  final Color color;
  final IconData iconData;

  const IconThemeOption({
    required this.id,
    required this.name,
    required this.description,
    required this.color,
    required this.iconData,
  });
}
