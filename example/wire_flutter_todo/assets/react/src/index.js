import React from 'react';
import ReactDOM from 'react-dom';
import App from './components/wrappers/App';

// Add bootstrap
import 'bootstrap/dist/css/bootstrap.css';

// Add our style
import './assets/style/index.css';

import Wire from 'wire';

Wire.add(this, 'SIGNAL', (payload, wid) => {
  console.log('> JS catch Wire signal -> SIGNAL: payload', payload, wid)
});

ReactDOM.render(
  <App/>,
  document.getElementById('root')
);
