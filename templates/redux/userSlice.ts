import { createSlice } from '@reduxjs/toolkit'

interface UserState {
  name: string
}

const userSlice = createSlice({
  name: 'user',
  initialState: {
    name: '',
  } as UserState,
  reducers: {
    setName(state, action) {
      state.name = action.payload
    },
  },
})
export const UserActions = userSlice.actions
export default userSlice.reducer
