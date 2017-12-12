import 'react-native';
import React from 'react';
import renderer from 'react-test-renderer';
import DefaultFeature from '../index';

describe('App tests', () => {
  test('renders without crashing', () => {
    const rendered = renderer.create(
      <DefaultFeature />
    );
    expect(rendered).toBeTruthy()
  });
});
