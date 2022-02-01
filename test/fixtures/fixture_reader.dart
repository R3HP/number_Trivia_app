import 'dart:io';

String readFixture(String fileNameLocation) => File('test/fixtures/$fileNameLocation').readAsStringSync();