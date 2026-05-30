import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../models/supplier.dart';

class SupplierRepository {
  static const String _storageKey = 'suppliers';

  Future<List<Supplier>> loadSuppliers() async {
    final preferences = await SharedPreferences.getInstance();
    final savedJson = preferences.getString(_storageKey);

    if (savedJson == null || savedJson.isEmpty) {
      return [];
    }

    final decodedList = jsonDecode(savedJson) as List<dynamic>;
    return decodedList
        .map((item) => Supplier.fromJson(item as Map<String, dynamic>))
        .toList();
  }

  Future<void> saveSuppliers(List<Supplier> suppliers) async {
    final preferences = await SharedPreferences.getInstance();
    final encodedList = suppliers.map((supplier) => supplier.toJson()).toList();
    await preferences.setString(_storageKey, jsonEncode(encodedList));
  }

  Future<void> clearSuppliers() async {
    final preferences = await SharedPreferences.getInstance();
    await preferences.remove(_storageKey);
  }
}
