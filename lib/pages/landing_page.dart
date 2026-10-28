import 'package:flutter/material.dart';
import 'platform_administration_page.dart';
import 'global_dashboard_page.dart';
import 'platform_configuration_page.dart';
import 'platform_identity_page.dart';
import 'feature_management_page.dart';
import 'license_management_page.dart';
import 'platform_health_overview_page.dart';
import 'global_settings_page.dart';
import 'notification_page.dart';

/// ============================================================
/// LOGO IMAGE
/// ============================================================
/// Two logo files are used (both must be listed in pubspec.yaml):
///   assets/icons/stackly.img.png     -> inside the dark side menu
///   assets/icons/stacklyone.img.png  -> in the top bar (phone + desktop)
///
///   flutter:
///     assets:
///       - assets/icons/image.png
///       - assets/icons/stackly.img.png
///       - assets/icons/stacklyone.img.png
///
/// If an image is missing, a plain icon + "STACKLY" text is shown
/// instead, so the app never crashes.
const String kLogoAssetPath = 'assets/icons/stackly.img.png';
const String kTopBarLogoAssetPath = 'assets/icons/stacklyone.img.png';

// ============================================================
// LOGO SIZES  (change these two numbers to make the logo bigger
// or smaller. The picture keeps its shape automatically, and on
// very narrow phones it shrinks itself to fit.)
// ============================================================
const double kSidebarLogoHeight = 64; // logo inside the side menu
const double kMobileLogoHeight = 120; // logo in the top bar on phones

class LandingPage extends StatefulWidget {
  const LandingPage({super.key});

  @override
  State<LandingPage> createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  // ============================================================
  // COLORS
  // ============================================================

  static const Color sidebarColor = Color(0xFF0B1230);
  static const Color primaryBlue = Color(0xFF1769FF);
  static const Color greenColor = Color(0xFF16A36A);
  static const Color amberColor = Color(0xFFB98900);
  static const Color redColor = Color(0xFFE0443E);

  // Sidebar text colors (bright, so they are easy to read on dark)
  static const Color sidebarText = Color(0xFFC8D3EA);
  static const Color sidebarTextStrong = Color(0xFFFFFFFF);

  // Below this width the sidebar becomes a drawer opened by the
  // three-line (hamburger) button.
  static const double mobileBreakpoint = 900;

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  // ============================================================
  // SELECTED MENU / LANGUAGE
  // ============================================================

  // selectedMenu = the page that is open.
  // selectedGroup = which sidebar group the highlighted item is in
  // (needed because some names, like "User Management", appear twice).
  String selectedMenu = 'Super Admin Management';
  String? selectedGroup = 'PLATFORM ADMINISTRATION';
  String selectedLanguage = 'English';

  // Desktop only: the double-arrow button hides / shows the sidebar.
  bool sidebarVisible = true;

  // ============================================================
  // SIDEBAR MENU DATA
  // ============================================================

  static const List<_SidebarGroupData> sidebarGroups = [
    _SidebarGroupData(
      title: 'PLATFORM ADMINISTRATION',
      icon: Icons.admin_panel_settings_outlined,
      items: [
        'Platform Administration',
        'Super Admin Management',
        'Global Dashboard',
        'Platform Configuration',
        'Global Settings',
        'Platform Branding',
        'License Management',
        'Feature Management',
        'Platform Health Overview',
        'Settings',
      ],
    ),
    _SidebarGroupData(
      title: 'TENANT MANAGEMENT',
      icon: Icons.apartment_outlined,
      items: [
        'Tenant Management',
        'Create Tenant',
        'Tenant Configuration',
        'Tenant Branding',
        'Tenant Database',
        'Tenant Isolation',
        'Tenant Backup',
      ],
    ),
    _SidebarGroupData(
      title: 'ORGANIZATION MANAGEMENT',
      icon: Icons.corporate_fare_outlined,
      items: [
        'Organization Management',
        'Company Setup',
        'Business Units',
        'Departments',
        'Branches',
        'Cost Center',
        'Locations',
      ],
    ),
    _SidebarGroupData(
      title: 'USER MANAGEMENT',
      icon: Icons.people_alt_outlined,
      items: [
        'User Management',
        'User Registration',
        'User Import',
        'User Profile',
        'User Activation',
        'User Deactivation',
        'Bulk User Upload',
      ],
    ),
    _SidebarGroupData(
      title: 'ROLE & PERMISSION MANAGEMENT',
      icon: Icons.admin_panel_settings_outlined,
      items: [
        'Roles & Permission Management',
        'Roles',
        'Permissions',
        'RBAC',
        'Data Permissions',
        'Department Permissions',
      ],
    ),
    _SidebarGroupData(
      title: 'AUTHENTICATION & SECURITY',
      icon: Icons.shield_outlined,
      items: [
        'Authentication & Security',
        'Login',
        'Login History',
        'SSO (Single Sign-On)',
        'OAuth',
        'MFA',
        'Password Policy',
        'Account Lockout',
        'Security Alerts',
        'Device Management',
        'Session Management',
      ],
    ),
    _SidebarGroupData(
      title: 'SYSTEM CONFIGURATION',
      icon: Icons.settings_outlined,
      items: [
        'System Configuration',
        'General Settings',
        'Localization',
        'Currency',
        'Time Zone',
        'Email Configuration',
        'SMS Configuration',
      ],
    ),
    _SidebarGroupData(
      title: 'AUDIT & COMPLIANCE',
      icon: Icons.fact_check_outlined,
      items: [
        'Audit & Compliance',
        'Audit Logs',
        'Activity Logs',
        'Security Logs',
      ],
    ),
  ];

