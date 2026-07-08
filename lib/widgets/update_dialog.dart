import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:pg_managment/core/utils/color_constant.dart';
import 'package:pg_managment/core/utils/app_fonts.dart';
import 'package:pg_managment/widgets/custom_elavated_button.dart';

class UpdateDialog extends StatelessWidget {
  final String updateUrl;
  final String version;

  const UpdateDialog({
    super.key,
    required this.updateUrl,
    required this.version,
  });

  Future<void> _launchUpdateUrl() async {
    final Uri url = Uri.parse(updateUrl);
    try {
      if (await canLaunchUrl(url)) {
        await launchUrl(url, mode: LaunchMode.externalApplication);
      }
    } catch (e) {
      debugPrint('Could not launch $updateUrl: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        elevation: 10,
        backgroundColor: Colors.white,
        child: Container(
          width: 350,
          padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Beautiful update illustration / icon
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: ColorConstant.primary.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.system_update_rounded,
                  size: 56,
                  color: ColorConstant.primary,
                ),
              ),
              const SizedBox(height: 24),
              // Heading
              Text(
                'Update Available',
                style: PMT.appStyle(
                  size: 22,
                  fontWeight: FontWeight.w700,
                  fontColor: ColorConstant.textDarkBrown,
                ),
              ),
              const SizedBox(height: 12),
              // Description
              Text(
                'A new version ($version) of Self-Mess is available. Please update to continue using the application.',
                textAlign: TextAlign.center,
                style: PMT.appStyle(
                  size: 14,
                  fontWeight: FontWeight.w400,
                  fontColor: Colors.black54,
                ),
              ),
              const SizedBox(height: 28),
              // CTA Button
              SizedBox(
                width: double.infinity,
                child: AppElevatedButton(
                  buttonName: 'Update Now',
                  onPressed: _launchUpdateUrl,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
