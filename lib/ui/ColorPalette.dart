import 'package:flutter/material.dart';
import 'package:keep_notes/colors.dart';

class ColorPalette extends StatelessWidget {
  final parentContext;

  const ColorPalette({
    required this.parentContext,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: bgColor,
      clipBehavior: Clip.hardEdge,
      insetPadding: EdgeInsets.all(MediaQuery.of(context).size.width * 0.03),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(2),
      ),
      child: Container(
        padding: EdgeInsets.all(8),
        child: Wrap(
          alignment: WrapAlignment.start,
          spacing: MediaQuery.of(context).size.width * 0.02,
          runSpacing: MediaQuery.of(context).size.width * 0.02,
          children: NoteColors.entries.map((entry) {
            return GestureDetector(
              onTap: () => Navigator.of(context).pop(entry.key),
              child: Container(
                width: MediaQuery.of(context).size.width * 0.12,
                height: MediaQuery.of(context).size.width * 0.12,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(MediaQuery.of(context).size.width * 0.06),
                  color: Color(entry.value['b']!),
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}