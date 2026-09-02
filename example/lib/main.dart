import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
  bool _autoExitToHome = true;

  final List<IconThemeOption> _iconThemes = [
    IconThemeOption(
      id: null,
      name: 'Default Classic',
      description: 'Asosiy standart brend ikonkasi (Moviy)',
      color: Color(0xFF0284C7),
      iconData: Icons.shield_rounded,
    ),
    IconThemeOption(
      id: 'dark_icon',
      name: 'Midnight Dark',
      description: 'Tungi rejim uchun qora va binafsharang',
      color: Color(0xFF8B5CF6),
      iconData: Icons.dark_mode_rounded,
    ),
    IconThemeOption(
      id: 'gold_icon',
      name: 'Gold VIP Luxury',
      description: 'VIP obunachilar uchun oltin tojli ikonka',
      color: Color(0xFFF59E0B),
      iconData: Icons.workspace_premium_rounded,
    ),
    IconThemeOption(
      id: 'neon_icon',
      name: 'Neon Emerald',
      description: 'Yorqin zamonaviy yashil neon ikonka',
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
                  ? 'Ikonka asl holiga (Default) qaytarildi!'
                  : 'Ikonka muvaffaqiyatli "$iconName" ga o\'zgartirildi!',
            ),
            behavior: SnackBarBehavior.floating,
            backgroundColor: const Color(0xFF10B981),
            duration: const Duration(seconds: 2),
          ),
        );
      }

      // Agar bosh ekranga chiqish yoqilgan bo'lsa, foydalanuvchiga ikonkani ko'rsatish uchun minimizatsiya qiladi
      if (_autoExitToHome) {
        await Future.delayed(const Duration(milliseconds: 600));
        await SystemNavigator.pop();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Xatolik: $e'),
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
            tooltip: 'Yangilash',
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
                                  ? 'Dinamik Ikonkalar Qo\'llab-quvvatlanadi'
                                  : 'Bu qurilmada ruxsat berilmagan',
                              style: const TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                        const Divider(height: 24),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text('Hozirgi Aktiv Ikonka:'),
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
                const SizedBox(height: 16),

                // Switch: Auto-exit to Home Screen
                SwitchListTile(
                  title: const Text(
                    'Ikonka tanlanganda Bosh ekranga chiqish',
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
                  subtitle: const Text(
                    'Tanlangan ikonkani darhol telefon ekranida ko\'rish uchun appdan chiqadi',
                  ),
                  value: _autoExitToHome,
                  onChanged: (val) => setState(() => _autoExitToHome = val),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                    side: BorderSide(color: Colors.grey.withValues(alpha: 0.2)),
                  ),
                ),
                const SizedBox(height: 20),

                const Text(
                  'Ilova Belgisini Tanlang:',
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
