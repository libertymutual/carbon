import 'react-native';
import React from 'react';
import * as Constants from '../Constants';

describe('Constants tests', () => {

  test('OS_IOS returns correct value', () => {
    expect(Constants.OS_IOS).toMatchSnapshot();
  });

  test('OS_ANDROID returns correct value', () => {
    expect(Constants.OS_ANDROID).toMatchSnapshot();
  });

  test('HELLO returns correct value', () => {
    expect(Constants.HELLO).toMatchSnapshot();
  });

  test('GOODBYE returns correct value', () => {
    expect(Constants.GOODBYE).toMatchSnapshot();
  });

  test('EXTERNAL_FEATURE_SECOND returns correct value', () => {
    expect(Constants.EXTERNAL_FEATURE_SECOND).toMatchSnapshot();
  });

  test('EXTERNAL_FEATURE_MODULE_SECOND returns correct value', () => {
    expect(Constants.EXTERNAL_FEATURE_MODULE_SECOND).toMatchSnapshot();
  });
});
