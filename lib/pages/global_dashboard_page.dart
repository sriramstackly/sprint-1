import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';

class GlobalDashboardPage extends StatelessWidget {
  const GlobalDashboardPage({super.key});

  static const Color primaryBlue = Color(0xFF1769FF);
  static const Color greenColor = Color(0xFF16A36A);
  static const Color amberColor = Color(0xFFB98900);

  // Below this width the page uses the phone layout.
  static const double phoneWidth = 550;

  // Text colors (dark enough to read easily)
  static const Color textStrong = Color(0xFF172033);
  static const Color textMedium = Color(0xFF354258);
  static const Color textSoft = Color(0xFF5F6B80);
  static const Color borderColor = Color(0xFFD5DBE7);

  // Opens the Export Report screen (see ExportReportPage below).
  void _openExport(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const ExportReportPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // =====================================================
        // HEADER
        // Phone: small path text, title, round refresh icon.
        // Bigger screens: also show the description + Refresh word.
        // =====================================================

        LayoutBuilder(
          builder: (context, constraints) {
            final bool phone = constraints.maxWidth < phoneWidth;

            return Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Platform Administration / Global Dashboard',
                        style: TextStyle(
                          fontSize: 11,
                          color: textSoft,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 6),
                      const Text(
                        'Global Dashboard',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w800,
                          color: textStrong,
                        ),
                      ),
                      if (!phone) ...[
                        const SizedBox(height: 5),
                        const Text(
                          'Track performance, engagement, and growth across all your social platforms in one place.',
                          style: TextStyle(
                            fontSize: 12,
                            color: textSoft,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                if (phone)
                  OutlinedButton(
                    onPressed: () {},
                    style: OutlinedButton.styleFrom(
                      foregroundColor: textMedium,
                      side: const BorderSide(color: Color(0xFFC9D0DD)),
                      minimumSize: const Size(40, 40),
                      padding: EdgeInsets.zero,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(9),
                      ),
                    ),
                    child: const Icon(Icons.refresh, size: 18),
                  )
                else
                  OutlinedButton.icon(
                    onPressed: () {},
                    icon: const Icon(Icons.refresh, size: 16),
                    label: const Text('Refresh'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: textMedium,
                      side: const BorderSide(color: Color(0xFFC9D0DD)),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 11,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(9),
                      ),
                    ),
                  ),
              ],
            );
          },
        ),

        const SizedBox(height: 24),

        _sectionTitle('PLATFORM OVERVIEW'),

        const SizedBox(height: 10),

        // =====================================================
        // OVERVIEW CARDS  (4 across on desktop, 2 x 2 on phone)
        // =====================================================

        LayoutBuilder(
          builder: (context, constraints) {
            final width = constraints.maxWidth;
            final bool phone = width < phoneWidth;

            final cards = [
              _statCard(
                title: 'TOTAL TENANTS',
                value: '132',
                change: '↑ 4% this month',
                icon: Icons.people_alt_outlined,
                color: primaryBlue,
                compact: phone,
              ),
              _statCard(
                title: 'TOTAL USERS',
                value: '48,920',
                change: '↑ 15% this month',
                icon: Icons.verified_user_outlined,
                color: primaryBlue,
                compact: phone,
              ),
              _statCard(
                title: 'ACTIVE SUBSCRIPTIONS',
                value: '1,233',
                change: '↑ 10% this month',
                icon: Icons.card_membership_outlined,
                color: primaryBlue,
                compact: phone,
              ),
              _statCard(
                title: 'ACTIVE SESSIONS',
                value: '789',
                change: '↑ 6% this month',
                icon: Icons.trending_up,
                color: primaryBlue,
                compact: phone,
              ),
            ];

            if (width >= 850) {
              return Row(
                children: [
                  for (int i = 0; i < cards.length; i++) ...[
                    Expanded(child: cards[i]),
                    if (i != cards.length - 1) const SizedBox(width: 14),
                  ],
                ],
              );
            }

            // 2 across (tablet and phone).
            // floorToDouble() removes tiny rounding leftovers that
            // can cause "overflowed by 0.xxx pixels".
            final double gap = phone ? 12 : 14;
            final double cardWidth = ((width - gap) / 2).floorToDouble();

            return Wrap(
              spacing: gap,
              runSpacing: gap,
              children: [
                for (final card in cards)
                  SizedBox(
                    width: cardWidth,
                    child: card,
                  ),
              ],
            );
          },
        ),

        const SizedBox(height: 24),

        // =====================================================
        // QUICK NAVIGATION  (4 across on desktop, 2 x 2 on phone)
        // =====================================================

        _sectionTitle('QUICK NAVIGATION'),

        const SizedBox(height: 10),

        LayoutBuilder(
          builder: (context, constraints) {
            final width = constraints.maxWidth;
            final bool phone = width < phoneWidth;

            final items = [
              (
                'Manage Tenants',
                'Manage accounts & users',
                Icons.people_alt_outlined,
              ),
              (
                'Platform Settings',
                'Global configuration',
                Icons.settings_outlined,
              ),
              (
                'Generate Report',
                'Reports & data usage',
                Icons.description_outlined,
              ),
              (
                'System Monitoring',
                'Track system activities',
                Icons.analytics_outlined,
              ),
            ];

            if (width < 800) {
              final double gap = phone ? 12 : 14;
              final double itemWidth = ((width - gap) / 2).floorToDouble();

              return Wrap(
                spacing: gap,
                runSpacing: gap,
                children: [
                  for (final item in items)
                    SizedBox(
                      width: itemWidth,
                      child: _quickCard(
                        item.$1,
                        item.$2,
                        item.$3,
                        compact: phone,
                      ),
                    ),
                ],
              );
            }

            return Row(
              children: [
                for (int i = 0; i < items.length; i++) ...[
                  Expanded(
                    child: _quickCard(
                      items[i].$1,
                      items[i].$2,
                      items[i].$3,
                    ),
                  ),
                  if (i != items.length - 1) const SizedBox(width: 14),
                ],
              ],
            );
          },
        ),

        const SizedBox(height: 24),

        // =====================================================
        // HEALTH + SYSTEM HEALTH  (one under the other on phone)
        // =====================================================

        LayoutBuilder(
          builder: (context, constraints) {
            if (constraints.maxWidth >= 850) {
              return Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: _platformHealthCard(),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _systemHealthCard(),
                  ),
                ],
              );
            }

            return Column(
              children: [
                _platformHealthCard(),
                const SizedBox(height: 16),
                _systemHealthCard(),
              ],
            );
          },
        ),

        const SizedBox(height: 24),

        // =====================================================
        // SECURITY + RECENT ACTIVITIES
        // =====================================================

        LayoutBuilder(
          builder: (context, constraints) {
            if (constraints.maxWidth >= 850) {
              return Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: _securityAlertsCard(),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _recentActivitiesCard(context),
                  ),
                ],
              );
            }

            return Column(
              children: [
                _securityAlertsCard(),
                const SizedBox(height: 16),
                _recentActivitiesCard(context),
              ],
            );
          },
        ),
      ],
    );
  }

  // ===========================================================
  // SECTION TITLE
  // ===========================================================

  Widget _sectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 10.5,
        fontWeight: FontWeight.w800,
        color: textSoft,
        letterSpacing: 0.8,
      ),
    );
  }

  // ===========================================================
  // CARD TITLE ROW  (title on the left, extra widget on the right)
  // The title is inside Expanded, so it can never push the row
  // past the card edge.
  // ===========================================================

  Widget _cardHeader(String title, Widget trailing) {
    return Row(
      children: [
        Expanded(
          child: Text(
            title,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w800,
              color: textStrong,
            ),
          ),
        ),
        const SizedBox(width: 8),
        trailing,
      ],
    );
  }

  // ===========================================================
  // STAT CARD
  // compact = true on phones (smaller icon and text so the
  // 2 x 2 grid fits without overflow)
  // ===========================================================

  Widget _statCard({
    required String title,
    required String value,
    required String change,
    required IconData icon,
    required Color color,
    bool compact = false,
  }) {
    final double iconBox = compact ? 26 : 30;

    return Container(
      constraints: BoxConstraints(
        minHeight: compact ? 100 : 105,
      ),
      padding: EdgeInsets.all(compact ? 14 : 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: borderColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Expanded = long titles wrap instead of overflowing
              Expanded(
                child: Text(
                  title,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: compact ? 9.5 : 10,
                    fontWeight: FontWeight.w800,
                    color: const Color(0xFF5A6479),
                    letterSpacing: compact ? 0.2 : 0.4,
                  ),
                ),
              ),
              const SizedBox(width: 6),
              Container(
                width: iconBox,
                height: iconBox,
                decoration: BoxDecoration(
                  color: const Color(0xFFEAF1FF),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  icon,
                  size: compact ? 14 : 16,
                  color: color,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              fontSize: compact ? 22 : 23,
              fontWeight: FontWeight.w800,
              color: textStrong,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            change,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
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

  // ===========================================================
  // QUICK CARD
  // compact = true on phones: icon on top, then title, then
  // the small line under it (like the reference photo).
  // ===========================================================

  Widget _quickCard(
    String title,
    String subtitle,
    IconData icon, {
    bool compact = false,
  }) {
    final iconBox = Container(
      width: 38,
      height: 38,
      decoration: BoxDecoration(
        color: const Color(0xFFEAF1FF),
        borderRadius: BorderRadius.circular(9),
      ),
      child: Icon(
        icon,
        color: primaryBlue,
        size: 19,
      ),
    );

    final titleText = Text(
      title,
      style: const TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w700,
        color: Color(0xFF202A3A),
      ),
    );

    final subtitleText = Text(
      subtitle,
      maxLines: compact ? 2 : 1,
      overflow: TextOverflow.ellipsis,
      style: const TextStyle(
        fontSize: 10.5,
        color: textSoft,
      ),
    );

    if (compact) {
      return Container(
        width: double.infinity,
        constraints: const BoxConstraints(minHeight: 112),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: borderColor),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            iconBox,
            const SizedBox(height: 12),
            titleText,
            const SizedBox(height: 3),
            subtitleText,
          ],
        ),
      );
    }

    return Container(
      constraints: const BoxConstraints(
        minHeight: 88,
      ),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: borderColor),
      ),
      child: Row(
        children: [
          iconBox,
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                titleText,
                const SizedBox(height: 3),
                subtitleText,
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ===========================================================
  // PLATFORM HEALTH
  // ===========================================================

  Widget _platformHealthCard() {
    return _whiteCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _cardHeader(
            'Platform Health Status',
            _smallDropdown('Last 7 Days'),
          ),
          const SizedBox(height: 18),
          _healthBar(
            'CPU Usage',
            0.37,
            '37%',
            amberColor,
          ),
          const SizedBox(height: 17),
          _healthBar(
            'Memory Utilization',
            0.54,
            '54%',
            greenColor,
          ),
          const SizedBox(height: 17),
          _healthBar(
            'Disk I/O',
            0.32,
            '32%',
            greenColor,
          ),
          const SizedBox(height: 17),
          _healthBar(
            'Network Bandwidth',
            0.78,
            '78%',
            amberColor,
          ),
        ],
      ),
    );
  }

  Widget _healthBar(
    String title,
    double value,
    String percentage,
    Color color,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                title,
                style: const TextStyle(
                  fontSize: 11.5,
                  color: textMedium,
                ),
              ),
            ),
            const SizedBox(width: 8),
            Text(
              percentage,
              style: TextStyle(
                fontSize: 10.5,
                fontWeight: FontWeight.w700,
                color: color,
              ),
            ),
          ],
        ),
        const SizedBox(height: 7),
        ClipRRect(
          borderRadius: BorderRadius.circular(5),
          child: LinearProgressIndicator(
            value: value,
            minHeight: 7,
            backgroundColor: const Color(0xFFE3E8F0),
            valueColor: AlwaysStoppedAnimation<Color>(color),
          ),
        ),
      ],
    );
  }

  // ===========================================================
  // SYSTEM HEALTH
  // ===========================================================

  Widget _systemHealthCard() {
    return _whiteCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _cardHeader(
            'System Health',
            _smallDropdown('Last 7 Days'),
          ),

          const SizedBox(height: 18),

          // Wrap = the three labels move to a new line on narrow
          // screens instead of running off the card.
          Wrap(
            spacing: 14,
            runSpacing: 6,
            children: [
              _legend(
                'Operational',
                const Color(0xFF6D4BC3),
              ),
              _legend(
                'Degraded',
                primaryBlue,
              ),
              _legend(
                'Down',
                greenColor,
              ),
            ],
          ),

          const SizedBox(height: 20),

          SizedBox(
            height: 150,
            child: CustomPaint(
              painter: _SystemHealthPainter(),
              child: const SizedBox.expand(),
            ),
          ),

          const SizedBox(height: 8),

          // Dates under the chart (sample dates - replace with real ones)
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _DateLabel('May 12'),
              _DateLabel('May 14'),
              _DateLabel('May 16'),
              _DateLabel('May 18'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _legend(String text, Color color) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          Icons.circle,
          size: 8,
          color: color,
        ),
        const SizedBox(width: 5),
        Text(
          text,
          style: const TextStyle(
            fontSize: 10.5,
            color: textSoft,
          ),
        ),
      ],
    );
  }

  Widget _smallDropdown(String text) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          text,
          style: const TextStyle(
            fontSize: 10.5,
            color: textSoft,
          ),
        ),
        const Icon(
          Icons.keyboard_arrow_down,
          size: 15,
          color: textSoft,
        ),
      ],
    );
  }

  // ===========================================================
  // SECURITY ALERTS
  // ===========================================================

  Widget _securityAlertsCard() {
    return _whiteCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _cardHeader(
            'Security alerts',
            TextButton(
              onPressed: () {},
              child: const Text(
                'View all alerts',
                style: TextStyle(
                  fontSize: 10.5,
                  color: primaryBlue,
                ),
              ),
            ),
          ),

          _alertItem(
            'High CPU Usage',
            'Production cluster CPU usage is high',
            '1 hour ago',
            amberColor,
          ),

          _alertItem(
            'Storage Threshold',
            'Storage utilization reached 80%',
            '2 hours ago',
            primaryBlue,
          ),

          _alertItem(
            'New Tenant Registration',
            'Tenant registration is pending',
            '2 hours ago',
            amberColor,
          ),
        ],
      ),
    );
  }

  Widget _alertItem(
    String title,
    String subtitle,
    String time,
    Color color,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(11),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.06),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Icon(
            Icons.warning_amber_outlined,
            size: 16,
            color: color,
          ),
          const SizedBox(width: 9),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 11.5,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF202A3A),
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: const TextStyle(
                    fontSize: 10.5,
                    color: textSoft,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(width: 8),

          Text(
            time,
            style: const TextStyle(
              fontSize: 10,
              color: textSoft,
            ),
          ),
        ],
      ),
    );
  }

  // ===========================================================
  // RECENT ACTIVITIES + EXPORT REPORT
  // ===========================================================

  Widget _recentActivitiesCard(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // RECENT ACTIVITIES WHITE CARD
        _whiteCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _cardHeader(
                'Recent activities',
                TextButton(
                  onPressed: () {},
                  child: const Text(
                    'View All',
                    style: TextStyle(
                      fontSize: 10.5,
                      color: primaryBlue,
                    ),
                  ),
                ),
              ),

              _activityItem(
                'New Tenant Created',
                'by Admin users',
                '10 min ago',
                amberColor,
              ),

              _activityItem(
                'License Updated',
                'by Admin users',
                '1 hour ago',
                amberColor,
              ),

              _activityItem(
                'User Added',
                'Super admin granted access to monitoring module',
                '2 hours ago',
                primaryBlue,
              ),

              _activityItem(
                'Backup Completed',
                'Daily automated backup completed successfully',
                'Yesterday',
                greenColor,
              ),
            ],
          ),
        ),

        // SPACE BELOW RECENT ACTIVITIES
        const SizedBox(height: 28),

        // EXPORT REPORT BLUE BUTTON  → opens the Export screen
        SizedBox(
          width: double.infinity,
          height: 45,
          child: ElevatedButton.icon(
            onPressed: () => _openExport(context),
            icon: const Icon(
              Icons.file_download_outlined,
              size: 17,
              color: Colors.white,
            ),
            label: const Text(
              'Export Report',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF192BE5),
              foregroundColor: Colors.white,
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
        ),
      ],
    );
  }

  // ===========================================================
  // ACTIVITY ITEM
  // ===========================================================

  Widget _activityItem(
    String title,
    String subtitle,
    String time,
    Color color,
  ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 13),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 3),
            child: Icon(
              Icons.circle,
              size: 8,
              color: color,
            ),
          ),

          const SizedBox(width: 10),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 11.5,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF202A3A),
                  ),
                ),

                const SizedBox(height: 2),

                Text(
                  subtitle,
                  style: const TextStyle(
                    fontSize: 10.5,
                    color: textSoft,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(width: 8),

          Text(
            time,
            style: const TextStyle(
              fontSize: 10,
              color: textSoft,
            ),
          ),
        ],
      ),
    );
  }

  // ===========================================================
  // WHITE CARD
  // ===========================================================

  Widget _whiteCard({
    required Widget child,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: borderColor),
      ),
      child: child,
    );
  }
}

