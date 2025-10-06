import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:clone/constants/string_constants.dart';
import '../bloc/contact_us_bloc.dart';
import '../bloc/contact_us_event.dart';
import '../bloc/contact_us_state.dart';

class ContactUsScreen extends StatefulWidget {
  const ContactUsScreen({super.key});

  @override
  State<ContactUsScreen> createState() => _ContactUsScreenState();
}

class _ContactUsScreenState extends State<ContactUsScreen> {
  final _formKey = GlobalKey<FormState>();
  final _whatsappNumberController = TextEditingController();
  final _contactNumberController = TextEditingController();
  final _companyNameController = TextEditingController();
  final _companyAddressController = TextEditingController();
  final _companyGSTController = TextEditingController();
  final _gstCertificateController = TextEditingController();

  @override
  void dispose() {
    _whatsappNumberController.dispose();
    _contactNumberController.dispose();
    _companyNameController.dispose();
    _companyAddressController.dispose();
    _companyGSTController.dispose();
    _gstCertificateController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ContactUsBloc(),
      child: Builder(builder: (context) => _buildScreen(context)),
    );
  }

  void _submitForm(BuildContext context) {
    if (_formKey.currentState!.validate()) {
      context.read<ContactUsBloc>().add(
        SubmitContactUsEvent(
          whatsappNumber: _whatsappNumberController.text.trim(),
          contactNumber: _contactNumberController.text.trim(),
          companyName: _companyNameController.text.trim(),
          companyAddress: _companyAddressController.text.trim(),
          companyGST: _companyGSTController.text.trim(),
          gstCertificate: _gstCertificateController.text.trim(),
        ),
      );
    }
  }

  Widget _buildScreen(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFFCEB007),
        elevation: 2,
        shadowColor: Color(0xFFCEB007).withOpacity(0.3),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white, size: 20),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        title: Row(
          children: [
            Image.asset(
              'assets/logo1.png',
              width: 80,
              height: 80,
              fit: BoxFit.contain,
            ),
            const SizedBox(width: 30),
            const Text(
              'Contact Us',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
        titleSpacing: 0,
      ),
      body: BlocConsumer<ContactUsBloc, ContactUsState>(
        listener: (context, state) {
          if (state is ContactUsSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.green,
              ),
            );
            _whatsappNumberController.clear();
            _contactNumberController.clear();
            _companyNameController.clear();
            _companyAddressController.clear();
            _companyGSTController.clear();
            _gstCertificateController.clear();
          } else if (state is ContactUsError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.error), backgroundColor: Colors.red),
            );
          }
        },
        builder: (context, state) {
          return Padding(
            padding: const EdgeInsets.all(20.0),
            child: Form(
              key: _formKey,
              child: ListView(
                children: [
                  const SizedBox(height: 20),
                  Center(
                    child: const Text(
                      'Contact Us!',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFFCEB007),
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),
                  TextFormField(
                    controller: _whatsappNumberController,
                    decoration: InputDecoration(
                      labelText: 'Whatsapp Number',
                      hintText: 'Enter your WhatsappNumber',
                      prefixIcon: Icon(Icons.person, color: Colors.black),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(
                          color: Color(0xFFCEB007),
                          width: 2,
                        ),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Please enter your WhatsappNumber';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    controller: _contactNumberController,
                    keyboardType: TextInputType.phone,
                    decoration: InputDecoration(
                      labelText: 'Contact Number',
                      hintText: 'Enter your Contact Number',
                      prefixIcon: Icon(Icons.phone, color: Colors.black),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(
                          color: Color(0xFFCEB007),
                          width: 2,
                        ),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Please enter your Contact Number';
                      }
                      if (value.trim().length < 10) {
                        return 'Please enter a valid Contact Number';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    controller: _companyNameController,
                    decoration: InputDecoration(
                      labelText: 'Company Name',
                      hintText: 'Enter your Company Name',
                      prefixIcon: Icon(Icons.store, color: Colors.black),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(
                          color: Color(0xFFCEB007),
                          width: 2,
                        ),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Please enter your Company Name';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    controller: _companyAddressController,
                    decoration: InputDecoration(
                      labelText: 'Company Address',
                      hintText: 'Enter your Company Address',
                      prefixIcon: Icon(Icons.store, color: Colors.black),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(
                          color: Color(0xFFCEB007),
                          width: 2,
                        ),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Please enter your Company Address';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    controller: _companyGSTController,
                    decoration: InputDecoration(
                      labelText: 'Company GST',
                      hintText: 'Enter your Company GST',
                      prefixIcon: Icon(Icons.store, color: Colors.black),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(
                          color: Color(0xFFCEB007),
                          width: 2,
                        ),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Please enter your Company GST';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    controller: _gstCertificateController,
                    decoration: InputDecoration(
                      labelText: 'GST Certificate',
                      hintText: 'Enter your GST Certificate',
                      prefixIcon: Icon(Icons.store, color: Colors.black),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(
                          color: Color(0xFFCEB007),
                          width: 2,
                        ),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Please enter your GST Certificate';
                      }
                      return null;
                    },
                  ),

                  const SizedBox(height: 30),
                  SizedBox(
                    height: 50,
                    child: ElevatedButton(
                      onPressed: state is ContactUsLoading
                          ? null
                          : () => _submitForm(context),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFFCEB007),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: state is ContactUsLoading
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 2,
                              ),
                            )
                          : const Text(
                              'Submit',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                    ),
                  ),
                  const SizedBox(height: 40),
                  Padding(
                    padding: const EdgeInsets.only(
                      left: 16,
                      right: 16,
                      bottom: 16,
                      top: 0,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'App Version - ${StringConstant.version}',
                          style: TextStyle(
                            color: Color.fromARGB(255, 95, 91, 91),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Image.asset('assets/33.png', width: 100, height: 100),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
