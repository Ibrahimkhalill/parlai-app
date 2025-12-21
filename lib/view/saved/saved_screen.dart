import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class SavedScreen extends StatelessWidget {
  const SavedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final devotionals = [
      {
        "id": 1,
        "date": "Dec 4, 2025",
        "duration": "5 min",
        "title": "Gratitude & Joy",
        "content":
            "Good morning. Today's devotional is about finding peace in your daily journey. Remember that each day brings new opportunities for growth and reflection. Take time to center yourself and connect with what matters most to you.",
      },
      {
        "id": 2,
        "date": "Dec 4, 2025",
        "duration": "5 min",
        "title": "Gratitude & Joy",
        "content":
            "Good morning. Today's devotional is about finding peace in your daily journey. Remember that each day brings new opportunities for growth and reflection. Take time to center yourself and connect with what matters most to you.",
      },
    ];

    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// Header
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              child: Text(
                "Saved Devotionals",
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
            ),

            /// List
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: devotionals.length,
                itemBuilder: (context, index) {
                  final item = devotionals[index];
                  return DevotionalCard(
                    date: item["date"] as String,
                    duration: item["duration"] as String,
                    title: item["title"] as String,
                    content: item["content"] as String,
                    onTap: () {
                      debugPrint("Open devotional ${item["id"]}");
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// ------------------------------------------------------------
/// Card Widget
/// ------------------------------------------------------------
class DevotionalCard extends StatelessWidget {
  final String date;
  final String duration;
  final String title;
  final String content;
  final VoidCallback onTap;

  const DevotionalCard({
    super.key,
    required this.date,
    required this.duration,
    required this.title,
    required this.content,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: const Color(0xFF1A1A1A),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  date,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Row(
                  children: [
                    const FaIcon(
                      FontAwesomeIcons.clock,
                      size: 16,
                      color: Colors.white,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      duration,
                      style: const TextStyle(color: Colors.white, fontSize: 16),
                    ),
                  ],
                ),
              ],
            ),

            const SizedBox(height: 16),

            /// Title
            Text(
              title,
              style: const TextStyle(
                color: Color(0xFFA855F7),
                fontSize: 22,
                fontWeight: FontWeight.w700,
                letterSpacing: 0.3,
              ),
            ),

            const SizedBox(height: 12),

            /// Content
            Text(
              content,
              maxLines: 6,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                color: Color(0xFFB0B0B0),
                fontSize: 15,
                height: 1.5,
                letterSpacing: 0.2,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
