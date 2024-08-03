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
  final Event event;

  const EditEventForm( {super.key, required this.event});

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

  late Event ev;// = widget.event;

  DateFormat formatter = DateFormat('EEE, d MMM yyyy'); // use any format

  final _dateC = TextEditingController();
  final _timeC = TextEditingController();

  ///Date
  DateTime selected = DateTime.now();
  DateTime initial = DateTime(2000);
  DateTime last = DateTime(2025);

  ///Time
  TimeOfDay timeOfDay = TimeOfDay.now();

  @override
  void initState() {
    super.initState();

    ev = widget.event;
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

            const Text("Edit Note",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
            ),
            const SizedBox(height: 16),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,

              children: [
                Expanded(flex: 3, child: editDate()),
                Expanded(child: editColour()),

              ],
            ),

            const SizedBox(height: 32),

            editTitle(),
            const SizedBox(height: 16),
            editDescription(),
            const SizedBox(height: 16),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,

              children: [
                Expanded(child: cancelButton() ),
                Expanded(child: saveButton()),

              ],
            ),

          ],
        ),
      ),
    );
  }


  Widget cancelButton() => Padding(
    padding: const EdgeInsets.symmetric(vertical: 16),
    child: ElevatedButton(
      onPressed: () {
        print('Cancel pressed');
        Navigator.pop(context);
      },
      child: const Text('Cancel'),
    ),
  );


  Widget saveButton() => Padding(
    padding: const EdgeInsets.symmetric(vertical: 16),
    child: ElevatedButton(
      onPressed: () {
        print('Submit pressed');
        Navigator.pop(context,ev);

  //      EventList().saveEventsToFile();

        // Validate returns true if the form is valid, or false otherwise.
        // if (_formKey.currentState!.validate()) {
        //   // If the form is valid, display a snackbar. In the real world,
        //   // you'd often call a server or save the information in a database.
        //   ScaffoldMessenger.of(context).showSnackBar(
        //     const SnackBar(content: Text('Processing Data')),
        //   );
        //}
      },
      child: const Text('Save'),
    ),
  );





  Widget editTitle() => TextFormField(
        decoration: const InputDecoration(
          labelText: 'Heading',
          border: OutlineInputBorder(),
          filled: true,
          fillColor: Colors.white,
        ),
        onChanged: (value) => setState(() => ev.title = value),
      );

  Widget editDate() =>
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
      );

  Widget editDescription() => TextFormField(
        decoration: const InputDecoration(
          labelText: 'Details',
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(),
        ),
        keyboardType: TextInputType.multiline,
        minLines: 1,
        maxLines: null,
        onChanged: (value) => setState(() => ev.details = value),
      );





  Widget editColour() =>
          InkWell(
            onTap: () => colorPickerDialog(),
            child: Container(
              child: IgnorePointer(
                child: TextField(
                  decoration:  InputDecoration(
                    labelText: 'Colour',
                    floatingLabelBehavior: FloatingLabelBehavior.always,
                  //  hintText: 'h',
                    border: const OutlineInputBorder(),
                    suffixIcon: const Icon(Icons.arrow_drop_down),
                    filled: true,
                    fillColor: ev.colour,
                  ),
                ),
              ),
            ),
      );

  Color getColour() {
    return Colors.red;
  }


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



  Future colorPickerDialog() async {
    // Wait for the dialog to return color selection result.
    final Color newColor = await showColorPickerDialog(
      // The dialog needs a context, we pass it in.
      context,
      // We use the dialogSelectColor, as its starting color.
      ev.colour,
      title: Text('Pick Colour',
          style: Theme.of(context).textTheme.titleLarge),
      width: 40,
      height: 40,
      spacing: 0,
      runSpacing: 0,
      borderRadius: 0,
      wheelDiameter: 165,
      enableOpacity: false,
      showColorCode: false,
      colorCodeHasColor: false,
      pickersEnabled: <ColorPickerType, bool>{
        ColorPickerType.both: false,
        ColorPickerType.primary: true,
        ColorPickerType.accent: false,
        ColorPickerType.bw: false,
        ColorPickerType.custom: false,
        ColorPickerType.wheel: false,
      },
      copyPasteBehavior: const ColorPickerCopyPasteBehavior(
        copyButton: false,
        pasteButton: false,
        longPressMenu: false,
      ),
      actionButtons: const ColorPickerActionButtons(
        okButton: false,
        closeButton: false,
        dialogActionButtons: true,
      ),
      transitionBuilder: (BuildContext context,
          Animation<double> a1,
          Animation<double> a2,
          Widget widget) {
        final double curvedValue =
            Curves.easeInOutBack.transform(a1.value) - 1.0;
        return Transform(
          transform: Matrix4.translationValues(
              0.0, curvedValue * 200, 0.0),
          child: Opacity(
            opacity: a1.value,
            child: widget,
          ),
        );
      },
      transitionDuration: const Duration(milliseconds: 400),
      constraints: const BoxConstraints(
          minHeight: 320, minWidth: 320, maxWidth: 320),
    );
    // We update the dialogSelectColor, to the returned result
    // color. If the dialog was dismissed it actually returns
    // the color we started with. The extra update for that
    // below does not really matter, but if you want you can
    // check if they are equal and skip the update below.
    setState(() {
      ev.colour = newColor;
    });

  }


}

