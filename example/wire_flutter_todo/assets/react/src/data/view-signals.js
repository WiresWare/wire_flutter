const values = JSON.parse(window.ViewSignals());

class ViewSignals {
  static get INPUT() { return values.INPUT }

  static get EDIT() { return values.EDIT }

  static get DELETE() { return values.DELETE }

  static get DISMISSED() { return values.DISMISSED }

  static get TOGGLE() { return values.TOGGLE }

  static get FILTER() { return values.FILTER }

  static get CLEAR_INPUT() { return values.CLEAR_INPUT }

  static get CLEAR_COMPLETED() { return values.CLEAR_COMPLETED }

  static get COMPLETE_ALL() { return values.COMPLETE_ALL }
}

export default ViewSignals;
