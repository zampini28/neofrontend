import 'package:flutter/material.dart';
import 'package:physioapp/services/schedule/schedule_appointment_controller.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';

class ConsultationCalendar extends StatefulWidget {
  const ConsultationCalendar({super.key});

  @override
  State<ConsultationCalendar> createState() => _ConsultationCalendarState();
}

class _ConsultationCalendarState extends State<ConsultationCalendar> {
  /// Page controller that holds the three week‑pages.
  late final PageController _pageCtrl;

  /// Index of the page that currently displays the *focused* week.
  /// 0 = previous week, 1 = current week, 2 = next week
  int _currentPage = 1;

  @override
  void initState() {
    super.initState();
    _pageCtrl = PageController(initialPage: _currentPage);
  }

  @override
  void dispose() {
    _pageCtrl.dispose();
    super.dispose();
  }

  /// Returns the first day of the week that should be displayed for a
  /// given page index.
  DateTime _firstDayOfWeek(int pageIndex) {
    final now = DateTime.now();
    // Find the Monday (or whatever start‑day you prefer) of the current week.
    final thisMonday = now.subtract(Duration(days: now.weekday - 1));
    // Shift by -1, 0, +1 weeks depending on the page.
    return thisMonday.add(Duration(days: 7 * (pageIndex - 1)));
  }

  @override
  Widget build(BuildContext context) {
    final scheduleProvider = Provider.of<ScheduleAppointmentController>(context);

    return Container(
      margin: const EdgeInsets.only(left: 20, right: 20, top: 10),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: AlignmentDirectional.topStart,
          end: AlignmentDirectional.bottomStart,
          colors: [
            Color.fromARGB(255, 223, 224, 234),
            Color.fromARGB(255, 233, 235, 240),
          ],
        ),
        borderRadius: BorderRadius.circular(30),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Consultas por dia',
            style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 18,
            ),
          ),
          const SizedBox(height: 15),
          // -----------------------------------------------------------------
          // PageView that holds three TableCalendars (prev, current, next)
          // -----------------------------------------------------------------
          SizedBox(
            height: 350, // enough height for a week view + header
            child: PageView.builder(
              controller: _pageCtrl,
              itemCount: 3,
              onPageChanged: (index) {
                setState(() => _currentPage = index);
                // When the user swipes to another week we also update the
                // controller's focusedDay so the rest of the app stays in sync.
                final newFocused = _firstDayOfWeek(index).add(const Duration(days: 3));
                scheduleProvider.updateFocusedDay(newFocused);
              },
              itemBuilder: (context, index) {
                final firstDay = _firstDayOfWeek(index);
                final lastDay = firstDay.add(const Duration(days: 6));

                return TableCalendar(
                  firstDay: firstDay,
                  lastDay: lastDay,
                  focusedDay: scheduleProvider.focusedDay,
                  selectedDayPredicate: (day) => isSameDay(scheduleProvider.selectedDate, day),
                  onDaySelected: (selected, focused) {
                    scheduleProvider.onDaySelected(selected, focused);
                  },
                  calendarFormat: CalendarFormat.week,
                  headerStyle: const HeaderStyle(
                    formatButtonVisible: false,
                    titleCentered: true,
                    titleTextStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  calendarStyle: CalendarStyle(
                    selectedDecoration: BoxDecoration(
                      color: Theme.of(context).primaryColor,
                      shape: BoxShape.circle,
                    ),
                    todayDecoration: BoxDecoration(
                      color: Theme.of(context).primaryColor.withOpacity(0.5),
                      shape: BoxShape.circle,
                    ),
                  ),
                );
              },
            ),
          ),
          // -----------------------------------------------------------------
          // Optional indicator showing which week is displayed
          // -----------------------------------------------------------------
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(3, (i) {
              return Container(
                width: 8,
                height: 8,
                margin: const EdgeInsets.symmetric(horizontal: 4),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: i == _currentPage ? Theme.of(context).primaryColor : Colors.grey[400],
                ),
              );
            }),
          ),
        ],
      ),
    );
  }
}
