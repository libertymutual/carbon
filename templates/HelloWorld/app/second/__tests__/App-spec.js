import 'react-native';
import React from 'react';
import renderer from 'react-test-renderer';
import App from '../App';

describe('App tests', () => {
  test('renders without crashing', () => {
    const rendered = renderer.create(
      <App />
    );
    expect(rendered).toBeTruthy();
  });
});
