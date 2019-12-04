/**
 * This file contains the queries for creating the database tables.
 * All the CREATE statements are of kind "create ... if not exists".
 */
export const migrations = {
  data() {
    return {
      /**
       * Contains all the queries to create the database tables.
       */
      CREATE_QUERIES: {
        // TODO JS objects aren't ordered, but the execution order is!!! => Find a ordered datastructure!

        CREATE_USERS:
          "create table if not exists users" +
          "  (" +
          "    id INTEGER NOT NULL" +
          "      PRIMARY KEY," +
          "    name VARCHAR(191) NOT NULL," +
          "    email VARCHAR(191) NOT NULL" +
          "      UNIQUE," +
          "    password VARCHAR(191) NOT NULL," +
          "    remember_token VARCHAR(100)," +
          "    created_at TIMESTAMP(0)," +
          "    updated_at TIMESTAMP(0)" +
          "  );",

        CREATE_ACCOUNTS:
          "create table if not exists accounts" +
          "  (" +
          "    id INTEGER NOT NULL" +
          "      PRIMARY KEY," +
          "    number VARCHAR(191) NOT NULL" +
          "      UNIQUE," +
          "    name VARCHAR(100) NOT NULL" +
          "      UNIQUE," +
          "    description VARCHAR(191) NOT NULL," +
          "    type_id INTEGER" +
          "      REFERENCES account_types," +
          "    is_deleted boolean default false NOT NULL," +
          "    owner_id INTEGER NOT NULL" +
          "      REFERENCES users," +
          "    is_public boolean default false NOT NULL" +
          "  );",

        CREATE_ACCOUNT_TEMPLATES:
          "create table if not exists account_templates" +
          "  (" +
          "    id INTEGER NOT NULL" +
          "      PRIMARY KEY," +
          "    number VARCHAR(191) NOT NULL" +
          "      UNIQUE," +
          "    name VARCHAR(100) NOT NULL" +
          "      UNIQUE," +
          "    description VARCHAR(191) NOT NULL," +
          "    type_id INTEGER" +
          "      REFERENCES account_types," +
          "    is_deleted boolean NOT NULL," +
          "    created_at TIMESTAMP(0)," +
          "    updated_at TIMESTAMP(0)" +
          "  );",

        CREATE_TRANSACTION_STACKS:
          "create table if not exists transaction_stacks" +
          "  (" +
          "    id INTEGER NOT NULL" +
          "      PRIMARY KEY," +
          "    name VARCHAR(64)" +
          "  );",

        CREATE_TRANSACTIONS:
          "create table if not exists transactions" +
          "  (" +
          "    id INTEGER NOT NULL" +
          "      PRIMARY KEY," +
          "    created_at TIMESTAMP(0)," +
          "    updated_at TIMESTAMP(0)," +
          "    stack_id INTEGER NOT NULL" +
          "      REFERENCES transaction_stacks," +
          "    TIMESTAMP_booking TIMESTAMP(0) NOT NULL," +
          "    account_id INTEGER NOT NULL" +
          "      REFERENCES accounts," +
          "    creator_id INTEGER NOT NULL" +
          "      REFERENCES users," +
          "    description VARCHAR(191) NOT NULL," +
          "    amount DOUBLE PRECISION NOT NULL" +
          "  );",

        CREATE_TRANSACTION_USERS:
          "create table if not exists transaction_users" +
          "  (" +
          "    id INTEGER NOT NULL" +
          "      PRIMARY KEY," +
          "    user_id INTEGER NOT NULL" +
          "      REFERENCES users," +
          "    transaction_id INTEGER NOT NULL" +
          "      REFERENCES transactions," +
          "      UNIQUE (transaction_id, user_id)" +
          "  );",

        CREATE_TRANSACTION_TEMPLATES:
          "create table if not exists transaction_templates" +
          "  (" +
          "    id INTEGER NOT NULL" +
          "      PRIMARY KEY," +
          "    created_at TIMESTAMP(0)," +
          "    updated_at TIMESTAMP(0)," +
          "    TIMESTAMP_booking TIMESTAMP(0) NOT NULL," +
          "    account_id INTEGER NOT NULL" +
          "      REFERENCES accounts," +
          "    creator_id INTEGER NOT NULL" +
          "      REFERENCES users," +
          "    description VARCHAR(191) NOT NULL," +
          "    amount DOUBLE PRECISION NOT NULL" +
          "  );",

        CREATE_TRANSACTION_TEMPLATE_USERS:
          "create table if not exists transaction_template_users" +
          "  (" +
          "    id INTEGER NOT NULL" +
          "      PRIMARY KEY," +
          "    user_id INTEGER NOT NULL" +
          "      REFERENCES users," +
          "    transaction_template_id INTEGER NOT NULL" +
          "      REFERENCES transaction_templates" +
          "  );",

        CREATE_TRANSACTION_TAGS:
          "create table if not exists transaction_tags" +
          "  (" +
          "    id INTEGER NOT NULL" +
          "      PRIMARY KEY," +
          "    name VARCHAR(64) NOT NULL" +
          "  );",

        CREATE_TRANSACTION__TRANSACTION_TAGS:
          "create table if not exists transaction_transaction_tag" +
          "  (" +
          "    id INTEGER NOT NULL" +
          "      PRIMARY KEY," +
          "    transaction_tag_id INTEGER NOT NULL" +
          "      REFERENCES transaction_tags," +
          "    transaction_id INTEGER NOT NULL" +
          "      REFERENCES transactions" +
          "  );",
      },


      /**
       * Contains all the queries to drop the database tables.
       */
      DROP_QUERIES: {
        // TODO JS objects aren't ordered, but the execution order is!!! => Find a ordered datastructure!

        DROP_MIGRATIONS:
          "drop table if exists migrations;",

        DROP_USERS:
          "drop table if exists users;",

        DROP_ACCOUNTS:
          "drop table if exists accounts;",

        DROP_ACCOUNT_TEMPLATES:
          "drop table if exists account_templates;",

        DROP_TRANSACTION_STACKS:
          "drop table if exists transaction_stacks;",

        DROP_TRANSACTIONS:
          "drop table if exists transactions;",

        DROP_TRANSACTION_USERS:
          "drop table if exists transaction_users;",

        DROP_TRANSACTION_TEMPLATES:
          "drop table if exists transaction_templates;",

        DROP_TRANSACTION_TEMPLATE_USERS:
          "drop table if exists transaction_template_users;",

        DROP_TRANSACTION_TAGS:
          "drop table if exists transaction_tags;",

        DROP_TRANSACTION__TRANSACTION_TAGS:
          "drop table if exists transaction_transaction_tag;",
      },
    };
  },

  methods: {
    /**
     * Create all tables in the given sql.js database.
     *
     * @param {sqljs.Database} database An opened database of (npm package) sql.js
     */
    createAllTables: function(database) {
      // TODO Ensure database is a sql.js object

      let statement = null;
      for (const [key, query] of Object.entries(this.CREATE_QUERIES)) {
        // Prepare query for database
        statement = database.prepare(query);

        // Run each statement on database
        statement.run();
      }
    },

    /**
     * TODO Doc me!
     *
     * @param {string} tableName The name of the table
     * @param {sqljs.Database} database The SQLite database to execute.
     */
    createTable: function(tableName, database) {
      // TODO Implement me!
    },


    /**
     * Contains the queries to drop all database tables.
     *
     * @param {sqljs.Database} database The SQLite database to execute.
     */
    dropAll: function(database) {
      /**
       * Drop all tables in the given sql.js database.
       *
       * @param {sqljs.Database} database An opened database of (npm package) sql.js
       */
      // TODO Ensure database is a sql.js object

      for (const item of Object.entries(migrations.createTables.queries)) {
        // Run each migration on database
        database.run(item);
      }
    },

    /**
     * TODO Doc me!
     *
     * @param {string} tableName The name of the table
     * @param {sqljs.Database} database The SQLite database to execute.
     */
    dropAllTables: function(tableName, database) {
      // TODO Implement me!
    },
  },

};
