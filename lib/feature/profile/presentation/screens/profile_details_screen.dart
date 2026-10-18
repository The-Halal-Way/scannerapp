import 'package:flutter/material.dart';
import 'package:scannerapp/config/theme/app_icons.dart';
import 'package:provider/provider.dart';
import 'package:scannerapp/config/theme/app_theme_colors.dart';
import 'package:scannerapp/feature/profile/presentation/providers/profile_provider.dart';
import 'package:scannerapp/feature/profile/presentation/widgets/profile_details_header.dart';
import 'package:scannerapp/feature/profile/presentation/widgets/profile_text_field.dart';

class ProfileDetailsScreen extends StatelessWidget {
  const ProfileDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: ProfileProvider.instance,
      child: const _ProfileDetailsContent(),
    );
  }
}

class _ProfileDetailsContent extends StatefulWidget {
  const _ProfileDetailsContent();

  @override
  State<_ProfileDetailsContent> createState() => _ProfileDetailsContentState();
}

class _ProfileDetailsContentState extends State<_ProfileDetailsContent> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _name;
  late final TextEditingController _pharmacy;
  late final TextEditingController _email;
  late final TextEditingController _phone;
  late final TextEditingController _deliveryArea;
  late final TextEditingController _address;
  bool _editing = false;

  @override
  void initState() {
    super.initState();
    final profile = ProfileProvider.instance;
    _name = TextEditingController(text: profile.name);
    _pharmacy = TextEditingController(text: profile.pharmacyName);
    _email = TextEditingController(text: profile.email);
    _phone = TextEditingController(text: profile.phone);
    _deliveryArea = TextEditingController(text: profile.deliveryArea);
    _address = TextEditingController(text: profile.address);
  }

  @override
  void dispose() {
    _name.dispose();
    _pharmacy.dispose();
    _email.dispose();
    _phone.dispose();
    _deliveryArea.dispose();
    _address.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final text = Theme.of(context).textTheme;
    final profile = context.watch<ProfileProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile details'),
        actions: [
          if (_editing)
            TextButton(onPressed: _cancel, child: const Text('Cancel'))
          else
            TextButton.icon(
              onPressed: () => setState(() => _editing = true),
              icon: const Icon(AppIcons.edit, size: 17),
              label: const Text('Edit'),
            ),
          const SizedBox(width: 8),
        ],
      ),
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: ListView(
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 30),
            children: [
              ProfileDetailsHeader(profile: profile),
              const SizedBox(height: 25),
              Text('PERSONAL INFORMATION', style: _sectionStyle(text, colors)),
              const SizedBox(height: 12),
              ProfileTextField(
                label: 'Full name',
                controller: _name,
                icon: AppIcons.person,
                editing: _editing,
                validator: _required,
              ),
              const SizedBox(height: 13),
              ProfileTextField(
                label: 'Email address',
                controller: _email,
                icon: AppIcons.at,
                editing: _editing,
                keyboardType: TextInputType.emailAddress,
                validator: _validateEmail,
              ),
              const SizedBox(height: 13),
              ProfileTextField(
                label: 'Phone number',
                controller: _phone,
                icon: AppIcons.phone,
                editing: _editing,
                keyboardType: TextInputType.phone,
                validator: _required,
              ),
              const SizedBox(height: 25),
              Text('PHARMACY & DELIVERY', style: _sectionStyle(text, colors)),
              const SizedBox(height: 12),
              ProfileTextField(
                label: 'Pharmacy name',
                controller: _pharmacy,
                icon: AppIcons.medical,
                editing: _editing,
                validator: _required,
              ),
              const SizedBox(height: 13),
              ProfileTextField(
                label: 'Delivery area',
                controller: _deliveryArea,
                icon: AppIcons.company,
                editing: _editing,
                validator: _required,
              ),
              const SizedBox(height: 13),
              ProfileTextField(
                label: 'Street address',
                controller: _address,
                icon: AppIcons.location,
                editing: _editing,
                maxLines: 2,
                validator: _required,
              ),
              if (_editing) ...[
                const SizedBox(height: 23),
                SizedBox(
                  width: double.infinity,
                  child: FilledButton.icon(
                    onPressed: _save,
                    icon: const Icon(AppIcons.check),
                    label: const Text('Save changes'),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  TextStyle? _sectionStyle(TextTheme text, AppThemeColors colors) =>
      text.labelSmall?.copyWith(
        color: colors.textMuted,
        fontWeight: FontWeight.w800,
        letterSpacing: .15,
      );

  String? _required(String? value) =>
      value == null || value.trim().isEmpty ? 'This field is required' : null;

  String? _validateEmail(String? value) {
    if (value == null || value.trim().isEmpty) return 'Email is required';
    if (!RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]+$').hasMatch(value.trim())) {
      return 'Enter a valid email';
    }
    return null;
  }

  void _cancel() {
    final profile = ProfileProvider.instance;
    _formKey.currentState?.reset();
    _name.text = profile.name;
    _pharmacy.text = profile.pharmacyName;
    _email.text = profile.email;
    _phone.text = profile.phone;
    _deliveryArea.text = profile.deliveryArea;
    _address.text = profile.address;
    FocusScope.of(context).unfocus();
    setState(() => _editing = false);
  }

  void _save() {
    if (!_formKey.currentState!.validate()) return;
    ProfileProvider.instance.update(
      name: _name.text,
      pharmacyName: _pharmacy.text,
      email: _email.text,
      phone: _phone.text,
      deliveryArea: _deliveryArea.text,
      address: _address.text,
    );
    FocusScope.of(context).unfocus();
    setState(() => _editing = false);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Profile updated for this session')),
    );
  }
}
