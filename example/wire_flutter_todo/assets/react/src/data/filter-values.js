const values = JSON.parse(window.FilterValues());

class FilterValues {
  static get ALL() { return values.ALL }

  static get ACTIVE() { return values.ACTIVE }

  static get COMPLETED() { return values.COMPLETED }
}

export default FilterValues;
