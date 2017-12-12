import 'react-native';
import React from 'react';
import helloWorldReducer from '../helloWorldReducer';
import { initialState } from '../helloWorldReducer';
import * as ActionTypes from '../../actions/ActionTypes';

describe('helloWorldReducer tests', () => {
  test('test hello', () => {
    expect(helloWorldReducer(initialState, { type: ActionTypes.HELLO })).toMatchSnapshot();
  });

  test('test goodbye', () => {
    expect(helloWorldReducer(initialState, { type: ActionTypes.GOODBYE })).toMatchSnapshot();
  });
});
