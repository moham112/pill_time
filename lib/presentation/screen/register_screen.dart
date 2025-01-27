import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pill_time/logic/auth_provider.dart';
import 'package:pill_time/presentation/widget/primary_button.dart';
import 'package:pill_time/presentation/widget/primary_text_field.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:pill_time/presentation/widget/prrimary_app_bar.dart';
import 'package:provider/provider.dart';
import 'package:flutter_timezone/flutter_timezone.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final ImagePicker picker = ImagePicker();
  File? imagable;

  // Define controllers
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController birthDateController = TextEditingController();

  final formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    Provider.of<AuthProvider>(context, listen: false).getFCMToken();
  }

  Future<String> getUserTimeZone() async {
    String timezone = await FlutterTimezone.getLocalTimezone();
    return timezone;
  }

  @override
  void dispose() {
    // Dispose controllers
    firstNameController.dispose();
    lastNameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    birthDateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PrimaryAppBar(
        title: Text('register'.tr().toString()),
      ),
      body: Center(
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: 25.w,
          ),
          child: Form(
            key: formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 20.h),
                Text(
                  "Create Account",
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                SizedBox(height: 20.h),
                Text(
                  "Please Inter your Informatioin and\ncreate your account",
                  style: Theme.of(context).textTheme.bodySmall,
                ),
                SizedBox(height: 40.h),
                PrimaryTextField(
                  validator: (p0) {
                    if (p0 == null || p0.isEmpty) {
                      return 'First Name is required';
                    }
                    if (p0.length > 100) {
                      return 'First Name must be less than 100 characters';
                    }
                    return null;
                  },
                  controller: firstNameController,
                  hint: "Enter your First Name",
                ),
                SizedBox(height: 20.h),
                PrimaryTextField(
                  validator: (p0) {
                    if (p0 != null && p0.length > 100) {
                      return 'Last Name must be less than 100 characters';
                    }
                    return null;
                  },
                  controller: lastNameController,
                  hint: "Enter your Last Name",
                ),
                SizedBox(height: 20.h),
                PrimaryTextField(
                  validator: (p0) {
                    if (p0 == null || p0.isEmpty) {
                      return 'Email is required';
                    }
                    if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
                        .hasMatch(p0)) {
                      return 'Invalid email format';
                    }
                    if (p0.length > 255) {
                      return 'Email must be less than 255 characters';
                    }
                    // Add unique email validation logic here if needed
                    return null;
                  },
                  controller: emailController,
                  hint: "Enter your Email",
                ),
                SizedBox(height: 20.h),
                PrimaryTextField(
                  obsecure: true,
                  validator: (p0) {
                    if (p0 == null || p0.isEmpty) {
                      return 'Password is required';
                    }
                    if (p0.length > 255) {
                      return 'Password must be less than 255 characters';
                    }
                    // Add password confirmation logic here if needed
                    return null;
                  },
                  controller: passwordController,
                  hint: "Enter your Password",
                ),
                SizedBox(height: 20.h),
                PrimaryTextField(
                  validator: (p0) {
                    if (p0 == null || p0.isEmpty) {
                      return 'Birth Date is required';
                    }
                    if (!RegExp(r'^\d{4}-\d{2}-\d{2}$').hasMatch(p0)) {
                      return 'Invalid date format. Use YYYY-MM-DD';
                    }
                    return null;
                  },
                  controller: birthDateController,
                  hint: "Enter your Birth Date",
                ),
                SizedBox(height: 20.h),
                GestureDetector(
                  onTap: () => pickImage(),
                  child: Container(
                    alignment: Alignment.center,
                    width: double.infinity,
                    padding: EdgeInsets.all(10.r),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16.r),
                      border: Border.all(
                        color: Colors.blueAccent,
                      ),
                    ),
                    child: Text("Pick an avatar"),
                  ),
                ),
                SizedBox(height: 10.h),
                SizedBox(
                  width: double.infinity,
                  child: PrimaryButton(
                    onPressed: () async {
                      if (!formKey.currentState!.validate()) {
                        return;
                      }
                      final Map<String, dynamic> data = {
                        "email": emailController.text,
                        "password": passwordController.text,
                        "password_confirmation": passwordController.text,
                        "first_name": firstNameController.text,
                        "last_name": lastNameController.text,
                        "birth_date": birthDateController.text,
                        "timezone": await getUserTimeZone(),
                        "fcm_token":
                            Provider.of<AuthProvider>(context, listen: false)
                                .FCMToken,
                      };

                      final authProvider =
                          Provider.of<AuthProvider>(context, listen: false);
                      await authProvider.register(data, imagable!);
                      if (authProvider.isAuthenticated()) {
                        Navigator.pushReplacementNamed(context, '/main_screen');
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Registration failed')),
                        );
                      }
                    },
                    text: "Sign Up",
                  ),
                ),
                SizedBox(height: 30.h),
                Align(
                  alignment: Alignment.center,
                  child: InkWell(
                    onTap: () =>
                        Navigator.pushReplacementNamed(context, '/login'),
                    child: RichText(
                      text: TextSpan(
                        text: 'Have an Account? ',
                        style: Theme.of(context).textTheme.bodySmall,
                        children: <TextSpan>[
                          TextSpan(
                            text: 'Sign In',
                            style: TextStyle(color: Colors.blue),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  pickImage() async {
    var status = await Permission.photos.status;
    if (!status.isGranted) {
      status = await Permission.photos.request();
    }

    // if (status.isGranted) {
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        imagable = File(image.path);
      });
    }
    // } else {
    //   ScaffoldMessenger.of(context).showSnackBar(
    //     SnackBar(content: Text('Permission to access gallery is denied')),
    //   );
    // }
  }
}
