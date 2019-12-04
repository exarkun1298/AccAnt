let EntitySchema = require("typeorm").EntitySchema;

module.exports = new EntitySchema({
  name: "Test",
  columns: {
    id: {
      type: Number,
      primary: true,
      generated: true
    },
    title: {
      type: String
    },
    text: {
      type: String
    }
  }
});
