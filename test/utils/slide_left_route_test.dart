import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gajahweb/utils/slide_left_route.dart';

void main() {
  test('SlideLeftRoute can be created as a PageRouteBuilder', () {
    final route = SlideLeftRoute(page: const SizedBox());
    expect(route, isA<PageRouteBuilder>());
  });
}