// =============================================================
// SMALL DATE TEXT UNDER THE CHART
// =============================================================

class _DateLabel extends StatelessWidget {
  final String text;
  const _DateLabel(this.text);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 10,
        color: Color(0xFF5F6B80),
      ),
    );
  }
}

// =============================================================
// SIMPLE LINE CHART PAINTER
// =============================================================

class _SystemHealthPainter extends CustomPainter {
  @override
  void paint(
    Canvas canvas,
    Size size,
  ) {
    final gridPaint = Paint()
      ..color = const Color(0xFFE3E8F0)
      ..strokeWidth = 1;

    for (int i = 0; i < 5; i++) {
      final y = size.height * i / 4;

      canvas.drawLine(
        Offset(0, y),
        Offset(size.width, y),
        gridPaint,
      );
    }

    final purplePaint = Paint()
      ..color = const Color(0xFF6D4BC3)
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    final bluePaint = Paint()
      ..color = const Color(0xFF1769FF)
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    final greenPaint = Paint()
      ..color = const Color(0xFF16A36A)
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    // Lines now run across the full width, like the photo.
    final purplePoints = [
      const Offset(0.00, 0.48),
      const Offset(0.17, 0.40),
      const Offset(0.33, 0.43),
      const Offset(0.50, 0.30),
      const Offset(0.67, 0.30),
      const Offset(0.83, 0.37),
      const Offset(1.00, 0.27),
    ];

    final bluePoints = [
      const Offset(0.00, 0.72),
      const Offset(0.17, 0.64),
      const Offset(0.33, 0.62),
      const Offset(0.50, 0.53),
      const Offset(0.67, 0.61),
      const Offset(0.83, 0.64),
      const Offset(1.00, 0.51),
    ];

    final greenPoints = [
      const Offset(0.00, 0.91),
      const Offset(0.17, 0.87),
      const Offset(0.33, 0.87),
      const Offset(0.50, 0.81),
      const Offset(0.67, 0.81),
      const Offset(0.83, 0.81),
      const Offset(1.00, 0.80),
    ];

    _drawLine(canvas, size, purplePoints, purplePaint);
    _drawLine(canvas, size, bluePoints, bluePaint);
    _drawLine(canvas, size, greenPoints, greenPaint);
  }

