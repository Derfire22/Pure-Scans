import 'package:custom_refresh_indicator/custom_refresh_indicator.dart';
import 'package:flutter/material.dart';

class NextChapiterIndicator extends StatelessWidget {
  final Widget child;
  final VoidCallback onAction;

  const NextChapiterIndicator({
    Key? key,
    required this.child,
    required this.onAction,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const height = 100.0;
    return CustomRefreshIndicator(
      onRefresh: () async => onAction(),
      trigger: IndicatorTrigger.trailingEdge,
      trailingScrollIndicatorVisible: false,
      leadingScrollIndicatorVisible: true,
      child: child,
      builder: (
        BuildContext context,
        Widget child,
        IndicatorController controller,
      ) {
        return AnimatedBuilder(
            animation: controller,
            builder: (context, _) {
              final dy = controller.value.clamp(0.0, 1.25) *
                  -(height - (height * 0.25));
              return Stack(
                children: [
                  Transform.translate(
                    offset: Offset(0.0, dy),
                    child: child,
                  ),
                  Positioned(
                    bottom: -height,
                    left: 0,
                    right: 0,
                    height: height,
                    child: Container(
                      transform: Matrix4.translationValues(0.0, dy, 0.0),
                      padding: const EdgeInsets.only(top: 20.0),
                      constraints: const BoxConstraints.expand(),
                      child: Column(
                        children: [
                          if (controller.isLoading)
                            Container(
                              margin: const EdgeInsets.only(bottom: 8.0),
                              width: 16,
                              height: 16,
                              child: const CircularProgressIndicator(),
                            )
                          else
                            const Icon(
                              Icons.keyboard_arrow_up,
                            ),
                          Text(
                            controller.isLoading
                                ? "Chargement..."
                                : "Relachez pour passer au chapitre suivant",
                            style: Theme.of(context).textTheme.bodyMedium,
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              );
            });
      },
    );
  }
}
