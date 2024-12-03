import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final List<Widget>? actions;
  final bool showBackButton;
  final Color? backgroundColor;
  final Color? textColor;
  final PreferredSizeWidget? bottom;

  const CustomAppBar({
    required this.title,
    this.actions,
    this.showBackButton = true,
    this.backgroundColor,
    this.textColor,
    this.bottom,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return AppBar(
      backgroundColor: backgroundColor ?? theme.scaffoldBackgroundColor,
      elevation: 0,
      centerTitle: true,
      title: Text(
        title,
        style: TextStyle(
          color: textColor ?? theme.textTheme.titleLarge?.color,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
      leading: showBackButton
          ? IconButton(
              icon: Icon(
                Icons.arrow_back_ios,
                color: textColor ?? theme.primaryColor,
              ),
              onPressed: () => Navigator.pop(context),
            )
          : null,
      actions: actions,
      bottom: bottom,
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(
      kToolbarHeight + (bottom?.preferredSize.height ?? 0.0));
} 