  void _drawLine(
    Canvas canvas,
    Size size,
    List<Offset> points,
    Paint paint,
  ) {
    final path = Path();

    for (int i = 0; i < points.length; i++) {
      final point = Offset(
        points[i].dx * size.width,
        points[i].dy * size.height,
      );

      if (i == 0) {
        path.moveTo(point.dx, point.dy);
      } else {
        path.lineTo(point.dx, point.dy);
      }

      canvas.drawCircle(
        point,
        3,
        Paint()
          ..color = paint.color
          ..style = PaintingStyle.fill,
      );
    }

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}

// =============================================================
// =============================================================
//
//  EXPORT REPORT PAGE
//
//  Opened by the blue "Export Report" button. The person picks
//    1. a file format  (PDF / CSV / Excel)
//    2. an interval    (Today / Last 7 Days / Last 30 Days)
//    3. options        (Include Charts / Include Detailed Tables)
//  and taps "Download Export".
//
//  The file itself is built in plain Dart (no packages):
//    - CSV   → real .csv text
//    - Excel → SpreadsheetML .xls (opens in Excel / Sheets / Numbers)
//    - PDF   → a real multi-page PDF (text + simple bar charts)
//
//  Saving the file to the device needs one small package, so it
//  is isolated in _saveFile() below — see the note there.
//
// =============================================================
// =============================================================

enum ExportFormat { pdf, csv, excel }

enum ExportInterval { today, last7Days, last30Days }

class ExportReportPage extends StatefulWidget {
  const ExportReportPage({super.key});

