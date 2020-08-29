const values = JSON.parse(window.DataKeys());

class DataKeys {
  static get LIST() { return values.LIST }

  static get COUNT() { return values.COUNT }

  static get FILTER() { return values.FILTER }

  static get STATE() { return values.STATE }
}

export default DataKeys;
