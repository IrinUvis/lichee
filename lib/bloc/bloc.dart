import 'package:firebase_auth/firebase_auth.dart';
import 'package:lichee/bloc/validator.dart';
import 'package:rxdart/rxdart.dart';

class Bloc extends Object with Validator {
  final _email = BehaviorSubject<String>();
  final _password = BehaviorSubject<String>();
  final _confirmedPassword = BehaviorSubject<String>();
  final _loggedin = BehaviorSubject<bool>();

  FirebaseAuth auth = FirebaseAuth.instance;

  Function(String) get addEmail => _email.sink.add;
  Function(String) get addPass => _password.sink.add;
  Function(String) get addConfPass => _confirmedPassword.sink.add;
  Function(bool) get loggedin => _loggedin.sink.add;

  Stream<String> get emailField => _email.stream.transform(validateEmail);
  Stream<String> get passField => _password.stream.transform(validatePass);
  Stream<String> get confPassField =>
      _confirmedPassword.stream.transform(validateConfPass);

  String get email => _email.value.toLowerCase().trim();
  String get password => _password.value;
  dynamic get isLoggedIn => _loggedin.valueOrNull;
  late UserCredential userCredential;
  Bloc();
  Bloc.init() {
    loggedin(false);
  }
  login() async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(
              email: this.email, password: this.password);
      loggedin(true);
      this.userCredential = userCredential;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        _email.addError('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        _email.addError('Wrong password provided for that user.');
      }
    }
  }

  register() async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
              email: this.email, password: this.password);
      this.userCredential = userCredential;
      loggedin(true);

      return true;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        _password.addError('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        _password.addError('The account already exists for that email.');
      }
    } catch (e) {
      print(e);
    }
    return false;
  }

  dispose() {
    _email.close();
    _password.close();
    _loggedin.close();
    _confirmedPassword.close();
  }
}
