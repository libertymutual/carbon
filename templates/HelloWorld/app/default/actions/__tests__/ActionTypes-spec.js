import * as ActionTypes from '../ActionTypes';

describe('ActionTypes tests', () => {

  test('LOGIN action type returns login', () => {
    expect(ActionTypes.LOGIN).toMatchSnapshot();
  });

  test('LOGOUT action type returns logout', () => {
    expect(ActionTypes.LOGOUT).toMatchSnapshot();
  });

  test('AUTH_UPDATE_AUTH_URL action type returns auth_update_auth_url', () => {
    expect(ActionTypes.AUTH_UPDATE_AUTH_URL).toMatchSnapshot();
  });

  test('AUTH_UPDATE_CLIENT_ID action type returns auth_update_client_id', () => {
    expect(ActionTypes.AUTH_UPDATE_CLIENT_ID).toMatchSnapshot();
  });

  test('AUTH_UPDATE_CLIENT_SECRET action type returns auth_update_client_secret', () => {
    expect(ActionTypes.AUTH_UPDATE_CLIENT_SECRET).toMatchSnapshot();
  });

  test('AUTH_UPDATE_CONFIG_NAME action type returns auth_update_config_name', () => {
    expect(ActionTypes.AUTH_UPDATE_CONFIG_NAME).toMatchSnapshot();
  });

  test('AUTH_UPDATE_PASSWORD action type returns auth_update_password', () => {
    expect(ActionTypes.AUTH_UPDATE_PASSWORD).toMatchSnapshot();
  });

  test('AUTH_UPDATE_USERNAME action type returns auth_update_username', () => {
    expect(ActionTypes.AUTH_UPDATE_USERNAME).toMatchSnapshot();
  });

  test('AUTH_UPDATE_VALIDATOR_ID action type returns auth_update_validator_id', () => {
    expect(ActionTypes.AUTH_UPDATE_VALIDATOR_ID).toMatchSnapshot();
  });

  test('INCREMENT action type returns increment', () => {
    expect(ActionTypes.INCREMENT).toMatchSnapshot();
  });

  test('DECREMENT action type returns decrement', () => {
    expect(ActionTypes.DECREMENT).toMatchSnapshot();
  });

  test('UPDATE_USERNAME action type returns update_username', () => {
    expect(ActionTypes.UPDATE_USERNAME).toMatchSnapshot();
  });

  test('UPDATE_PASSWORD action type returns update_password', () => {
    expect(ActionTypes.UPDATE_PASSWORD).toMatchSnapshot();
  });

  test('SAVE_CREDENTIALS action type returns save_credentials', () => {
    expect(ActionTypes.SAVE_CREDENTIALS).toMatchSnapshot();
  });

  test('DELETE_CREDENTIALS action type returns delete_credentials', () => {
    expect(ActionTypes.DELETE_CREDENTIALS).toMatchSnapshot();
  });
});
