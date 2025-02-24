import 'package:flutter/material.dart';
import 'package:todo_list_app/core/theme/app_palette.dart';

class MyButton extends StatelessWidget {
  final String text;
  final void Function()? onPressed;

  const MyButton({super.key, required this.text, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppPalette.primaryColor,
            foregroundColor: Colors.white,
          ),
          onPressed: onPressed,
          child: Text(text),
        )
      ],
    );
  }
}
