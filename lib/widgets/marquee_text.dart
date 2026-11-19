import 'dart:async';
import 'dart:ui' as ui;

import 'package:flutter/widgets.dart';

class MarqueeText extends StatefulWidget {
  const MarqueeText(
    this.text, {
    super.key,
    this.style,
    this.scrollWhen = false,
    this.hoverToScroll = false,
    this.textAlign = TextAlign.start,
  });

  final String text;
  final TextStyle? style;
  final bool scrollWhen;
  final bool hoverToScroll;
  final TextAlign textAlign;

  @override
  State<MarqueeText> createState() => _MarqueeTextState();
}

class _MarqueeTextState extends State<MarqueeText>
    with TickerProviderStateMixin {
  static const _pause = Duration(milliseconds: 1500);

  AnimationController? _controller;
  Animation<double>? _position;
  Timer? _startTimer;
  Duration? _movementDuration;
  var _hovered = false;

  @override
  void didUpdateWidget(covariant MarqueeText oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.text != widget.text || oldWidget.style != widget.style) {
      _controller?.dispose();
      _startTimer?.cancel();
      _startTimer = null;
      _controller = null;
      _movementDuration = null;
    }
  }

  @override
  void dispose() {
    _controller?.dispose();
    _startTimer?.cancel();
    super.dispose();
  }

  void _queueControllerSync(double overflow) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      final shouldRun =
          overflow > 0 &&
          widget.scrollWhen &&
          (!widget.hoverToScroll || _hovered) &&
          !MediaQuery.disableAnimationsOf(context) &&
          TickerMode.valuesOf(context).enabled;
      if (!shouldRun) {
        if (_controller != null) {
          _startTimer?.cancel();
          _startTimer = null;
          _controller!.dispose();
          _controller = null;
          _position = null;
          setState(() {});
        }
        return;
      }
      final moveDuration = Duration(
        milliseconds: (overflow / 30 * 1000).ceil().clamp(1, 60000),
      );
      if (_controller == null || _movementDuration != moveDuration) {
        _controller?.dispose();
        _movementDuration = moveDuration;
        const jump = Duration(milliseconds: 1);
        final cycle = moveDuration + _pause * 2 + jump;
        _controller = AnimationController(vsync: this, duration: cycle);
        _position = TweenSequence<double>([
          TweenSequenceItem(
            tween: Tween(begin: 0, end: 1),
            weight: moveDuration.inMilliseconds.toDouble(),
          ),
          TweenSequenceItem(
            tween: ConstantTween(1),
            weight: _pause.inMilliseconds.toDouble(),
          ),
          TweenSequenceItem(
            tween: Tween(begin: 1, end: 0),
            weight: jump.inMilliseconds.toDouble(),
          ),
          TweenSequenceItem(
            tween: ConstantTween(0),
            weight: _pause.inMilliseconds.toDouble(),
          ),
        ]).animate(_controller!);
        setState(() {});
        final controller = _controller!;
        _startTimer = Timer(_pause, () {
          if (mounted && identical(controller, _controller)) {
            controller.repeat();
          }
          _startTimer = null;
        });
      } else if (!_controller!.isAnimating) {
        _controller!.repeat();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final direction = Directionality.of(context);
    final scaler = MediaQuery.textScalerOf(context);
    return LayoutBuilder(
      builder: (context, constraints) {
        final finite = constraints.maxWidth.isFinite;
        final width = constraints.maxWidth;
        final painter = TextPainter(
          text: TextSpan(text: widget.text, style: widget.style),
          textDirection: direction,
          textScaler: scaler,
          maxLines: 1,
        )..layout();
        final textWidth = painter.width;
        painter.dispose();
        final overflow = finite
            ? (textWidth - width).clamp(0, double.infinity).toDouble()
            : 0.0;
        _queueControllerSync(overflow);

        Widget child;
        if (overflow == 0) {
          child = Text(
            widget.text,
            maxLines: 1,
            softWrap: false,
            style: widget.style,
            textAlign: widget.textAlign,
            overflow: TextOverflow.clip,
          );
        } else if (!widget.scrollWhen || (widget.hoverToScroll && !_hovered)) {
          child = ShaderMask(
            blendMode: ui.BlendMode.dstIn,
            shaderCallback: (bounds) {
              final fadeStart = (bounds.width - 20).clamp(0, bounds.width);
              final stop = bounds.width == 0 ? 0.0 : fadeStart / bounds.width;
              return LinearGradient(
                begin: direction == TextDirection.ltr
                    ? Alignment.centerLeft
                    : Alignment.centerRight,
                end: direction == TextDirection.ltr
                    ? Alignment.centerRight
                    : Alignment.centerLeft,
                colors: const [
                  Color(0xff000000),
                  Color(0xff000000),
                  Color(0x00000000),
                ],
                stops: [0, stop, 1],
              ).createShader(bounds);
            },
            child: Text(
              widget.text,
              maxLines: 1,
              softWrap: false,
              style: widget.style,
              textAlign: widget.textAlign,
              overflow: TextOverflow.clip,
            ),
          );
        } else {
          child = RepaintBoundary(
            child: ClipRect(
              child: ShaderMask(
                blendMode: ui.BlendMode.dstIn,
                shaderCallback: (bounds) => const LinearGradient(
                  colors: [
                    Color(0x00000000),
                    Color(0xff000000),
                    Color(0xff000000),
                    Color(0x00000000),
                  ],
                  stops: [0, 0.08, 0.92, 1],
                ).createShader(bounds),
                child: AnimatedBuilder(
                  animation: _controller ?? kAlwaysDismissedAnimation,
                  builder: (context, text) => Transform.translate(
                    offset: Offset(-overflow * (_position?.value ?? 0), 0),
                    child: text,
                  ),
                  child: SizedBox(
                    width: textWidth,
                    child: Text(
                      widget.text,
                      maxLines: 1,
                      softWrap: false,
                      style: widget.style,
                    ),
                  ),
                ),
              ),
            ),
          );
        }
        if (widget.hoverToScroll && overflow > 0) {
          child = MouseRegion(
            onEnter: (_) {
              _hovered = true;
              setState(() {});
              _queueControllerSync(overflow);
            },
            onExit: (_) {
              _hovered = false;
              _startTimer?.cancel();
              _startTimer = null;
              _controller?.dispose();
              _controller = null;
              _position = null;
              setState(() {});
            },
            child: child,
          );
        }
        return child;
      },
    );
  }
}
