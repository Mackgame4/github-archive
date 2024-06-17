import {
    View,
    //Text,
    StyleSheet
} from '@react-pdf/renderer';

import { colorVars } from '../Utils';

const styles = StyleSheet.create({
    progBarContainer: {
        width: '100%',
        height: 10,
    },
    progBar: {
        width: '100%',
        height: '100%',
        backgroundColor: colorVars.primaryColor
    },
});

const PdfProgBar = ({ value, width, height, isRounded, isOutlined }: { value: number, width?: number, height?: number, isRounded?: boolean, isOutlined: boolean }) => (
    <View style={[styles.progBarContainer, { width, height, borderRadius: isRounded ? '50%' : 0, border: isOutlined ? `1px solid ${colorVars.primaryColor}` : 'none' }]}>
        <View style={[styles.progBar, { width: `${value}%`, borderRadius: isRounded ? '50%' : 0 }]} />
    </View>
);

export default PdfProgBar;