import 'package:flutter/material.dart';
import 'package:circular_countdown_timer/circular_countdown_timer.dart';
import 'package:TrainUp/themes/colors.dart' as color;

class CircularCountdownTimerWidget extends StatefulWidget {
  final int duration;
  final TextStyle textStyle;
  final Function() onTimerComplete;
  final Function() updateDuration; // Add this property

  const CircularCountdownTimerWidget({
    Key? key,
    required this.duration,
    required this.textStyle,
    required this.onTimerComplete,
    required this.updateDuration, // Add this property
  }) : super(key: key);

  @override
  _CircularCountdownTimerWidgetState createState() =>
      _CircularCountdownTimerWidgetState();
}

class _CircularCountdownTimerWidgetState
    extends State<CircularCountdownTimerWidget> {
  late CountDownController _controller;

  @override
  void initState() {
    super.initState();
    _controller = CountDownController();
  }

  @override
  Widget build(BuildContext context) {
    // print('called');
    // print(widget.duration);

    return CircularCountDownTimer(
      duration: widget.duration,
      initialDuration: 0,
      controller: _controller,
      width: MediaQuery.of(context).size.width / 3,
      height: MediaQuery.of(context).size.width / 3,
      ringColor: color.AppColor.gradientSecond.withOpacity(0.2),
      fillColor: color.AppColor.gradientFirst.withOpacity(0.8),
      strokeWidth: 10.0,
      textStyle: widget.textStyle,
      isReverse: true,
      isReverseAnimation: true,
      onComplete: () {
        widget.onTimerComplete(); // Call the onTimerComplete callback
        final newDuration = widget.updateDuration();
        print('Timer completed. Restarting with duration: $newDuration');
        _controller.restart(duration: newDuration);
      },
    );
  }
}