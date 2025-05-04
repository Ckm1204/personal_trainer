// lib/modules/questions/widgets/question_widgets.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class QuestionWidgets {
  static Widget buildMultipleChoice(
    String question,
    List<String> options,
    RxList<String> selectedValues, {
    bool allowMultiple = false,
    Function(String)? onOtherSelected,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(question, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        ...options.map((option) => Obx(() {
          final isSelected = selectedValues.contains(option);
          return CheckboxListTile(
            title: option == 'Otro'
              ? TextField(
                  decoration: const InputDecoration(hintText: 'Especifique'),
                  onChanged: onOtherSelected,
                )
              : Text(option),
            value: isSelected,
            onChanged: (bool? value) {
              if (value == true) {
                if (!allowMultiple) selectedValues.clear();
                selectedValues.add(option);
              } else {
                selectedValues.remove(option);
              }
            },
          );
        })),
        const SizedBox(height: 16),
      ],
    );
  }

  static Widget buildSingleChoice(
    String question,
    List<String> options,
    RxString selectedValue,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(question, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        ...options.map((option) => Obx(() =>
          RadioListTile<String>(
            title: Text(option),
            value: option,
            groupValue: selectedValue.value,
            onChanged: (value) => selectedValue.value = value!,
          ),
        )),
        const SizedBox(height: 16),
      ],
    );
  }
}