  @override
  State<ExportReportPage> createState() => _ExportReportPageState();
}

class _ExportReportPageState extends State<ExportReportPage> {
  static const Color _blue = Color(0xFF192BE5);
  static const Color _navyPill = Color(0xFF1E2A5A);
  static const Color _textStrong = GlobalDashboardPage.textStrong;
  static const Color _textSoft = GlobalDashboardPage.textSoft;
  static const Color _border = GlobalDashboardPage.borderColor;

  ExportFormat format = ExportFormat.pdf;
  ExportInterval interval = ExportInterval.last30Days;
  bool includeCharts = false;
  bool includeTables = false;
  bool exporting = false;

  // ---------------------------------------------------------
  // LABELS
  // ---------------------------------------------------------

  String _intervalLabel(ExportInterval i) {
    switch (i) {
      case ExportInterval.today:
        return 'Today';
      case ExportInterval.last7Days:
        return 'Last 7 Days';
      case ExportInterval.last30Days:
        return 'Last 30 Days';
    }
  }

  String get _extension {
    switch (format) {
      case ExportFormat.pdf:
        return 'pdf';
      case ExportFormat.csv:
        return 'csv';
      case ExportFormat.excel:
        return 'xls';
    }
  }

  String _two(int n) => n.toString().padLeft(2, '0');

