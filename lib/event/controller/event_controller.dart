import 'package:get/get.dart';
import 'package:add_2_calendar/add_2_calendar.dart';
import 'package:flutter/material.dart';

class EventController extends GetxController {
  // Reactive variables for event details
  var eventTitle = ''.obs;
  var eventDescription = ''.obs;
  var eventDate = DateTime.now().obs;
  var eventTime = TimeOfDay.now().obs;
  var recurrence = 'None'.obs; // Options: None, Daily, Weekly, Monthly

  // Update event details
  void updateEventTitle(String title) {
    eventTitle.value = title;
  }

  void updateEventDescription(String description) {
    eventDescription.value = description;
  }

  void updateEventDate(DateTime date) {
    eventDate.value = date;
  }

  void updateEventTime(TimeOfDay time) {
    eventTime.value = time;
  }

  void updateRecurrence(String newRecurrence) {
    recurrence.value = newRecurrence;
  }

  // Save event to calendar
  void saveEventToCalendar() {
    if (eventTitle.value.isEmpty) {
      Get.snackbar('Error', 'Event title is required');
      return;
    }

    // Combine date and time
    final DateTime startDateTime = DateTime(
      eventDate.value.year,
      eventDate.value.month,
      eventDate.value.day,
      eventTime.value.hour,
      eventTime.value.minute,
    );

    // Set end time (1 hour after start time for simplicity)
    final DateTime endDateTime = startDateTime.add(Duration(hours: 1));

    // Map recurrence
    Recurrence? eventRecurrence;
    switch (recurrence.value) {
      case 'Daily':
        eventRecurrence = Recurrence(frequency: Frequency.daily);
        break;
      case 'Weekly':
        eventRecurrence = Recurrence(frequency: Frequency.weekly);
        break;
      case 'Monthly':
        eventRecurrence = Recurrence(frequency: Frequency.monthly);
        break;
      default:
        eventRecurrence = null;
    }

    // Create calendar event
    final Event event = Event(
      title: eventTitle.value,
      description: eventDescription.value,
      startDate: startDateTime,
      endDate: endDateTime,
      recurrence: eventRecurrence,
    );

    // Add event to calendar
    Add2Calendar.addEvent2Cal(event).then((success) {
      Get.snackbar(
        'Success',
        success ? 'Event added to calendar' : 'Failed to add event',
      );
    });
  }
}