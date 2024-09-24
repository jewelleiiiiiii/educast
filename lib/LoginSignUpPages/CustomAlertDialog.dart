import 'package:flutter/material.dart';

class CustomAlertDialog extends StatelessWidget {
  final Color colorMessage;
  final String title;
  final double height;
  final double widght;
  final bool actionCloseVisibility;
  final bool actionOkayVisibility;
  final String actionLabel;
  final Function()? onPressedCloseBtn;
  final Function()? onPressOkay;
  final Widget child;

  const CustomAlertDialog({
    super.key,
    required this.colorMessage,
    required this.title,
    this.height = 58,
    this.widght = 300,
    this.actionCloseVisibility = true,
    this.actionOkayVisibility = false,
    this.actionLabel = "Reset",
    this.onPressOkay,
    this.onPressedCloseBtn,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      alignment: Alignment.centerLeft,
      title: Row(
        children: [
          Icon(
            Icons.warning_rounded,
            color: colorMessage,
          ),
          const SizedBox(
            width: 8.0,
          ),
          Text(title)
        ],
      ),
      titleTextStyle: TextStyle(fontSize: 18.0, color: colorMessage),
      titlePadding: const EdgeInsets.all(18.0),
      content: Container(
        // color: Colors.red,
        // width: width * 0.3,
        height: height,
        width: widght,
        alignment: Alignment.centerLeft,
        child: child,
      ),
      contentPadding:
          const EdgeInsets.symmetric(horizontal: 18.0, vertical: 18.0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18.0)),
      actionsPadding: const EdgeInsets.all(18.0),
      actions: [
        Row(
          mainAxisAlignment: actionCloseVisibility && actionOkayVisibility
              ? MainAxisAlignment.spaceBetween
              : MainAxisAlignment.end,
          children: [
            Visibility(
              // visible: true,
              visible: actionCloseVisibility,
              child: Container(
                  decoration:
                      BoxDecoration(borderRadius: BorderRadius.circular(12.0)),
                  child: ElevatedButton(
                      style: ButtonStyle(
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.circular(12.0)))),
                      onPressed: onPressedCloseBtn,
                      child: const Text("Close"))),
            ),
            Visibility(
              visible: actionOkayVisibility,
              child: Container(
                  decoration:
                      BoxDecoration(borderRadius: BorderRadius.circular(12.0)),
                  child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color.fromARGB(255, 159, 41, 33),
                        // primary: Colors.redAccent,
                        // onPrimary: Colors.black54,
                        shadowColor: Colors.redAccent,
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(10),
                          ),
                        ),
                      ),
                      onPressed: onPressOkay,
                      child: Text(
                        actionLabel,
                        style: TextStyle(color: Colors.white70),
                      ))),
            ),
          ],
        )
      ],
    );
  }
}
