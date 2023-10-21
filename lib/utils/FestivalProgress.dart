import 'package:flutter/material.dart';

import 'AppImages.dart';

class FestivalProgress extends StatefulWidget {
  static String tag = '/FestivalProgress';

  @override
  FestivalProgressState createState() => FestivalProgressState();
}

class FestivalProgressState extends State<FestivalProgress> with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    duration: const Duration(seconds: 2),
    vsync: this,
  )..repeat(reverse: true);

  late final Animation<double> _animation = CurvedAnimation(
    parent: _controller,
    curve: Curves.bounceInOut,
  );

  @override
  void initState() {
    super.initState();
    init();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  init() async {
    //
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      child: RotationTransition(
        turns: _animation,
        child: Container(
          width: 65,
          height: 65,
          padding: EdgeInsets.all(8),
          child: Image.asset(ic_christmas_categories),
        ),
      ),
    );
  }
}
