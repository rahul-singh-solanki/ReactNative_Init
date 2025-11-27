import { StackNavigationOptions, StackScreenProps } from '@react-navigation/stack'

export enum StackScreen {
  HOME = 'HOME'
}

export type StackParamsList = {
  [StackScreen.HOME]: undefined;
};

export type StackScreenOptions = (
  props: StackScreenProps<StackParamsList>
) => StackNavigationOptions

export type StackNavigationProp<RouteName extends keyof StackParamsList> =
  StackScreenProps<StackParamsList, RouteName>
