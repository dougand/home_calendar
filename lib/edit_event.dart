//
//
//  date / time
//
//  Title
//
//  description
//
//  Type/colour
//
//

import 'package:flutter/material.dart';
import 'package:flex_color_picker/flex_color_picker.dart';
import 'package:intl/intl.dart';
import 'event_list.dart';

// Create a Form widget.
class EditEventForm extends StatefulWidget {
  const EditEventForm({super.key});

  @override
  EditEventFormState createState() {
    return EditEventFormState();
  }
}

// Create a corresponding State class.
// This class holds data related to the form.
class EditEventFormState extends State<EditEventForm> {
  // Create a global key that uniquely identifies the Form widget
  // and allows validation of the form.
  //
  // Note: This is a GlobalKey<FormState>,
  // not a GlobalKey<MyCustomFormState>.
  final _formKey = GlobalKey<FormState>();

  String title = '';
  String description = '';
  DateTime date = DateTime.now();
  String colour = '';

  DateFormat formatter = DateFormat('EEE, d MMM yyyy'); // use any format

  final _dateC = TextEditingController();
  final _timeC = TextEditingController();

  ///Date
  DateTime selected = DateTime.now();
  DateTime initial = DateTime(2000);
  DateTime last = DateTime(2025);

  ///Time
  TimeOfDay timeOfDay = TimeOfDay.now();

// Color for the picker shown in Card on the screen.
  late Color screenPickerColor;
  // Color for the picker in a dialog using onChanged.
  late Color dialogPickerColor;
  // Color for picker using the color select dialog.
  late Color dialogSelectColor;

  @override
  void initState() {
    super.initState();
    screenPickerColor = Colors.blue; // Material blue.
    dialogPickerColor = Colors.red; // Material red.
    dialogSelectColor = const Color(0xFFA239CA); // A purple color.

    _dateC.text = formatter.format(selected);
  }

  @override
  Widget build(BuildContext context) {
    // Build a Form widget using the _formKey created above.
    return Form(
      key: _formKey,
      child: Material(
        color: Colors.grey.shade200,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // ListTile(
            //     title: new TextField(
            //       decoration: new InputDecoration(
            //         hintText: "New Entry",
            //       ),
            //   ),
            // ),

            // ListView(
            //     padding: EdgeInsets.all(16),
            //   children: [
            editTitle(),
            const SizedBox(height: 16),
            editDate(),
            const SizedBox(height: 16),
            editDescription(),
            const SizedBox(height: 16),
            editColour(),
            const SizedBox(height: 32),

            // TextFormField(
            //   // The validator receives the text that the user has entered.
            //   validator: (value) {
            //     if (value == null || value.isEmpty) {
            //       return 'Please enter some text';
            //     }
            //     return null;
            //   },
            // ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16),
              child: ElevatedButton(
                onPressed: () {
                  print('Submit pressed');
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Saving Data')),
                  );

                  EventList().saveEventsToFile();

                  // Validate returns true if the form is valid, or false otherwise.
                  // if (_formKey.currentState!.validate()) {
                  //   // If the form is valid, display a snackbar. In the real world,
                  //   // you'd often call a server or save the information in a database.
                  //   ScaffoldMessenger.of(context).showSnackBar(
                  //     const SnackBar(content: Text('Processing Data')),
                  //   );
                  //}
                },
                child: const Text('Submit'),
              ),
            ),
          ],
          // ),
          // ],
        ),
      ),
    );
  }

  Widget editTitle() => TextFormField(
        decoration: const InputDecoration(
          labelText: 'Title',
          border: OutlineInputBorder(),
          filled: true,
          fillColor: Colors.white,
        ),
        onChanged: (value) => setState(() => title = value),
      );

  Widget editDate() => Column(children: [
        InkWell(
          onTap: () => displayDatePicker(context),
          child: Container(
            child: IgnorePointer(
              child: TextFormField(
                controller: _dateC,
                decoration: const InputDecoration(
                  labelText: 'Date/Time',
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(),
                  suffixIcon: Icon(Icons.arrow_drop_down),

                ),

              ),
            ),
          ),
        ),
//        ElevatedButton(
//            onPressed: () => displayDatePicker(context),
//            child: const Text("Pick Date")),
      ]);

  Widget editDescription() => TextFormField(
        decoration: const InputDecoration(
          labelText: 'Description',
          border: OutlineInputBorder(),
        ),
        onChanged: (value) => setState(() => description = value),
      );

  Widget editColour() => Column(
        children: [
          TextFormField(
            decoration: const InputDecoration(
              labelText: 'Colour',
              border: OutlineInputBorder(),
              filled: true,
              fillColor: Colors.orange,
            ),
            onChanged: (value) => setState(() => colour = value),
          ),
          ElevatedButton(
              onPressed: () => colorPickerDialog(),
              child: const Text("Pick Colour")),
        ],
      );

  Future displayDatePicker(BuildContext context) async {
    var date = await showDatePicker(
      context: context,
      initialDate: selected,
      firstDate: initial,
      lastDate: last,
    );

    if (date != null) {
      setState(() {
        selected =date;
        _dateC.text = formatter.format(date);
      });
    }
  }

  Future displayTimePicker(BuildContext context) async {
    var time = await showTimePicker(context: context, initialTime: timeOfDay);

    if (time != null) {
      setState(() {
        _timeC.text = "${time.hour}:${time.minute}";
      });
    }
  }

  Future<bool> colorPickerDialog() async {
    return ColorPicker(
      // Use the dialogPickerColor as start color.
      color: dialogPickerColor,
      // Update the dialogPickerColor using the callback.
      onColorChanged: (Color color) =>
          setState(() => dialogPickerColor = color),
      width: 40,
      height: 40,
      borderRadius: 4,
      spacing: 5,
      runSpacing: 5,
      wheelDiameter: 155,
      heading: Text(
        'Select color',
        style: Theme.of(context).textTheme.titleSmall,
      ),
      subheading: Text(
        'Select color shade',
        style: Theme.of(context).textTheme.titleSmall,
      ),
      wheelSubheading: Text(
        'Selected color and its shades',
        style: Theme.of(context).textTheme.titleSmall,
      ),
      showMaterialName: true,
      showColorName: true,
      showColorCode: true,
      copyPasteBehavior: const ColorPickerCopyPasteBehavior(
        longPressMenu: true,
      ),
      materialNameTextStyle: Theme.of(context).textTheme.bodySmall,
      colorNameTextStyle: Theme.of(context).textTheme.bodySmall,
      colorCodeTextStyle: Theme.of(context).textTheme.bodySmall,
      pickersEnabled: const <ColorPickerType, bool>{
        ColorPickerType.both: false,
        ColorPickerType.primary: true,
        ColorPickerType.accent: false,
        ColorPickerType.bw: false,
        ColorPickerType.custom: false,
        ColorPickerType.wheel: false,
      },
      //customColorSwatchesAndNames: colorsNameMap,
    ).showPickerDialog(
      context,
      // New in version 3.0.0 custom transitions support.
      transitionBuilder: (BuildContext context, Animation<double> a1,
          Animation<double> a2, Widget widget) {
        final double curvedValue =
            Curves.easeInOutBack.transform(a1.value) - 1.0;
        return Transform(
          transform: Matrix4.translationValues(0.0, curvedValue * 200, 0.0),
          child: Opacity(
            opacity: a1.value,
            child: widget,
          ),
        );
      },
      transitionDuration: const Duration(milliseconds: 400),
      constraints:
          const BoxConstraints(minHeight: 460, minWidth: 300, maxWidth: 320),
    );
  }
}
