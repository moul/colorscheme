// ManfredTouron Dynamic Theme for hterm/Blink Shell
// Automatically switches between light and dark themes based on system preferences
// Generated from ManfredTouron.hterm.js and ManfredTouron-Light.hterm.js

// Dark theme configuration
const darkScheme = {
  cursor: 'rgba(238,238,238, 0.5)',
  foreground: '#eeeeee',
  background: '#000000',
  colors: ['#222222', '#ff0000', '#51ff0f', '#e7a800', '#3950d7', '#d336b1', '#66b2ff', '#cecece', '#4e4e4e', '#ff008b', '#62c750', '#f4ff00', '#70a5ed', '#b867e6', '#00d4fc', '#ffffff']
};

// Light theme configuration
const lightScheme = {
  cursor: 'rgba(26,26,26, 0.5)',
  foreground: '#1a1a1a',
  background: '#fafafa',
  colors: ['#eeeeee', '#cc0000', '#33b30d', '#b38000', '#2640b3', '#a62680', '#4d8cd9', '#4d4d4d', '#b3b3b3', '#e60066', '#409933', '#bfb300', '#4d80cc', '#994db3', '#00a6cc', '#333333']
};

// Function to apply theme
function applyTheme(theme) {
  t.prefs_.set('cursor-color', theme.cursor);
  t.prefs_.set('foreground-color', theme.foreground);
  t.prefs_.set('background-color', theme.background);
  if (theme.colors) {
    t.prefs_.set('color-palette-overrides', theme.colors);
  }
}

// Function to set theme based on system preference
function setPreferredScheme() {
  const isDarkMode = window.matchMedia && window.matchMedia('(prefers-color-scheme: dark)').matches;
  applyTheme(isDarkMode ? darkScheme : lightScheme);
}

// Apply initial theme
setPreferredScheme();

// Listen for theme changes
if (window.matchMedia) {
  window.matchMedia('(prefers-color-scheme: dark)').addEventListener('change', setPreferredScheme);
}

// Optional: Add manual theme toggle function
window.toggleManfredTouronTheme = function() {
  const currentBackground = t.prefs_.get('background-color');
  if (currentBackground === darkScheme.background) {
    applyTheme(lightScheme);
  } else {
    applyTheme(darkScheme);
  }
};
