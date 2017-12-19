import 'react-native';
import React from 'react';
import renderer from 'react-test-renderer';
import configureMockStore from 'redux-mock-store';
import thunk from 'redux-thunk';
import ContactScreen from '../ContactScreen';

const middlewares = [thunk];
const mockStore = configureMockStore(middlewares);
let store;

describe('ContactScreen tests', () => {
  beforeEach(() => {
    // Sets up a new store
    store = mockStore({});
  });

  test('Contact Screen renders correctly', () => {
    const tree = renderer.create(
      <ContactScreen store={store} navigation={{}}/>
    );
    expect(tree.toJSON()).toMatchSnapshot();
  });
});
