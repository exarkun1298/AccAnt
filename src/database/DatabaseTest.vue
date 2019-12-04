<template>
  <div>
    <v-btn @click="createDatabase()">Create Database</v-btn>

    <v-btn @click="createTables()">Create Tables</v-btn>

    <v-btn @click="insertData()">Insert Data</v-btn>

    <v-btn @click="closeDatabase()">Close Database</v-btn>
  </div>
</template>

<script>
import { migrations } from "./migrations.js";
import sql from "sql.js";

import fs from "fs";
import path from "path";

const DATABASE_FILENAME = "accant.db";
const DATABASE_PATH = DATABASE_FILENAME; //path.join(__dirname, DATABASE_FILENAME);

export default {
  name: "DatabaseTest",

  methods: {
    createDatabase: function() {
      console.log("Creating database. . .");

      // Check if database file exists
      if (!fs.existsSync(DATABASE_PATH)) {
        // Database file does not exist - create it
        this.database = new sql.Database();
        this.writeDatabase(DATABASE_PATH);
      }

      // Load database
      this.database = this.readDatabase(DATABASE_PATH);

      console.log("Created database.");
    },
    /**
     * Load the data from the SQLite database.
     * NOTE: This does not contain error handling, so make sure the database file exists!
     *
     * @param {string} databasePath The path to the database file.
     * @return {sql.Database}
     */
    readDatabase: function(databasePath) {
      var filebuffer = fs.readFileSync(databasePath);

      // Load the db
      return new sql.Database(filebuffer);
    },
    /**
     * Write the data to the SQLite database.
     * If the file exists it will be silently overwritten.
     *
     * @param {string} databasePath The path to the database file.
     */
    writeDatabase: function(databasePath) {
      var data = this.database.export();
      var buffer = new Buffer.from(data);
      fs.writeFileSync(databasePath, buffer);
    },

    createTables: function() {
      console.log("Creating tables. . .");

      // const sqlstr = "CREATE TABLE IF NOT EXISTS hello (a int, b char);";
      // this.database.run(sqlstr);
      this.createAllTables(this.database);

      console.log("Created tables.");
    },

    insertData: function() {
      console.log("Inserting data. . .");

      let sqlstr =
        "INSERT INTO users (name, email, password) VALUES ('Max', 'max@email.de', 'p1xnotinplaintext');";
      sqlstr +=
        "INSERT INTO users (name, email, password) VALUES ('Maria', 'maria@email.de', 'p1xplxnotinplaintext');";

      this.database.run(sqlstr); // Run the query without returning anything

      console.log("Inserted data.");
    },

    closeDatabase: function() {
      console.log("Closing database. . .");
      this.writeDatabase(DATABASE_PATH);
      this.database.close();
      console.log("Closed database.");
    }
  },

  data: function() {
    return {
      database: null
    };
  },

  mixins: [migrations]
};
</script>

<style scoped>
</style>
