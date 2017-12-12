import 'react-native';
import React from 'react';
import configureStore from '../index';

describe('store tests', () => {

  test('Store is configured correctly', () => {
    expect(configureStore()).toMatchSnapshot();
  });
});
