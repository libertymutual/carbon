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

  test('EXTERNAL_FEATURE_SECOND returns correct value', () => {
    expect(Constants.EXTERNAL_FEATURE_SECOND).toMatchSnapshot();
  });

  test('EXTERNAL_FEATURE_MODULE_SECOND returns correct value', () => {
    expect(Constants.EXTERNAL_FEATURE_MODULE_SECOND).toMatchSnapshot();
  });

  test('EXTERNAL_FEATURE_WEB returns correct value', () => {
    expect(Constants.EXTERNAL_FEATURE_WEB).toMatchSnapshot();
  });

  test('EXTERNAL_FEATURE_MODULE_WEB returns correct value', () => {
    expect(Constants.EXTERNAL_FEATURE_MODULE_WEB).toMatchSnapshot();
  });
});
