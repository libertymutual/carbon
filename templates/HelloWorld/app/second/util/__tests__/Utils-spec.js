import 'react-native';
import React from 'react';
import Utils from '../Utils';

describe('Utils tests', () => {

  test('getAppVersion is not undefined', () => {
    // Note: We are not matching this to a snapshot or a static value
    // because the app name will change regularly.
    expect(Utils.getAppVersion()).toBeDefined();
  });

  test('getAppName is not undefined', () => {
    // Note: We are not matching this to a snapshot or a static value
    // because the app name will change for each app.
    expect(Utils.getAppName()).toBeDefined();
  });

  test('getAppDescription is not undefined', () => {
    // Note: We are not matching this to a snapshot or a static value
    // because the app description will change for each app.
    expect(Utils.getAppDescription()).toBeDefined();
  });
});
