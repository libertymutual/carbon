import React from 'react';
import { AsyncStorage } from 'react-native';
import { Provider } from 'react-redux';
import { persistStore } from 'redux-persist';
import { StackNavigator } from 'react-navigation';
import routes from './routes/routes';
import configureStore from './store';

// Setup Stores/Reducers
const store = configureStore();

// Setup Navigation
// Provide possible routes, and initial route (initial screen to load)
const AppNavigator = StackNavigator(routes, {
  initialRouteName: 'HomeScreen',
});

/**
 * Top Level App Component
 * @extends {React.Component}
 */
class App extends React.Component {

  /**
   * Called when the component has been mounted
   * @override
   */
  componentDidMount() {
    persistStore(store, { storage: AsyncStorage });
  }

  render() {
    return (
      <Provider store={store}>
        <AppNavigator />
      </Provider>
    );
  }
}

/**
 * Default export
 */
export default App;
