import 'react-native';
import React from 'react';
import * as NavigationTargets from '../NavigationTargets';

describe('NavigationTargets tests', () => {

  test('HOME returns correct value', () => {
    expect(NavigationTargets.HOME).toMatchSnapshot();
  });

  test('ABOUT returns correct value', () => {
    expect(NavigationTargets.ABOUT).toMatchSnapshot();
  });
});
