import 'react-native';
import React from 'react';
import renderer from 'react-test-renderer';
import SecondFeature from '../index';

describe('App tests', () => {
  test('renders without crashing', () => {
    const rendered = renderer.create(
      <SecondFeature />
    );
    expect(rendered).toBeTruthy();
  });
});
