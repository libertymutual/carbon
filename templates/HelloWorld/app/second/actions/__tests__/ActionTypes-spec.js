import * as ActionTypes from '../ActionTypes';

describe('ActionTypes tests', () => {

  test('HELLO action type returns hello', () => {
    expect(ActionTypes.HELLO).toMatchSnapshot();
  });

  test('GOODBYE action type returns goodbye', () => {
    expect(ActionTypes.GOODBYE).toMatchSnapshot();
  });


  test('INCREMENT action type returns increment', () => {
    expect(ActionTypes.INCREMENT).toMatchSnapshot();
  });

  test('DECREMENT action type returns decrement', () => {
    expect(ActionTypes.DECREMENT).toMatchSnapshot();
  });
});
