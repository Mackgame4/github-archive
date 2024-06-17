import {
    Svg,
    Path,
    Rect,
    Circle,
    Line,
    Polyline,
    StyleSheet
} from '@react-pdf/renderer';

import { colorVars } from '../Utils';

const styles = StyleSheet.create({
    icon: {
        width: 16,
        height: 16,
    },
});

type IconProps = {
    width?: number,
    height?: number,
    color?: string,
    strokeWidth?: number,
    isOutlined?: boolean
}

/* Icon components */
export const PhoneIcon = ({ width, height, color, strokeWidth, isOutlined }: IconProps) => (
    <Svg width={width || styles.icon.width} height={height || styles.icon.height} viewBox="0 0 24 24" fill="none">
        <Path d="M22 16.92v3a2 2 0 0 1-2.18 2 19.79 19.79 0 0 1-8.63-3.07 19.5 19.5 0 0 1-6-6 19.79 19.79 0 0 1-3.07-8.67A2 2 0 0 1 4.11 2h3a2 2 0 0 1 2 1.72 12.84 12.84 0 0 0 .7 2.81 2 2 0 0 1-.45 2.11L8.09 9.91a16 16 0 0 0 6 6l1.27-1.27a2 2 0 0 1 2.11-.45 12.84 12.84 0 0 0 2.81.7A2 2 0 0 1 22 16.92z"
        stroke={isOutlined ? color || colorVars.primaryColor : 'none'}
        fill={!isOutlined ? color || colorVars.primaryColor : 'none'}
        stroke-linecap="round" stroke-linejoin="round"
        strokeWidth={strokeWidth || 2} />
    </Svg>
);

export const EmailIcon = ({ width, height, color, strokeWidth, isOutlined }: IconProps) => (
    <Svg width={width || styles.icon.width} height={height || styles.icon.height} viewBox="0 0 24 24" fill="none">
        <Path d="M4 4h16c1.1 0 2 .9 2 2v12c0 1.1-.9 2-2 2H4c-1.1 0-2-.9-2-2V6c0-1.1.9-2 2-2z"
        stroke={isOutlined ? color || colorVars.primaryColor : 'none'}
        fill={!isOutlined ? color || colorVars.primaryColor : 'none'}
        stroke-linecap="round" stroke-linejoin="round"
        strokeWidth={strokeWidth || 2} />
        <Polyline points="22,6 12,13 2,6"
        fill="none"
        stroke={isOutlined ? color || colorVars.primaryColor : 'none'}
        stroke-linecap="round" stroke-linejoin="round"
        strokeWidth={strokeWidth || 2} />
    </Svg>
);

export const GithubIcon = ({ width, height, color, strokeWidth, isOutlined }: IconProps) => (
    <Svg width={width || styles.icon.width} height={height || styles.icon.height} viewBox="0 0 24 24" fill="none">
        <Path d="M12 0C5.37 0 0 5.37 0 12c0 5.31 3.438 9.813 8.205 11.385.6.113.82-.26.82-.577 0-.285-.01-1.04-.015-2.04-3.338.724-4.042-1.614-4.042-1.614-.546-1.384-1.333-1.754-1.333-1.754-1.088-.743.082-.727.082-.727 1.204.085 1.837 1.236 1.837 1.236 1.07 1.834 2.808 1.303 3.493.996.108-.774.42-1.303.763-1.605-2.67-.307-5.48-1.336-5.48-5.93 0-1.31.465-2.385 1.235-3.23-.123-.308-.54-1.527.12-3.18 0 0 1.008-.322 3.3 1.23a11.575 11.575 0 0 1 3-.39c1.017.003 2.04.137 3 .39 2.29-1.552 3.296-1.23 3.296-1.23.662 1.653.245 2.873.12 3.18.77.845 1.234 1.92 1.234 3.23 0 4.607-2.816 5.618-5.49 5.918.43.372.815 1.102.815 2.22 0 1.606-.015 2.896-.015 3.286 0 .32.215.693.825.575C20.57 21.81 24 17.31 24 12c0-6.63-5.37-12-12-12"
        stroke={isOutlined ? color || colorVars.primaryColor : 'none'}
        fill={!isOutlined ? color || colorVars.primaryColor : 'none'}
        stroke-linecap="round" stroke-linejoin="round"
        strokeWidth={strokeWidth || 2} />
    </Svg>
);

export const LinkedInIcon = ({ width, height, color, strokeWidth, isOutlined }: IconProps) => (
    <Svg width={width || styles.icon.width} height={height || styles.icon.height} viewBox="0 0 24 24" fill="none">
        <Path d="M16 8a6 6 0 0 1 6 6v7h-4v-7a2 2 0 0 0-2-2 2 2 0 0 0-2 2v7h-4v-7a6 6 0 0 1 6-6z"
        stroke={isOutlined ? color || colorVars.primaryColor : 'none'}
        fill={!isOutlined ? color || colorVars.primaryColor : 'none'}
        stroke-linecap="round" stroke-linejoin="round"
        strokeWidth={strokeWidth || 2} />
        <Rect x="2" y="9" width="4" height="12"
        stroke={isOutlined ? color || colorVars.primaryColor : 'none'}
        fill={!isOutlined ? color || colorVars.primaryColor : 'none'}
        stroke-linecap="round" stroke-linejoin="round"
        strokeWidth={strokeWidth || 2} />
        <Circle cx="4" cy="4" r="2"
        stroke={isOutlined ? color || colorVars.primaryColor : 'none'}
        fill={!isOutlined ? color || colorVars.primaryColor : 'none'}
        stroke-linecap="round" stroke-linejoin="round"
        strokeWidth={strokeWidth || 2} />
    </Svg>
);

export const ExternalLinkIcon = ({ width, height, color, strokeWidth, isOutlined }: IconProps) => (
    <Svg width={width || styles.icon.width} height={height || styles.icon.height} viewBox="0 0 24 24" fill="none">
        <Path d="M18 13v6a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2V8a2 2 0 0 1 2-2h6"
        stroke={isOutlined ? color || colorVars.primaryColor : 'none'}
        fill="none"
        stroke-linecap="round" stroke-linejoin="round"
        strokeWidth={strokeWidth || 2} />
        <Polyline points="15 3 21 3 21 9"
        stroke={isOutlined ? color || colorVars.primaryColor : 'none'}
        fill="none"
        stroke-linecap="round" stroke-linejoin="round"
        strokeWidth={strokeWidth || 2} />
        <Line x1="10" y1="14" x2="21" y2="3"
        stroke={isOutlined ? color || colorVars.primaryColor : 'none'}
        fill="none"
        stroke-linecap="round" stroke-linejoin="round"
        strokeWidth={strokeWidth || 2} />
    </Svg>
);
/* Icon wrapper */
const PdfIcon = ({ name, ...props }: { name: string } & IconProps) => {
    switch (name) {
        case 'phoneIcon':
            return <PhoneIcon {...props} />;
        case 'emailIcon':
            return <EmailIcon {...props} />;
        case 'githubIcon':
            return <GithubIcon {...props} />;
        case 'linkedInIcon':
            return <LinkedInIcon {...props} />;
        case 'externalLinkIcon':
            return <ExternalLinkIcon {...props} />;
        default:
            return null;
    }
}

export default PdfIcon;