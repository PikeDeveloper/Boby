import 'package:flutter/material.dart';
import 'package:boby/ui/screens/match_it/widgets/gradient_button.dart';

class NumberOptionsGrid extends StatelessWidget {
  final List<int> options;
  final void Function(int) onTap;
  final bool Function(int) isWrong;
  final bool Function(int) isCorrect;
  const NumberOptionsGrid(
      {super.key,
      required this.options,
      required this.onTap,
      required this.isWrong,
      required this.isCorrect});

  @override
  Widget build(BuildContext context) {
    const List<String> wordsEn = [
      'One',
      'Two',
      'Three',
      'Four',
      'Five',
      'Six',
      'Seven',
      'Eight',
      'Nine',
      'Ten',
      'Eleven',
      'Twelve',
      'Thirteen',
      'Fourteen',
      'Fifteen',
      'Sixteen',
      'Seventeen',
      'Eighteen',
      'Nineteen',
      'Twenty',
    ];
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 12,
        crossAxisSpacing: 12,
        childAspectRatio: 3.5,
      ),
      itemCount: options.length,
      itemBuilder: (context, index) {
        final n = options[index];
        final label = n >= 1 && n <= 20 ? wordsEn[n - 1] : '$n';
        final wrong = isWrong(n);
        return GradientButton(
          onTap: () => onTap(n),
          isError: wrong,
          isCorrect: isCorrect(n),
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.w800,
              height: 1.0,
              letterSpacing: 0.5,
            ),
          ),
        );
      },
    );
  }
}
