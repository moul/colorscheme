// ManfredTouron Dynamic theme for hterm
// Automatically switches between light and dark based on system preference

const darkScheme = {
  cursor: '#eeeeee',
  foreground: '#eeeeee',
  background: '#000000',
  colors: [
    '#222222', '#ff0000', '#51ff0f', '#e7a800',
    '#3950d7', '#d336b1', '#66b2ff', '#cecece',
    '#4e4e4e', '#ff008b', '#62c750', '#f4ff00',
    '#70a5ed', '#b867e6', '#00d4fc', '#ffffff'
  ]
};

const lightScheme = {
  cursor: '#191919',
  foreground: '#191919',
  background: '#f9f9f9',
  colors: [
    '#eeeeee', '#cc0000', '#33b20c', '#b27f00',
    '#263fb2', '#a5267f', '#4c8cd8', '#4c4c4c',
    '#b2b2b2', '#e50066', '#3f9933', '#bfb200',
    '#4c7fcc', '#994cb2', '#00a5cc', '#333333'
  ]
};

function applyScheme(scheme) {
  for (const [key, value] of Object.entries(scheme)) {
    term_.prefs_.set(key, value);
  }
}

function updateTheme() {
  const isDark = window.matchMedia && window.matchMedia('(prefers-color-scheme: dark)').matches;
  applyScheme(isDark ? darkScheme : lightScheme);
}

// Initial theme
updateTheme();

// Listen for changes
if (window.matchMedia) {
  window.matchMedia('(prefers-color-scheme: dark)').addEventListener('change', updateTheme);
}
