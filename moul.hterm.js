// moul dark theme for hterm
const terminalProfile = {
  cursor: '#eeeeee',
  foreground: '#eeeeee',
  background: '#000000',
  colors: [
    '#222222',
    '#ff0000',
    '#51ff0f',
    '#e7a800',
    '#3950d7',
    '#d336b1',
    '#66b2ff',
    '#cecece',
    '#4e4e4e',
    '#ff008b',
    '#62c750',
    '#f4ff00',
    '#70a5ed',
    '#b867e6',
    '#00d4fc',
    '#ffffff'
  ]
};

for (const [key, value] of Object.entries(terminalProfile)) {
  term_.prefs_.set(key, value);
}
