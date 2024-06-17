import { Font } from '@react-pdf/renderer';

Font.register({
    family: 'Oswald-Regular',
    src: 'https://fonts.gstatic.com/s/oswald/v13/Y_TKV6o8WovbUd3m_X9aAA.ttf',
});

Font.register({
    family: 'HelveticaNeue-Light',
    src: '/fonts/HelveticaNeue-Light.ttf',
});

Font.register({
    family: 'HelveticaNeue-Regular',
    src: '/fonts/HelveticaNeue-Medium.ttf',
});

Font.register({
    family: 'HelveticaNeue-Bold',
    src: '/fonts/HelveticaNeue-Heavy.ttf',
});

Font.register({
    family: 'Inter-Regular',
    src: '/fonts/Inter-Regular.ttf'
});

Font.register({
    family: 'CaviarDreams-Regular',
    src: '/fonts/CaviarDreams.ttf'
});

Font.register({
    family: 'CaviarDreams-Bold',
    src: '/fonts/CaviarDreams_Bold.ttf'
});

Font.register({
    family: 'CaviarDreams-Italic',
    src: '/fonts/CaviarDreams_Italic.ttf'
});

Font.register({
    family: 'CaviarDreams-BoldItalic',
    src: '/fonts/CaviarDreams_BoldItalic.ttf'
});

Font.register({
    family: 'Ostrich-Regular',
    src: '/fonts/ostrich-regular.ttf'
});

Font.register({
    family: 'JetBrainsMono-Light',
    src: '/fonts/JetBrainsMono-Light.ttf'
});

Font.register({
    family: 'JetBrainsMono-Regular',
    src: '/fonts/JetBrainsMono-Medium.ttf'
});

Font.register({
    family: 'JetBrainsMono-Bold',
    src: '/fonts/JetBrainsMono-Bold.ttf'
});

Font.register({
    family: 'JetBrainsMono-ExtraBold',
    src: '/fonts/JetBrainsMono-ExtraBold.ttf'
});

Font.register({
    family: 'JetBrainsMono-Italic',
    src: '/fonts/JetBrainsMono-MediumItalic.ttf'
});

Font.register({
    family: 'JetBrainsMono-BoldItalic',
    src: '/fonts/JetBrainsMono-BoldItalic.ttf'
});

Font.register({
    family: 'JetBrainsMono-ExtraBoldItalic',
    src: '/fonts/JetBrainsMono-ExtraBoldItalic.ttf'
});

Font.register({
    family: 'JetBrainsMono-LightItalic',
    src: '/fonts/JetBrainsMono-LightItalic.ttf'
});

export const themes = {
    green: {
        light: {
            primaryColor: '#017E05',
            secondaryColor: '#33362F',
            accentColor: '#797a71',
            textColor: '#2B312E',
            textForegroundColor: '#ffffff',
            backgroudColor: '#FDFDF5'
        },
        dark: {
            primaryColor: '#00f708',
            secondaryColor: '#c1ccb3',
            accentColor: '#A2A498',
            textColor: '#dcf1e7',
            textForegroundColor: '#000000',
            backgroudColor: '#141414'
        },
    },
};

export function getTheme(theme: string) {
    const [themeName, mode] = theme.split('-');
    const selectedTheme = themes[themeName as keyof typeof themes];
    return selectedTheme[mode as keyof typeof selectedTheme];
}

import { Config, Locales } from './Config';

export const colorVars = getTheme(Config.defaultTheme);

export function getLocale() {
    return Locales[Config.defaultLocale as keyof typeof Locales];
}

export function ln(key: string) {
    const locale = getLocale();
    return locale[key as keyof typeof locale] as string || key as string;
}

/*export function mergeStyles(...styles: unknown[]) {
    return Object.assign({}, ...styles);
}*/