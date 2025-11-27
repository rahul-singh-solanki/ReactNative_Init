import React from "react"
import { NavigationContainer } from "@react-navigation/native"
import { createStackNavigator } from '@react-navigation/stack'

import Home from "screens/home"
import { StackParamsList, StackScreen } from "types/RootStackParams"

const Stack = createStackNavigator<StackParamsList>()

function Navigator() {
  return (
    <NavigationContainer>
      <Stack.Navigator>
        <Stack.Screen name={StackScreen.HOME} component={Home} />
      </Stack.Navigator>
    </NavigationContainer>
  )
}

export default Navigator