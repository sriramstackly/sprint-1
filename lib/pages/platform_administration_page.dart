
import 'package:flutter/material.dart';

class PlatformAdministrationPage extends StatefulWidget {
  const PlatformAdministrationPage({super.key});

  @override
  State<PlatformAdministrationPage> createState() =>
      _PlatformAdministrationPageState();
}

class _PlatformAdministrationPageState
    extends State<PlatformAdministrationPage> {
  static const Color primaryBlue = Color(0xFF1769FF);
  static const Color greenColor = Color(0xFF16A36A);
  static const double phoneWidth = 550;

  final List<_ManagementItem> managementItems = const [
    _ManagementItem(
      'Super Admin Dashboard',
      'Platform status, KPIs, system health and recent admin activity.',
      Icons.dashboard_outlined,
    ),
    _ManagementItem(
      'Global Dashboard',
      'Platform-wide KPIs across every organization.',
      Icons.public_outlined,
    ),
    _ManagementItem(
      'Platform Configuration',
      'Platform name, timezone, session limits and environment defaults.',
      Icons.settings_outlined,
    ),
    _ManagementItem(
      'Platform Branding',
      'Logo, brand colors, login background and custom domain.',
      Icons.palette_outlined,
    ),
    _ManagementItem(
      'Feature Management',
      'Manage features and rollout percentages across tenants.',
      Icons.extension_outlined,
    ),
    _ManagementItem(
      'Platform Health Overview',
      'Monitor authentication, APIs, database and storage.',
      Icons.monitor_heart_outlined,
    ),
    _ManagementItem(
      'License Management',
      'Manage license status, seat usage and renewal dates.',
      Icons.description_outlined,
    ),
    _ManagementItem(
      'Settings',
      'Platform defaults, security policies and notifications.',
      Icons.apps_outlined,
    ),
  ];

  final List<_ManagementItem> organizationItems = const [
    _ManagementItem(
      'Company Setup',
      'Business units, departments, branches and legal entity details.',
      Icons.business_outlined,
    ),
    _ManagementItem(
      'User Management',
      'Invite, deactivate and manage organization users.',
      Icons.people_alt_outlined,
    ),
  ];

  Widget _menuButton() {
    return Container(
      width: 44,
      height: 44,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: const Color(0xFFD5DBE7),
        ),
      ),
      child: IconButton(
        tooltip: 'Menu',
        onPressed: () {
          final scaffold = Scaffold.maybeOf(context);
          if (scaffold != null && scaffold.hasDrawer) {
            scaffold.openDrawer();
          }
        },
        icon: const Icon(
          Icons.menu,
          color: Color(0xFF202A3A),
          size: 22,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final phone = constraints.maxWidth < phoneWidth;

        return SingleChildScrollView(
          padding: EdgeInsets.all(phone ? 14 : 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Mobile menu button
              if (phone) ...[
                _menuButton(),
                const SizedBox(height: 20),
              ],

              // Breadcrumb
              RichText(
                text: const TextSpan(
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                  ),
                  children: [
                    TextSpan(
                      text: 'Platform Administration',
                      style: TextStyle(
                        color: Color(0xFF6B7487),
                      ),
                    ),
                    TextSpan(
                      text: '  /  ',
                      style: TextStyle(
                        color: Color(0xFF6B7487),
                      ),
                    ),
                    TextSpan(
                      text: 'Dashboard',
                      style: TextStyle(
                        color: Color(0xFF172033),
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 10),

              // Welcome heading
              const Text(
                'Welcome back, Sriram',
                style: TextStyle(
                  fontSize: 21,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF172033),
                ),
              ),

              const SizedBox(height: 5),

              const Text(
                'Monitor your platform and manage your organization.',
                style: TextStyle(
                  fontSize: 12,
                  color: Color(0xFF6B7487),
                ),
              ),

              const SizedBox(height: 24),

              _sectionTitle('PLATFORM OVERVIEW'),

              const SizedBox(height: 12),

              // Platform overview cards
              LayoutBuilder(
                builder: (context, box) {
                  final width = box.maxWidth;

                  final columns = width < phoneWidth
                      ? 1
                      : width < 900
                          ? 2
                          : 3;

                  final cardWidth =
                      (width - (columns - 1) * 14) / columns;

                  return Wrap(
                    spacing: 14,
                    runSpacing: 14,
                    children: [
                      SizedBox(
                        width: cardWidth,
                        child: _statCard(
                          'TOTAL USERS',
                          '96,412',
                          '↑ 1.8% this month',
                          Icons.people_outline,
                        ),
                      ),
                      SizedBox(
                        width: cardWidth,
                        child: _statCard(
                          'ACTIVE USERS',
                          '78,930',
                          '4,215 online now',
                          Icons.wifi_tethering_outlined,
                        ),
                      ),
                      SizedBox(
                        width: cardWidth,
                        child: _statCard(
                          'ORGANIZATIONS',
                          '1,842',
                          '↑ 4.2% this month',
                          Icons.apartment_outlined,
                        ),
                      ),
                      SizedBox(
                        width: cardWidth,
                        child: _statCard(
                          'LICENSES ACTIVE',
                          '2,140',
                          '27 expiring < 30 days',
                          Icons.description_outlined,
                        ),
                      ),
                      SizedBox(
                        width: cardWidth,
                        child: _uptimeCard(),
                      ),
                    ],
                  );
                },
              ),

              const SizedBox(height: 28),

              // Super Admin Management
              _sectionTitle('SUPER ADMIN MANAGEMENT'),

              const SizedBox(height: 12),

              LayoutBuilder(
                builder: (context, box) {
                  final width = box.maxWidth;
                  final columns = width < 850 ? 2 : 3;
                  final gap = phone ? 8.0 : 14.0;

                  final cardWidth =
                      (width - (columns - 1) * gap) / columns;

                  return Wrap(
                    spacing: gap,
                    runSpacing: 10,
                    children: [
                      for (final item in managementItems)
                        SizedBox(
                          width: cardWidth,
                          child: _managementCard(
                            item,
                            compact: phone,
                          ),
                        ),
                    ],
                  );
                },
              ),

              const SizedBox(height: 28),

              // Organization
              _sectionTitle('ORGANIZATION'),

              const SizedBox(height: 12),

              LayoutBuilder(
                builder: (context, box) {
                  final width = box.maxWidth;

                  final cardWidth = width < 650
                      ? width
                      : (width - 14) / 2;

                  return Wrap(
                    spacing: 14,
                    runSpacing: 10,
                    children: [
                      for (final item in organizationItems)
                        SizedBox(
                          width: cardWidth,
                          child: _managementCard(item),
                        ),
                    ],
                  );
                },
              ),

              const SizedBox(height: 10),
            ],
          ),
        );
      },
    );
  }

  // Section heading
  Widget _sectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 11,
        fontWeight: FontWeight.w800,
        color: Color(0xFF6B7487),
        letterSpacing: 0.8,
      ),
    );
  }

  // Statistics card
  Widget _statCard(
    String title,
    String value,
    String subtitle,
    IconData icon,
  ) {
    return Container(
      height: 112,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: const Color(0xFFD5DBE7),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF5A6479),
                  ),
                ),
              ),
              Icon(
                icon,
                size: 19,
                color: primaryBlue,
              ),
            ],
          ),
          const Spacer(),
          Text(
            value,
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w800,
              color: Color(0xFF172033),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            subtitle,
            style: const TextStyle(
              fontSize: 10.5,
              fontWeight: FontWeight.w600,
              color: greenColor,
            ),
          ),
        ],
      ),
    );
  }

  // Platform uptime card
  Widget _uptimeCard() {
    return Container(
      height: 112,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [
            Color(0xFF1769FF),
            Color(0xFF1045B8),
          ],
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'PLATFORM UPTIME',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 10,
                  fontWeight: FontWeight.w800,
                ),
              ),
              Icon(
                Icons.monitor_heart_outlined,
                color: Colors.white,
              ),
            ],
          ),
          Spacer(),
          Text(
            '99.98%',
            style: TextStyle(
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.w800,
            ),
          ),
          SizedBox(height: 4),
          Text(
            'Healthy — all regions',
            style: TextStyle(
              color: Colors.white,
              fontSize: 10.5,
            ),
          ),
        ],
      ),
    );
  }

  // Management cards
  Widget _managementCard(
    _ManagementItem item, {
    bool compact = false,
  }) {
    return InkWell(
      borderRadius: BorderRadius.circular(10),
      onTap: () {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${item.title} selected'),
          ),
        );
      },
      child: Container(
        constraints: BoxConstraints(
          minHeight: compact ? 90 : 125,
        ),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: const Color(0xFFE1E6EF),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: const Color(0xFFEAF1FF),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                item.icon,
                color: primaryBlue,
                size: 20,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              item.title,
              style: const TextStyle(
                fontSize: 12.5,
                fontWeight: FontWeight.w700,
                color: Color(0xFF202A3A),
              ),
            ),
            if (!compact) ...[
              const SizedBox(height: 6),
              Text(
                item.description,
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 11,
                  height: 1.45,
                  color: Color(0xFF5F6B80),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

// Management item model
class _ManagementItem {
  final String title;
  final String description;
  final IconData icon;

  const _ManagementItem(
    this.title,
    this.description,
    this.icon,
  );
}

