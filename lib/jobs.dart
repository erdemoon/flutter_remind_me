import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:ui' as ui;

class GradientIcon extends StatelessWidget {
  GradientIcon(
      this.icon,
      this.size,
      this.gradient,
      );

  final IconData icon;
  final double size;
  final Gradient gradient;

  @override
  Widget build(BuildContext context) {
    return ShaderMask(
      child: SizedBox(
        width: size * 1.2,
        height: size * 1.2,
        child: Icon(
          icon,
          size: size,
          color: Colors.white,
        ),
      ),
      shaderCallback: (Rect bounds) {
        final Rect rect = Rect.fromLTRB(0, 0, size, size);
        return gradient.createShader(rect);
      },
    );
  }
}

class MenuText extends StatelessWidget{
  MenuText(
      this.icon,
      this.text
  );

  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    return RichText(
        textAlign: TextAlign.start,
        text: TextSpan(
            children: [
              WidgetSpan(alignment: ui.PlaceholderAlignment.middle,
                child: GradientIcon(
                  icon,
                  40.0,
                  LinearGradient(
                    colors: <Color>[
                      Theme.of(context).colorScheme.secondary,
                      Theme.of(context).colorScheme.primary,
                    ],
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                  ),
                ),
              )
              ,TextSpan(
                  text:text,
                  style: GoogleFonts.montserrat(textStyle:
                  TextStyle(
                      fontWeight:FontWeight.w500 ,
                      fontSize:17.5,
                      color: Theme.of(context).colorScheme.surface) )
              )
            ]
        )
    );
  }
}
