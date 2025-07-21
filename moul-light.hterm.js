// moul light theme for hterm
const terminalProfile = {
  cursor: '#191919',
  foreground: '#191919',
  background: '#f9f9f9',
  colors: [
    '#eeeeee',
    '#cc0000',
    '#33b20c',
    '#b27f00',
    '#263fb2',
    '#a5267f',
    '#4c8cd8',
    '#4c4c4c',
    '#b2b2b2',
    '#e50066',
    '#3f9933',
    '#bfb200',
    '#4c7fcc',
    '#994cb2',
    '#00a5cc',
    '#333333'
  ]
};

for (const [key, value] of Object.entries(terminalProfile)) {
  term_.prefs_.set(key, value);
}
