import 'package:clone/constants/string_constants.dart';
import 'package:clone/core/di/injection.dart';
import 'package:clone/services/user_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/feedback_bloc.dart';
import '../bloc/feedback_event.dart';
import '../bloc/feedback_state.dart';

class FeedbackScreen extends StatefulWidget {
  final int? customerId;
  const FeedbackScreen({super.key, this.customerId});
  @override
  State<FeedbackScreen> createState() => _FeedbackScreenState();
}

class _FeedbackScreenState extends State<FeedbackScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _feedbackController = TextEditingController();
  int _rating = 0;
  late UserService _userService;
  @override
  void initState() {
    super.initState();
    _userService = getIt<UserService>();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _feedbackController.dispose();
    super.dispose();
  }

  Future<void> _submitFeedback(BuildContext context) async {
    if (_formKey.currentState!.validate()) {
      if (_rating == 0) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Please provide a rating'),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }
      final customerId =
          widget.customerId ??
          await _userService.getCurrentCustomerIdWithFallback();
      context.read<FeedbackBloc>().add(
        SubmitFeedbackEvent(
          referenceId: 0,
          referenceType: "mobile_app",
          companyId: 19,
          name: _nameController.text,
          customerId: customerId,
          email: _emailController.text,
          customerFeedBack: _feedbackController.text,
          rating: _rating,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => FeedbackBloc(),
      child: Builder(
        builder: (context) {
          return BlocConsumer<FeedbackBloc, FeedbackState>(
            listener: (context, state) {
              if (state is FeedbackSuccess) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(state.message),
                    backgroundColor: Colors.black,
                    duration: const Duration(seconds: 2),
                  ),
                );
                _nameController.clear();
                _emailController.clear();
                _feedbackController.clear();
                setState(() => _rating = 0);
              } else if (state is FeedbackError) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(state.error),
                    backgroundColor: Colors.red,
                    duration: const Duration(seconds: 3),
                  ),
                );
              }
            },
            builder: (context, state) {
              return Scaffold(
                appBar: AppBar(
                  backgroundColor: Color(0xFFCEB007),
                  elevation: 2,
                  shadowColor: Color(0xFFCEB007).withOpacity(0.3),
                  leading: IconButton(
                    icon: const Icon(
                      Icons.arrow_back_ios,
                      color: Colors.white,
                      size: 20,
                    ),
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
                        'Feedback',
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
                body: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Form(
                    key: _formKey,
                    child: ListView(
                      children: [
                        Text(
                          'We value your opinion!',
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFFCEB007),
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Please share your experience with us',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[600],
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 30),
                        Text(
                          'How would you rate our service?',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: Colors.black87,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: List.generate(5, (index) {
                            return IconButton(
                              onPressed: () {
                                setState(() {
                                  _rating = index + 1;
                                });
                              },
                              icon: Icon(
                                index < _rating
                                    ? Icons.star
                                    : Icons.star_border,
                                color: Color(0xFFCEB007),
                                size: 36,
                              ),
                            );
                          }),
                        ),
                        const SizedBox(height: 20),
                        TextFormField(
                          controller: _nameController,
                          decoration: InputDecoration(
                            labelText: 'Your Name',
                            labelStyle: TextStyle(color: Colors.grey[600]),
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
                            prefixIcon: Icon(
                              Icons.person,
                              color: Colors.black87,
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your name';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: _emailController,
                          decoration: InputDecoration(
                            labelText: 'Email Address',
                            labelStyle: TextStyle(color: Colors.grey[600]),
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
                            prefixIcon: Icon(
                              Icons.email,
                              color: Colors.black87,
                            ),
                          ),
                          keyboardType: TextInputType.emailAddress,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your email';
                            }
                            if (!value.contains('@')) {
                              return 'Please enter a valid email';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: _feedbackController,
                          maxLines: 5,
                          decoration: InputDecoration(
                            labelText: 'Your Feedback',
                            labelStyle: TextStyle(color: Colors.grey[600]),
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
                            alignLabelWithHint: true,
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your feedback';
                            }
                            if (value.length < 10) {
                              return 'Feedback must be at least 10 characters long';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 30),
                        ElevatedButton(
                          onPressed: state is FeedbackLoading
                              ? null
                              : () => _submitFeedback(context),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color(0xFFCEB007),
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            elevation: 3,
                          ),
                          child: state is FeedbackLoading
                              ? const SizedBox(
                                  height: 20,
                                  width: 20,
                                  child: CircularProgressIndicator(
                                    color: Colors.white,
                                    strokeWidth: 2,
                                  ),
                                )
                              : const Text(
                                  'Submit Feedback',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                        ),
                        const SizedBox(height: 70),
                        Padding(
                          padding: const EdgeInsets.only(
                            left: 16,
                            right: 16,
                            bottom: 16,
                            top: 8,
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
                              Image.asset(
                                'assets/33.png',
                                width: 100,
                                height: 100,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
