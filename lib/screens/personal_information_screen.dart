import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../shared/tradix_shared.dart';

class PersonalInformationScreen extends StatefulWidget {
  const PersonalInformationScreen({super.key});

  @override
  State<PersonalInformationScreen> createState() => _PersonalInformationScreenState();
}

class _PersonalInformationScreenState extends State<PersonalInformationScreen> {
  final TextEditingController _nameController =
  TextEditingController(text: 'Mary Sims');
  final TextEditingController _phoneController =
  TextEditingController(text: '+1 555 123 4567');
  final TextEditingController _emailController =
  TextEditingController(text: 'mary.sims@email.com');

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  void _saveAndExit() {
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: TradixColors.pageBg,
      body: SafeArea(
        child: Column(
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(18, 24, 18, 26),
              decoration: const BoxDecoration(
                color: TradixColors.tealDark,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  InkWell(
                    onTap: () => Navigator.of(context).pop(),
                    borderRadius: BorderRadius.circular(20),
                    child: const Padding(
                      padding: EdgeInsets.all(4.0),
                      child: Icon(
                        Icons.arrow_back,
                        color: Colors.white,
                        size: 26,
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Center(
                    child: Text(
                      'Personal Information',
                      style: GoogleFonts.instrumentSans(
                        fontSize: 22,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(18, 20, 18, 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _FieldLabel(text: 'Name'),
                    const SizedBox(height: 8),
                    _InfoField(controller: _nameController, hintText: 'Enter your name'),
                    const SizedBox(height: 16),
                    _FieldLabel(text: 'Phone'),
                    const SizedBox(height: 8),
                    _InfoField(controller: _phoneController, hintText: 'Enter your phone number'),
                    const SizedBox(height: 16),
                    _FieldLabel(text: 'Email'),
                    const SizedBox(height: 8),
                    _InfoField(controller: _emailController, hintText: 'Enter your email'),
                    const SizedBox(height: 280),
                    SizedBox(
                      width: double.infinity,
                      height: 48,
                      child: ElevatedButton(
                        onPressed: _saveAndExit,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: TradixColors.teal,
                          foregroundColor: Colors.white,
                          elevation: 4,
                          shadowColor: const Color(0x33000000),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text(
                          'Save and Exit',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _FieldLabel extends StatelessWidget {
  final String text;

  const _FieldLabel({required this.text});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 13,
        fontWeight: FontWeight.w500,
        color: TradixColors.dark,
      ),
    );
  }
}

class _InfoField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;

  const _InfoField({
    required this.controller,
    required this.hintText,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: TradixColors.line),
        boxShadow: const [
          BoxShadow(
            color: Color(0x10000000),
            blurRadius: 8,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: TextField(
        controller: controller,
        style: const TextStyle(
          fontSize: 15,
          color: TradixColors.dark,
          fontWeight: FontWeight.w500,
        ),
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: const TextStyle(
            fontSize: 15,
            color: Color(0xFF9AA3AA),
          ),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        ),
      ),
    );
  }
}