import 'package:cached_network_image/cached_network_image.dart';
import 'package:shimmer/shimmer.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:pg_managment/core/utils/app_fonts.dart';
import 'package:pg_managment/core/utils/color_constant.dart';
import 'package:pg_managment/widgets/custom_elavated_button.dart';
import 'package:pg_managment/core/utils/commonConstant.dart';
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

  void _shareProfile(dynamic data) {
    if (data == null) return;

    final String shareText =
        """
🎓 STUDENT PROFILE
------------------
👤 Name: ${data.name ?? 'N/A'}
🆔 Student ID: ${data.id ?? 'N/A'}
📧 Email: ${data.email ?? 'N/A'}
📱 Mobile: ${data.mobile ?? 'N/A'}
🏥 Blood Group: ${data.bloodGroup ?? 'N/A'}

🏢 RESIDENCY
Hostel: ${data.hostelName ?? 'N/A'}
Room No: ${data.roomNo ?? 'N/A'}

📚 ACADEMICS
Course: ${data.currentlyPursuing ?? 'N/A'}
Year: ${data.currentlyStudyingYear ?? 'N/A'}

📍 ADDRESS
${data.residentialAddress ?? 'N/A'}
------------------
Shared via Self Mess App
""";

    Share.share(shareText, subject: 'Student Profile: ${data.name}');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF1F5F9),
      body: Obx(() {
        if (controller.isLoading.value) {
          return _buildShimmerProfile(context);
        }

        final data = controller.model.value.data;

        if (data == null) {
          return const Center(child: Text("No student data found"));
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
                        child: const Icon(
                          Icons.arrow_back_ios_new_rounded,
                          color: Colors.white,
                          size: 18,
                        ),
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
                          child: const Icon(
                            Icons.share_rounded,
                            color: Colors.white,
                            size: 18,
                          ),
                        ),
                        onPressed: () {
                          _shareProfile(data);
                        },
                      ),
                    ],
                  ),
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Column(
                        children: [
                          _buildPremiumAvatar(
                            imageUrl: data.profileImage,
                            canEdit: false,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            data.name ?? 'No Name',
                            style: PMT.appStyle(
                              size: 24,
                              fontWeight: FontWeight.w800,
                              fontColor: Colors.white,
                            ),
                          ),
                          Text(
                            "Student ID: ${data.id ?? 'N/A'}",
                            style: PMT.appStyle(
                              size: 14,
                              fontWeight: FontWeight.w500,
                              fontColor: Colors.white.withOpacity(0.8),
                            ),
                          ),
                          const SizedBox(height: 30),

                          // Basic Information Card
                          _buildModernCard(
                            context,
                            "Personal Details",
                            Icons.person_rounded,
                            [
                              _buildInteractiveTile(
                                Icons.email_outlined,
                                "Email Address",
                                data.email,
                                onTap: () => _sendEmail(data.email),
                              ),
                              _buildInteractiveTile(
                                Icons.phone_android_rounded,
                                "Mobile Number",
                                data.mobile,
                                onTap: () => _makeCall(data.mobile),
                                onLongPress: () =>
                                    _copyToClipboard("Mobile", data.mobile),
                              ),
                              _buildInteractiveTile(
                                Icons.bloodtype_outlined,
                                "Blood Group",
                                data.bloodGroup,
                                isLast: true,
                              ),
                            ],
                          ),

                          const SizedBox(height: 20),

                          // Residency Information
                          _buildModernCard(
                            context,
                            "Residency",
                            Icons.home_work_rounded,
                            [
                              _buildInteractiveTile(
                                Icons.business_rounded,
                                "Hostel Name",
                                data.hostelName,
                              ),
                              _buildInteractiveTile(
                                Icons.meeting_room_rounded,
                                "Room Number",
                                data.roomNo,
                              ),
                              _buildInteractiveTile(
                                Icons.location_on_outlined,
                                "Full Address",
                                data.residentialAddress,
                                isLast: true,
                              ),
                            ],
                          ),

                          const SizedBox(height: 20),

                          // Academic Information
                          _buildModernCard(
                            context,
                            "Academic Profile",
                            Icons.school_rounded,
                            [
                              _buildInteractiveTile(
                                Icons.book_outlined,
                                "Currently Pursuing",
                                data.currentlyPursuing,
                              ),
                              _buildInteractiveTile(
                                Icons.calendar_today_rounded,
                                "Current Year",
                                data.currentlyStudyingYear?.toString(),
                                isLast: true,
                              ),
                            ],
                          ),

                          const SizedBox(height: 20),
                          _buildModernCard(
                            context,
                            "Financial Summary",
                            Icons.account_balance_wallet_rounded,
                            [
                              _buildInteractiveTile(
                                Icons.currency_rupee_rounded,
                                "Refundable Deposit",
                                "₹${data.deposit}",
                                isLast: true,
                                isHighlight: true,
                              ),
                            ],
                          ),

                          const SizedBox(height: 35),
                          if (Get.arguments == null ||
                              Get.arguments['isViewMode'] != true)
                            AppElevatedButton(
                              buttonName: 'Edit Profile Information',
                              onPressed: () {
                                Get.toNamed(
                                  AppRoutes.addStudentScreenRoute,
                                  arguments: {
                                    "data": data,
                                    "isAddEdit": 1,
                                    "isStudentShow": true,
                                  },
                                )?.then((value) {
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

  void _showStudentEditOptions(BuildContext context, dynamic data) {
    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.all(20),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(30),
            topRight: Radius.circular(30),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            const SizedBox(height: 25),
            Text(
              "Edit Options",
              style: PMT.appStyle(
                size: 18,
                fontWeight: FontWeight.w800,
                fontColor: Colors.black87,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              "Contact admin for any changes",
              style: PMT.appStyle(size: 14, fontColor: Colors.grey[600]),
            ),
            const SizedBox(height: 25),
            ListTile(
              leading: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.orange.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.edit_note_rounded,
                  color: Colors.orange,
                ),
              ),
              title: Text(
                "View/Edit Profile Details",
                style: PMT.appStyle(size: 16, fontWeight: FontWeight.w600),
              ),
              subtitle: Text(
                "Review your account information",
                style: PMT.appStyle(size: 12, fontColor: Colors.grey),
              ),
              trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 14),
              onTap: () {
                Get.back();
                Get.toNamed(
                  AppRoutes.addStudentScreenRoute,
                  arguments: {
                    "data": data,
                    "isAddEdit": 1,
                    "isStudentShow": true,
                  },
                );
              },
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildPremiumAvatar({String? imageUrl, required bool canEdit}) {
    return Center(
      child: Stack(
        children: [
          Container(
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
            child: ClipRRect(
              borderRadius: BorderRadius.circular(60),
              child: (imageUrl != null && imageUrl.isNotEmpty)
                  ? CachedNetworkImage(
                      imageUrl: imageUrl,
                      fit: BoxFit.cover,
                      placeholder: (context, url) => Center(
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: ColorConstant.primary,
                        ),
                      ),
                      errorWidget: (context, url, error) => const Icon(
                        Icons.person,
                        size: 60,
                        color: Colors.white,
                      ),
                    )
                  : const Icon(Icons.person, size: 60, color: Colors.white),
            ),
          ),
          if (canEdit)
            Positioned(
              bottom: 0,
              right: 0,
              child: GestureDetector(
                onTap: () => _showImageSourceBottomSheet(),
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: ColorConstant.primary,
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 2),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.camera_alt_rounded,
                    color: Colors.white,
                    size: 20,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  void _showImageSourceBottomSheet() {
    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.all(20),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(30),
            topRight: Radius.circular(30),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            const SizedBox(height: 25),
            Text(
              "Update Profile Photo",
              style: PMT.appStyle(
                size: 18,
                fontWeight: FontWeight.w800,
                fontColor: Colors.black87,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              "Select a source for your profile picture",
              style: PMT.appStyle(size: 14, fontColor: Colors.grey[600]),
            ),
            const SizedBox(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildSourceOption(
                  icon: Icons.camera_enhance_rounded,
                  label: "Camera",
                  color: Colors.blue,
                  onTap: () {
                    Get.back();
                    controller.pickImage(ImageSource.camera);
                  },
                ),
                _buildSourceOption(
                  icon: Icons.photo_library_rounded,
                  label: "Gallery",
                  color: Colors.purple,
                  onTap: () {
                    Get.back();
                    controller.pickImage(ImageSource.gallery);
                  },
                ),
              ],
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
      isScrollControlled: true,
    );
  }

  Widget _buildSourceOption({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Column(
      children: [
        GestureDetector(
          onTap: onTap,
          child: Container(
            width: 70,
            height: 70,
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: color, size: 30),
          ),
        ),
        const SizedBox(height: 10),
        Text(
          label,
          style: PMT.appStyle(
            size: 14,
            fontWeight: FontWeight.w600,
            fontColor: Colors.black,
          ),
        ),
      ],
    );
  }

  Widget _buildModernCard(
    BuildContext context,
    String title,
    IconData icon,
    List<Widget> children,
  ) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 10),
            child: Row(
              children: [
                Icon(icon, color: ColorConstant.primary, size: 20),
                const SizedBox(width: 10),
                Text(
                  title,
                  style: PMT.appStyle(
                    size: 16,
                    fontWeight: FontWeight.w800,
                    fontColor: Colors.black87,
                  ),
                ),
              ],
            ),
          ),
          const Divider(height: 1),
          Column(children: children),
          const SizedBox(height: 5),
        ],
      ),
    );
  }

  Widget _buildInteractiveTile(
    IconData icon,
    String label,
    String? value, {
    bool isLast = false,
    bool isHighlight = false,
    VoidCallback? onTap,
    VoidCallback? onLongPress,
  }) {
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
                child: Icon(
                  icon,
                  color: isHighlight
                      ? ColorConstant.primary
                      : Colors.grey.shade600,
                  size: 20,
                ),
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
                        fontWeight: FontWeight.w500,
                      ),
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
              if (onTap != null && CommonConstant.instance.isStudent == 1)
                Icon(
                  Icons.arrow_forward_ios_rounded,
                  size: 12,
                  color: Colors.grey.shade300,
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildShimmerProfile(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Stack(
        children: [
          Container(
            height: 300,
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(32),
                bottomRight: Radius.circular(32),
              ),
            ),
          ),
          SafeArea(
            child: SingleChildScrollView(
              physics: const NeverScrollableScrollPhysics(),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: [
                    const SizedBox(height: 50),
                    Center(
                      child: Container(
                        width: 120,
                        height: 120,
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                    const SizedBox(height: 15),
                    Container(
                      width: 200,
                      height: 24,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Container(
                      width: 150,
                      height: 16,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                    const SizedBox(height: 40),
                    _buildShimmerCard(),
                    const SizedBox(height: 20),
                    _buildShimmerCard(),
                    const SizedBox(height: 20),
                    _buildShimmerCard(),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildShimmerCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 150,
            height: 20,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(4),
            ),
          ),
          const SizedBox(height: 20),
          ...List.generate(
            3,
            (index) => Padding(
              padding: const EdgeInsets.only(bottom: 15),
              child: Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 15),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 100,
                        height: 12,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Container(
                        width: 150,
                        height: 16,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
