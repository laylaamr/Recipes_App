import 'package:flutter/material.dart';

class CostumAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CostumAppBar({super.key, required this.title});
  final String title;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      centerTitle: true,
      title: Text(
        title,
        style: const TextStyle(fontSize: 30, color: Color(0xff4A7C74)),
      ),
      leading: const Icon(
        Icons.filter_list,
        size: 25,
        color: Color(0xff4A7C74),
      ),
      actions: const [
        Icon(
          Icons.search,
          size: 25,
          color: Color(0xff4A7C74),
        ),
        SizedBox(
          width: 10,
        )
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

