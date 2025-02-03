"use strict";
import AsyncStorage from '@react-native-async-storage/async-storage';
import * as Updates from "expo-updates";
import { ThemeName } from 'tamagui';

export const themes = [
    //{ value: 'black', label: 'Black' },
    //{ value: 'white', label: 'White' },
    { value: 'light', label: 'Light' },
    { value: 'dark', label: 'Dark' },
    { value: 'dark_green', label: 'Dark Green' },
    { value: 'dark_blue', label: 'Dark Blue' },
    { value: 'dark_purple', label: 'Dark Purple' },
    { value: 'dark_red', label: 'Dark Red' },
    { value: 'dark_orange', label: 'Dark Orange' },
    { value: 'dark_yellow', label: 'Dark Yellow' },
    { value: 'dark_pink', label: 'Dark Pink' },
    { value: 'dark_cyan', label: 'Dark Cyan' },
    { value: 'dark_gray', label: 'Dark Gray' },
    { value: 'green', label: 'Green' },
    { value: 'blue', label: 'Blue' },
    { value: 'purple', label: 'Purple' },
    { value: 'red', label: 'Red' },
    { value: 'orange', label: 'Orange' },
    { value: 'yellow', label: 'Yellow' },
    { value: 'pink', label: 'Pink' },
    { value: 'cyan', label: 'Cyan' },
    { value: 'gray', label: 'Gray' },
];

export const defaultTheme = 'dark_blue' as ThemeName;

async function getTheme() {
    const theme = await AsyncStorage.getItem('theme');
    if (theme) {
        return theme as ThemeName;
    } else {
        return defaultTheme as ThemeName;
    }
}

async function changeTheme(theme: ThemeName) {
    await AsyncStorage.setItem('theme', theme);
    await Updates.reloadAsync();
}

// gets theme main color (removes dark_ if exists)
function getThemeColor(theme: ThemeName) {
    if (!theme) {
        return defaultTheme;
    }
    if (theme.includes('dark_')) {
        return theme.replace('dark_', '');
    } else {
        return theme;
    }
}

export { getTheme, changeTheme, getThemeColor };