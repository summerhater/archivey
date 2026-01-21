import 'package:archivey/config/text_theme_extension.dart';
import 'package:flutter/material.dart';
import '../config/color_scheme_extension.dart';

///슬라이드아웃 + 페이드아웃 되지않고 뚝 사라지는 UI 때문에 커스텀 스낵바 제작.

class CustomAppSnackBar extends StatefulWidget {
  final Widget content;
  final Duration duration;
  final VoidCallback onDismissed;

  const CustomAppSnackBar({
    super.key,
    required this.content,
    required this.duration,
    required this.onDismissed,
  });

  @override
  State<CustomAppSnackBar> createState() => _CustomAppSnackBarState();
}

class _CustomAppSnackBarState extends State<CustomAppSnackBar>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<Offset> _slide;
  late final Animation<double> _fade;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
      reverseDuration: const Duration(milliseconds: 1000),
    );

    _slide =
        Tween(
          begin: const Offset(0, 1),
          end: Offset.zero,
        ).animate(
          CurvedAnimation(
            parent: _controller,
            curve: Curves.easeOutCubic,
            reverseCurve: Curves.easeInCubic,
          ),
        );

    _fade = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOut,
      reverseCurve: Curves.easeIn,
    );

    _controller.forward();

    Future.delayed(widget.duration, () async {
      if (!mounted) return;
      await _controller.reverse();
      widget.onDismissed();

      ///애니메이션 끝난 후 제거
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final appColorScheme = Theme.of(context).extension<AppColorScheme>()!;

    return Positioned(
      left: 16,
      right: 16,
      bottom: 30,
      child: FadeTransition(
        opacity: _fade,
        child: SlideTransition(
          position: _slide,
          child: Material(
            color: appColorScheme.snackBarBg,
            borderRadius: BorderRadius.circular(10),
            child: Padding(
              padding: const EdgeInsets.symmetric(
                vertical: 20,
                horizontal: 16,
              ),
              child: widget.content,
            ),
          ),
        ),
      ),
    );
  }
}

// extension AppSnackBar on BuildContext {
//   void showAppSnackBar({
//     required Widget content,
//     Duration duration = const Duration(seconds: 2),
//   }) {
//     final overlay = Overlay.of(this, rootOverlay: true);
//
//     ///상위 위젯 기준이 아닌 기기 기준으로 위치 잡기
//     late final OverlayEntry entry;
//
//     entry = OverlayEntry(
//       builder: (_) => CustomAppSnackBar(
//         content: content,
//         duration: duration,
//         onDismissed: () {
//           entry.remove();
//
//           /// 애니메이션 중 OverlayEntry를 제거해서 생긴 프레임 컷 문제때매 여기서만 제거(버벅임 문제)
//         },
//       ),
//     );
//
//     overlay.insert(entry);
//   }
// }


extension AppSnackBar on BuildContext {
  void showAppSnackBar({
    required Widget content,
    Duration duration = const Duration(seconds: 2),
  }) {
    final overlay = Overlay.of(this, rootOverlay: true);

    late final OverlayEntry entry;

    entry = OverlayEntry(
      builder: (_) => CustomAppSnackBar(
        content: content,
        duration: duration,
        onDismissed: () {
          entry.remove();
        },
      ),
    );

    overlay.insert(entry);
  }

  void showAppMessageSnackBar(
      String message, {
        Duration duration = const Duration(seconds: 2),
        Color? textColor,
      }) {
    final appColorScheme = Theme.of(this).extension<AppColorScheme>()!;
    final appTextTheme = Theme.of(this).extension<AppTextTheme>()!;

    showAppSnackBar(
      duration: duration,
      content: Text(
        message,
        style: appTextTheme.bodySmall.copyWith(
          color: textColor ?? appColorScheme.primary,
        ),
      ),
    );
  }
}