import 'react-native';
import React from 'react';
import * as StylingConstants from '../StylingConstants';

describe('StylingConstants tests', () => {

  test('COLOR_LIGHTGRAY returns correct value', () => {
    expect(StylingConstants.COLOR_LIGHTGRAY).toMatchSnapshot();
  });
});
