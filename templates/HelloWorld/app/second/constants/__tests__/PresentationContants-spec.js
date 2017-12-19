import 'react-native';
import React from 'react';
import * as PresentationConstants from '../PresentationConstants';

describe('PresentationConstants tests', () => {

  test('CONTINUE returns correct value', () => {
    expect(PresentationConstants.CONTINUE).toMatchSnapshot();
  });

  test('CLOSE returns correct value', () => {
    expect(PresentationConstants.CLOSE).toMatchSnapshot();
  });

  test('OK returns correct value', () => {
    expect(PresentationConstants.OK).toMatchSnapshot();
  });

  test('YES returns correct value', () => {
    expect(PresentationConstants.YES).toMatchSnapshot();
  });

  test('NO returns correct value', () => {
    expect(PresentationConstants.NO).toMatchSnapshot();
  });

  test('GO_BACK returns correct value', () => {
    expect(PresentationConstants.GO_BACK).toMatchSnapshot();
  });

  test('PAGE_TITLE_HOME_SCREEN returns correct value', () => {
    expect(PresentationConstants.PAGE_TITLE_HOME_SCREEN).toMatchSnapshot();
  });

  test('PAGE_TITLE_ABOUT_SCREEN returns correct value', () => {
    expect(PresentationConstants.PAGE_TITLE_ABOUT_SCREEN).toMatchSnapshot();
  });

  test('HOMESCREEN_WELCOME returns correct value', () => {
    expect(PresentationConstants.HOMESCREEN_WELCOME).toMatchSnapshot();
  });

  test('HOMESCREEN_INTRO returns correct value', () => {
    expect(PresentationConstants.HOMESCREEN_INTRO).toMatchSnapshot();
  });

  test('HOMESCREEN_COUNTER_VALUE returns correct value', () => {
    expect(PresentationConstants.HOMESCREEN_COUNTER_VALUE).toMatchSnapshot();
  });

  test('HOMESCREEN_BUTTON_LABEL_BACK_TO_DEFAULT_FEATURE returns correct value', () => {
    expect(PresentationConstants.HOMESCREEN_BUTTON_LABEL_BACK_TO_DEFAULT_FEATURE).toMatchSnapshot();
  });

  test('HOMESCREEN_BUTTON_LABEL_ABOUT returns correct value', () => {
    expect(PresentationConstants.HOMESCREEN_BUTTON_LABEL_ABOUT).toMatchSnapshot();
  });

  test('ABOUT_WELCOME returns correct value', () => {
    expect(PresentationConstants.ABOUT_WELCOME).toMatchSnapshot();
  });

  test('ABOUT_BUTTON_LABEL_TOGGLE returns correct value', () => {
    expect(PresentationConstants.ABOUT_BUTTON_LABEL_TOGGLE).toMatchSnapshot();
  });

  test('ABOUT_HELLO_WORLD returns correct value', () => {
    expect(PresentationConstants.ABOUT_HELLO_WORLD).toMatchSnapshot();
  });

  test('ABOUT_GOODBYE_WORLD returns correct value', () => {
    expect(PresentationConstants.ABOUT_GOODBYE_WORLD).toMatchSnapshot();
  });
});
