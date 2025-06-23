import 'package:cached_network_image/cached_network_image.dart';
import 'package:codebase_project_assignment/core/constants/app_colors.dart';
import 'package:codebase_project_assignment/generated/l10n.dart';
import 'package:codebase_project_assignment/presentation/widgets/common/common_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:shimmer_animation/shimmer_animation.dart';

class UserDetailPage extends StatelessWidget {
  final String avatar;
  final String name;
  final String email;

  const UserDetailPage({
    super.key,
    required this.avatar,
    required this.name,
    required this.email,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar:  CommonAppBar(
      title: S.of(context)?.userDetails??"",
    ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Profile Image
              CircleAvatar(
                radius: 60,
                backgroundColor: Colors.grey.shade200,
                child: ClipOval(
                  child: CachedNetworkImage(
                    imageUrl: avatar,

                    fit: BoxFit.cover,
                    placeholder: (context, url) => Shimmer(
                      color: Colors.grey[400]!,
                      child: Container(
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    errorWidget: (context, url, error) => const Icon(
                      Icons.person,
                      size: 40,
                      color: Colors.grey,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // Name
              Text(
                name,
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),

              // Email
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.email, color: AppColors.textSecondary),
                  const SizedBox(width: 8),
                  Text(
                    email,
                    style: theme.textTheme.bodyMedium,
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
