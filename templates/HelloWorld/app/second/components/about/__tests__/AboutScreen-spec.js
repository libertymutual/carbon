import 'react-native';
import React from 'react';
import renderer from 'react-test-renderer';
import configureMockStore from 'redux-mock-store';
import thunk from 'redux-thunk';
import AboutScreen from '../AboutScreen';
import { initialState } from '../../../reducers/helloWorldReducer';

const middlewares = [thunk];
const mockStore = configureMockStore(middlewares);
let store;

describe('AboutScreen tests', () => {
  beforeEach(() => {
    // Sets up a new store
    store = mockStore({
      helloWorld: initialState
    });
  });

  test('About Screen renders correctly', () => {
    const tree = renderer.create(
      <AboutScreen store={store} navigation={{}}/>
    );
    expect(tree.toJSON()).toMatchSnapshot();
  });

  test('Goodbye message displays when helloWorld state is hello', () => {

    // Override the default initialState so state is goodbye
    store = mockStore({
      helloWorld: {
        state: 'goodbye'
      }
    });
    const tree = renderer.create(
      <AboutScreen store={store} navigation={{}}/>
    );
    expect(tree.toJSON()).toMatchSnapshot();
  });
});