  static const String organizationGroupKey = 'ORGANIZATION';

  static const List<_OrgMenuData> organizationMenu = [
    _OrgMenuData('Company Setup', Icons.business_outlined),
    _OrgMenuData('User Management', Icons.people_alt_outlined),
  ];

  // Tracks which dropdown groups are currently open.
  final Set<String> expandedGroups = {'PLATFORM ADMINISTRATION'};

  _SidebarGroupData? _groupFor(String title) {
    for (final group in sidebarGroups) {
      if (group.items.contains(title)) return group;
    }
    return null;
  }

  // Opens a page + highlights it in the sidebar.
  void _select(String title, {String? group}) {
    final String? g = group ?? _groupFor(title)?.title;
    // If the phone drawer is open, close it.
    _scaffoldKey.currentState?.closeDrawer();
    setState(() {
      selectedMenu = title;
      selectedGroup = g;
      if (g != null && g != organizationGroupKey) {
        expandedGroups.add(g);
      }
    });
  }

  // ============================================================
  // DASHBOARD DATA (would normally come from an API)
  // ============================================================

  bool isRefreshing = false;

  final List<Map<String, String>> securityAlerts = const [
    {
      'title': '27 licenses expiring within 30 days',
      'subtitle': 'Review renewals before Sep 22.',
      'level': 'warning',
    },
    {
      'title': '3 organizations awaiting activation approval',
      'subtitle': 'Submitted via self-signup, pending review.',
      'level': 'info',
    },
    {
      'title': 'Unusual login pattern detected',
      'subtitle': 'Delta Retail Group — 3 logins from new locations.',
      'level': 'danger',
    },
  ];

  final List<Map<String, String>> recentLogins = const [
    {
      'title': 'Ana Ferreira signed in from Lisbon, PT',
      'subtitle': '18 minutes ago',
      'status': 'ok',
    },
    {
      'title': 'Unrecognized device signed in to Delta Retail Group',
      'subtitle': '52 minutes ago',
      'status': 'warning',
    },
    {
      'title': 'sriram (Super Admin) signed in',
      'subtitle': '3 hours ago',
      'status': 'ok',
    },
    {
      'title': 'sriram (Super Admin) signed in',
      'subtitle': '3 hours ago',
      'status': 'ok',
    },
    {
      'title': '5 failed attempts on account j.mehta@acmecorp.com — locked',
      'subtitle': '5 hours ago',
      'status': 'danger',
    },
  ];

  // ============================================================
  // BUILD
  // ============================================================

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final bool mobile = constraints.maxWidth < mobileBreakpoint;

