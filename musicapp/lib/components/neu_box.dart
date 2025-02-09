import 'package:flutter/material.dart';
import 'package:musicapp/themes/theme_provider.dart';
import 'package:provider/provider.dart';

class NeuBox extends StatelessWidget {
  final Widget? child;
  const NeuBox({
    super.key,
    required this.child,
  });
  @override
  Widget build(BuildContext context) {
    // bool isDarkMode = Provider.of<ThemeProvider>(context).isDarkMode;
    // TODO: implement build
    return Container(
      decoration: BoxDecoration(
          color: Colors.black,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            // BoxShadow(
            //   color: isDarkMode ? Colors.black :  Colors.grey.shade500,
            //   blurRadius: 15,
            //   offset: const Offset(4, 4),
            // ),

            //  BoxShadow(
            //   color:isDarkMode ? Colors.grey.shade800 : Colors.white,
            //   blurRadius: 15,
            //   offset: const Offset(4, 4),
            // )
            BoxShadow(
              color: Colors.grey.shade800,
              blurRadius: 10,
              offset: const Offset(5, 5),
            ),
            const BoxShadow(
              color: Colors.black54,
              blurRadius: 10,
              offset: Offset(-5, -5),
            ),
          ]),
      padding: EdgeInsets.all(17),
      child: child,
    );
  }
}
