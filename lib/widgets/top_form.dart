import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:instaloader/utils/constants.dart';

class TopForm extends StatelessWidget {
  final TextEditingController controller;
  final VoidCallback onPressed;

  const TopForm({Key? key, required this.controller, required this.onPressed}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          flex: 3,
          child: TextField(
            controller: controller,
            decoration: InputDecoration(
              hintText: "enterURL".tr,
              hintStyle: const TextStyle(color: whiteColor),
              prefixIcon: const Icon(Icons.search, color: whiteColor),
              filled: true,
              fillColor: bgColor,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(5),
                borderSide: const BorderSide(color: whiteColor),
              ),
            ),
            style: const TextStyle(color: whiteColor),
          ),
        ),
        const SizedBox(width: defaultPadding / 2),
        Expanded(
          flex: 1,
          child: ElevatedButton(
            onPressed: onPressed,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: defaultPadding - 2),
              child: Text(
                "getContent".tr,
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