        return Scaffold(
          key: _scaffoldKey,
          backgroundColor: const Color(0xFFF5F7FB),

          // Phone / small window: sidebar lives in a drawer.
          drawer: mobile
              ? Drawer(
                  width: 290,
                  backgroundColor: sidebarColor,
                  shape: const RoundedRectangleBorder(),
                  child: SafeArea(child: _buildSidebarContent()),
                )
              : null,

          body: SafeArea(
            child: Row(
              children: [
                if (!mobile && sidebarVisible)
                  Container(
                    width: 280,
                    color: sidebarColor,
                    child: _buildSidebarContent(),
                  ),
                Expanded(child: _buildMainArea(mobile)),
              ],
            ),
          ),
        );
      },
    );
  }

  // ============================================================
  // SIDEBAR
  // ============================================================

  Widget _buildSidebarContent() {
    return Column(
      children: [
        // ---------------- LOGO ----------------
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 24, 20, 14),
          child: Align(
            alignment: Alignment.centerLeft,
            child: _logoMark(
              height: kSidebarLogoHeight,
              fallbackColor: Colors.white,
            ),
          ),
        ),

        // ---------------- "ONE ENTERPRISE CLOUD" PILL ----------------
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 8),
            decoration: BoxDecoration(
              color: const Color(0xFF0F2A2E),
              borderRadius: BorderRadius.circular(22),
              border: Border.all(color: const Color(0xFF2E7D6B)),
            ),
            child: const Text(
              'ONE ENTERPRISE CLOUD',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Color(0xFF5FE3C0),
                fontSize: 12,
                fontWeight: FontWeight.w600,
                letterSpacing: 1.6,
                fontFamily: 'monospace',
              ),
            ),
          ),
        ),

        const SizedBox(height: 14),

        // ---------------- SCROLLABLE MENU ----------------
        Expanded(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.fromLTRB(12, 0, 12, 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                for (final group in sidebarGroups) _sidebarGroupItem(group),

                const SizedBox(height: 14),
                _sidebarSectionLabel('ORGANIZATION'),
                const SizedBox(height: 6),
                for (final item in organizationMenu)
                  _sidebarItem(
                    title: item.title,
                    groupKey: organizationGroupKey,
                    icon: item.icon,
                  ),

                const SizedBox(height: 14),
                const Divider(color: Color(0xFF1F2B52), height: 1),
                _buildSidebarFooter(),
              ],
            ),
          ),
        ),
      ],
    );
  }

  // Logo picture.
  // - Wrapped in FittedBox(scaleDown) so it never overflows: on a narrow
  //   phone it simply shrinks to fit the free space.
  // - If the file is missing, an icon + "STACKLY" text is shown instead.
  Widget _logoMark({
    required double height,
    required Color fallbackColor,
    String asset = kLogoAssetPath,
  }) {
    return SizedBox(
      height: height,
      child: FittedBox(
        fit: BoxFit.scaleDown,
        alignment: Alignment.centerLeft,
        child: Image.asset(
          asset,
          height: height,
          fit: BoxFit.contain,
          alignment: Alignment.centerLeft,
          filterQuality: FilterQuality.high,
          errorBuilder: (context, error, stackTrace) {
            debugPrint('Stackly logo error ($asset): $error');

            return Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.layers_outlined,
                  color: fallbackColor,
                  size: height * 0.6,
                ),
                const SizedBox(width: 6),
                Text(
                  'STACKLY',
                  style: TextStyle(
                    color: fallbackColor,
                    fontSize: height * 0.32,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 1.1,
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _sidebarSectionLabel(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      child: Text(
        text,
        style: const TextStyle(
          color: Color(0xFFA9B7D6),
          fontSize: 11,
          fontWeight: FontWeight.w600,
          letterSpacing: 1.6,
        ),
      ),
    );
  }

  // ---------------- Dropdown group: heading + items ----------------
  Widget _sidebarGroupItem(_SidebarGroupData group) {
    final bool expanded = expandedGroups.contains(group.title);
    final bool groupActive = selectedGroup == group.title;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        InkWell(
          borderRadius: BorderRadius.circular(8),
          onTap: () {
            setState(() {
              if (expanded) {
                expandedGroups.remove(group.title);
              } else {
                expandedGroups.add(group.title);
              }
            });
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 13),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    group.title,
                    style: TextStyle(
                      color: groupActive ? sidebarTextStrong : sidebarText,
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.6,
                    ),
                  ),
                ),
                Icon(
                  expanded ? Icons.expand_less : Icons.expand_more,
                  size: 18,
                  color: sidebarText,
                ),
              ],
            ),
          ),
        ),
        AnimatedSize(
          duration: const Duration(milliseconds: 180),
          alignment: Alignment.topCenter,
          child: expanded
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    for (final item in group.items)
                      _sidebarItem(title: item, groupKey: group.title),
                  ],
                )
              : const SizedBox(width: double.infinity, height: 0),
        ),
      ],
    );
  }

  // One clickable line inside a dropdown (or the Organization list).
  Widget _sidebarItem({
    required String title,
    required String groupKey,
    IconData? icon,
  }) {
    final bool selected = selectedMenu == title && selectedGroup == groupKey;

    return Padding(
      padding: const EdgeInsets.only(bottom: 3),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () => _select(title, group: groupKey),
        child: Container(
          width: double.infinity,
          padding: EdgeInsets.only(
            left: icon == null ? 24 : 12,
            right: 12,
            top: 12,
            bottom: 12,
          ),
          decoration: BoxDecoration(
            color: selected ? const Color(0xFF16234D) : Colors.transparent,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: selected ? primaryBlue : Colors.transparent,
              width: 1.3,
            ),
          ),
          child: Row(
            children: [
              if (icon != null) ...[
                Icon(
                  icon,
                  size: 18,
                  color: selected ? sidebarTextStrong : sidebarText,
                ),
                const SizedBox(width: 12),
              ],
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    color: selected ? sidebarTextStrong : sidebarText,
                    fontSize: 14,
                    fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ============================================================
  // SIDEBAR FOOTER: LANGUAGE, PROFILE
  // ============================================================

  Widget _buildSidebarFooter() {
    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          InkWell(
            borderRadius: BorderRadius.circular(8),
            onTap: _showLanguagePicker,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              child: Row(
                children: [
                  const Icon(Icons.language, size: 18, color: sidebarText),
                  const SizedBox(width: 12),
                  const Expanded(
                    child: Text(
                      'Language',
                      style: TextStyle(color: sidebarText, fontSize: 14, fontWeight: FontWeight.w500),
                    ),
                  ),
                  Text(
                    selectedLanguage,
                    style: const TextStyle(color: sidebarText, fontSize: 12.5, fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(width: 4),
                  const Icon(Icons.expand_more, size: 16, color: sidebarText),
                ],
              ),
            ),
          ),
          const SizedBox(height: 8),
          InkWell(
            borderRadius: BorderRadius.circular(10),
            onTap: _showProfileMenu,
            child: Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: const Color(0xFF16234D),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                children: [
                  _profileAvatar(size: 34),
                  const SizedBox(width: 10),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'sriram',
                          style: TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w700),
                        ),
                        SizedBox(height: 2),
                        Text(
                          'Super Admin',
                          style: TextStyle(color: Color(0xFFB4C0DC), fontSize: 11, fontWeight: FontWeight.w500),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Round avatar with the first letter (no image needed).
  Widget _profileAvatar({required double size}) {
    return Container(
      width: size,
      height: size,
      alignment: Alignment.center,
      decoration: const BoxDecoration(color: primaryBlue, shape: BoxShape.circle),
      child: const Text(
        'S',
        style: TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w700),
      ),
    );
  }

  // Round gradient avatar (teal -> blue) with the "S" letter,
  // used in the phone top bar.
  Widget _gradientAvatar({required double size}) {
    return Container(
      width: size,
      height: size,
      alignment: Alignment.center,
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF7FD6C2), Color(0xFF3D8FD6)],
        ),
      ),
      child: Text(
        'S',
        style: TextStyle(
          color: Colors.white,
          fontSize: size * 0.4,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }

  void _showLanguagePicker() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        final languages = ['English', 'Hindi', 'Tamil', 'Spanish'];
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Padding(
                padding: EdgeInsets.all(16),
                child: Text(
                  'Select language',
                  style: TextStyle(fontWeight: FontWeight.w800, fontSize: 14),
                ),
              ),
              for (final lang in languages)
                ListTile(
                  title: Text(lang),
                  trailing: selectedLanguage == lang
                      ? const Icon(Icons.check, color: primaryBlue)
                      : null,
                  onTap: () {
                    setState(() => selectedLanguage = lang);
                    Navigator.of(context).pop();
                  },
                ),
              const SizedBox(height: 8),
            ],
          ),
        );
      },
    );
  }

  void _showProfileMenu() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Opening profile settings…'),
        behavior: SnackBarBehavior.floating,
      ),
    );
    // TODO: open your real profile/account page.
  }

  // ============================================================
  // PAGE ROUTING
  // ============================================================
  // Returns the page for the selected menu item.
  // Returning null shows the Super Admin Dashboard below.
  //
  //   'Platform Administration'  -> PlatformAdministrationPage
  //   'Global Dashboard'         -> GlobalDashboardPage
  //   'Platform Configuration'   -> PlatformConfigurationPage
  //   'Global Settings'          -> GlobalSettingsPage
  //   'Platform Branding'        -> PlatformIdentityPage
  //   'Feature Management'       -> FeatureManagementPage
  //   'License Management'       -> LicenseManagementPage
  //   'Platform Health Overview' -> PlatformHealthOverviewPage
  //
  // Every other item shows a simple placeholder page until you build it.
  Widget? _pageForSelectedMenu() {
    switch (selectedMenu) {
      case 'Super Admin Dashboard':
      case 'Super Admin Management':
        return null;
      case 'Platform Administration':
        return const PlatformAdministrationPage();
      case 'Global Dashboard':
        return const GlobalDashboardPage();
      case 'Platform Configuration':
        return PlatformConfigurationPage();
      case 'Global Settings':
        return GlobalSettingsPage();
      case 'Platform Branding':
        return PlatformIdentityPage();
      case 'Feature Management':
        return FeatureManagementPage();
      case 'License Management':
        return LicenseManagementPage();
      case 'Platform Health Overview':
        return PlatformHealthOverviewPage();
      default:
        final group = _groupFor(selectedMenu);
        return _placeholderPage(
          title: selectedMenu,
          icon: group?.icon ?? Icons.dashboard_customize_outlined,
          description:
              'This page is not built yet. Replace this placeholder with your own page.',
        );
    }
  }

  Widget _placeholderPage({
    required String title,
    required IconData icon,
    required String description,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 70),
      child: Column(
        children: [
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              color: const Color(0xFFEAF1FF),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Icon(icon, size: 30, color: primaryBlue),
          ),
          const SizedBox(height: 18),
          Text(
            title,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w800,
              color: Color(0xFF172033),
            ),
          ),
          const SizedBox(height: 8),
          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 420),
            child: Text(
              description,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 13, color: Color(0xFF6B7487)),
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // MAIN AREA
  // ============================================================

  Widget _buildMainArea(bool mobile) {
    final double pad = mobile ? 16 : 28;

    return Column(
      children: [
        // Top bar. On phones it is a white block with a divider line
        // under it (like the design); on desktop it keeps the page colour.
        Container(
          decoration: BoxDecoration(
            color: mobile ? Colors.white : const Color(0xFFF5F7FB),
            border: mobile
                ? const Border(bottom: BorderSide(color: Color(0xFFE3E8F0)))
                : null,
          ),
          padding: EdgeInsets.fromLTRB(pad, mobile ? 8 : 22, pad, mobile ? 14 : 15),
          child: mobile ? _buildMobileTopBar() : _buildTopBar(),
        ),
        Expanded(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            padding: EdgeInsets.fromLTRB(pad, mobile ? 16 : 4, pad, 35),
            child: _pageForSelectedMenu() ??
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildDashboardHeader(mobile),
                    const SizedBox(height: 22),
                    _sectionLabel('PLATFORM OVERVIEW'),
                    const SizedBox(height: 10),
                    _buildPlatformOverview(),
                    const SizedBox(height: 24),
                    _sectionLabel('SYSTEM STATUS'),
                    const SizedBox(height: 10),
                    _buildSystemStatus(),
                    const SizedBox(height: 24),
                    _sectionLabel('RESOURCE UTILIZATION'),
                    const SizedBox(height: 10),
                    _buildResourceUtilization(),
                    const SizedBox(height: 24),
                    _sectionLabel('QUICK NAVIGATION'),
                    const SizedBox(height: 10),
                    _buildQuickNavigation(),
                    const SizedBox(height: 24),
                    LayoutBuilder(
                      builder: (context, constraints) {
                        final bool wide = constraints.maxWidth >= 900;

                        final alerts = _buildSecurityAlertsCard();
                        final activity = _buildRecentActivityCard();

                        if (wide) {
                          return Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(child: alerts),
                              const SizedBox(width: 16),
                              Expanded(child: activity),
                            ],
                          );
                        }

                        return Column(
                          children: [
                            alerts,
                            const SizedBox(height: 16),
                            activity,
                          ],
                        );
                      },
                    ),
                    // (The phone "Export report" button that used to sit
                    // below Recent login activities has been removed.)
                  ],
                ),
          ),
        ),
      ],
    );
  }

  Widget _sectionLabel(String text) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 10.5,
        fontWeight: FontWeight.w800,
        color: Color(0xFF6B7487),
        letterSpacing: 0.8,
      ),
    );
  }

  // ============================================================
  // TOP BAR - DESKTOP
  // ============================================================

  Widget _buildTopBar() {
    return Row(
      children: [
        IconButton(
          onPressed: () => setState(() => sidebarVisible = !sidebarVisible),
          padding: EdgeInsets.zero,
          constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
          icon: Icon(
            sidebarVisible
                ? Icons.keyboard_double_arrow_left
                : Icons.keyboard_double_arrow_right,
            color: const Color(0xFF52627F),
            size: 25,
          ),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 420),
            child: _searchBox(),
          ),
        ),
        const SizedBox(width: 18),
        _bellButton(),
        const SizedBox(width: 18),
        _profileAvatar(size: 38),
        const SizedBox(width: 10),
        const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'sriram',
              style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: Color(0xFF202A3A)),
            ),
            SizedBox(height: 2),
            Text(
              'Super Admin',
              style: TextStyle(fontSize: 10, color: Color(0xFF6B7487)),
            ),
          ],
        ),
      ],
    );
  }

  // ============================================================
  // TOP BAR - MOBILE
  // Row 1: menu button | STACKLY logo | bell (red dot) + "S" avatar
  // Row 2: pill search bar
  // ============================================================

  Widget _buildMobileTopBar() {
    return Column(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // THREE LINES: opens the sidebar drawer
            InkWell(
              borderRadius: BorderRadius.circular(12),
              onTap: () => _scaffoldKey.currentState?.openDrawer(),
              child: Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: const Color(0xFFF7F9FC),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: const Color(0xFFE3E8F0)),
                ),
                child: const Icon(Icons.menu, color: Color(0xFF202A3A), size: 24),
              ),
            ),
            const SizedBox(width: 10),

            // Logo takes all the free space in the middle and
            // shrinks automatically if the phone is very narrow.
            Expanded(
              child: Align(
                alignment: Alignment.centerLeft,
                child: _logoMark(
                  height: kMobileLogoHeight,
                  fallbackColor: primaryBlue,
                  asset: kTopBarLogoAssetPath,
                ),
              ),
            ),
            const SizedBox(width: 8),

            // Bell sits right beside the "S" avatar.
            _bellButton(mobile: true),
            const SizedBox(width: 8),
            InkWell(
              customBorder: const CircleBorder(),
              onTap: _showProfileMenu,
              child: _gradientAvatar(size: 46),
            ),
          ],
        ),
        const SizedBox(height: 8),
        _searchBox(pill: true),
      ],
    );
  }

  Widget _searchBox({bool pill = false}) {
    return Container(
      height: pill ? 50 : 44,
      decoration: BoxDecoration(
        color: pill ? const Color(0xFFF5F7FA) : Colors.white,
        borderRadius: BorderRadius.circular(pill ? 25 : 9),
        border: Border.all(color: const Color(0xFFD5DBE7)),
      ),
      child: Row(
        children: [
          SizedBox(width: pill ? 18 : 14),
          Icon(Icons.search, size: pill ? 22 : 19, color: const Color(0xFF6B7487)),
          SizedBox(width: pill ? 12 : 10),
          Expanded(
            child: Text(
              'Search tenants, users, settings...',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: const Color(0xFF6B7487),
                fontSize: pill ? 14.5 : 12.5,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _bellButton({bool mobile = false}) {
    final double size = mobile ? 44 : 40;

    return InkWell(
      borderRadius: BorderRadius.circular(mobile ? 12 : 9),
      
      onTap: () {
      Navigator.push(
      context,
      MaterialPageRoute(
      builder: (context) => const NotificationPage(),
    ),
  );
},

      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: mobile ? const Color(0xFFF7F9FC) : const Color(0xFFEAF1FF),
          borderRadius: BorderRadius.circular(mobile ? 12 : 9),
          border: mobile ? Border.all(color: const Color(0xFFE3E8F0)) : null,
        ),
        child: Stack(
          alignment: Alignment.center,
          clipBehavior: Clip.none,
          children: [
            Icon(
              Icons.notifications_none_outlined,
              color: const Color(0xFF3B4C6B),
              size: mobile ? 23 : 21,
            ),
            Positioned(
              top: mobile ? -3 : 9,
              right: mobile ? -3 : 10,
              child: Container(
                width: mobile ? 8 : 7,
                height: mobile ? 8 : 7,
                decoration: const BoxDecoration(
                  color: redColor,
                  shape: BoxShape.circle,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ============================================================
  // DASHBOARD HEADER
  // ============================================================

  Widget _buildDashboardHeader(bool mobile) {
    final titleBlock = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Platform Administration / Dashboard',
          style: TextStyle(fontSize: 11, color: Color(0xFF6B7487), fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 6),
        Text(
          'Super Admin Dashboard',
          style: TextStyle(
            fontSize: mobile ? 22 : 24,
            fontWeight: FontWeight.w800,
            color: const Color(0xFF172033),
          ),
        ),
        const SizedBox(height: 4),
        const Text(
          'Welcome back, Super Admin',
          style: TextStyle(fontSize: 12.5, color: Color(0xFF6B7487)),
        ),
      ],
    );

    final refreshButton = OutlinedButton.icon(
      onPressed: _handleRefresh,
      icon: isRefreshing
          ? const SizedBox(
              width: 14,
              height: 14,
              child: CircularProgressIndicator(strokeWidth: 2),
            )
          : const Icon(Icons.refresh, size: 17),
      label: const Text('Refresh'),
      style: OutlinedButton.styleFrom(
        foregroundColor: const Color(0xFF354258),
        side: const BorderSide(color: Color(0xFFC9D0DD)),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(9)),
        textStyle: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700),
      ),
    );

    final exportButton = ElevatedButton.icon(
      onPressed: _handleExportReport,
      icon: const Icon(Icons.file_download_outlined, size: 17),
      label: Text(mobile ? 'Export' : 'Export report'),
      style: ElevatedButton.styleFrom(
        backgroundColor: primaryBlue,
        foregroundColor: Colors.white,
        elevation: 0,
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(9)),
        textStyle: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700),
      ),
    );

    if (mobile) {
      // Phone: title on the left, small refresh icon on the right.
      return Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(child: titleBlock),
          const SizedBox(width: 12),
          InkWell(
            borderRadius: BorderRadius.circular(9),
            onTap: _handleRefresh,
            child: Container(
              width: 40,
              height: 40,
              alignment: Alignment.center,
              child: isRefreshing
                  ? const SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Icon(Icons.refresh, size: 22, color: Color(0xFF354258)),
            ),
          ),
        ],
      );
    }

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(child: titleBlock),
        const SizedBox(width: 16),
        Row(
          children: [
            refreshButton,
            const SizedBox(width: 10),
            exportButton,
          ],
        ),
      ],
    );
  }

  void _handleRefresh() {
    setState(() => isRefreshing = true);
    Future.delayed(const Duration(milliseconds: 700), () {
      if (!mounted) return;
      setState(() => isRefreshing = false);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Dashboard refreshed.'), behavior: SnackBarBehavior.floating),
      );
    });
  }

  void _handleExportReport() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Preparing report export…'), behavior: SnackBarBehavior.floating),
    );
    // TODO: connect to your real export code.
  }

  // ============================================================
  // PLATFORM OVERVIEW
  // ============================================================

  Widget _buildPlatformOverview() {
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;

        // 4 across on big screens, 2 across on tablets (600px),
        // 1 across on phones (400px).
        int columns = 4;
        if (width < 950) columns = 2;
        if (width < 480) columns = 1;
        final itemWidth = (width - (columns - 1) * 14) / columns;

        final cards = [
          _overviewCard(
            icon: Icons.people_alt_outlined,
            label: 'TOTAL USERS',
            value: '96,412',
            footnote: '↑ 1.8% this month',
            footnoteColor: greenColor,
          ),
          _overviewCard(
            icon: Icons.wifi_tethering_outlined,
            label: 'ACTIVE USERS',
            value: '78,930',
            footnote: '● 4,215 online now',
            footnoteColor: greenColor,
          ),
          _overviewCard(
            icon: Icons.apartment_outlined,
            label: 'ORGANIZATIONS',
            value: '1,842',
            footnote: '↑ 4.2% this month',
            footnoteColor: greenColor,
          ),
          _overviewCard(
            icon: Icons.badge_outlined,
            label: 'LICENSES ACTIVE',
            value: '2,140',
            footnote: '27 expiring < 30 days',
            footnoteColor: Colors.white,
            highlighted: true,
          ),
        ];

        return Wrap(
          spacing: 14,
          runSpacing: 14,
          children: [
            for (final card in cards) SizedBox(width: itemWidth, child: card),
          ],
        );
      },
    );
  }

  Widget _overviewCard({
    required IconData icon,
    required String label,
    required String value,
    required String footnote,
    required Color footnoteColor,
    bool highlighted = false,
  }) {
    return InkWell(
      onTap: () {
        // "LICENSES ACTIVE" card opens License Management.
        if (label == 'LICENSES ACTIVE') {
          _select('License Management', group: 'PLATFORM ADMINISTRATION');
        }
      },
      borderRadius: BorderRadius.circular(14),
      child: Container(
        constraints: const BoxConstraints(minHeight: 108),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          gradient: highlighted
              ? const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Color(0xFF1769FF), Color(0xFF2E82FF)],
                )
              : null,
          color: highlighted ? null : Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: highlighted ? null : Border.all(color: const Color(0xFFD5DBE7)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 10.5,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 0.4,
                    color: highlighted ? Colors.white : const Color(0xFF5A6479),
                  ),
                ),
                Icon(icon, size: 17, color: highlighted ? Colors.white : primaryBlue),
              ],
            ),
            const SizedBox(height: 10),
            Text(
              value,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w800,
                color: highlighted ? Colors.white : const Color(0xFF172033),
              ),
            ),
            const SizedBox(height: 6),
            Text(
              footnote,
              style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: footnoteColor),
            ),
          ],
        ),
      ),
    );
  }

  // ============================================================
  // SYSTEM STATUS
  // ============================================================

  Widget _buildSystemStatus() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFD5DBE7)),
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final items = [
            _statusItem('SERVER STATUS', 'Healthy', greenColor),
            _statusItem('DATABASE', 'Connected', greenColor),
            _statusItem('API GATEWAY', 'Running', greenColor),
            _statusItem('STORAGE', '68% used', amberColor),
          ];
          final wide = constraints.maxWidth >= 750;
          if (wide) {
            return Row(
              children: [
                for (int i = 0; i < items.length; i++) ...[
                  Expanded(child: items[i]),
                  if (i != items.length - 1) const SizedBox(width: 14),
                ],
              ],
            );
          }
          return Wrap(
            spacing: 20,
            runSpacing: 16,
            children: [
              for (final item in items)
                SizedBox(width: (constraints.maxWidth - 20) / 2, child: item),
            ],
          );
        },
      ),
    );
  }

  Widget _statusItem(String label, String value, Color dotColor) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 10,
            fontWeight: FontWeight.w800,
            color: Color(0xFF6B7487),
            letterSpacing: 0.4,
          ),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Icon(Icons.circle, size: 9, color: dotColor),
            const SizedBox(width: 7),
            Flexible(
              child: Text(
                value,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: Color(0xFF202A3A)),
              ),
            ),
          ],
        ),
      ],
    );
  }

  // ============================================================
  // RESOURCE UTILIZATION
  // ============================================================

  Widget _buildResourceUtilization() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFD5DBE7)),
      ),
      child: Column(
        children: [
          _resourceBar('CPU usage', 0.42, primaryBlue),
          const SizedBox(height: 16),
          _resourceBar('Memory usage', 0.57, const Color(0xFF7C5CFF)),
          const SizedBox(height: 16),
          _resourceBar('Storage', 0.68, amberColor),
        ],
      ),
    );
  }

  Widget _resourceBar(String label, double value, Color color) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label, style: const TextStyle(fontSize: 12.5, fontWeight: FontWeight.w600, color: Color(0xFF354258))),
            Text(
              '${(value * 100).round()}%',
              style: const TextStyle(fontSize: 12.5, fontWeight: FontWeight.w700, color: Color(0xFF202A3A)),
            ),
          ],
        ),
        const SizedBox(height: 8),
        ClipRRect(
          borderRadius: BorderRadius.circular(6),
          child: LinearProgressIndicator(
            value: value,
            minHeight: 8,
            backgroundColor: const Color(0xFFE3E8F0),
            valueColor: AlwaysStoppedAnimation<Color>(color),
          ),
        ),
      ],
    );
  }

  // ============================================================
  // QUICK NAVIGATION
  // ============================================================

  Widget _buildQuickNavigation() {
    final items = [
      ('User Management', 'Manage accounts & roles', Icons.people_alt_outlined, 'User Management'),
      ('Platform Settings', 'Global configuration', Icons.settings_outlined, 'Platform Configuration'),
      ('License Management', 'Renewals & seat usage', Icons.badge_outlined, 'License Management'),
      ('Audit Logs', 'Track admin actions', Icons.fact_check_outlined, 'Audit Logs'),
      ('Notifications', 'Notification centre', Icons.notifications_none_outlined, 'Notifications'),
      ('Backup & Recovery', 'Snapshots & restore', Icons.settings_backup_restore_outlined, 'Backup & Recovery'),
      ('Reports', 'Platform analytics', Icons.bar_chart_outlined, 'Reports'),
      ('Security Center', 'Threats & policies', Icons.shield_outlined, 'Security Center'),
    ];

    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        int columns = 4;
        if (width < 950) columns = 3;
        if (width < 700) columns = 2;
        if (width < 300) columns = 1;
        final itemWidth = (width - (columns - 1) * 14) / columns;

        return Wrap(
          spacing: 14,
          runSpacing: 14,
          children: [
            for (final item in items)
              SizedBox(
                width: itemWidth,
                child: _quickNavItem(
                  title: item.$1,
                  subtitle: item.$2,
                  icon: item.$3,
                  targetMenu: item.$4,
                ),
              ),
          ],
        );
      },
    );
  }

  Widget _quickNavItem({
    required String title,
    required String subtitle,
    required IconData icon,
    required String targetMenu,
  }) {
    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: () => _select(targetMenu),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: const Color(0xFFD5DBE7)),
        ),
        child: Row(
          children: [
            Container(
              width: 38,
              height: 38,
              decoration: BoxDecoration(
                color: const Color(0xFFEAF1FF),
                borderRadius: BorderRadius.circular(9),
              ),
              child: Icon(icon, color: primaryBlue, size: 19),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: Color(0xFF202A3A)),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontSize: 10.5, color: Color(0xFF6B7487)),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ============================================================
  // SECURITY ALERTS CARD
  // ============================================================

  Widget _buildSecurityAlertsCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFD5DBE7)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Security alerts',
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w800, color: Color(0xFF172033)),
          ),
          const SizedBox(height: 12),
          for (final alert in securityAlerts)
            _alertRow(title: alert['title']!, subtitle: alert['subtitle']!, level: alert['level']!),
          const SizedBox(height: 4),
          Center(
            child: TextButton(
              onPressed: () => _select('Security Alerts'),
              child: const Text(
                'View all alerts',
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: primaryBlue),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _alertRow({required String title, required String subtitle, required String level}) {
    Color color;
    IconData icon;
    switch (level) {
      case 'danger':
        color = redColor;
        icon = Icons.lock_outline;
        break;
      case 'warning':
        color = amberColor;
        icon = Icons.warning_amber_outlined;
        break;
      default:
        color = primaryBlue;
        icon = Icons.info_outline;
    }

    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 30,
            height: 30,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, size: 15, color: color),
          ),
          const SizedBox(width: 11),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontSize: 12.5, fontWeight: FontWeight.w700, color: Color(0xFF202A3A))),
                const SizedBox(height: 2),
                Text(subtitle, style: const TextStyle(fontSize: 11, color: Color(0xFF6B7487))),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // RECENT LOGIN ACTIVITY CARD
  // ============================================================

  
  Widget _buildRecentActivityCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: const Color(0xFFD5DBE7),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Recent login activities heading
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                child: Text(
                  'Recent login activities',
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF172033),
                  ),
                ),
              ),
              SizedBox(width: 8),
              Text(
                'Last 24 hours',
                style: TextStyle(
                  fontSize: 11,
                  color: Color(0xFF6B7487),
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          // Recent login activity list
          for (final entry in recentLogins)
            _activityRow(
              title: entry['title']!,
              subtitle: entry['subtitle']!,
              status: entry['status']!,
            ),

          const SizedBox(height: 4),

          // Full-width Export button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: _handleExportReport,
              icon: const Icon(
                Icons.file_download_outlined,
                size: 16,
              ),
              label: const Text('Export'),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF172DE0),
                foregroundColor: Colors.white,
                elevation: 0,
                padding: const EdgeInsets.symmetric(
                  vertical: 13,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                textStyle: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _activityRow({
    required String title,
    required String subtitle,
    required String status,
  }) {
    Color color;
    IconData icon;

    switch (status) {
      case 'danger':
        color = redColor;
        icon = Icons.error_outline;
        break;

      case 'warning':
        color = amberColor;
        icon = Icons.warning_amber_outlined;
        break;

      default:
        color = greenColor;
        icon = Icons.check_circle_outline;
    }

    return Padding(
      padding: const EdgeInsets.only(bottom: 13),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            icon,
            size: 16,
            color: color,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF202A3A),
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: const TextStyle(
                    fontSize: 10.5,
                    color: Color(0xFF6B7487),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// A dropdown group in the sidebar: a heading plus its list of items.
class _SidebarGroupData {
  final String title;
  final IconData icon; // used only on placeholder pages
  final List<String> items;
  const _SidebarGroupData({
    required this.title,
    required this.icon,
    required this.items,
  });
}

/// An item in the ORGANIZATION list (has its own icon).
class _OrgMenuData {
  final String title;
  final IconData icon;
  const _OrgMenuData(this.title, this.icon);
}