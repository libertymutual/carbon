import 'react-native';
import React from 'react';
import * as NavigationTargets from '../NavigationTargets';

describe('NavigationTargets tests', () => {

  test('CONTACT returns correct value', () => {
    expect(NavigationTargets.CONTACT).toMatchSnapshot();
  });

  test('HOME returns correct value', () => {
    expect(NavigationTargets.HOME).toMatchSnapshot();
  });

  test('PROFILE returns correct value', () => {
    expect(NavigationTargets.PROFILE).toMatchSnapshot();
  });

  test('ABOUT returns correct value', () => {
    expect(NavigationTargets.ABOUT).toMatchSnapshot();
  });

  test('BIOMETRIC returns correct value', () => {
    expect(NavigationTargets.BIOMETRIC).toMatchSnapshot();
  });
});
