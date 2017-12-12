import 'react-native';
import React from 'react';
import renderer from 'react-test-renderer';
import configureMockStore from 'redux-mock-store';
import thunk from 'redux-thunk';
import { AboutScreen } from '../AboutScreen';

const middlewares = [thunk];
const mockStore = configureMockStore(middlewares);
let store;

describe('AboutScreen tests', () => {
  beforeEach(() => {
    // Sets up a new store
    store = mockStore();
  });

  test('About Screen renders correctly', () => {
    const tree = renderer.create(
      <AboutScreen store={store} navigation={{}}/>
    );
    expect(tree.toJSON()).toMatchSnapshot();
  });

  test('test _navigateBack calls goBack() on the React Navigation object', () => {

    // Generate the component
    const navigation = {
      goBack: function () {
      }
    };
    const component = renderer.create(<AboutScreen store={store} navigation={navigation}/>);
    
    // Mock the navigation.goBack function
    jest.spyOn(navigation, 'goBack');

    component.getInstance()._navigateBack();
    
    // Check the navigation.goBack() function was called
    expect(navigation.goBack).toHaveBeenCalled();

    // Restore the navigation.goBack() function
    navigation.goBack.mockRestore();
  });

});
