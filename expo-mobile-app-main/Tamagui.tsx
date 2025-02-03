import { useIsomorphicLayoutEffect, TamaguiProvider, Theme, ThemeName } from 'tamagui';
import config from './tamagui.config';
import { useState, useEffect } from 'react';
import { useFonts } from 'expo-font';
import * as SplashScreen from 'expo-splash-screen';
import { getTheme, defaultTheme } from './src/themes';
import { Inter_400Regular, Inter_500Medium, Inter_600SemiBold, Inter_700Bold } from '@expo-google-fonts/inter';
import { SafeAreaProvider } from 'react-native-safe-area-context';
import { StatusBar } from 'expo-status-bar';

SplashScreen.preventAutoHideAsync();

export default function Tamagui(props: any) {
  // Get theme
  const [theme, setTheme] = useState(defaultTheme) as ThemeName | any;
  useIsomorphicLayoutEffect(() => {
    (async () => {
      const theme = await getTheme();
      setTheme(theme);
    })();
  }, []);

  // a function that gets if the theme is dark or not (picks "theme" from the state and returns true if it's dark (is has a dark_ prefix))
  function isDark() {
    if (theme === undefined) {
      return false;
    } else if (theme.startsWith('dark_')) {
      return true;
    } else {
      return false;
    }
  }

  // TODO: Add splash screen
  // Load fonts
  const [fontsLoaded, error] = useFonts({
    'Inter': Inter_400Regular,
    'Inter-Medium': Inter_500Medium,
    'Inter-SemiBold': Inter_600SemiBold,
    'Inter-Bold': Inter_700Bold,
    'InterMedium': Inter_500Medium,
    'InterSemiBold': Inter_600SemiBold,
    'InterBold': Inter_700Bold,
  });

  useEffect(() => {
    async function loadFonts() {
      try {
        await SplashScreen.hideAsync();
      } catch (e) {
        console.error('Error hiding splash screen:', e);
      }
    }

    if (fontsLoaded) {
      loadFonts();
    }
  }, [fontsLoaded]);

  if (!fontsLoaded || error) {
    return null;
  }

  return (
    <SafeAreaProvider style={{ backgroundColor: isDark() ? '#161616' : '#fff' }}>
      <StatusBar style={isDark() ? 'light' : 'dark'} />
      <TamaguiProvider config={config}>
          <Theme name={theme ?? null}>
            {props.children}
          </Theme>
      </TamaguiProvider>
    </SafeAreaProvider>
  );
}