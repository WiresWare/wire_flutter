import React, {Component} from 'react';
import TodoList from '../ui/TodoList';
import StateProvider from './StateProvider';
import KeyStrokeHandler from './KeyStrokeHandler';
import DataKeys from 'data/data-keys';
import ViewSignals from 'data/view-signals';

class App extends Component {
  render() {
    console.log(DataKeys.LIST);
    console.log(ViewSignals.FILTER);
    return (
      <StateProvider>
        <KeyStrokeHandler>
          <TodoList/>
        </KeyStrokeHandler>
      </StateProvider>
    );
  }
}

export default App;
