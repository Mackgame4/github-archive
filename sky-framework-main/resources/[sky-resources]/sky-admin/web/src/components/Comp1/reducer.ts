import { createSlice, PayloadAction  } from '@reduxjs/toolkit'

interface CompReducer {
  settings: string
}

// Define the initial state using that type
const initialState: CompReducer = {
  settings: 'test'
}

export const compReducer = createSlice({
  name: 'comp',
  initialState,
  reducers: {
    /* setSettings: (state, action: PayloadAction<string>) => {
      state.settings = action.payload
    } */ // Example Disabled by Default -- REDUX
  }
})

// Action creators are generated for each case reducer function

//export const { setSettings } = appReducer.actions  // Example Disabled by Default -- REDUX


export default compReducer.reducer