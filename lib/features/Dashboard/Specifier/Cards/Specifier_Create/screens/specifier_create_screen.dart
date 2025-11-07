import 'package:clone/constants/string_constants.dart';
import 'package:clone/features/Dashboard/Specifier/Cards/Specifier_Create/bloc/specifier_create_bloc.dart';
import 'package:clone/features/Dashboard/Specifier/Cards/Specifier_Create/bloc/specifier_create_event.dart';
import 'package:clone/features/Dashboard/Specifier/Cards/Specifier_Create/bloc/specifier_create_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SpecifierCreateScreen extends StatefulWidget {
  const SpecifierCreateScreen({super.key});

  @override
  State<SpecifierCreateScreen> createState() => _SpecifierCreateScreenState();
}

class _SpecifierCreateScreenState extends State<SpecifierCreateScreen> {
  final _formKey = GlobalKey<FormState>();
  final _projectName = TextEditingController();
  final _contactPerson = TextEditingController();
  final _contactNumber = TextEditingController();
  final _remarks = TextEditingController();
  final _sheet = TextEditingController();

  @override
  void dispose() {
    _projectName.dispose();
    _contactPerson.dispose();
    _contactNumber.dispose();
    _remarks.dispose();
    _sheet.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SpecifierCreateBloc(),
      child: Builder(builder: (context) => _buildScreen(context)),
    );
  }

  void _submitForm(BuildContext context) {
    if (_formKey.currentState!.validate()) {
      context.read<SpecifierCreateBloc>().add(
        SubmitSpecifierCreateEvent(
          projectName: _projectName.text.trim(),
          contactPerson: _contactPerson.text.trim(),
          contactNumber: _contactNumber.text.trim(),
          remarks: _remarks.text.trim(),
          sheet: _sheet.text.trim(),
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
            const SizedBox(width: 22),
            const Text(
              'Create Specification',
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
      body: BlocConsumer<SpecifierCreateBloc, SpecifierCreateState>(
        listener: (context, state) {
          if (state is SpecifierCreateSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Submitted successful'),
                backgroundColor: Colors.green,
              ),
            );
            _projectName.clear();
            _contactPerson.clear();
            _contactNumber.clear();
            _remarks.clear();
            _sheet.clear();
          } else if (state is SpecifierCreateError) {
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
                      'Create Specification',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFFCEB007),
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),
                  TextFormField(
                    controller: _projectName,
                    decoration: InputDecoration(
                      labelText: 'Project Name',
                      hintText: 'Enter your Project Name',
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
                        return 'Please enter your Project Name';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    controller: _contactPerson,
                    // keyboardType: TextInputType.phone,
                    decoration: InputDecoration(
                      labelText: 'Contact Person',
                      hintText: 'Enter your Contact Person',
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
                        return 'Please enter your Project Name';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    controller: _contactNumber,
                    keyboardType: TextInputType.phone,
                    decoration: InputDecoration(
                      labelText: 'Company Number',
                      hintText: 'Enter your Company Number',
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
                    controller: _remarks,
                    decoration: InputDecoration(
                      labelText: 'Remarks',
                      hintText: 'Enter your Remarks',
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
                        return 'Please enter your Remarks';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    controller: _sheet,
                    decoration: InputDecoration(
                      labelText: 'Sheet',
                      hintText: 'Enter your Sheet',
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
                        return 'Please enter your Company Sheet';
                      }
                      return null;
                    },
                  ),

                  const SizedBox(height: 30),
                  SizedBox(
                    height: 50,
                    child: ElevatedButton(
                      onPressed: state is SpecifierCreateLoading
                          ? null
                          : () => _submitForm(context),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFFCEB007),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: state is SpecifierCreateLoading
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
                  const SizedBox(height: 100),
                  Padding(
                    padding: const EdgeInsets.only(
                      left: 16,
                      right: 16,
                      bottom: 26,
                      top: 30,
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


// "projectName": "string",
//   "contactPerson": "string",
//   "contactNumber": "string",
//   "remarks": "string",
//   "sheet": "string",