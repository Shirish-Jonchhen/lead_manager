import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:lead_manager/utils/utils.dart';
import '../models/lead_model.dart';
import '../theme/app_colors.dart';

class LeadCard extends StatelessWidget {
  final Lead lead;
  final int index;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const LeadCard({
    super.key,
    required this.lead,
    required this.index,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Slidable(
      key: ValueKey(lead),
      endActionPane: ActionPane(
        extentRatio: 0.5,
        motion: const DrawerMotion(),
        children: [
          SlidableAction(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(10),
              bottomLeft: Radius.circular(10),
            ),
            onPressed: (context) {
              onEdit();
            },
            backgroundColor: AppColors.primary,
            foregroundColor: Colors.white,
            icon: Icons.edit,
            label: 'Edit',
          ),
          SlidableAction(
            borderRadius: const BorderRadius.only(
              topRight: Radius.circular(10),
              bottomRight: Radius.circular(10),
            ),
            onPressed: (context) {
              onDelete();
            },
            backgroundColor: AppColors.error,
            foregroundColor: Colors.white,
            icon: Icons.delete,
            label: 'Delete',
          ),
        ],
      ),
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.card,
          borderRadius: BorderRadius.circular(10),
          boxShadow: const [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 5,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: ListTile(
        
          leading: CircleAvatar(

            backgroundColor: AppColors.primary,
            child: Text(
              lead.name[0].toUpperCase(),
              style: const TextStyle(color: Colors.white),
            ),
          ),
          title: Text(lead.name),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(lead.email),
              Text(lead.phone),
              Text(
                'Service: ${lead.serviceDisplayName}',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ],
          ),
          trailing: Column(
            crossAxisAlignment: .end,
            children: [
              Text(
                "${Utils.getDateDaySuffix(lead.createdAt.day)} ${Utils.months[lead.createdAt.month]}, ${lead.createdAt.year.toString()}",
                style: TextStyle(color: AppColors.textLight),
              ),
              Text(
                "${lead.createdAt.hour}:${lead.createdAt.minute}",
                style: TextStyle(color: AppColors.textLight),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
