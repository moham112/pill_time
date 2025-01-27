import 'dart:io';

import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:pill_time/helper/cache_helper.dart';
import 'package:pill_time/helper/constants.dart';
import 'package:pill_time/logic/app_provider.dart';
import 'package:pill_time/logic/auth_provider.dart';
import 'package:pill_time/presentation/widget/primary_button.dart';
import 'package:pill_time/presentation/widget/primary_text_field.dart';
import 'package:pill_time/presentation/widget/prrimary_app_bar.dart';
import 'package:provider/provider.dart';

class UserProfileScreen extends StatefulWidget {
  const UserProfileScreen({super.key});

  @override
  UserProfileScreenState createState() => UserProfileScreenState();
}

class UserProfileScreenState extends State<UserProfileScreen> {
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController birthDateController = TextEditingController();
  String localeSelected = 'en';
  final _formKey = GlobalKey<FormState>();

  File? _profileImage;
  final ImagePicker _imagePicker = ImagePicker();

  @override
  void dispose() {
    firstNameController.dispose();
    lastNameController.dispose();
    emailController.dispose();
    birthDateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PrimaryAppBar(
        title: Text('user_profile'.tr()),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Consumer<AuthProvider>(
            builder: (context, value, child) => Form(
              key: _formKey,
              child: Column(
                children: [
                  Stack(
                    children: [
                      CircleAvatar(
                          radius: 50,
                          backgroundImage: _profileImage == null
                              ? NetworkImage(
                                  CacheHelper.getData("user_profile_picture"))
                              : FileImage(_profileImage!)),
                      Positioned(
                        bottom: -10,
                        right: -10,
                        child: IconButton(
                          icon: CircleAvatar(
                            radius: 12,
                            backgroundColor: Colors.blue,
                            child: Icon(
                              Icons.edit,
                              size: 12,
                              color: Colors.white,
                            ),
                          ),
                          onPressed: _pickImage,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  Text(
                    '''${Provider.of<AuthProvider>(context).user.firstName} ${Provider.of<AuthProvider>(context).user.lastName}''',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 20),
                  PrimaryTextField(
                    validator: (p0) {
                      if (p0!.length > 100) {
                        return 'first_name_cant_be_more_than_100_characters'
                            .tr();
                      }
                      return null;
                    },
                    controller: firstNameController,
                    hint: CacheHelper.getData("user_first_name"),
                  ),
                  SizedBox(height: 10),
                  PrimaryTextField(
                    validator: (p0) {
                      if (p0!.length > 100) {
                        return 'last_name_cant_be_more_than_100_characters'
                            .tr();
                      }
                      return null;
                    },
                    controller: lastNameController,
                    hint: CacheHelper.getData("user_last_name"),
                  ),
                  SizedBox(height: 10),
                  PrimaryTextField(
                    validator: (p0) {
                      if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
                          .hasMatch(p0!)) {
                        return 'invalid_email_format'.tr();
                      }
                      if (p0.length > 255) {
                        return 'email_cant_be_more_than_255_characters'.tr();
                      }
                      return null;
                    },
                    controller: emailController,
                    hint: CacheHelper.getData("user_email"),
                  ),
                  SizedBox(height: 10),
                  PrimaryTextField(
                    validator: (p0) {
                      return null;
                    },
                    controller: birthDateController,
                    hint: CacheHelper.getData("user_birthdate"),
                  ),
                  SizedBox(height: 15.h),
                  DropdownButtonFormField<String>(
                    value: CacheHelper.getData("lang"),
                    decoration: InputDecoration(
                      labelText: 'select_language'.tr(),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                        borderSide: BorderSide(
                          color: Colors.grey,
                          width: 1.0,
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                        borderSide: BorderSide(
                          color: Colors.grey,
                          width: 1.0,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                        borderSide: BorderSide(
                          color: Colors.blue,
                          width: 2.0,
                        ),
                      ),
                    ),
                    items: supportedLocales.entries
                        .map((e) => DropdownMenuItem(
                              value: e.key,
                              child: Text(e.value),
                            ))
                        .toList(),
                    onChanged: (String? value) {
                      localeSelected = value!;
                    },
                  ),
                  SizedBox(height: 20),
                  PrimaryButton(
                      text: 'save'.tr(),
                      onPressed: () async {
                        if (!_formKey.currentState!.validate()) {
                          return;
                        }
                        final userUpdatedData = {
                          "first_name": firstNameController.text.isNotEmpty
                              ? firstNameController.text
                              : CacheHelper.getData("user_first_name"),
                          "last_name": lastNameController.text.isNotEmpty
                              ? lastNameController.text
                              : CacheHelper.getData("user_last_name"),
                          "email": emailController.text.isNotEmpty
                              ? emailController.text
                              : CacheHelper.getData("user_email"),
                          "birth_date": birthDateController.text.isNotEmpty
                              ? birthDateController.text
                              : CacheHelper.getData("user_birthdate"),
                        };
                        try {
                          Provider.of<AppProvider>(context, listen: false)
                              .changeLanguage(localeSelected, context);
                          await Provider.of<AuthProvider>(context,
                                  listen: false)
                              .updateUserData(userUpdatedData,
                                  CacheHelper.getData("user_id"),
                                  profilePicture: _profileImage);

                          Navigator.pop(context);
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: Text('saved_successfully'.tr()),
                          ));
                        } on DioException catch (e) {
                          if (e.type == DioExceptionType.connectionTimeout) {
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content: Text('no_internet_connection'.tr()),
                            ));
                          }
                        }
                      }),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  _pickImage() async {
    var status = await Permission.photos.status;
    if (!status.isGranted) {
      status = await Permission.photos.request();
    }

    // if (status.isGranted) {
    final XFile? image =
        await _imagePicker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        _profileImage = File(image.path);
      });
    }
    // } else {
    //   ScaffoldMessenger.of(context).showSnackBar(
    //     SnackBar(content: Text('Permission to access gallery is denied')),
    //   );
    // }
  }
}
