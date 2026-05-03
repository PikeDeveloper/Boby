import 'package:flutter/material.dart';
import 'package:boby/services/storage_service.dart';

class MathSettings extends StatelessWidget {
  const MathSettings({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: StorageService.instance.listenable(keys: [
        StorageService.mathOpAddKey,
        StorageService.mathOpSubKey,
        StorageService.mathOpMulKey,
        StorageService.mathOpDivKey,
      ]),
      builder: (context, box, _) {
        return Row(
          children: [
            _opItem(
              context,
              label: '+',
              value: StorageService.instance.getMathOpAdd(),
              onChanged: (v) =>
                  StorageService.instance.setMathOpAdd(v ?? false),
            ),
            _opItem(
              context,
              label: '-',
              value: StorageService.instance.getMathOpSub(),
              onChanged: (v) =>
                  StorageService.instance.setMathOpSub(v ?? false),
            ),
            _opItem(
              context,
              label: 'X',
              value: StorageService.instance.getMathOpMul(),
              onChanged: (v) =>
                  StorageService.instance.setMathOpMul(v ?? false),
            ),
            _opItem(
              context,
              label: '/',
              value: StorageService.instance.getMathOpDiv(),
              onChanged: (v) =>
                  StorageService.instance.setMathOpDiv(v ?? false),
            ),
          ],
        );
      },
    );
  }

  Widget _opItem(BuildContext context,
      {required String label,
      required bool value,
      required ValueChanged<bool?> onChanged}) {
    return Container(
      padding: EdgeInsets.zero,
      margin: const EdgeInsets.all(5),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25),
        border: Border.all(color: Colors.indigo),
        color: const Color.fromARGB(207, 255, 255, 255).withOpacity(0.5),
      ),
      width: 80,
      child: CheckboxListTile(
        title: Text(
          label,
          style: const TextStyle(
              fontSize: 20, fontWeight: FontWeight.bold, color: Colors.indigo),
        ),
        value: value,
        onChanged: onChanged,
        controlAffinity: ListTileControlAffinity.leading,
        contentPadding: EdgeInsets.zero,
      ),
    );
  }
}
