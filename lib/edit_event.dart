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
  String date = '';
  String colour = '';

  @override
  Widget build(BuildContext context) {
    // Build a Form widget using the _formKey created above.
    return Form(
      key: _formKey,
      child: Material(



        child: ListView(
          padding: EdgeInsets.all(16),
          children: [
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
                  // Validate returns true if the form is valid, or false otherwise.
                  if (_formKey.currentState!.validate()) {
                    // If the form is valid, display a snackbar. In the real world,
                    // you'd often call a server or save the information in a database.
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Processing Data')),
                    );
                  }
                },
                child: const Text('Submit'),
              ),
            ),
          ],
        ),
      ),
    );
  }


  Widget editTitle() => TextFormField(
    decoration: InputDecoration(
      labelText: 'Title',
      border: OutlineInputBorder(),
    ),
    onChanged: (value) => setState(() => title = value),
  );


  Widget editDate() => TextFormField(
    decoration: InputDecoration(
      labelText: 'Date/Time',
      border: OutlineInputBorder(),
    ),
    onChanged: (value) => setState(() => date = value),
  );


  Widget editDescription() => TextFormField(
    decoration: InputDecoration(
      labelText: 'Description',
      border: OutlineInputBorder(),
    ),
    onChanged: (value) => setState(() => description = value),
  );


  Widget editColour() => TextFormField(
    decoration: InputDecoration(
      labelText: 'Colour',
      border: OutlineInputBorder(),
    ),
    onChanged: (value) => setState(() => colour = value),
  );

}




