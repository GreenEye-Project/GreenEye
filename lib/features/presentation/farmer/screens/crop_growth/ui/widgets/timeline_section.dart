import 'package:flutter/material.dart';

class TimelineSection extends StatelessWidget {
  final int day;
  const TimelineSection({super.key, required this.day});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          child: Text(
            "TimeLine",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
          ),
        ),
        SizedBox(
          height: 120,
          child: ListView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            children: const [
              _TimelineDot(
                title: "Germination",
                date: "Mar 22 2025",
                active: true,
              ),
              _TimelineDot(title: "Seedling", date: "Mar 27 2025"),
              _TimelineDot(title: "Vegetative", date: "Apr 02 2025"),
              _TimelineDot(title: "Flowering", date: "Apr 12 2025"),
            ],
          ),
        ),
      ],
    );
  }
}

class _TimelineDot extends StatelessWidget {
  final String title;
  final String date;
  final bool active;
  const _TimelineDot({
    required this.title,
    required this.date,
    this.active = false,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Column(
          children: [
            CircleAvatar(
              radius: 12,
              backgroundColor: active ? Colors.green : Colors.grey.shade300,
              child: Icon(
                Icons.eco,
                size: 14,
                color: active ? Colors.white : Colors.black54,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              title,
              style: TextStyle(
                fontSize: 13,
                color: active ? Colors.green : Colors.black87,
              ),
            ),
            Text(
              date,
              style: TextStyle(fontSize: 11, color: Colors.grey.shade600),
            ),
          ],
        ),
        const SizedBox(width: 35),
      ],
    );
  }
}