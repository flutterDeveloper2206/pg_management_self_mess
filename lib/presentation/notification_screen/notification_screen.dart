import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pg_managment/core/utils/app_fonts.dart';
import 'package:pg_managment/core/utils/color_constant.dart';
import 'package:pg_managment/widgets/custom_image_view.dart';
import 'package:intl/intl.dart';
import 'controller/notification_screen_controller.dart';

class NotificationScreen extends GetWidget<NotificationScreenController> {
  const NotificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        backgroundColor: ColorConstant.primary,
        centerTitle: true,
        elevation: 2,
        leading: IconButton(
          icon: CustomImageView(
            height: 24,
            width: 24,
            imagePath: 'assets/images/left-arrow.png',
            color: Colors.white,
          ),
          onPressed: () => Get.back(),
        ),
        title: Text(
          "Notifications",
          style: PMT.appStyle(
            size: 20,
            fontWeight: FontWeight.w600,
            fontColor: Colors.white,
          ),
        ),
        actions: [
          Obx(() => controller.notifications.isNotEmpty
              ? IconButton(
                  icon: const Icon(Icons.delete_sweep_outlined,
                      color: Colors.white),
                  onPressed: () => _showClearAllDialog(context),
                  tooltip: "Clear All",
                )
              : const SizedBox()),
        ],
      ),
      body: Obx(() {
        if (controller.isLoading.value && controller.notifications.isEmpty) {
          return Center(
            child: CircularProgressIndicator(color: ColorConstant.primary),
          );
        }

        if (controller.notifications.isEmpty) {
          return RefreshIndicator(
            onRefresh: () => controller.getNotifications(),
            color: ColorConstant.primary,
            child: ListView(
              children: [
                SizedBox(height: MediaQuery.of(context).size.height * 0.2),
                Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(30),
                        decoration: BoxDecoration(
                          color: ColorConstant.primary.withOpacity(0.1),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.notifications_none_rounded,
                          size: 80,
                          color: ColorConstant.primary,
                        ),
                      ),
                      const SizedBox(height: 24),
                      Text(
                        "All Caught Up!",
                        style: PMT.appStyle(
                          size: 20,
                          fontWeight: FontWeight.bold,
                          fontColor: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        "You don't have any notifications right now.",
                        style: PMT.appStyle(size: 14, fontColor: Colors.grey),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        }

        return RefreshIndicator(
          onRefresh: () => controller.getNotifications(),
          color: ColorConstant.primary,
          child: ListView.separated(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
            itemCount: controller.notifications.length,
            separatorBuilder: (context, index) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              final notification = controller.notifications[index];
              return Dismissible(
                key: Key(notification.id.toString()),
                direction: DismissDirection.endToStart,
                onDismissed: (direction) {
                  controller.deleteNotification(notification.id!);
                },
                background: Container(
                  alignment: Alignment.centerRight,
                  padding: const EdgeInsets.only(right: 20),
                  decoration: BoxDecoration(
                    color: Colors.red.shade400,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: const Icon(Icons.delete_outline, color: Colors.white),
                ),
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.06),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                    border: notification.isRead == false
                        ? Border.all(color: ColorConstant.primary, width: 1.5)
                        : null,
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                          color: _getColorForType(notification.type)
                              .withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Center(
                          child: Icon(
                            _getIconForType(notification.type),
                            color: _getColorForType(notification.type),
                            size: 26,
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Text(
                                    notification.title ?? "Update",
                                    style: PMT.appStyle(
                                      size: 17,
                                      fontWeight: FontWeight.bold,
                                      fontColor: Colors.black87,
                                    ),
                                  ),
                                ),
                                if (notification.isRead == false)
                                  Container(
                                    width: 8,
                                    height: 8,
                                    decoration: BoxDecoration(
                                      color: ColorConstant.primary,
                                      shape: BoxShape.circle,
                                    ),
                                  ),
                              ],
                            ),
                            const SizedBox(height: 6),
                            ExpandableText(
                              text: notification.body ?? "",
                              style: PMT.appStyle(
                                size: 14,
                                fontColor: Colors.black54,
                              ),
                            ),
                            const SizedBox(height: 12),
                            Row(
                              children: [
                                const Icon(Icons.access_time,
                                    size: 14, color: Colors.grey),
                                const SizedBox(width: 4),
                                Text(
                                  _formatDateTime(notification.createdAt),
                                  style: PMT.appStyle(
                                      size: 12, fontColor: Colors.grey),
                                ),
                              ],
                            ),
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
      }),
    );
  }

  void _showClearAllDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          "Clear All",
          style: PMT.appStyle(size: 18, fontWeight: FontWeight.bold),
        ),
        content: Text(
          "Are you sure you want to delete all notifications?",
          style: PMT.appStyle(size: 15, fontColor: Colors.black87),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text(
              "Cancel",
              style: PMT.appStyle(size: 14, fontColor: Colors.grey),
            ),
          ),
          TextButton(
            onPressed: () {
              Get.back();
              controller.clearAllNotifications();
            },
            child: Text(
              "Clear",
              style: PMT.appStyle(
                size: 14,
                fontWeight: FontWeight.bold,
                fontColor: Colors.red,
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _formatDateTime(DateTime? dateTime) {
    if (dateTime == null) return "";
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inMinutes < 60) {
      return '${difference.inMinutes} mins ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours} hours ago';
    } else if (difference.inDays < 7) {
      return '${difference.inDays} days ago';
    } else {
      return DateFormat('dd MMM, yyyy').format(dateTime);
    }
  }

  Color _getColorForType(String? type) {
    switch (type) {
      case 'announcement':
        return Colors.blue;
      case 'event':
        return Colors.orange;
      case 'alert':
        return Colors.red;
      default:
        return ColorConstant.primary;
    }
  }

  IconData _getIconForType(String? type) {
    switch (type) {
      case 'announcement':
        return Icons.campaign_rounded;
      case 'event':
        return Icons.event_available_rounded;
      case 'alert':
        return Icons.warning_amber_rounded;
      default:
        return Icons.notifications_active_rounded;
    }
  }
}

class ExpandableText extends StatefulWidget {
  final String text;
  final TextStyle style;
  final int maxLines;

  const ExpandableText({
    super.key,
    required this.text,
    required this.style,
    this.maxLines = 3,
  });

  @override
  State<ExpandableText> createState() => _ExpandableTextState();
}

class _ExpandableTextState extends State<ExpandableText> {
  bool isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final textSpan = TextSpan(text: widget.text, style: widget.style);
        final textPainter = TextPainter(
          text: textSpan,
          textDirection: Directionality.of(context),
          maxLines: widget.maxLines,
        );
        textPainter.layout(maxWidth: constraints.maxWidth);

        if (textPainter.didExceedMaxLines) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.text,
                style: widget.style,
                maxLines: isExpanded ? null : widget.maxLines,
                overflow:
                    isExpanded ? TextOverflow.visible : TextOverflow.ellipsis,
              ),
              GestureDetector(
                onTap: () => setState(() => isExpanded = !isExpanded),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Text(
                    isExpanded ? "Show less" : "Show more",
                    style: PMT.appStyle(
                      size: 13,
                      fontWeight: FontWeight.bold,
                      fontColor: ColorConstant.primary,
                    ),
                  ),
                ),
              ),
            ],
          );
        } else {
          return Text(widget.text, style: widget.style);
        }
      },
    );
  }
}