  // ---------------------------------------------------------
  // DOWNLOAD
  // ---------------------------------------------------------

  Future<void> _download() async {
    if (exporting) return;

    // Grab these before the page closes.
    final messenger = ScaffoldMessenger.of(context);
    final navigator = Navigator.of(context);

    setState(() => exporting = true);

    try {
      final now = DateTime.now();
      final fileName =
          'global_dashboard_report_${now.year}${_two(now.month)}${_two(now.day)}.$_extension';

      final report = _ReportData(
        intervalLabel: _intervalLabel(interval),
        generatedAt: now,
        includeCharts: includeCharts,
        includeTables: includeTables,
      );

      final Uint8List bytes;
      switch (format) {
        case ExportFormat.pdf:
          bytes = report.toPdf();
          break;
        case ExportFormat.csv:
          bytes = report.toCsv();
          break;
        case ExportFormat.excel:
          bytes = report.toExcelXml();
          break;
      }

      await _saveFile(fileName, bytes);

      if (!mounted) return;
      navigator.pop();
      messenger.hideCurrentSnackBar();
      messenger.showSnackBar(
        SnackBar(
          behavior: SnackBarBehavior.floating,
          content: Text(
            'Export ready: $fileName (${(bytes.length / 1024).toStringAsFixed(1)} KB)',
          ),
        ),
      );
    } catch (e) {
      if (!mounted) return;
      setState(() => exporting = false);
      messenger.hideCurrentSnackBar();
      messenger.showSnackBar(
        const SnackBar(
          behavior: SnackBarBehavior.floating,
          content: Text('Export failed. Please try again.'),
        ),
      );
    }
  }

  /// SAVES THE FILE.
  ///
  /// Stock Flutter cannot write to the Downloads folder, so this is
  /// the one place that needs a package. Add to pubspec.yaml:
  ///
  ///   dependencies:
  ///     file_saver: ^0.2.14
  ///
  /// then add `import 'package:file_saver/file_saver.dart';` at the top
  /// of this file and replace the body below with:
  ///
  ///   final dot = fileName.lastIndexOf('.');
  ///   await FileSaver.instance.saveFile(
  ///     name: fileName.substring(0, dot),
  ///     bytes: bytes,
  ///     fileExtension: fileName.substring(dot + 1),
  ///     mimeType: switch (format) {
  ///       ExportFormat.pdf => MimeType.pdf,
  ///       ExportFormat.csv => MimeType.csv,
  ///       ExportFormat.excel => MimeType.microsoftExcel,
  ///     },
  ///   );
  ///
  /// (Or use share_plus / your own backend download URL instead.)
  Future<void> _saveFile(String fileName, Uint8List bytes) async {
    // Placeholder so the app compiles with stock Flutter only.
    // The bytes are already a complete, valid file.
    await Future<void>.delayed(const Duration(milliseconds: 600));
  }

