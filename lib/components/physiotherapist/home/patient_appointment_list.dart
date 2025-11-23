import 'dart:io';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:physioapp/services/schedule/schedule_appointment_controller.dart';
import 'package:provider/provider.dart';

class PatientAppointmentList extends StatelessWidget {
  const PatientAppointmentList({super.key});

  @override
  Widget build(BuildContext context) {
    final scheduleProvider =
        Provider.of<ScheduleAppointmentController>(context);
    return ListView.builder(
      shrinkWrap: true,
      itemCount: scheduleProvider.listSchedule.length,
      itemBuilder: (context, index) => scheduleProvider.listSchedule.isNotEmpty
          ? Container(
              width: double.infinity,
              height: 160,
              margin: const EdgeInsets.only(right: 20, left: 20, top: 20),
              padding: const EdgeInsets.only(
                  right: 30, left: 30, top: 20, bottom: 20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(28),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            width: 230,
                            child: Text(
                              scheduleProvider.listSchedule
                                  .elementAt(index)
                                  .patient
                                  .name,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 18,
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 230,
                            child: Text(
                              scheduleProvider.listSchedule
                                  .elementAt(index)
                                  .symptoms,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontWeight: FontWeight.normal,
                                fontSize: 13,
                                color: Theme.of(context)
                                    .textTheme
                                    .labelSmall
                                    ?.color,
                              ),
                            ),
                          ),
                        ],
                      ),
                      CircleAvatar(
                        backgroundColor: Colors.grey,
                        backgroundImage: FileImage(
                          File(
                            scheduleProvider.listSchedule
                                .elementAt(index)
                                .patient
                                .imageProfile
                                .path,
                          ),
                        ),
                        minRadius: 30,
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(
                        width: 160,
                        child: Text(
                          DateFormat.yMd().add_jms().format(
                                scheduleProvider.listSchedule
                                    .elementAt(index)
                                    .dateSchedule,
                              ),
                          overflow: TextOverflow.clip,
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 14,
                            color: Theme.of(context).colorScheme.tertiary,
                          ),
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color.fromARGB(255, 233, 235, 240),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: Text(
                          'Ver prontuário',
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 13,
                            color: Theme.of(context).textTheme.bodyLarge?.color,
                          ),
                        ),
                      )
                    ],
                  )
                ],
              ),
            )
          : const Text('Nenhum paciente cadastrado'),
    );
  }
}
