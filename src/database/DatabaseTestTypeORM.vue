<template>
  <div>
    <v-btn @click="createDatabase()">Create Database</v-btn>

    <v-btn @click="connectToDatabase()">Connect to Database</v-btn>

    <v-btn @click="closeDatabaseConnection()">Close Connection</v-btn>

    <v-btn @click="insertData()">Insert Data</v-btn>

    <v-btn @click="closeDatabase()">Close Database</v-btn>
  </div>
</template>

<script>
import sql from "sql.js";
import fs from "fs";
import path from "path";
import { getConnection, createConnection, Connection } from "typeorm";

const DATABASE_FILENAME = "accant.db";
const DATABASE_PATH = DATABASE_FILENAME; //path.join(__dirname, DATABASE_FILENAME);

export default {
  data() {
    return {
      Connection: null
    };
  },
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
      //this.database = this.readDatabase(DATABASE_PATH);

      console.log("Created database.");
    },

    connectToDatabase() {
      this.Connection = createConnection();
      console.log(this.Connection);
    },

    closeDatabaseConnection() {}
  }
};
</script>

<style scoped>
</style>
