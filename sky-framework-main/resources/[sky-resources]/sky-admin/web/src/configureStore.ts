import { configureStore } from '@reduxjs/toolkit';
import appReducer from './components/reducer';
import compReducer from './components/Comp1/reducer'

const store = configureStore({
  reducer: {
      app: appReducer,
      comp: compReducer
  }
})

export type RootState = ReturnType<typeof store.getState>
// Inferred type: {posts: PostsState, comments: CommentsState, users: UsersState}
export type AppDispatch = typeof store.dispatch

export default store;