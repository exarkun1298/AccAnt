/**
 * This Mixin covers the database communication for sending transactions
 * to the database
 */


import Axios from "axios";
import {
  snackBarEventBus
} from "../../main.js"; // for displaying Snackbars

export const importDatabaseMixin = {

  data() {
    return {
      accountTable: [],
    }
  },


  methods: {

    submitTransactions: function () {
      // Create data package (to send a bunch of transactions at once).
      const transactionPackage = this.createTransactionPackage();

      // Send the data to the backend
      this.sendTransactionsToDatabase(transactionPackage);
    },

    /**
     * @implements snackBarEventBus
     *
     * @param {int} stackID unique ID for every transaction stack provided by the backend
     * @param {array} transactionData correctly formatted transaction data @type Object
     * {
     *   stack_id @type Integer
     *   timestamp_booking: @type String | Example "21.12.2018"
     *   account_number: @type Integer
     *   description: @type Integer
     *   amount: @type Float
     *   other_account: @type Integer
     *   tags: @type String
     * }
     *
     * @return void
     * @async a transaction gets send to the backend, a snackbar will inform the user on the status of the operation
     */
    sendTransactionsToDatabase(transactionData) {
      // initialize it in a proper way for the backend to interpret is correctly
      // add the data provided by the user
      const transactionsToSend = transactionData;

      //debug output
      console.log("This many Transactions are in the Controller: #" +
        transactionsToSend.transactions ? transactionsToSend.transactions.length : 0);

      Axios.post(
        "/api/import-transactions",
        transactionsToSend
      ).then(
        answer => {
          //route as specified in routes/web.php //data
          console.log(answer);

          //show the snackbar depending on the answer

          // Empty transactionsToSend array for next usage
          let transactionsToSend = [];

          snackBarEventBus.$emit("onShowSnackBar", {
            message: answer.data.message,
            icon: "check_circle"
          });
        },

        error => {
          console.log(error);
          snackBarEventBus.$emit("onShowSnackBar", {
            message: error.response.data.message,
            icon: "warning"
          });
          /**
           * @todo What to do now(retry, inform user, etc.) ?
           */
        }
      );
    },


    /**
     * Submit the data to import to the backend.
     */
    createTransactionPackage: function () {
      // Create JSON structure for Backend
      let transactions = {
        headers: this.importHeaders,
        transactions: this.preprocessData(this.importData),
      };

      return transactions;
    },


    /**
     * Preprocess the data to fit the format the backend expects.
     *
     * @param {array} transactions The imported transactions
     */
    preprocessData: function (transactions) {
      switch (this.selectedSource.name) {
        case this.importer.accant:
          return preprocessAccAnt(transactions);
        case this.importer.sparkasse:
          return preprocessSparkasse(transactions);
        default:
          throw {
            name: "NotImplementedException",
            message: "The selected importer '" + this.importer + "' is not supported or not implemented.",
            toString: function () {
              return this.name + ": " + this.message;
            }
          };
      }


      function preprocessAccAnt(transactions) {
        // TODO Implement this!
      }

      function preprocessSparkasse(transactions) {
        // The preprocessed transactions
        const processedTransactions = transactions.map(transaction => {
          var dateParts = transaction[0].match(/(\d+)/g);
          return {
            // Convert the German "Buchungstag" (day of booking) of Sparkasse into ISO date
            0: new Date(dateParts[2], dateParts[1] - 1, dateParts[0]) // parse from (short) German format; month is 0-indexed
              .toISOString(), // Format in ISO

            1: transaction[1],

            // Remove all thousand separator "." and repalce decimal separator "," with international "."
            2: transaction[2]
              .replace(/\./g, '') // see https://stackoverflow.com/a/832262/1700776
              .replace(',', '.'),

            3: transaction[3],
          }
        });

        return processedTransactions;
      }
    },

  },
}
