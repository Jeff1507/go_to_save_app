import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

enum LogoSize { sm, md, lg }

class Logo extends StatelessWidget {
  final LogoSize size;
  final Color? color;

  const Logo({super.key, this.size = LogoSize.md, this.color});

  double _getLogoSize() {
    switch (size) {
      case LogoSize.sm:
        return 16;
      case LogoSize.md:
        return 24;
      case LogoSize.lg:
        return 36;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Text(
      'Go To Save',
      style: GoogleFonts.cherryBombOne(
        fontSize: _getLogoSize(),
        color: color ?? Theme.of(context).colorScheme.primary,
      ),
    );
  }
}
