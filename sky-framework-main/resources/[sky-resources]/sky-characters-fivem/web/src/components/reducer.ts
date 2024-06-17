import { createSlice, PayloadAction  } from '@reduxjs/toolkit'

interface CounterState {
  settings: string
}

// Define the initial state using that type
const initialState: CounterState = {
  settings: 'test'
}

export const appReducer = createSlice({
  name: 'app',
  initialState,
  reducers: {
    /* setSettings: (state, action: PayloadAction<string>) => {
      state.settings = action.payload
    } */ // Example Disabled by Default -- REDUX
  }
})

// Action creators are generated for each case reducer function
//export const { setSettings } = appReducer.actions  // Example Disabled by Default -- REDUX
export default appReducer.reducer