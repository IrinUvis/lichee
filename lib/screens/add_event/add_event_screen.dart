import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lichee/constants/channel_constants.dart';
import 'package:lichee/constants/colors.dart';
import 'package:lichee/constants/constants.dart';
import 'package:lichee/providers/firebase_provider.dart';
import 'package:lichee/screens/add_event/time_picker_button.dart';
import 'package:provider/provider.dart';
import 'add_event_controller.dart';
import 'date_picker_button.dart';
import 'event_date.dart';

class AddEventScreen extends StatefulWidget {
  static const String id = 'add_event_screen';

  final AddEventNavigationParams data;

  const AddEventScreen({Key? key, required this.data}) : super(key: key);

  @override
  _AddEventScreenState createState() => _AddEventScreenState();
}

class _AddEventScreenState extends State<AddEventScreen> {
  final _formKey = GlobalKey<FormState>();
  late FocusNode _focusNode;
  final eventTitleEditingController = TextEditingController();
  final eventLocalizationEditingController = TextEditingController();

  late final AddEventController _addEventController;

  late EventDate eventDate = EventDate();

  bool isDatePicked = false;

  //File? get file => _file;

  //ImagePicker get imagePicker => _imagePicker;

  // set file(File? value) {
  //   setState(() {
  //     _file = value;
  //   });
  // }

  @override
  void initState() {
    super.initState();
    _addEventController = AddEventController(
        Provider.of<FirebaseProvider>(context, listen: false).firestore);
    _focusNode = FocusNode();
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
            foregroundColor: LicheeColors.primary,
            backgroundColor: LicheeColors.appBarColor,
            title: Text(widget.data.channelName, style: kAppBarTitleTextStyle)),
        body: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(height: 20.0),
                  Text('Add event',
                      style: kBannerTextStyle.copyWith(letterSpacing: 2.0)),
                  const SizedBox(height: 30.0),
                  getEventData(),
                  const SizedBox(height: 5.0),
                  isDatePicked
                      ? Text('You have to choose date and time of the event')
                      : Container(),
                  const SizedBox(height: 30.0),
                  ElevatedButton(
                    onPressed: _createEvent,
                    child: kCreateEventButtonText,
                    style: kPinkRoundedButtonStyle,
                  ),
                  const SizedBox(height: 20.0),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Form getEventData() {
    final eventTitleField = TextFormField(
      autofocus: false,
      controller: eventTitleEditingController,
      keyboardType: TextInputType.name,
      validator: (value) {
        RegExp regex = RegExp(r'^.{3,}$');
        if (value!.isEmpty) {
          return ('Event title cannot be empty');
        }
        if (!regex.hasMatch(value)) {
          return ('Enter valid event title (min. 3 characters)');
        }
        return null;
      },
      onSaved: (value) {
        eventTitleEditingController.text = value!;
      },
      textInputAction: TextInputAction.next,
      decoration: kAddEventTitleBarInputDecoration,
    );

    final eventLocalizationField = TextFormField(
      autofocus: false,
      controller: eventLocalizationEditingController,
      keyboardType: TextInputType.name,
      validator: (value) {
        RegExp regex = RegExp(r'^.{3,}$');
        if (value!.isEmpty) {
          return ('Localization cannot be empty');
        }
        if (!regex.hasMatch(value)) {
          return ('Enter valid localization (min. 3 characters)');
        }
        return null;
      },
      onSaved: (value) {
        eventLocalizationEditingController.text = value!;
      },
      textInputAction: TextInputAction.next,
      decoration: kAddEventLocalizationBarInputDecoration,
    );

    return Form(
      key: _formKey,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          eventTitleField,
          const SizedBox(height: 20.0),
          eventLocalizationField,
          const SizedBox(height: 20.0),
          DatePickerButton(eventDate: eventDate),
          const SizedBox(height: 20.0),
          TimePickerButton(eventDate: eventDate),
        ],
      ),
    );
  }

  void _createEvent() {
    if (_formKey.currentState!.validate()) {
      if (!eventDate.validate()) {
        setState(() => isDatePicked = true);
        return;
      } else {
        setState(() => isDatePicked = false);
      }

      _addEventController.addEvent(
          title: eventTitleEditingController.text,
          localization: eventLocalizationEditingController.text,
          date: eventDate.getCombinedDate(),
          interestedUsers: List.empty(),
          goingUsers: List.empty(),
          channelId: widget.data.channelId);

      ScaffoldMessenger.of(context).showSnackBar(kEventAddedSnackBar);
      eventTitleEditingController.clear();
      eventLocalizationEditingController.clear();
      setState(() => eventDate.clear());
    } else {
      if (!eventDate.validate()) {
        setState(() => isDatePicked = true);
      } else {
        setState(() => isDatePicked = false);
      }
    }
  }
}

class AddEventNavigationParams {
  final String channelId;
  final String channelName;

  AddEventNavigationParams({
    required this.channelId,
    required this.channelName,
  });
}
