import HomeScreen from '../components/home/HomeScreen';
import ContactScreen from '../components/contact/ContactScreen';
import ProfileScreen from '../components/profile/ProfileScreen';
import AboutScreen from '../components/about/AboutScreen';
import BiometricScreen from '../components/biometric/BiometricScreen';
import LoginScreen from '../components/login/LoginScreen';

/**
 * List of possible navigation routes
 */
const routes = {
  HomeScreen: {
    screen: HomeScreen,
  },
  ContactScreen: {
    screen: ContactScreen,
  },
  ProfileScreen: {
    screen: ProfileScreen,
  },
  AboutScreen: {
    screen: AboutScreen,
  },
  BiometricScreen: {
    screen: BiometricScreen,
  },
  LoginScreen: {
    screen: LoginScreen,
  },
};

export default routes;
