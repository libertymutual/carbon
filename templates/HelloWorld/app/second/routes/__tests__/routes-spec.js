import 'react-native';
import React from 'react';
import routes from '../routes';

describe('routes tests', () => {

  test('Routes are valid', () => {
    expect(routes).toMatchSnapshot();
  });
});
