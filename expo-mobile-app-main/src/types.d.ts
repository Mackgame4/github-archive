// the "navigation" prop is added to the "Route" component
import { RouteComponentProps } from 'react-router-dom';

export interface IRouteProps {
    navigation: RouteComponentProps;
}

// the "RootStackParamList" is added to the "Route" component
import { StackNavigationProp } from '@react-navigation/stack';

export type RootStackParamList = {
    [key: string]: undefined;
};

// Generic type for the "navigation" prop
export type NavigationProp = StackNavigationProp<RootStackParamList>;