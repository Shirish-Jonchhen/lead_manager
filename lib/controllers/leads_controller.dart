import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../models/lead_model.dart';
import '../screens/lead_form_screen.dart';
import '../theme/app_colors.dart';

class LeadsController {
  ValueListenable<Box<Lead>> listenable() {
    return Hive.box<Lead>('leads').listenable();
  }

  List<Lead> getLeads(Box<Lead> box) {
    return box.values.toList().cast<Lead>();
  }

  List<Lead> filterLeads(List<Lead> leads, String query) {
    if (query.isEmpty) return leads;
    return leads.where((lead) {
      return lead.name.toLowerCase().contains(query) ||
          lead.email.toLowerCase().contains(query) ||
          lead.phone.toLowerCase().contains(query) ||
          lead.serviceDisplayName.toLowerCase().contains(query);
    }).toList();
  }

  Future<void> addLead(Lead lead) async {
    final box = Hive.box<Lead>('leads');
    await box.add(lead);
  }

  Future<void> updateLead(
    Lead lead, {
    required String name,
    required String email,
    required String phone,
    required dynamic service,
  }) async {
    lead.name = name;
    lead.email = email;
    lead.phone = phone;
    lead.service = service;
    await lead.save();
  }

  Future<void> deleteLead(Lead lead) async {
    await lead.delete();
  }

  void goToAdd(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => const LeadFormScreen()),
    );
  }

  void goToEdit(BuildContext context, Lead lead, int index) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => LeadFormScreen(lead: lead, index: index),
      ),
    );
  }

  void confirmDelete(BuildContext context, Lead lead) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.card,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        title: const Text('Delete Lead'),
        content: const Text('Are you sure you want to delete this lead?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              await deleteLead(lead);
              Navigator.of(context).pop();
            },
            child: const Text(
              'Delete',
              style: TextStyle(color: AppColors.error),
            ),
          ),
        ],
      ),
    );
  }
}
