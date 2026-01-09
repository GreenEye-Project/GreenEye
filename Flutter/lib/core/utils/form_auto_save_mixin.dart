import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

mixin FormAutoSaveMixin<T extends StatefulWidget> on State<T> {
  String get formKey;

  Future<void> saveFormData(Map<String, dynamic> data) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(formKey, jsonEncode(data));
  }

  Future<Map<String, dynamic>?> loadFormData() async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getString(formKey);
    if (data != null) {
      return jsonDecode(data);
    }
    return null;
  }

  Future<void> clearFormData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(formKey);
  }
}
