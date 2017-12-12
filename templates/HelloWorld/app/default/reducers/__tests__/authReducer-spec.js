import 'react-native';
import React from 'react';
import authReducer from '../authReducer';
import { initialState } from '../authReducer';
import * as ActionTypes from '../../actions/ActionTypes';

describe('authReducer tests', () => {
  test('test login', () => {
    expect(authReducer(initialState, { type: ActionTypes.LOGIN })).toMatchSnapshot();
  });

  test('test logout', () => {
    expect(authReducer(initialState, { type: ActionTypes.LOGOUT })).toMatchSnapshot();
  });
});
