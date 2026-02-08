
import 'package:flutter/material.dart';
import 'package:lead_manager/theme/app_colors.dart';
import '../models/lead_model.dart';
import '../widgets/custom_text_field.dart';
import '../controllers/leads_controller.dart';

class LeadFormScreen extends StatefulWidget {
  final Lead? lead;
  final int? index;

  const LeadFormScreen({super.key, this.lead, this.index});

  @override
  State<LeadFormScreen> createState() => _LeadFormScreenState();
}

class _LeadFormScreenState extends State<LeadFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  String? _selectedService;
  final LeadsController _controller = LeadsController();

  final List<String> _staticServices = [
    'App Development',
    'Web Development',
    'SEO Optimization',
    'Digital Marketing',
    'UI/UX Design',
    'Cloud Solutions',
    'Data Analysis',
    'IT Consulting',
  ];

  @override
  void initState() {
    super.initState();
    if (widget.lead != null) {
      _nameController.text = widget.lead!.name;
      _emailController.text = widget.lead!.email;
      _phoneController.text = widget.lead!.phone;
      final dynamic serviceData = widget.lead!.service;
      if (serviceData is String) {
        _selectedService = serviceData;
      } else if (serviceData is List && serviceData.isNotEmpty) {
        _selectedService = serviceData.first.toString();
      }
    }
  }

  Future<void> _saveLead() async {
    if (_formKey.currentState!.validate()) {
      if (_selectedService == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please select a service')),
        );
        return;
      }

      if (widget.lead != null) {
        await _controller.updateLead(
          widget.lead!,
          name: _nameController.text,
          email: _emailController.text,
          phone: _phoneController.text,
          service: _selectedService!,
        );
      } else {
        final lead = Lead(
          name: _nameController.text,
          email: _emailController.text,
          phone: _phoneController.text,
          service: _selectedService!,
          createdAt: DateTime.now(),
        );
        await _controller.addLead(lead);
      }

      if (context.mounted) {
        Navigator.of(context).pop();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.lead != null ? 'Edit Lead' : 'Add Lead'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [

              //name
              CustomTextField(
                hintText: "John Doe",

                controller: _nameController,
                label: 'Name',
                validator: (value) =>
                    value!.isEmpty ? 'Please enter name' : null,
              ),
              const SizedBox(height: 16),

              //email
              CustomTextField(
                hintText: "john.doe@example.com",
                controller: _emailController,
                label: 'Email',
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter email';
                  }
                  final emailRegex = RegExp(
                    r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
                  );
                  if (!emailRegex.hasMatch(value)) {
                    return 'Please enter a valid email';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),


              //phone number
              CustomTextField(
                hintText: "98XXXXXXXX",
                controller: _phoneController,
                label: 'Phone',
                keyboardType: TextInputType.phone,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter phone';
                  }
                  if (value.length < 10) {
                    return 'Phone number must be at least 10 digits';
                  }
                  if (!RegExp(r'^[0-9]+$').hasMatch(value)) {
                    return 'Please enter a valid phone number';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),


              //service
              Text(
                "Service",
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: AppColors.textMain,
                ),
              ),
              const SizedBox(height: 8),
              DropdownButtonFormField<String>(
                hint: const Text("Select Service"),
                initialValue: _selectedService,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                ),
                items: _staticServices.map((service) {
                  return DropdownMenuItem(value: service, child: Text(service));
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedService = value;
                  });
                },
                validator: (value) =>
                    value == null ? 'Please select a service' : null,
              ),
              const SizedBox(height: 24),

              //save
              ElevatedButton(
                onPressed: _saveLead,
                child: Text(widget.lead != null ? 'Update Lead' : 'Save Lead'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
