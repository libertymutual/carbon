import 'react-native';
import React from 'react';
import counterReducer from '../counterReducer';
import { initialState } from '../counterReducer';
import * as ActionTypes from '../../actions/ActionTypes';

describe('counterReducer tests', () => {
  test('test increment counter', () => {
    expect(counterReducer(initialState, { type: ActionTypes.INCREMENT })).toMatchSnapshot();
  });

  test('test decrement counter', () => {
    expect(counterReducer(initialState, { type: ActionTypes.DECREMENT })).toMatchSnapshot();
  });
});
