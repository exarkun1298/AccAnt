<template>
  <!-- Send button -->
  <v-layout row wrap justify-space-between>
    <v-flex>
      <v-card>
        <v-card-actions>
          <v-btn @click="send">Send</v-btn>
        </v-card-actions>
      </v-card>
    </v-flex>
  </v-layout>
</template>

<script>
import Axios from "axios";
import { snackBarEventBus } from "../../../main.js"; //for displaying Snackbars
export default {
  computed: {
    recordQueue() {
      return this.$store.state.transactionsForm.recordQueue;
    }
  },
  methods: {
    emptyRecordQueue() {
      this.$store.commit("transactionsForm/emptyRecordQueue");
    },

    emptyTransactionForm() {
      this.$store.commit("transactionsForm/clearTransactionForm");
    },

    /**
     * @implements transactionDatabaseMixin
     */
    send() {
      this.sendTransactionsToDatabase(this.recordQueue);
    },

    /**
     * @implements snackBarEventBus
     *
     * @param {int} stackID unique ID for every transaction stack provided by the backend
     * @param {Array} transactionData correctly formatted transaction data @type Object
     * {
     * timestamp_booking: @type String | Example "21.12.2018"
     * account_number: @type Integer
     * description: @type Integer
     * amount: @type Float
     * counter_account_number: @type Integer
     * tags: @type String
     * }
     *
     * @return void
     * @async a transaction gets send to the backend, a snackbar will inform the user on the status of the operation
     */
    sendTransactionsToDatabase(transactionData) {
      let transactionsQueue = {};
      transactionsQueue = {
        transactions: transactionData
      };
      // initialize it in a proper way for the backend to interpret is correctly
      // add the data provided by the user

      Axios.post("/api/insert-multiple-transactions", transactionsQueue).then(
        answer => {
          //empty the table and reset the form
          this.emptyTransactionForm();
          this.emptyRecordQueue();

          //show the snackbar depending on the answer
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
    }
  }
};
</script>

<style>
</style>
