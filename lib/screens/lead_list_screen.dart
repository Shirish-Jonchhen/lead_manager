import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/lead_model.dart';
import '../theme/app_colors.dart';
import '../widgets/lead_card.dart';
import '../controllers/leads_controller.dart';

class LeadListScreen extends StatefulWidget {
  const LeadListScreen({super.key});

  @override
  State<LeadListScreen> createState() => _LeadListScreenState();
}

class _LeadListScreenState extends State<LeadListScreen> {
  final _searchController = TextEditingController();
  String _searchQuery = '';
  final _controller = LeadsController();

  @override
  void initState() {
    super.initState();
    _searchController.addListener(() {
      setState(() {
        _searchQuery = _searchController.text.toLowerCase();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Leads'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              final navigator = Navigator.of(context);
              final prefs = await SharedPreferences.getInstance();
              await prefs.setBool('isLoggedIn', false);

              navigator.pushReplacementNamed('/login');
            },
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(60),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _searchController,
                    decoration: InputDecoration(
                      hintText: 'Search leads...',
                      prefixIcon: const Icon(Icons.search),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      filled: true,
                      fillColor: AppColors.card,
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.info_outline, color: Colors.white),
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        backgroundColor: AppColors.card,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        title: const Text('Search Info'),
                        content: const Text(
                          'You can search for leads by their:\n'
                          '• Name\n'
                          '• Email\n'
                          '• Phone Number\n'
                          '• Service',
                        ),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.of(context).pop(),
                            child: const Text('Got it'),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
      body: ValueListenableBuilder(
        valueListenable: _controller.listenable(),
        builder: (context, Box<Lead> box, _) {
          final leads = _controller.getLeads(box);
          final filteredLeads = _controller.filterLeads(leads, _searchQuery)..sort((a, b) => b.createdAt.compareTo(a.createdAt));

          if (filteredLeads.isEmpty) {
            return const Center(child: Text('No leads found'));
          }

          return RefreshIndicator(
            color: AppColors.primary,
            onRefresh: () async{
              setState(() {});
            },
            child: ListView.separated(
              physics: AlwaysScrollableScrollPhysics(),
              separatorBuilder: (context, index) => const SizedBox(height: 8),
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
              itemCount: filteredLeads.length,
              itemBuilder: (context, index) {
                final lead = filteredLeads[index];
                return LeadCard(
                  lead: lead,
                  index: index,
                  onEdit: () => _controller.goToEdit(context, lead, index),
                  onDelete: () => _controller.confirmDelete(context, lead),
                );
              },
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.primary,

        onPressed: () {
          _controller.goToAdd(context);
        },
        child: const Icon(Icons.add, color: AppColors.background),
      ),
    );
  }
}
