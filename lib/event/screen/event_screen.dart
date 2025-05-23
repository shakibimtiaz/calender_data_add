import 'package:calender_data_add/event/controller/event_controller.dart' show EventController;
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class EventScreen extends StatelessWidget {
  const EventScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final EventController controller = Get.put(EventController());

    return Scaffold(
      appBar: AppBar(
        title: Text('Add Event to Calendar'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Event Title
              TextField(
                decoration: InputDecoration(labelText: 'Event Title'),
                onChanged: (value) => controller.updateEventTitle(value),
              ),
              SizedBox(height: 16),

              // Event Description
              TextField(
                decoration: InputDecoration(labelText: 'Event Description'),
                onChanged: (value) => controller.updateEventDescription(value),
              ),
              SizedBox(height: 16),

              // Event Date
              Obx(() => ListTile(
                    title: Text('Date: ${controller.eventDate.value.toString().split(' ')[0]}'),
                    trailing: Icon(Icons.calendar_today),
                    onTap: () async {
                      DateTime? picked = await showDatePicker(
                        context: context,
                        initialDate: controller.eventDate.value,
                        firstDate: DateTime(2025),
                        lastDate: DateTime(2030),
                      );
                      if (picked != null) {
                        controller.updateEventDate(picked);
                      }
                    },
                  )),
              SizedBox(height: 16),

              // Event Time
              Obx(() => ListTile(
                    title: Text('Time: ${controller.eventTime.value.format(context)}'),
                    trailing: Icon(Icons.access_time),
                    onTap: () async {
                      TimeOfDay? picked = await showTimePicker(
                        context: context,
                        initialTime: controller.eventTime.value,
                      );
                      if (picked != null) {
                        controller.updateEventTime(picked);
                      }
                    },
                  )),
              SizedBox(height: 16),

              // Recurrence Dropdown
              Obx(() {
                // Ensure the value is one of the allowed items; fallback to 'None' if invalid
                final validRecurrence = ['None', 'Daily', 'Weekly', 'Monthly']
                        .contains(controller.recurrence.value)
                    ? controller.recurrence.value
                    : 'None';

                return DropdownButtonFormField<String>(
                  value: validRecurrence,
                  decoration: InputDecoration(labelText: 'Recurrence'),
                  items: ['None', 'Daily', 'Weekly', 'Monthly']
                      .map((String value) => DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          ))
                      .toList(),
                  onChanged: (value) {
                    if (value != null) {
                      controller.updateRecurrence(value);
                    }
                  },
                );
              }),
              SizedBox(height: 32),

              // Save Button
              Center(
                child: ElevatedButton(
                  onPressed: controller.saveEventToCalendar,
                  child: Text('Save to Calendar'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}