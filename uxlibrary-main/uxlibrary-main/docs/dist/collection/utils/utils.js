import data from './docs.json';
export const debugMode = process.env.NODE_ENV === 'development';
export const buildVersion = '1.0.0';
const githubPageURL = 'https://github.com/Mackgame4/uxlibrary';
export function log(message, ...args) {
  if (!debugMode)
    return;
  console.log(`%c${message}`, 'background-color: #3498DB; border-radius: 2px; color: white; padding: 3px; font-size: 0.645rem;', ...args);
  return message;
}
export function getDataComponents() {
  try {
    log("loadedComponents", `UXLibrary loaded ${data.components.length} components`, data);
    return data;
  }
  catch (error) {
    log("loadedComponents", `UXLibrary failed to load components`, error);
    return null;
  }
}
export function redirectToGithub() {
  window.open(githubPageURL, '_blank');
}
