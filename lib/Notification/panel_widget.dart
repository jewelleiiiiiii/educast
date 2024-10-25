// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:educast/common/grade_level.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:logger/logger.dart';

class PanelContainerWidget extends StatelessWidget {
  final Map<String, dynamic> data;
  const PanelContainerWidget({required this.data, super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18.0, vertical: 4),
      child: Container(
        padding: const EdgeInsets.all(12.0),
        // margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12.0),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 6.0,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const Icon(
              Icons.notifications,
              size: 32,
            ),
            const SizedBox(
              width: 8,
            ),
            TitleContentWidgetPanelContainer(data["name"], data)

            // notification == "message"
            //     ? Container()
            //     : notification == "approval"
            //         ? TitleContentWidgetPanelContainer(
            //             "Approval",
            //             data,
            //           )
            //         : notification == "merchant"
            //             ? Container()
            //             : Container(),
          ],
        ),
      ),
    );
  }
}

class TitleContentWidgetPanelContainer extends StatelessWidget {
  final String deviceName;
  final Map<String, dynamic> data;

  const TitleContentWidgetPanelContainer(this.deviceName, this.data,
      {super.key});

  @override
  Widget build(BuildContext context) {
    final Logger logger = Logger();

    logger.d(data["lastLogin"].runtimeType);

    var date = data["lastLogin"].toDate();
    String formattedDate = DateFormat('MMMM d, y h:mm a').format(date);
    Widget _buildInfoRow(String label, String? value) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(width: 10),
          Text(value ?? 'N/A'), // Handle null values gracefully
        ],
      );
    }

    return Expanded(
      child: GestureDetector(
        onTap: () {
          logger.d(GradeLevel.gradeLevel);

          showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: const Text("Device Informations"),
                content: SizedBox(
                  height: MediaQuery.of(context).size.height * 0.1,
                  child: Column(
                    children: [
                      _buildInfoRow("ID:", data['deviceName']),
                      _buildInfoRow("Device Name:", data['name']),
                      _buildInfoRow("Model:", data['model']),
                      _buildInfoRow("Device Brand:", data['brand']),
                    ],
                  ),
                ),
                actionsPadding: EdgeInsets.only(bottom: 8, right: 8),
                actions: [
                  TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Text("Close"))
                ],
              );
            },
          );
        },
        child: SizedBox(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(deviceName,
                      style: const TextStyle(
                          fontSize: 16, fontWeight: FontWeight.bold)),
                  Text(formattedDate.toString(),
                      style: const TextStyle(fontSize: 10))
                ],
              ),
              // Text(
            ],
          ),
        ),
      ),
    );
  }
}
