import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gajahweb/utils/slideLeftRoute.dart';

void main() {
  test('SlideLeftRoute can be created as a PageRouteBuilder', () {
    final route = SlideLeftRoute(page: const SizedBox());
    expect(route, isA<PageRouteBuilder>());
  });
}

