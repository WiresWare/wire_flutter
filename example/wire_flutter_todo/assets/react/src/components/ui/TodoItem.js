import React from 'react';
import CheckBox from './CheckBox';
import Wire from 'wire';

export default function TodoItem(props) {
  const {data, changeStatus} = props;
  const handleChange = (checked) => changeStatus(data.id, checked);
  const className = 'todo-item ui-state-default ' + (data.completed === true ? 'completed' : 'pending');

  Wire.send('SIGNAL');

  return (
    <li className={className}>
      <div className="checkbox">
        <label>
          <CheckBox checked={data.completed} onChange={handleChange}/> {data.text}
        </label>
      </div>
    </li>
  );
}
