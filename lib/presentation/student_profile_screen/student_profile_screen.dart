import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:pg_managment/core/utils/app_fonts.dart';
import 'package:pg_managment/core/utils/color_constant.dart';
import 'package:pg_managment/widgets/custom_elavated_button.dart';
import '../../routes/app_routes.dart';
import 'controller/student_profile_screen_controller.dart';

class StudentProfileScreen extends GetWidget<StudentProfileScreenController> {
  const StudentProfileScreen({super.key});

  Future<void> _makeCall(String? phone) async {
    if (phone == null || phone.isEmpty) return;
    final Uri url = Uri.parse('tel:$phone');
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    }
  }

  Future<void> _sendEmail(String? email) async {
    if (email == null || email.isEmpty) return;
    final Uri url = Uri.parse('mailto:$email');
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    }
  }

  Future<void> _launchWhatsApp(String? phone) async {
    if (phone == null || phone.isEmpty) return;
    final Uri url = Uri.parse("https://wa.me/91$phone");
    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    }
  }

  void _copyToClipboard(String label, String? value) {
    if (value == null || value.isEmpty) return;
    Clipboard.setData(ClipboardData(text: value));
    Get.snackbar(
      "Copied",
      "$label copied to clipboard",
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.black87,
      colorText: Colors.white,
      margin: const EdgeInsets.all(20),
      duration: const Duration(seconds: 1),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF1F5F9),
      body: Obx(() {
        final data = controller.model.value.data;

        if (data == null) {
          return const Center(child: CircularProgressIndicator());
        }

        return Stack(
          children: [
            // Header Gradient Background
            Container(
              height: 300,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    ColorConstant.primary,
                    ColorConstant.primary.withOpacity(0.85),
                  ],
                ),
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(32),
                  bottomRight: Radius.circular(32),
                ),
              ),
            ),

            SafeArea(
              child: CustomScrollView(
                physics: const BouncingScrollPhysics(),
                slivers: [
                  SliverAppBar(
                    backgroundColor: Colors.transparent,
                    elevation: 0,
                    leading: IconButton(
                      icon: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.arrow_back_ios_new_rounded,
                            color: Colors.white, size: 18),
                      ),
                      onPressed: () => Get.back(),
                    ),
                    actions: [
                      IconButton(
                        icon: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.2),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(Icons.share_rounded,
                              color: Colors.white, size: 18),
                        ),
                        onPressed: () {
                          // TODO: Implement share
                        },
                      ),
                      const SizedBox(width: 10),
                    ],
                    centerTitle: true,
                    floating: true,
                  ),
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Column(
                        children: [
                          const SizedBox(height: 10),
                          // Premium Avatar with pulse effect
                          _buildPremiumAvatar(data.name),
                          const SizedBox(height: 15),
                          SizedBox(
                            width: Get.width * 0.85,
                            child: Text(
                              data.name?.toUpperCase() ?? 'GUEST STUDENT',
                              textAlign: TextAlign.center,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: PMT
                                  .appStyle(
                                size: 20,
                                fontColor: Colors.white,
                                fontWeight: FontWeight.w900,
                              )
                                  .copyWith(
                                shadows: [
                                  Shadow(
                                    color: Colors.black.withOpacity(0.3),
                                    offset: const Offset(0, 2),
                                    blurRadius: 4,
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(height: 6),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 6),
                            decoration: BoxDecoration(
                              color: Colors.black.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              data.email ?? 'no-email@pg.com',
                              style: PMT.appStyle(
                                  size: 13, fontColor: Colors.white),
                            ),
                          ),
                          const SizedBox(height: 25),

                          // Quick Action Bar
                          _buildQuickActions(data.mobile, data.email),
                          const SizedBox(height: 25),

                          // Profile Info Sections
                          _buildSectionCard(
                            "Contact Information",
                            Icons.contact_phone_rounded,
                            [
                              _buildInteractiveTile(Icons.phone_rounded,
                                  "Primary Mobile", data.mobile,
                                  onTap: () => _makeCall(data.mobile),
                                  onLongPress: () => _copyToClipboard(
                                      "Mobile Number", data.mobile)),
                              _buildInteractiveTile(Icons.phone_android_rounded,
                                  "Alt. Mobile", data.alternativeMobile,
                                  onTap: () =>
                                      _makeCall(data.alternativeMobile),
                                  onLongPress: () => _copyToClipboard(
                                      "Alt Mobile", data.alternativeMobile)),
                              _buildInteractiveTile(Icons.email_rounded,
                                  "Email Address", data.email,
                                  onTap: () => _sendEmail(data.email),
                                  onLongPress: () =>
                                      _copyToClipboard("Email", data.email)),
                              _buildInteractiveTile(Icons.bloodtype_rounded,
                                  "Blood Group", data.bloodGroup),
                              _buildInteractiveTile(Icons.location_on_rounded,
                                  "Home Address", data.residentialAddress,
                                  isLast: true),
                            ],
                          ),

                          const SizedBox(height: 20),
                          _buildSectionCard(
                            "Residency & Academics",
                            Icons.school_rounded,
                            [
                              _buildInteractiveTile(Icons.apartment_rounded,
                                  "Hostel Details", data.hostelName),
                              _buildInteractiveTile(Icons.meeting_room_rounded,
                                  "Room Assignment", "Room ${data.roomNo}"),
                              _buildInteractiveTile(Icons.book_rounded,
                                  "Course/Pursuing", data.currentlyPursuing),
                              _buildInteractiveTile(
                                  Icons.calendar_month_rounded,
                                  "Year of Study",
                                  "Year ${data.currentlyStudyingYear}"),
                              _buildInteractiveTile(
                                  Icons.event_available_rounded,
                                  "Joining Date",
                                  data.date != null
                                      ? data.date.toString().split(' ')[0]
                                      : 'N/A'),
                              _buildInteractiveTile(Icons.history_edu_rounded,
                                  "Pass-out Year", "${data.year}"),
                              _buildInteractiveTile(Icons.person_pin_rounded,
                                  "Advisor/Guide", data.advisorGuide,
                                  isLast: true),
                            ],
                          ),

                          const SizedBox(height: 20),
                          _buildSectionCard(
                            "Financial Summary",
                            Icons.account_balance_wallet_rounded,
                            [
                              _buildInteractiveTile(
                                  Icons.currency_rupee_rounded,
                                  "Refundable Deposit",
                                  "₹${data.deposit}",
                                  isLast: true,
                                  isHighlight: true),
                            ],
                          ),

                          const SizedBox(height: 35),
                          if (Get.arguments == null ||
                              Get.arguments['isViewMode'] != true)
                            AppElevatedButton(
                              buttonName: 'Edit Profile Information',
                              onPressed: () {
                                Get.toNamed(AppRoutes.addStudentScreenRoute,
                                    arguments: {
                                      "data": data,
                                      "isAddEdit": 1,
                                      "isStudentShow": true
                                    })?.then((value) {
                                  controller.getStudentProfile();
                                });
                              },
                            ),
                          const SizedBox(height: 40),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      }),
    );
  }

  Widget _buildPremiumAvatar(String? name) {
    return Container(
      width: 120,
      height: 120,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: Colors.white, width: 5),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 20,
            spreadRadius: 5,
          ),
        ],
      ),
      child: CircleAvatar(
        radius: 55,
        backgroundColor: Colors.white,
        child: Text(
          name != null && name.isNotEmpty ? name[0].toUpperCase() : '?',
          style: PMT.appStyle(
              size: 50,
              fontColor: ColorConstant.primary,
              fontWeight: FontWeight.w900),
        ),
      ),
    );
  }

  Widget _buildQuickActions(String? phone, String? email) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _quickActionButton(Icons.call_rounded, "Call", Colors.green,
            onTap: () => _makeCall(phone)),
        _quickActionButton(Icons.forum_rounded, "Message", Colors.blue,
            onTap: () => _makeCall(phone)), // Simplified as calling for now
        _quickActionButton(
            Icons.chat_bubble_rounded, "WhatsApp", const Color(0xFF25D366),
            onTap: () => _launchWhatsApp(phone)),
        _quickActionButton(
            Icons.alternate_email_rounded, "Email", Colors.orange,
            onTap: () => _sendEmail(email)),
      ],
    );
  }

  Widget _quickActionButton(IconData icon, String label, Color color,
      {VoidCallback? onTap}) {
    return Column(
      children: [
        GestureDetector(
          onTap: onTap,
          child: Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: color.withOpacity(0.2),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Icon(icon, color: color, size: 22),
          ),
        ),
        const SizedBox(height: 8),
        Text(label,
            style: PMT.appStyle(
                size: 11,
                fontColor: Colors.black54,
                fontWeight: FontWeight.w600)),
      ],
    );
  }

  Widget _buildSectionCard(String title, IconData icon, List<Widget> children) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 20, 24, 15),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: ColorConstant.primary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(icon, color: ColorConstant.primary, size: 18),
                ),
                const SizedBox(width: 12),
                Text(
                  title,
                  style: PMT.appStyle(
                      size: 17,
                      fontWeight: FontWeight.w800,
                      fontColor: Colors.black87),
                ),
              ],
            ),
          ),
          const Divider(height: 1, thickness: 0.5),
          Padding(
            padding: const EdgeInsets.all(8),
            child: Column(children: children),
          ),
        ],
      ),
    );
  }

  Widget _buildInteractiveTile(IconData icon, String label, String? value,
      {bool isLast = false,
      bool isHighlight = false,
      VoidCallback? onTap,
      VoidCallback? onLongPress}) {
    final bool isEmpty =
        (value == null || value.isEmpty || value == "null" || value == "N/A");
    final String displayValue = isEmpty ? 'Not Set' : value;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        onLongPress: onLongPress,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: isHighlight
                      ? ColorConstant.primary.withOpacity(0.1)
                      : const Color(0xFFF8FAFC),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(icon,
                    color: isHighlight
                        ? ColorConstant.primary
                        : Colors.grey.shade600,
                    size: 20),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      label,
                      style: PMT.appStyle(
                          size: 12,
                          fontColor: Colors.grey.shade500,
                          fontWeight: FontWeight.w500),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      displayValue,
                      style: PMT.appStyle(
                        size: 15,
                        fontColor: isHighlight
                            ? ColorConstant.primary
                            : (isEmpty ? Colors.grey.shade400 : Colors.black87),
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
              if (onTap != null)
                Icon(Icons.arrow_forward_ios_rounded,
                    size: 12, color: Colors.grey.shade300),
            ],
          ),
        ),
      ),
    );
  }
}
