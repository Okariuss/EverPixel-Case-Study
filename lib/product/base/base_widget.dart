import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'base_view_model.dart';

class BaseWidget<T extends ChangeNotifier> extends StatefulWidget {
  final Widget Function(BuildContext context, T viewModel, Widget? child)
      builder;
  final T viewModel;
  final Widget? child;
  final Function(T)? onModelReady;
  final VoidCallback? onDispose;

  BaseWidget({
    Key? key,
    required this.builder,
    required this.viewModel,
    this.child,
    this.onModelReady,
    this.onDispose,
  }) : super(key: key);

  _BaseWidgetState<T> createState() => _BaseWidgetState<T>();
}

class _BaseWidgetState<T extends ChangeNotifier> extends State<BaseWidget<T>> {
  @override
  void initState() {
    super.initState();
    if (widget.onModelReady != null) widget.onModelReady!(widget.viewModel);
  }

  @override
  void dispose() {
    super.dispose();
    if (widget.onDispose != null) widget.onDispose;
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<T>(
      create: (context) => widget.viewModel,
      child: Consumer<T>(
        builder: (context, model, child) {
          return Stack(
            children: [
              widget.builder(context, model, child),
              if (model is BaseViewModel && model.busy)
                Container(
                  color: Colors.black.withOpacity(0.5),
                  child: Center(
                    child: CircularProgressIndicator(),
                  ),
                ),
            ],
          );
        },
        child: widget.child,
      ),
    );
  }
}
