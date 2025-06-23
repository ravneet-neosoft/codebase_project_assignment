import 'package:cached_network_image/cached_network_image.dart';
import 'package:codebase_project_assignment/core/constants/app_colors.dart';
import 'package:codebase_project_assignment/data/models/user_detail_arguments.dart';
import 'package:codebase_project_assignment/domain/entities/user_entity.dart';
import 'package:codebase_project_assignment/main/navigation/route_paths.dart';
import 'package:flutter/material.dart';
import 'package:shimmer_animation/shimmer_animation.dart';

class UserCard extends StatelessWidget {
  final UserEntity user;

  const UserCard({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final size = MediaQuery.of(context).size;

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: ListTile(
        contentPadding:
        EdgeInsets.symmetric(horizontal: size.width * 0.04, vertical: 10),
        leading: CircleAvatar(
          radius: 28,
          backgroundColor: Colors.grey.shade200,
          child: ClipOval(
            child: CachedNetworkImage(
              imageUrl: user.avatar,
              width: 56,
              height: 56,
              fit: BoxFit.cover,
              placeholder: (context, url) => Shimmer(
                color: Colors.grey[300]!,
                child: Container(
                  width: 56,
                  height: 56,
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
        title: Text(
          user.fullName,
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),
        subtitle: Text(user.email, style: theme.textTheme.bodySmall),
        trailing: const Icon(Icons.chevron_right, color: AppColors.textSecondary),
        onTap: () {
          Navigator.pushNamed(
            context,
            RoutePaths.userDetail,
            arguments: UserDetailArguments(
              avatar: user.avatar,
              name: user.fullName,
              email: user.email,
            ),
          );
        },
      ),
    );
  }
}
