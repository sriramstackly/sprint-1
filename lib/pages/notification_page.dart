
import 'package:flutter/material.dart';

class NotificationPage extends StatefulWidget {
  const NotificationPage({super.key});

  @override
  State<NotificationPage> createState() =>
      _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  bool showUnreadOnly = false;

  final List<Map<String, dynamic>> notifications = [
    {
      'title': 'Acme Corp enterprise license expires in 5 days',
      'description':
          'Review account usage and renewal terms before automatic suspension.',
      'time': '10m ago',
      'icon': Icons.warning_amber_rounded,
      'color': const Color(0xFFFFA726),
      'read': false,
    },
    {
      'title': 'NovaTech Solutions completed onboarding and SSO setup',
      'description':
          'Primary tenant provisioned with 240 employee seats.',
      'time': '1h ago',
      'icon': Icons.check_circle_outline,
      'color': const Color(0xFF16A36A),
      'read': false,
    },
    {
      'title':
          'Admin login from unrecognized IP (194.26.29.11)',
      'description':
          'Delta Retail Group – Frankfurt, DE. Geo-fence alert triggered.',
      'time': '3h ago',
      'icon': Icons.lock_outline,
      'color': const Color(0xFFFFA726),
      'read': false,
    },
    {
      'title': '5 consecutive failed MFA attempts',
      'description':
          'User j.miller@acmecorp.com temporarily locked.',
      'time': 'Yesterday',
      'icon': Icons.block,
      'color': const Color(0xFFFF5252),
      'read': false,
    },
  ];

  void markAllAsRead() {
    setState(() {
      for (final notification in notifications) {
        notification['read'] = true;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final filteredNotifications = showUnreadOnly
        ? notifications.where((n) => n['read'] == false).toList()
        : notifications;

    final unreadCount =
        notifications.where((n) => n['read'] == false).length;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        surfaceTintColor: Colors.white,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(
            Icons.arrow_back,
            color: Color(0xFF172033),
          ),
        ),
        title: const Text(
          'Notification',
          style: TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.w700,
            color: Color(0xFF172033),
          ),
        ),
        bottom: const PreferredSize(
          preferredSize: Size.fromHeight(1),
          child: Divider(
            height: 1,
            color: Color(0xFFE6EAF0),
          ),
        ),
      ),

      body: Column(
        children: [
          // ALL / UNREAD / MARK ALL AS READ
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 14,
              vertical: 12,
            ),
            decoration: const BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: Color(0xFFE6EAF0),
                ),
              ),
            ),
            child: Row(
              children: [
                _tabButton(
                  'All (12)',
                  !showUnreadOnly,
                  () {
                    setState(() {
                      showUnreadOnly = false;
                    });
                  },
                ),
                const SizedBox(width: 8),
                _tabButton(
                  'Unread ($unreadCount)',
                  showUnreadOnly,
                  () {
                    setState(() {
                      showUnreadOnly = true;
                    });
                  },
                ),
                const Spacer(),
                InkWell(
                  onTap: markAllAsRead,
                  child: const Text(
                    'Mark all as read',
                    style: TextStyle(
                      fontSize: 10,
                      color: Color(0xFF3046E8),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // NOTIFICATION CONTENT
          Expanded(
            child: filteredNotifications.isEmpty
                ? _emptyNotifications()
                : ListView.separated(
                    padding: const EdgeInsets.all(14),
                    itemCount: filteredNotifications.length,
                    separatorBuilder: (_, __) =>
                        const Divider(height: 1),
                    itemBuilder: (context, index) {
                      final item = filteredNotifications[index];

                      return InkWell(
                        onTap: () {
                          setState(() {
                            item['read'] = true;
                          });
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            vertical: 12,
                          ),
                          child: Row(
                            crossAxisAlignment:
                                CrossAxisAlignment.start,
                            children: [
                              Container(
                                width: 34,
                                height: 34,
                                decoration: BoxDecoration(
                                  color: (item['color'] as Color)
                                      .withValues(alpha: 0.12),
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(
                                  item['icon'] as IconData,
                                  color: item['color'] as Color,
                                  size: 18,
                                ),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      item['title'] as String,
                                      style: const TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w700,
                                        color: Color(0xFF172033),
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      item['description'] as String,
                                      style: const TextStyle(
                                        fontSize: 10.5,
                                        color: Color(0xFF7C89A0),
                                      ),
                                    ),
                                    const SizedBox(height: 5),
                                    Text(
                                      item['time'] as String,
                                      style: const TextStyle(
                                        fontSize: 10,
                                        color: Color(0xFF8A96AA),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              if (item['read'] == false)
                                const Icon(
                                  Icons.circle,
                                  size: 7,
                                  color: Color(0xFF3046E8),
                                ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
          ),

          // BOTTOM BUTTON
          Container(
            width: double.infinity,
            decoration: const BoxDecoration(
              border: Border(
                top: BorderSide(
                  color: Color(0xFFE6EAF0),
                ),
              ),
            ),
            child: TextButton(
              onPressed: () {
                setState(() {
                  showUnreadOnly = false;
                });
              },
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'View all notifications',
                    style: TextStyle(
                      fontSize: 12,
                      color: Color(0xFF3046E8),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(width: 4),
                  Icon(
                    Icons.arrow_forward,
                    size: 15,
                    color: Color(0xFF3046E8),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _tabButton(
    String title,
    bool selected,
    VoidCallback onTap,
  ) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(6),
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 11,
          vertical: 9,
        ),
        decoration: BoxDecoration(
          color: selected
              ? const Color(0xFF3046E8)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(6),
        ),
        child: Text(
          title,
          style: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w600,
            color: selected
                ? Colors.white
                : const Color(0xFF63718A),
          ),
        ),
      ),
    );
  }

  Widget _emptyNotifications() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 100,
              height: 100,
              decoration: const BoxDecoration(
                color: Color(0xFFEAF1FF),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.notifications,
                size: 46,
                color: Color(0xFF3864F4),
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'No Notifications',
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w800,
                color: Color(0xFF172033),
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              "You're all caught up! When there are new alerts or updates, they'll show up here.",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 11,
                color: Color(0xFF8290AA),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
