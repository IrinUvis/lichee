import 'dart:async';

class Validator {
  static String pass = "";
  final validateEmail = new StreamTransformer<String, String>.fromHandlers(
      handleData: (email, sink) {
    if (!email.contains('@'))
      sink.addError('Email must contain "@"');
    else
      sink.add(email);
  });

  final validatePass = new StreamTransformer<String, String>.fromHandlers(
      handleData: (pass1, sink) {
    if (pass1.length < 5)
      sink.addError('Password length must be greater than 6');
    else {
      sink.add(pass1);
      pass = pass1;
    }
  });
  final validateConfPass = new StreamTransformer<String, String>.fromHandlers(
      handleData: (busqueda, sink) {
    if (busqueda != pass)
      sink.addError('Passwords must be equal');
    else
      sink.add(busqueda);
  });
}
