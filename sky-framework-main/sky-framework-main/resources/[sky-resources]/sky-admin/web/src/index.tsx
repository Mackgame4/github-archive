import React from 'react';
import { ThemeProvider, createTheme } from '@mui/material/styles';
import { VisibilityProvider } from './providers/VisibilityProvider';
import { ReduxProvider } from './providers/ReduxProvider';
import CssBaseline from '@mui/material/CssBaseline';
import { Provider } from 'react-redux'
import './index.css';
import App from './components/App';
import { createRoot } from 'react-dom/client';
import store from './configureStore'
import { red } from '@mui/material/colors';

const root = createRoot(document.getElementById('root')!);

const theme = createTheme({
  palette: {
    primary: {
      main: red[500],
    },
  },
});

root.render(
  <React.StrictMode>
    <Provider store={store}>
      <ReduxProvider>
        <ThemeProvider theme={theme}>
          <CssBaseline>
            <VisibilityProvider>
              <App />
            </VisibilityProvider>
          </CssBaseline>
        </ThemeProvider>
      </ReduxProvider>
    </Provider>
  </React.StrictMode>
);