  // ---------------------------------------------------------
  // BUILD
  // ---------------------------------------------------------

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 560),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _buildHeader(),
                const Divider(height: 1, color: _border),
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.fromLTRB(16, 18, 16, 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildFormatSection(),
                        const SizedBox(height: 22),
                        _buildIntervalSection(),
                        const SizedBox(height: 18),
                        _buildOptionsCard(),
                      ],
                    ),
                  ),
                ),
                _buildBottomBar(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // HEADER: back button + title + description
  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          InkWell(
            onTap: exporting ? null : () => Navigator.of(context).pop(),
            borderRadius: BorderRadius.circular(10),
            child: Container(
              width: 38,
              height: 38,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: _border),
              ),
              child: const Icon(Icons.arrow_back, size: 18, color: _textStrong),
            ),
          ),
          const SizedBox(width: 12),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Export Global Dashboard Report',
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w800,
                    color: _textStrong,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  'Download a detailed summary of platform insights and performance.',
                  style: TextStyle(fontSize: 12.5, height: 1.35, color: _textSoft),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _sectionLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w600,
          color: _textStrong,
        ),
      ),
    );
  }

  // FILE FORMAT: three selectable cards
  Widget _buildFormatSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _sectionLabel('File Format'),
        Row(
          children: [
            Expanded(
              child: _formatCard(
                ExportFormat.pdf,
                Icons.picture_as_pdf_outlined,
                'PDF Document',
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: _formatCard(
                ExportFormat.csv,
                Icons.text_snippet_outlined,
                'CSV (Raw Data)',
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: _formatCard(
                ExportFormat.excel,
                Icons.table_chart_outlined,
                'Excel Spreadsheet',
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _formatCard(ExportFormat value, IconData icon, String label) {
    final bool selected = format == value;

    return InkWell(
      onTap: exporting ? null : () => setState(() => format = value),
      borderRadius: BorderRadius.circular(10),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 140),
        height: 92,
        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 10),
        decoration: BoxDecoration(
          color: selected ? const Color(0xFFF4F6FF) : Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: selected ? _blue : _border,
            width: selected ? 1.4 : 1,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 30, color: _textStrong),
            const SizedBox(height: 10),
            Text(
              label,
              textAlign: TextAlign.center,
              maxLines: 2,
              style: const TextStyle(
                fontSize: 10.5,
                height: 1.2,
                color: _textStrong,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // TELEMETRY & USAGE INTERVAL: pills
  Widget _buildIntervalSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _sectionLabel('Telemetry & Usage Interval'),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            for (final value in ExportInterval.values) _intervalPill(value),
          ],
        ),
      ],
    );
  }

  Widget _intervalPill(ExportInterval value) {
    final bool selected = interval == value;

    return InkWell(
      onTap: exporting ? null : () => setState(() => interval = value),
      borderRadius: BorderRadius.circular(24),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 140),
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 11),
        decoration: BoxDecoration(
          color: selected ? _navyPill : const Color(0xFFF0F2F6),
          borderRadius: BorderRadius.circular(24),
        ),
        child: Text(
          _intervalLabel(value),
          style: TextStyle(
            fontSize: 12.5,
            fontWeight: FontWeight.w600,
            color: selected ? Colors.white : _textStrong,
          ),
        ),
      ),
    );
  }

  // OPTIONS card with two switches
  Widget _buildOptionsCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(14, 14, 14, 6),
      decoration: BoxDecoration(
        color: const Color(0xFFFAFBFC),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: _border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Options',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: _textStrong,
            ),
          ),
          const SizedBox(height: 10),
          _optionRow(
            title: 'Include Charts',
            subtitle: 'Embed visual graphs in output',
            value: includeCharts,
            onChanged: (v) => setState(() => includeCharts = v),
          ),
          const Divider(height: 1, color: Color(0xFFE6EAF0)),
          _optionRow(
            title: 'Include Detailed Tables',
            subtitle: 'Append raw data rows',
            value: includeTables,
            onChanged: (v) => setState(() => includeTables = v),
          ),
          if (includeCharts && format != ExportFormat.pdf)
            const Padding(
              padding: EdgeInsets.only(top: 2, bottom: 10),
              child: Text(
                'Charts are only embedded in PDF exports.',
                style: TextStyle(fontSize: 11, color: _textSoft),
              ),
            ),
        ],
      ),
    );
  }

  Widget _optionRow({
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 13.5,
                    fontWeight: FontWeight.w500,
                    color: _textStrong,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: const TextStyle(fontSize: 11.5, color: _textSoft),
                ),
              ],
            ),
          ),
          Switch(
            value: value,
            onChanged: exporting ? null : onChanged,
            activeThumbColor: Colors.white,
            activeTrackColor: _blue,
            inactiveThumbColor: Colors.white,
            inactiveTrackColor: const Color(0xFFD9DDE5),
            trackOutlineColor: WidgetStateProperty.all(Colors.transparent),
          ),
        ],
      ),
    );
  }

  // BOTTOM BAR: Cancel + Download Export
  Widget _buildBottomBar() {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: Color(0xFFEEF0F4))),
      ),
      child: Row(
        children: [
          Expanded(
            flex: 4,
            child: SizedBox(
              height: 50,
              child: OutlinedButton(
                onPressed: exporting ? null : () => Navigator.of(context).pop(),
                style: OutlinedButton.styleFrom(
                  foregroundColor: _textStrong,
                  side: const BorderSide(color: _border),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: const Text(
                  'Cancel',
                  style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            flex: 5,
            child: SizedBox(
              height: 50,
              child: ElevatedButton.icon(
                onPressed: exporting ? null : _download,
                style: ElevatedButton.styleFrom(
                  backgroundColor: _blue,
                  foregroundColor: Colors.white,
                  disabledBackgroundColor: _blue.withValues(alpha: 0.7),
                  disabledForegroundColor: Colors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                icon: exporting
                    ? const SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : const Icon(Icons.file_download_outlined, size: 18),
                label: Text(
                  exporting ? 'Preparing…' : 'Download Export',
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// =============================================================
// REPORT DATA + FILE BUILDERS (CSV / Excel / PDF)
//
// The numbers below are the same sample numbers shown on the
// dashboard. Replace them with your real data (API / state) —
// the three file builders will pick the new values up.
// =============================================================

class _ReportData {
  final String intervalLabel;
  final DateTime generatedAt;
  final bool includeCharts;
  final bool includeTables;

  const _ReportData({
    required this.intervalLabel,
    required this.generatedAt,
    required this.includeCharts,
    required this.includeTables,
  });

  // (metric, value, change)
  static const List<(String, String, String)> overview = [
    ('Total Tenants', '132', '+4% this month'),
    ('Total Users', '48,920', '+15% this month'),
    ('Active Subscriptions', '1,233', '+10% this month'),
    ('Active Sessions', '789', '+6% this month'),
  ];

  // (metric, percent)
  static const List<(String, int)> health = [
    ('CPU Usage', 37),
    ('Memory Utilization', 54),
    ('Disk I/O', 32),
    ('Network Bandwidth', 78),
  ];

  // (title, details, time)
  static const List<(String, String, String)> alerts = [
    ('High CPU Usage', 'Production cluster CPU usage is high', '1 hour ago'),
    ('Storage Threshold', 'Storage utilization reached 80%', '2 hours ago'),
    ('New Tenant Registration', 'Tenant registration is pending', '2 hours ago'),
  ];

  static const List<(String, String, String)> activities = [
    ('New Tenant Created', 'by Admin users', '10 min ago'),
    ('License Updated', 'by Admin users', '1 hour ago'),
    (
      'User Added',
      'Super admin granted access to monitoring module',
      '2 hours ago',
    ),
    (
      'Backup Completed',
      'Daily automated backup completed successfully',
      'Yesterday',
    ),
  ];

  String _two(int n) => n.toString().padLeft(2, '0');

  String get _generatedText =>
      '${generatedAt.year}-${_two(generatedAt.month)}-${_two(generatedAt.day)} '
      '${_two(generatedAt.hour)}:${_two(generatedAt.minute)}';

  // Rows shared by CSV and Excel.
  List<List<String>> _rows() {
    final rows = <List<String>>[
      ['Global Dashboard Report'],
      ['Interval', intervalLabel],
      ['Generated', _generatedText],
      [],
      ['PLATFORM OVERVIEW'],
      ['Metric', 'Value', 'Change'],
      for (final o in overview) [o.$1, o.$2, o.$3],
      [],
      ['PLATFORM HEALTH'],
      ['Metric', 'Usage %'],
      for (final h in health) [h.$1, '${h.$2}'],
    ];

    if (includeTables) {
      rows.addAll([
        [],
        ['SECURITY ALERTS'],
        ['Title', 'Details', 'Time'],
        for (final a in alerts) [a.$1, a.$2, a.$3],
        [],
        ['RECENT ACTIVITIES'],
        ['Title', 'Details', 'Time'],
        for (final a in activities) [a.$1, a.$2, a.$3],
      ]);
    }

    return rows;
  }

  // ---------------------------------------------------------
  // CSV
  // ---------------------------------------------------------

  Uint8List toCsv() {
    String cell(String v) {
      if (v.contains(',') || v.contains('"') || v.contains('\n')) {
        return '"${v.replaceAll('"', '""')}"';
      }
      return v;
    }

    final text = _rows().map((r) => r.map(cell).join(',')).join('\r\n');

    // BOM so Excel opens UTF-8 correctly.
    return Uint8List.fromList([0xEF, 0xBB, 0xBF, ...utf8.encode(text)]);
  }

  // ---------------------------------------------------------
  // EXCEL  (SpreadsheetML 2003 — a plain XML file Excel opens)
  // ---------------------------------------------------------

  Uint8List toExcelXml() {
    String esc(String v) => v
        .replaceAll('&', '&amp;')
        .replaceAll('<', '&lt;')
        .replaceAll('>', '&gt;');

    final b = StringBuffer()
      ..write('<?xml version="1.0" encoding="UTF-8"?>')
      ..write('<?mso-application progid="Excel.Sheet"?>')
      ..write('<Workbook xmlns="urn:schemas-microsoft-com:office:spreadsheet" '
          'xmlns:ss="urn:schemas-microsoft-com:office:spreadsheet">')
      ..write('<Worksheet ss:Name="Global Dashboard"><Table>');

    for (final row in _rows()) {
      b.write('<Row>');
      for (final v in row) {
        final isNumber = int.tryParse(v) != null;
        b.write(
          '<Cell><Data ss:Type="${isNumber ? 'Number' : 'String'}">${esc(v)}</Data></Cell>',
        );
      }
      b.write('</Row>');
    }

    b.write('</Table></Worksheet></Workbook>');
    return Uint8List.fromList(utf8.encode(b.toString()));
  }

  // ---------------------------------------------------------
  // PDF  (hand-built, Helvetica, A4, auto page breaks)
  // ---------------------------------------------------------

  Uint8List toPdf() {
    final items = <_PdfItem>[
      _PdfItem.text('Global Dashboard Report', size: 20, bold: true),
      _PdfItem.text('Platform Administration', size: 11),
      _PdfItem.text('Interval: $intervalLabel', size: 11),
      _PdfItem.text('Generated: $_generatedText', size: 11),
      _PdfItem.space(),
      _PdfItem.text('PLATFORM OVERVIEW', size: 12, bold: true),
      for (final o in overview)
        _PdfItem.text('${o.$1}: ${o.$2}  (${o.$3})', size: 11),
      _PdfItem.space(),
      _PdfItem.text('PLATFORM HEALTH', size: 12, bold: true),
      for (final h in health)
        if (includeCharts)
          _PdfItem.bar(h.$1, h.$2 / 100, '${h.$2}%')
        else
          _PdfItem.text('${h.$1}: ${h.$2}%', size: 11),
    ];

    if (includeTables) {
      items
        ..add(_PdfItem.space())
        ..add(_PdfItem.text('SECURITY ALERTS', size: 12, bold: true));
      for (final a in alerts) {
        items.add(_PdfItem.text('${a.$1} - ${a.$2} (${a.$3})', size: 10));
      }
      items
        ..add(_PdfItem.space())
        ..add(_PdfItem.text('RECENT ACTIVITIES', size: 12, bold: true));
      for (final a in activities) {
        items.add(_PdfItem.text('${a.$1} - ${a.$2} (${a.$3})', size: 10));
      }
    }

    return _buildPdf(items);
  }

  static String _pdfEscape(String s) {
    final b = StringBuffer();
    for (final c in s.codeUnits) {
      if (c == 0x5C || c == 0x28 || c == 0x29) {
        b.write('\\');
        b.writeCharCode(c);
      } else if (c < 32 || c > 126) {
        b.write('?');
      } else {
        b.writeCharCode(c);
      }
    }
    return b.toString();
  }

  static Uint8List _buildPdf(List<_PdfItem> items) {
    // 1) Lay the items out onto pages.
    final streams = <StringBuffer>[StringBuffer()];
    double y = 790;

    for (final it in items) {
      if (y < 60) {
        streams.add(StringBuffer());
        y = 790;
      }
      final s = streams.last;
      final yy = y.toStringAsFixed(1);

      if (it.isSpace) {
        // just moves down
      } else if (it.isBar) {
        final yb = (y - 1).toStringAsFixed(1);
        s.write(
            'BT /F1 10 Tf 50 $yy Td (${_pdfEscape(it.text)}) Tj ET\n');
        s.write('0.89 0.91 0.94 rg 230 $yb 200 8 re f\n');
        s.write(
            '0.09 0.41 1 rg 230 $yb ${(200 * it.value).toStringAsFixed(1)} 8 re f\n');
        s.write('0 g BT /F1 10 Tf 440 $yy Td (${_pdfEscape(it.label)}) Tj ET\n');
      } else {
        s.write(
            'BT /${it.bold ? 'F2' : 'F1'} ${it.size} Tf 50 $yy Td (${_pdfEscape(it.text)}) Tj ET\n');
      }

      y -= it.step;
    }

    // 2) Build the PDF objects.
    final pageCount = streams.length;
    final objs = <String>[
      '<< /Type /Catalog /Pages 2 0 R >>',
      '<< /Type /Pages /Kids [${[
        for (var i = 0; i < pageCount; i++) '${5 + 2 * i} 0 R'
      ].join(' ')}] /Count $pageCount >>',
      '<< /Type /Font /Subtype /Type1 /BaseFont /Helvetica >>',
      '<< /Type /Font /Subtype /Type1 /BaseFont /Helvetica-Bold >>',
    ];

    for (var i = 0; i < pageCount; i++) {
      final content = streams[i].toString();
      objs.add(
        '<< /Type /Page /Parent 2 0 R /MediaBox [0 0 595 842] '
        '/Resources << /Font << /F1 3 0 R /F2 4 0 R >> >> '
        '/Contents ${6 + 2 * i} 0 R >>',
      );
      objs.add('<< /Length ${content.length} >>\nstream\n$content\nendstream');
    }

    // 3) Write the file with its cross-reference table.
    final out = StringBuffer('%PDF-1.4\n');
    final offsets = <int>[];

    for (var i = 0; i < objs.length; i++) {
      offsets.add(out.length);
      out.write('${i + 1} 0 obj\n${objs[i]}\nendobj\n');
    }

    final xrefPos = out.length;
    out.write('xref\n0 ${objs.length + 1}\n');
    out.write('0000000000 65535 f \n');
    for (final o in offsets) {
      out.write('${o.toString().padLeft(10, '0')} 00000 n \n');
    }
    out.write(
        'trailer\n<< /Size ${objs.length + 1} /Root 1 0 R >>\nstartxref\n$xrefPos\n%%EOF');

    return Uint8List.fromList(out.toString().codeUnits);
  }
}

/// One line / spacer / bar in the PDF.
class _PdfItem {
  final String text;
  final String label; // value text shown at the end of a bar
  final double value; // 0..1 for bars
  final double size;
  final bool bold;
  final bool isBar;
  final bool isSpace;

  const _PdfItem._({
    this.text = '',
    this.label = '',
    this.value = 0,
    this.size = 11,
    this.bold = false,
    this.isBar = false,
    this.isSpace = false,
  });

  factory _PdfItem.text(String text, {double size = 11, bool bold = false}) =>
      _PdfItem._(text: text, size: size, bold: bold);

  factory _PdfItem.space() => const _PdfItem._(isSpace: true);

  factory _PdfItem.bar(String name, double value, String label) =>
      _PdfItem._(text: name, value: value, label: label, isBar: true);

  double get step => isSpace ? 12 : (isBar ? 20 : size + 7);
}