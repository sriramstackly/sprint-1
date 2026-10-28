import 'package:flutter/material.dart';

class LicenseManagementPage extends StatefulWidget {
  const LicenseManagementPage({super.key});

  @override
  State<LicenseManagementPage> createState() =>
      _LicenseManagementPageState();
}

class _LicenseManagementPageState
    extends State<LicenseManagementPage> {
  int currentPage = 1;

  final List<Map<String, dynamic>> licenses = [
    {
      'key': 'LIC-4421-MNPR',
      'plan': 'Standard',
      'seats': '50 Seats',
      'type': 'Org Plan 123 Inc',
      'expiry': 'Nov 02, 2024',
      'status': 'Active',
    },
    {
      'key': 'LIC-4421-MNPR',
      'plan': 'Standard',
      'seats': '50 Seats',
      'type': 'Org Plan 123 Inc',
      'expiry': 'Nov 02, 2024',
      'status': 'Expiring',
    },
    {
      'key': 'LIC-4421-MNPR',
      'plan': 'Standard',
      'seats': '50 Seats',
      'type': 'Org Plan 123 Inc',
      'expiry': 'Nov 02, 2024',
      'status': 'Expiring',
    },
    {
      'key': 'LIC-4421-MNPR',
      'plan': 'Standard',
      'seats': '50 Seats',
      'type': 'Org Plan 123 Inc',
      'expiry': 'Nov 02, 2024',
      'status': 'Rejected',
    },
  ];

 @override
Widget build(BuildContext context) {
  return LayoutBuilder(
    builder: (context, constraints) {
      final bool isMobile = constraints.maxWidth < 700;

      return SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(isMobile),
            const SizedBox(height: 12),
            _buildStatistics(isMobile),
            const SizedBox(height: 14),
            _buildLicenseSection(isMobile),
          ],
        ),
      );
    },
  );
}

  // ============================================================
  // HEADER
  // ============================================================

  Widget _buildHeader(bool isMobile) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 2),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'License Management',
            style: TextStyle(
              fontSize: isMobile ? 17 : 25,
              fontWeight: FontWeight.w700,
              color: const Color(0xff202124),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Manage platform licenses across organizations and tenants',
            style: TextStyle(
              fontSize: isMobile ? 9 : 11,
              color: const Color(0xff747b83),
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // STATISTICS
  // ============================================================

  Widget _buildStatistics(bool isMobile) {
    final cards = [
      _statCard(
        title: 'Total Licenses',
        value: '2,458',
        subtitle: '↑ 12% vs last month',
        icon: Icons.vpn_key_outlined,
        iconBackground: const Color(0xffedf4ff),
        iconColor: const Color(0xff3178d7),
        subtitleColor: const Color(0xff20a463),
      ),
      _statCard(
        title: 'Active Licenses',
        value: '2,104',
        subtitle: '85.6% utilization rate',
        icon: Icons.check_circle_outline,
        iconBackground: const Color(0xffdcfaee),
        iconColor: const Color(0xff20bd83),
        subtitleColor: const Color(0xff626b74),
      ),
      _statCard(
        title: 'Expired licenses',
        value: '142',
        subtitle: 'Within next 30 days',
        icon: Icons.warning_amber_outlined,
        iconBackground: const Color(0xfffff4cf),
        iconColor: const Color(0xffffb800),
        subtitleColor: const Color(0xff626b74),
      ),
      _statCard(
        title: 'Suspended licenses',
        value: '36',
        subtitle: 'Requires admin review',
        icon: Icons.block_outlined,
        iconBackground: const Color(0xffffe6e8),
        iconColor: const Color(0xffee5b65),
        subtitleColor: const Color(0xff626b74),
      ),
    ];

    if (isMobile) {
      return Column(
        children: [
          for (int i = 0; i < cards.length; i++) ...[
            cards[i],
            if (i != cards.length - 1)
              const SizedBox(height: 8),
          ],
        ],
      );
    }

    return Row(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        for (int i = 0; i < cards.length; i++) ...[
          Expanded(child: cards[i]),
          if (i != cards.length - 1)
            const SizedBox(width: 12),
        ],
      ],
    );
  }

  Widget _statCard({
    required String title,
    required String value,
    required String subtitle,
    required IconData icon,
    required Color iconBackground,
    required Color iconColor,
    required Color subtitleColor,
  }) {
    return Container(
      width: double.infinity,
      // A fixed height here clipped the content by 1px on some
      // screens ("BOTTOM OVERFLOWED BY 1.00 PIXELS"). Using a
      // minimum height instead lets the card grow if it ever
      // needs a hair more room, with no visible size difference
      // in the normal case.
      constraints: const BoxConstraints(minHeight: 78),
      padding: const EdgeInsets.symmetric(
        horizontal: 13,
        vertical: 10,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(7),
        border: Border.all(
          color: const Color(0xffe2e7ec),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 9,
                    fontWeight: FontWeight.w500,
                    color: Color(0xff626870),
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: Color(0xff202124),
                  ),
                ),
                const SizedBox(height: 1),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: 7.5,
                    color: subtitleColor,
                  ),
                ),
              ],
            ),
          ),
          Container(
            width: 25,
            height: 25,
            decoration: BoxDecoration(
              color: iconBackground,
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              size: 13,
              color: iconColor,
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // LICENSE SECTION
  // ============================================================

  Widget _buildLicenseSection(bool isMobile) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(
        isMobile ? 8 : 14,
        0,
        isMobile ? 8 : 14,
        10,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: const Color(0xffe3e8ed),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.only(
              top: 11,
              bottom: 9,
            ),
            child: Text(
              'LICENSE LIST',
              style: TextStyle(
                fontSize: 8,
                fontWeight: FontWeight.w600,
                color: Color(0xff777f87),
                letterSpacing: .3,
              ),
            ),
          ),

          _buildFilters(isMobile),

          const SizedBox(height: 12),

          if (isMobile)
            _buildMobileLicenseList()
          else
            _buildDesktopTable(),

          const SizedBox(height: 10),

          _buildBottom(isMobile),
        ],
      ),
    );
  }

  // ============================================================
  // FILTERS
  // ============================================================

  Widget _buildFilters(bool isMobile) {
    if (isMobile) {
      return Column(
        children: [
          _searchBox(),

          const SizedBox(height: 7),

          Row(
            children: [
              Expanded(child: _filterButton('Organization')),
              const SizedBox(width: 5),
              Expanded(child: _filterButton('License Type')),
              const SizedBox(width: 5),
              Expanded(child: _filterButton('Status')),
            ],
          ),
        ],
      );
    }

    return Row(
      children: [
        Expanded(
          child: _searchBox(),
        ),
        const SizedBox(width: 8),
        _filterButton('Organization'),
        const SizedBox(width: 8),
        _filterButton('License Type'),
        const SizedBox(width: 8),
        _filterButton('Status'),
      ],
    );
  }

  Widget _searchBox() {
    return Container(
      height: 29,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(5),
        border: Border.all(
          color: const Color(0xffdfe4e9),
        ),
      ),
      child: Row(
        children: [
          const SizedBox(width: 7),
          Icon(
            Icons.search,
            size: 14,
            color: Colors.grey.shade500,
          ),
          const SizedBox(width: 5),
          Text(
            'Search',
            style: TextStyle(
              fontSize: 9,
              color: Colors.grey.shade500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _filterButton(String text) {
    return Container(
      height: 29,
      padding: const EdgeInsets.symmetric(horizontal: 7),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(5),
        border: Border.all(
          color: const Color(0xffdfe4e9),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Flexible(
            child: Text(
              text,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontSize: 8,
                color: Color(0xff5f666e),
              ),
            ),
          ),
          const SizedBox(width: 3),
          Icon(
            Icons.keyboard_arrow_down,
            size: 12,
            color: Colors.grey.shade600,
          ),
        ],
      ),
    );
  }

  // ============================================================
  // MOBILE LICENSE LIST
  // ============================================================

  Widget _buildMobileLicenseList() {
    return Column(
      children: [
        for (final license in licenses) ...[
          _mobileLicenseCard(license),
          const SizedBox(height: 7),
        ],
      ],
    );
  }

  Widget _mobileLicenseCard(
    Map<String, dynamic> license,
  ) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(
        9,
        9,
        9,
        8,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(6),
        border: Border.all(
          color: const Color(0xffe1e5e9),
        ),
      ),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.start,
                  children: [
                    Text(
                      license['key'],
                      style: const TextStyle(
                        fontSize: 8.5,
                        fontWeight: FontWeight.w600,
                        color: Color(0xff272b30),
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '${license['plan']} · ${license['seats']}',
                      style: TextStyle(
                        fontSize: 7,
                        color: Colors.grey.shade600,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      license['type'],
                      style: TextStyle(
                        fontSize: 7,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
              ),

              _statusBadge(license['status']),
            ],
          ),

          const SizedBox(height: 6),

          Row(
            children: [
              Text(
                'Expires: ',
                style: TextStyle(
                  fontSize: 7,
                  color: Colors.grey.shade500,
                ),
              ),
              Text(
                license['expiry'],
                style: const TextStyle(
                  fontSize: 7,
                  color: Color(0xff41464d),
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),

          const SizedBox(height: 7),

          Row(
            children: [
              Expanded(
                child: _smallActionButton(
                  icon: Icons.refresh,
                  text: 'Renew',
                  color: const Color(0xff252a30),
                ),
              ),
              const SizedBox(width: 5),
              Expanded(
                child: _smallActionButton(
                  icon: Icons.pause_circle_outline,
                  text: 'Suspend',
                  color: const Color(0xffffa000),
                ),
              ),
              const SizedBox(width: 5),
              Expanded(
                child: _smallActionButton(
                  icon: Icons.check_circle_outline,
                  text: 'Activate',
                  color: const Color(0xff18a56b),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ============================================================
  // STATUS
  // ============================================================

  Widget _statusBadge(String status) {
    Color bg;
    Color fg;

    switch (status) {
      case 'Active':
        bg = const Color(0xffddf6e9);
        fg = const Color(0xff24945d);
        break;

      case 'Expiring':
        bg = const Color(0xffffefc6);
        fg = const Color(0xffd99600);
        break;

      default:
        bg = const Color(0xffffe5e7);
        fg = const Color(0xffdc515b);
    }

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 6,
        vertical: 3,
      ),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 4,
            height: 4,
            decoration: BoxDecoration(
              color: fg,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 3),
          Text(
            status,
            style: TextStyle(
              fontSize: 6.5,
              fontWeight: FontWeight.w600,
              color: fg,
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // ACTION BUTTON
  // ============================================================

  Widget _smallActionButton({
    required IconData icon,
    required String text,
    required Color color,
  }) {
    return Container(
      height: 23,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(4),
        border: Border.all(
          color: color.withOpacity(.65),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            size: 10,
            color: color,
          ),
          const SizedBox(width: 3),
          Text(
            text,
            style: TextStyle(
              fontSize: 7,
              color: color,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // DESKTOP TABLE
  // ============================================================

  Widget _buildDesktopTable() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(7),
      child: Column(
        children: [
          Container(
            height: 40,
            color: const Color(0xff20285f),
            child: const Row(
              children: [
                _TableHeader('', 6),
                _TableHeader('LICENSE KEY', 20),
                _TableHeader('ORGANIZATION PLAN', 25),
                _TableHeader('LICENSE TYPE', 21),
                _TableHeader('EXPIRY DATE', 20),
                _TableHeader('STATUS', 18),
              ],
            ),
          ),

          for (final license in licenses)
            _desktopRow(license),
        ],
      ),
    );
  }

  Widget _desktopRow(Map<String, dynamic> license) {
    return Container(
      height: 55,
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          bottom: BorderSide(
            color: Colors.grey.shade200,
          ),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            flex: 6,
            child: Center(
              child: SizedBox(
                width: 14,
                height: 14,
                child: Checkbox(
                  value: false,
                  onChanged: (_) {},
                  materialTapTargetSize:
                      MaterialTapTargetSize.shrinkWrap,
                ),
              ),
            ),
          ),

          Expanded(
            flex: 20,
            child: Text(
              license['key'],
              style: const TextStyle(fontSize: 10),
            ),
          ),

          Expanded(
            flex: 25,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [
                Text(
                  license['plan'],
                  style: const TextStyle(fontSize: 10),
                ),
                Text(
                  license['seats'],
                  style: TextStyle(
                    fontSize: 9,
                    color: Colors.grey.shade600,
                  ),
                ),
              ],
            ),
          ),

          Expanded(
            flex: 21,
            child: Text(
              license['type'],
              style: const TextStyle(fontSize: 10),
            ),
          ),

          Expanded(
            flex: 20,
            child: Text(
              license['expiry'],
              style: const TextStyle(fontSize: 10),
            ),
          ),

          Expanded(
            flex: 18,
            child: _statusBadge(license['status']),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // BOTTOM
  // ============================================================

  Widget _buildBottom(bool isMobile) {
    if (isMobile) {
      return Column(
        children: [
          Row(
            children: [
              Expanded(
                child: _outlineButton(
                  Icons.file_download_outlined,
                  'Export',
                ),
              ),
              const SizedBox(width: 7),
              Expanded(
                flex: 2,
                child: _createButton(),
              ),
            ],
          ),

          const SizedBox(height: 8),

          Text(
            'Showing 1–5 of 2,458 entries',
            style: TextStyle(
              fontSize: 7,
              color: Colors.grey.shade600,
            ),
          ),

          const SizedBox(height: 7),

          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _pageButton(Icons.chevron_left),
              _numberButton('1', selected: true),
              _numberButton('2'),
              _numberButton('3'),
              _pageButton(Icons.chevron_right),
            ],
          ),
        ],
      );
    }

    return Row(
      children: [
        _outlineButton(
          Icons.file_download_outlined,
          'Export',
        ),
        const Spacer(),
        Text(
          'Showing 1–5 of 2,458 entries',
          style: TextStyle(
            fontSize: 9,
            color: Colors.grey.shade600,
          ),
        ),
        const SizedBox(width: 15),
        _pageButton(Icons.chevron_left),
        _numberButton('1', selected: true),
        _numberButton('2'),
        _numberButton('3'),
        _pageButton(Icons.chevron_right),
        const SizedBox(width: 12),
        _createButton(),
      ],
    );
  }

  Widget _outlineButton(
    IconData icon,
    String text,
  ) {
    return Container(
      height: 29,
      padding: const EdgeInsets.symmetric(
        horizontal: 13,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(5),
        border: Border.all(
          color: const Color(0xffdfe4e9),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            size: 12,
            color: const Color(0xff30343a),
          ),
          const SizedBox(width: 5),
          Text(
            text,
            style: const TextStyle(
              fontSize: 8,
              color: Color(0xff30343a),
            ),
          ),
        ],
      ),
    );
  }

  Widget _createButton() {
    return Container(
      height: 29,
      padding: const EdgeInsets.symmetric(
        horizontal: 12,
      ),
      decoration: BoxDecoration(
        color: const Color(0xff172bd4),
        borderRadius: BorderRadius.circular(5),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: const [
          Icon(
            Icons.add,
            size: 13,
            color: Colors.white,
          ),
          SizedBox(width: 4),
          Text(
            'Create License',
            style: TextStyle(
              color: Colors.white,
              fontSize: 8,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _pageButton(IconData icon) {
    return Container(
      width: 25,
      height: 25,
      margin: const EdgeInsets.only(left: 3),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(4),
        border: Border.all(
          color: const Color(0xffe0e5ea),
        ),
      ),
      child: Icon(
        icon,
        size: 14,
        color: Colors.grey.shade500,
      ),
    );
  }

  Widget _numberButton(
    String number, {
    bool selected = false,
  }) {
    return Container(
      width: 25,
      height: 25,
      margin: const EdgeInsets.only(left: 3),
      decoration: BoxDecoration(
        color: selected
            ? const Color(0xff1476d4)
            : Colors.white,
        borderRadius: BorderRadius.circular(4),
        border: Border.all(
          color: selected
              ? const Color(0xff1476d4)
              : const Color(0xffe0e5ea),
        ),
      ),
      child: Center(
        child: Text(
          number,
          style: TextStyle(
            fontSize: 8,
            color: selected
                ? Colors.white
                : const Color(0xff606770),
            fontWeight: selected
                ? FontWeight.w600
                : FontWeight.normal,
          ),
        ),
      ),
    );
  }
}

// ============================================================
// DESKTOP TABLE HEADER
// ============================================================

class _TableHeader extends StatelessWidget {
  final String text;
  final int flex;

  const _TableHeader(
    this.text,
    this.flex,
  );

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: flex,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 8,
        ),
        child: Text(
          text,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 8,
            fontWeight: FontWeight.w600,
            letterSpacing: .3,
          ),
        ),
      ),
    );
  }
}