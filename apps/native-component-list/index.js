import '@expo/metro-runtime';
import { registerRootComponent } from 'expo';
import { inject } from '@vercel/analytics';

import App from './App';

// Inject Vercel Web Analytics
inject();

// registerRootComponent calls AppRegistry.registerComponent('main', () => App);
// It also ensures that whether you load the app in the Expo Go or in a native build,
// the environment is set up appropriately
registerRootComponent(App);
