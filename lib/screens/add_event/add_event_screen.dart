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

  final _eventTitleEditingController = TextEditingController();
  final _eventLocalizationEditingController = TextEditingController();

  late final AddEventController _addEventController;

  final EventDate _eventDate = EventDate();
  bool _isDatePicked = true;

  late final TextFormField _eventTitleField;
  late final TextFormField _eventLocalizationField;

  @override
  void initState() {
    super.initState();
    _addEventController = AddEventController(
        Provider.of<FirebaseProvider>(context, listen: false).firestore);
    _focusNode = FocusNode();

    _eventTitleField = _eventTitleFieldF();
    _eventLocalizationField = _eventLocalizationFieldF();
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
                  kAddEventTitleText,
                  const SizedBox(height: 30.0),
                  _getEventData(),
                  const SizedBox(height: 5.0),
                  _isDatePicked ? Container() : kNoDateForEventPickedText,
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

  Form _getEventData() {
    return Form(
      key: _formKey,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _eventTitleField,
          const SizedBox(height: 20.0),
          _eventLocalizationField,
          const SizedBox(height: 20.0),
          DatePickerButton(eventDate: _eventDate),
          const SizedBox(height: 20.0),
          TimePickerButton(eventDate: _eventDate),
        ],
      ),
    );
  }

  TextFormField _eventLocalizationFieldF() {
    return TextFormField(
      autofocus: false,
      controller: _eventLocalizationEditingController,
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
        _eventLocalizationEditingController.text = value!;
      },
      textInputAction: TextInputAction.next,
      decoration: kAddEventLocalizationBarInputDecoration,
    );
  }

  TextFormField _eventTitleFieldF() {
    return TextFormField(
      autofocus: false,
      controller: _eventTitleEditingController,
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
        _eventTitleEditingController.text = value!;
      },
      textInputAction: TextInputAction.next,
      decoration: kAddEventTitleBarInputDecoration,
    );
  }

  void _createEvent() {
    if (_formKey.currentState!.validate()) {
      if (!_eventDate.validate()) {
        setState(() => _isDatePicked = false);
        return;
      } else {
        setState(() => _isDatePicked = true);
      }

      _addEventController.addEvent(
          title: _eventTitleEditingController.text,
          localization: _eventLocalizationEditingController.text,
          date: _eventDate.getCombinedDate(),
          interestedUsers: List.empty(),
          goingUsers: List.empty(),
          channelId: widget.data.channelId);

      ScaffoldMessenger.of(context).showSnackBar(kEventAddedSnackBar);
      _eventTitleEditingController.clear();
      _eventLocalizationEditingController.clear();
      setState(() => _eventDate.clear());
    } else {
      if (!_eventDate.validate()) {
        setState(() => _isDatePicked = false);
      } else {
        setState(() => _isDatePicked = true);
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
