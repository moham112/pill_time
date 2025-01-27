// import 'package:easy_localization/easy_localization.dart';
import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pill_time/logic/auth_provider.dart';
import 'package:pill_time/presentation/widget/primary_button.dart';
import 'package:pill_time/presentation/widget/primary_text_field.dart';
import 'package:pill_time/presentation/widget/prrimary_app_bar.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  initState() {
    super.initState();
    Provider.of<AuthProvider>(context, listen: false).getFCMToken();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PrimaryAppBar(
        title: Text('log_in'.tr()),
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
                  'welcome'.tr(),
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                SizedBox(height: 20.h),
                Text(
                  'log_in_message'.tr(),
                  style: Theme.of(context).textTheme.bodySmall,
                ),
                SizedBox(height: 40.h),
                PrimaryTextField(
                  validator: (p0) {
                    if (p0!.isEmpty) {
                      return 'enter_email'.tr();
                    }
                    return null;
                  },
                  controller: emailController,
                  hint: 'enter_email'.tr(),
                ),
                SizedBox(height: 20.h),
                PrimaryTextField(
                  obsecure: true,
                  validator: (p0) {
                    if (p0!.isEmpty) {
                      return 'enter_password'.tr();
                    }
                    return null;
                  },
                  controller: passwordController,
                  hint: 'enter_password'.tr(),
                ),
                SizedBox(height: 30.h),
                Align(
                  alignment: Alignment.centerRight,
                  child: Text('forgot_password'.tr()),
                ),
                SizedBox(height: 20.h),
                SizedBox(
                  width: double.infinity,
                  child: PrimaryButton(
                    onPressed: () async {
                      if (!formKey.currentState!.validate()) {
                        return;
                      }
                      final AuthProvider authProvider;
                      Map<String, dynamic> creds = {
                        "email": emailController.text,
                        "password": passwordController.text,
                        "fcm_token":
                            Provider.of<AuthProvider>(context, listen: false)
                                .FCMToken,
                      };
                      try {
                        authProvider =
                            Provider.of<AuthProvider>(context, listen: false);
                        await Provider.of<AuthProvider>(context, listen: false)
                            .login(creds);
                      } on DioException catch (e) {
                        if (e.type == DioExceptionType.badResponse) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                                content: Text('wrong_email_or_password'.tr())),
                          );
                        }
                        return;
                      }

                      if (authProvider.isAuthenticated()) {
                        Navigator.pushReplacementNamed(context, '/main_screen');
                      }
                    },
                    text: 'log_in'.tr(),
                  ),
                ),
                SizedBox(height: 30.h),
                Align(
                  alignment: Alignment.center,
                  child: InkWell(
                    onTap: () =>
                        Navigator.pushReplacementNamed(context, '/register'),
                    child: RichText(
                      text: TextSpan(
                        text: "${'not_register'.tr()} ",
                        style: Theme.of(context).textTheme.bodySmall,
                        children: <TextSpan>[
                          TextSpan(
                            text: 'register'.tr(),
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
}
