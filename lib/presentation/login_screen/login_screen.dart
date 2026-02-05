// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:pg_managment/core/utils/app_fonts.dart';
// import 'package:pg_managment/core/utils/color_constant.dart';
// import 'package:pg_managment/core/utils/size_utils.dart';
// import 'package:pg_managment/routes/app_routes.dart';
// import 'package:pg_managment/widgets/custom_app_text_form_field.dart';
// import 'package:pg_managment/widgets/custom_elavated_button.dart';
// import 'package:pg_managment/widgets/custom_image_view.dart';
// import 'controller/login_screen_controller.dart';
//
// class LoginScreen extends GetWidget<LoginScreenController> {
//   const LoginScreen({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//         backgroundColor: ColorConstant.primary,
//         body: SafeArea(
//           child: Center(
//             child: Padding(
//               padding: const EdgeInsets.symmetric(horizontal: 16),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   Center(
//                     child: Text(
//                       "Login",
//                       style: PMT.appStyle(
//                           size: 30,
//                           fontWeight: FontWeight.bold,
//                           fontColor: ColorConstant.primaryWhite),
//                     ),
//                   ),
//                   Divider(
//                     color: ColorConstant.primaryWhite,
//                     thickness: 3,
//                   ),
//                   vBox(20),
//                   Text(
//                     'Email',
//                     style: PMT.appStyle(
//                         size: 18,
//                         fontWeight: FontWeight.w500,
//                         fontColor: ColorConstant.primaryWhite),
//                   ),
//                   vBox(10),
//                   CustomAppTextFormField(
//                     controller: controller.emailController,
//                     hintText: 'Enter Your Email',
//                   ),
//                   vBox(20),
//                   Text(
//                     'Password',
//                     style: PMT.appStyle(
//                         size: 18,
//                         fontWeight: FontWeight.w500,
//                         fontColor: ColorConstant.primaryWhite),
//                   ),
//                   vBox(10),
//                   Obx(
//                     () => CustomAppTextFormField(
//                       isObscureText: !controller.isShow.value,
//                       controller: controller.passwordController,
//                       suffix: InkWell(
//                           onTap: () {
//                             controller.isShow.value = !controller.isShow.value;
//                           },
//                           child: Padding(
//                             padding: const EdgeInsets.all(8.0),
//                             child: CustomImageView(
//                               height: 30,
//                               width: 30,
//                               imagePath:   controller.isShow.value
//                                 ? 'assets/images/eye.png'
//                                 : 'assets/images/hidden.png'),
//                           )),
//                       hintText: 'Enter Your Password',
//                     ),
//                   ),
//                   vBox(30),
//                   AppElevatedButton(
//                     buttonColor: ColorConstant.primaryBlack,
//                     buttonName: 'Login',
//                     onPressed: () {
//                       controller.login(controller.emailController.text,
//                           controller.passwordController.text);
//                     },
//                   ),
//                   vBox(40),
//                   Divider(
//                     color: ColorConstant.primaryWhite,
//                     thickness: 3,
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ));
//   }
// }
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pg_managment/core/utils/app_fonts.dart';
import 'package:pg_managment/core/utils/color_constant.dart';
import 'package:pg_managment/core/utils/size_utils.dart';
import 'package:pg_managment/routes/app_routes.dart';
import 'package:pg_managment/widgets/custom_app_text_form_field.dart';
import 'package:pg_managment/widgets/custom_elavated_button.dart';
import 'package:pg_managment/widgets/custom_image_view.dart';
import 'controller/login_screen_controller.dart';

