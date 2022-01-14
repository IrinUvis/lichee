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
  //DateTime? eventDate;
  TimeOfDay? eventTime;

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
      Provider.of<FirebaseProvider>(context, listen: false).firestore,
      Provider.of<FirebaseProvider>(context, listen: false).storage,
    );
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
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              const SizedBox(height: 50.0),
              Text('Add event',
                  style: kBannerTextStyle.copyWith(letterSpacing: 2.0)),
              Expanded(child: getEventData()),
              isDatePicked ? Text('You have to choose date and time of the event') : Container(),
              ElevatedButton(
                onPressed: _createEvent,
                child: kCreateEventButtonText,
                style: kPinkRoundedButtonStyle,
              ),
              const SizedBox(height: 50.0),
            ],
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
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          eventTitleField,
          eventLocalizationField,
          DatePickerButton(eventDate: eventDate),
          TimePickerButton(eventDate: eventDate),
        ],
      ),
    );
  }

  // Future<void> _createChannel() async {
  //   if (_formKey.currentState!.validate()) {
  //     if (chosenCategoryId == '') {
  //       setState(() {
  //         isCategoryEmpty = true;
  //         chosenCategoryName = 'Category cannot be empty';
  //       });
  //       return;
  //     }
  //     String? imageUrl;
  //     var uuid = const Uuid();
  //     DateTime now = DateTime.now();
  //     String city = channelCityEditingController.text.capitalize();
  //     city = removeDiacritics(city);
  //     final myId = Provider.of<User?>(context, listen: false)!.uid;
  //     List<String> usersIds = [myId];
  //
  //     if (_file == null) {
  //       imageUrl =
  //           'https://www.fivb.org/Vis2009/Images/GetImage.asmx?No=202004911&width=920&height=588&stretch=uniformtofill';
  //     }
  //     if (_file != null) {
  //       try {
  //         imageUrl = await _addChannelController.uploadPhoto(
  //             uuid: uuid.v1(), currentTime: now, file: _file!);
  //         setState(() {
  //           _file = null;
  //         });
  //       } on FirebaseException catch (_) {
  //         Fluttertoast.showToast(
  //             msg: 'An unexpected error has occurred! Message wasn\'t sent');
  //       }
  //     }
  //
  //     _addChannelController.addChannel(
  //         channelName: channelNameEditingController.text,
  //         imageUrl: imageUrl!,
  //         city: city,
  //         now: now,
  //         description: channelDescriptionEditingController.text,
  //         usersIds: usersIds,
  //         userId: myId,
  //         parentCategoryId: chosenCategoryId);
  //
  //     ScaffoldMessenger.of(context).showSnackBar(kChannelAddedSnackBar);
  //
  //     channelNameEditingController.clear();
  //     channelCityEditingController.clear();
  //     channelDescriptionEditingController.clear();
  //     setState(() {
  //       chosenCategoryId = '';
  //     });
  //   }
  // }

  void _createEvent() {
    if (_formKey.currentState!.validate()) {
      if (!eventDate.validate()) {
        setState(() {
          isDatePicked = true;
        });
        return;
      }
      print(eventDate.getCombinedDate());
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
