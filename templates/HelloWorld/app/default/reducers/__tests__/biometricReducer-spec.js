import 'react-native';
import React from 'react';
import biometricReducer from '../biometricReducer';
import { initialState } from '../biometricReducer';
import * as ActionTypes from '../../actions/ActionTypes';

describe('biometricReducer tests', () => {
  test('test update username', () => {
    expect(biometricReducer(initialState, { type: ActionTypes.UPDATE_USERNAME, username: "NewUsername" })).toMatchSnapshot();
  });

  test('test update password', () => {
    expect(biometricReducer(initialState, { type: ActionTypes.UPDATE_PASSWORD, password: "NewPassword" })).toMatchSnapshot();
  });

  test('test save credentials', () => {
    expect(biometricReducer(initialState, { type: ActionTypes.SAVE_CREDENTIALS })).toMatchSnapshot();
  });

  test('test delete credentials', () => {
    expect(biometricReducer(initialState, { type: ActionTypes.DELETE_CREDENTIALS })).toMatchSnapshot();
  });
});