class LoginScreen extends GetWidget<LoginScreenController> {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            children: [
              const SizedBox(height: 10),
              // Logo Section
              _buildLogoSection(),
              const SizedBox(height: 30),
              // Login Form
              _buildLoginForm(),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLogoSection() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            ColorConstant.primary,
            ColorConstant.primary.withOpacity(0.8),
          ],
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: ColorConstant.primary.withOpacity(0.3),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        children: [
          // Logo Container
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: Colors.white.withOpacity(0.3),
                width: 2,
              ),
            ),
            child: const Icon(
              Icons.home_work,
              size: 40,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'PG Management',
            style: PMT.appStyle(
              size: 24,
              fontWeight: FontWeight.bold,
              fontColor: Colors.white,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Welcome back! Please sign in to continue',
            style: PMT.appStyle(
              size: 14,
              fontColor: Colors.white.withOpacity(0.9),
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildLoginForm() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 20,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title
          Text(
            'Sign In',
            style: PMT.appStyle(
              size: 28,
              fontWeight: FontWeight.bold,
              fontColor: Colors.black87,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Enter your credentials to access your account',
            style: PMT.appStyle(
              size: 14,
              fontColor: Colors.grey[600]!,
            ),
          ),
          const SizedBox(height: 32),
          // Email Field
          _buildInputField(
            label: 'Email Address',
            controller: controller.emailController,
            hintText: 'Enter your email',
            prefixIcon: Icons.email_outlined,
            keyboardType: TextInputType.emailAddress,
          ),
          const SizedBox(height: 20),
          // Password Field
          Obx(
            () => _buildPasswordField(
              label: 'Password',
              controller: controller.passwordController,
              hintText: 'Enter your password',
              isObscure: !controller.isShow.value,
              onToggleVisibility: () {
                controller.isShow.value = !controller.isShow.value;
              },
            ),
          ),
          const SizedBox(height: 32),
          // Login Button
          SizedBox(
            width: double.infinity,
            height: 52,
            child: ElevatedButton(
              onPressed: () {
                controller.login(
                  controller.emailController.text,
                  controller.passwordController.text,
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: ColorConstant.primary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                elevation: 2,
              ),
              child: Text(
                'Sign In',
                style: PMT.appStyle(
                  size: 16,
                  fontWeight: FontWeight.w600,
                  fontColor: Colors.white,
                ),
              ),
            ),
          ),
          const SizedBox(height: 24),
          // Footer
          Center(
            child: Text(
              '© 2025 SELFMESS Management System',
              style: PMT.appStyle(
                size: 12,
                fontColor: Colors.grey[500]!,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInputField({
    required String label,
    required TextEditingController controller,
    required String hintText,
    required IconData prefixIcon,
    TextInputType? keyboardType,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: PMT.appStyle(
            size: 14,
            fontWeight: FontWeight.w600,
            fontColor: Colors.black87,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: const Color(0xFFF8F9FA),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: Colors.grey.withOpacity(0.2),
            ),
          ),
          child: TextField(
            controller: controller,
            keyboardType: keyboardType,
            decoration: InputDecoration(
              hintText: hintText,
              hintStyle: PMT.appStyle(
                size: 14,
                fontColor: Colors.grey[500]!,
              ),
              prefixIcon: Icon(
                prefixIcon,
                color: Colors.grey[600],
                size: 20,
              ),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 16,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPasswordField({
    required String label,
    required TextEditingController controller,
    required String hintText,
    required bool isObscure,
    required VoidCallback onToggleVisibility,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: PMT.appStyle(
            size: 14,
            fontWeight: FontWeight.w600,
            fontColor: Colors.black87,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: const Color(0xFFF8F9FA),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: Colors.grey.withOpacity(0.2),
            ),
          ),
          child: TextField(
            controller: controller,
            obscureText: isObscure,
            decoration: InputDecoration(
              hintText: hintText,
              hintStyle: PMT.appStyle(
                size: 14,
                fontColor: Colors.grey[500]!,
              ),
              prefixIcon: Icon(
                Icons.lock_outline,
                color: Colors.grey[600],
                size: 20,
              ),
              suffixIcon: GestureDetector(
                onTap: onToggleVisibility,
                child: Container(
                  padding: const EdgeInsets.all(12),
                  child: Icon(
                    isObscure ? Icons.visibility_off : Icons.visibility,
                    color: Colors.grey[600],
                    size: 20,
                  ),
                ),
              ),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 16,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
