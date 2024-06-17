import React, {Context, createContext, useContext } from "react";
import { useDispatch } from 'react-redux'
import {useNuiEvent} from "../hooks/useNuiEvent";


// Include Reducer Quicker Funcs
//import { setSettings } from '../components/reducer' // Example Disabled by Default -- REDUX

const ReduxCtx = createContext<ReduxProviderValue | null>(null)
interface ReduxProviderValue {}

// This should be mounted at the top level of your application, it is currently set to
// apply a CSS visibility value. If this is non-performant, this should be customized.
export const ReduxProvider: React.FC<{ children: React.ReactNode }> = ({ children }) => {
    const dispatch = useDispatch();

    //useNuiEvent<any>('setSettings', (data) => dispatch(setSettings(data))) // Example Disabled by Default -- REDUX

  return (
    <ReduxCtx.Provider
      value={{}}
    >
      {children}
  </ReduxCtx.Provider>)
}

export const useRedux = () => useContext<ReduxProviderValue>(ReduxCtx as Context<ReduxProviderValue>)