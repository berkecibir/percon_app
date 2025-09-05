import 'package:flutter/material.dart';
import 'package:percon_app/core/widgets/device_padding/device_padding.dart';
import 'package:percon_app/core/widgets/device_spacing/device_spacing.dart';

class UserInfoCard extends StatelessWidget {
  final String title;
  final String content;
  final IconData icon;
  const UserInfoCard({
    super.key,
    required this.title,
    required this.content,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: DevicePadding.medium.all,
        child: Row(
          children: [
            Icon(icon, color: Theme.of(context).primaryColor),
            DeviceSpacing.small.width,
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: Theme.of(
                      context,
                    ).textTheme.titleSmall?.copyWith(color: Colors.grey[600]),
                  ),
                  DeviceSpacing.xsmall.height,
                  Text(content, style: Theme.of(context).textTheme.bodyLarge),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
