import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:splitly/home/widget/widget.dart';

class HomeInitialBody extends StatelessWidget {
  const HomeInitialBody({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Flexible(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(
              spacing: 1.h,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                _TitleWidget('Participantes'),
                _SubtitleWidget('¿Quiénes participaron en la reunión?'),
                _TitleWidget('Gastos'),
                _SubtitleWidget('Agregá los gastos realizados por item.'),
                _TitleWidget('Consumos'),
                _SubtitleWidget(
                  // ignore: lines_longer_than_80_chars
                  'Agregá los consumos realizados por persona.\nSi no se agrega un consumo, se asume que esa persona consumió todo.',
                ),
                _TitleWidget('¿Algún comentario extra?'),
                _SubtitleWidget(
                  // ignore: lines_longer_than_80_chars
                  'Podés agregar alguna condición o comentario extra para tener en cuenta a la hora de repartir los gastos.\nEj.: Nico cubre los gastos de Agus',
                ),
              ],
            ),
          ),
        ),
        CustomButton(
          text: 'Enviar',
          margin: EdgeInsets.all(5.w),
          onPressed: () {},
        ),
      ],
    );
  }
}

class _TitleWidget extends StatelessWidget {
  const _TitleWidget(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 5.w),
      child: Text(
        text,
        style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: const Color.fromARGB(255, 71, 92, 103),
            ),
      ),
    );
  }
}

class _SubtitleWidget extends StatelessWidget {
  const _SubtitleWidget(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 7.5.w),
      child: Text(
        text,
        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: const Color.fromARGB(255, 78, 97, 108),
            ),
      ),
    );
  }
}
