
import 'package:flutter/material.dart';

class ServiceControlCard extends StatelessWidget {
  final String serviceName;
  final String statusText;
  final Color statusColor;
  final bool value;
  final ValueChanged<bool> onChanged;
  final VoidCallback? onLaunch;
  final String imageAsset;

  const ServiceControlCard({
    super.key,
    required this.serviceName,
    required this.statusText,
    required this.statusColor,
    required this.value,
    required this.onChanged,
    this.onLaunch,
    required this.imageAsset,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return SizedBox(
      width: 160,
      height: 160,
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Image.asset(
                    imageAsset,
                    width: 40,
                    height: 40,
                    fit: BoxFit.contain,
                  ),
                  (onLaunch != null) ? 
                    SizedBox(
                      width: 24,
                      height: 24,
                      child: IconButton(
                        padding: EdgeInsets.zero,
                        iconSize: 18,
                        icon: const Icon(Icons.open_in_new),
                        onPressed: onLaunch,
                        color: theme.textTheme.bodySmall?.color,
                      ),
                    )
                  : SizedBox(
                      width: 24,
                      height: 24,
                      child: IconButton(
                        padding: EdgeInsets.zero,
                        iconSize: 18,
                        icon: const Icon(Icons.open_in_new),
                        onPressed: onLaunch,
                        color: const Color.fromARGB(255, 46, 46, 46),
                      ),
                    ),
                ],
              ),
              const Spacer(),
              Text(
                serviceName,
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 2),
              Row(
                children: [
                  Container(
                    width: 10,
                    height: 8,
                    decoration: BoxDecoration(
                      color: statusColor,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      statusText,
                      style: theme.textTheme.bodySmall,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  SizedBox(
                    height: 24,
                    child: Switch(
                      value: value,
                      onChanged: onChanged,
                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
