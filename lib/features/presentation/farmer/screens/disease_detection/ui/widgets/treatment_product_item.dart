import 'package:flutter/material.dart';

class TreatmentProductItem extends StatelessWidget {
  final Map<String, dynamic> product;

  const TreatmentProductItem({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 12),
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          const Icon(Icons.close, color: Colors.red),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              product["name"],
              style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
            ),
          ),
          Text(
            product["price"],
            style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
          ),
          const SizedBox(width: 10),
          const Icon(Icons.arrow_forward_ios, size: 18),
        ],
      ),
    );
  }
}