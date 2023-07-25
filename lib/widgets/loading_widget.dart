// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:reshop/consts/constants.dart';

class LoadingWidget extends StatelessWidget {
  final bool isLoading;
  final Widget child;
  const LoadingWidget({
    Key? key,
    required this.isLoading,
    required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: Stack(
        children: [
          child,
          isLoading
              ? Container(
                  color: Colors.black.withOpacity(0.7),
                )
              : Container(),
          isLoading
              ? Center(child: SpinKitFadingCube(color: myPrimaryColor))
              : Container()
        ],
      ),
    );
  }
}
