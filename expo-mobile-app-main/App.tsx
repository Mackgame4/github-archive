import { NavigationContainer, DefaultTheme } from '@react-navigation/native';
import { createNativeStackNavigator } from '@react-navigation/native-stack';
import { useState, useEffect} from 'react';
import { ThemeName } from 'tamagui';

import { getTheme, defaultTheme } from './src/themes';
import { getLocale, getLocaleAsync } from './src/locales';
import Tamagui from './Tamagui';
import Debug from './src/Debug';

const Stack = createNativeStackNavigator();

// Screens
import Home from './src/screens/Home';
import Login from './src/screens/Login';
import ForgotPassModal from './src/screens/ForgotPassword';

export default function App() {
  const [theme, setTheme] = useState(defaultTheme) as ThemeName | any;
  useEffect(() => {
    (async () => {
      const theme = await getTheme();
      setTheme(theme);
    })();
  }, []);

  function isDark() {
    if (theme === undefined) {
      return false;
    } else if (theme.startsWith('dark_')) {
      return true;
    } else {
      return false;
    }
  }

  const [locale, setLocale] = useState(getLocale);
  useEffect(() => {
      getLocaleAsync().then((locale) => {
          setLocale(locale);
      });
  }, []);

  return (
    <NavigationContainer
      theme={{
        colors: {
          ...DefaultTheme.colors,
          background: isDark() ? '#161616' : '#fff',
        },
        dark: isDark(),
      }}
    >
      <Tamagui>
        <Stack.Navigator
          initialRouteName="Home"
          screenOptions={{
            headerShown: false
          }}
        >
          <Stack.Group>
            <Stack.Screen name="Home" component={Home} />
            <Stack.Screen name="Login" component={Login} />
          </Stack.Group>
          <Stack.Group screenOptions={{ presentation: 'modal' }}>
            <Stack.Screen name="DebugModal" component={Debug} />
            <Stack.Screen name="ForgotPassModal" component={ForgotPassModal} />
          </Stack.Group>
        </Stack.Navigator>
      </Tamagui>
    </NavigationContainer>
  );
}