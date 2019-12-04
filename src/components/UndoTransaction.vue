<template>
  <div>
    <h1 headline>Buchungen umkehren</h1>
    <v-subheader></v-subheader>
    <div class="text-xs-center">
      <v-progress-circular size="100" v-if="isLoading" indeterminate color="primary"></v-progress-circular>
    </div>

    <v-expansion-panel v-if="!isLoading">
      <v-expansion-panel-content v-for="(stackObject,i) in stackIDObject" :key="i">
        <div slot="header">Buchungsstapel: {{stackObject.stack}} vom {{stackObject.date}}</div>
        <v-card>
          <v-btn @click="undoTransaction(stackObject.transactionData)" row ml-4>Buchungen stornieren</v-btn>
          <accant-transaction-table
            row
            :sortDescending="true"
            :tableData="stackObject.transactionData"
            :useFormattedTags="true"
          ></accant-transaction-table>
        </v-card>
      </v-expansion-panel-content>
    </v-expansion-panel>
  </div>
</template>

<script>
import Axios from "axios";
import TransactionTable from "./reusables/TransactionTable.vue";
import { snackBarEventBus } from "../main.js"; //for displaying Snackbars
import { basicDatabaseFetchersMixin } from "./reusables/basicDatabaseFetchersMixin.js";
//import { transactionDataMixin } from "./transactions/transactionDataMixin.js";

export default {
  mixins: [basicDatabaseFetchersMixin],
  components: {
    "accant-transaction-table": TransactionTable
  },

  data: () => ({
    stackIDObject: [],
    isLoading: false,
    accountIDTable: [],
    rawData: null
  }),

  beforeMount() {
    this.getTransactionsGroupedByStacks();
  },

  methods: {
    getTransactionsGroupedByStacks() {
      this.isLoading = true;
      this.stackIDObject = [];

      Axios.get("/api/get-grouped-transactions").then(answer => {
        //get data from response

        this.stackIDObject = Object.values(answer.data).reverse();

        this.isLoading = false;
      });
    },

    undoTransaction(transactionsToUndo) {
      let undoneTransactions = [];

      let todayDate = new Date();
      let day = ("0" + todayDate.getDate()).slice(-2);
      let month = ("0" + (todayDate.getMonth() + 1)).slice(-2);
      let year = todayDate.getFullYear();

      let formattedDate = day + "." + month + "." + year;

      Axios.get("/api/generate-transaction-guid").then(answerGUID => {
        Axios.get("/api/get-account-id-table")

          .then(answerAccountIDs => {
            this.accountIDTable = JSON.parse(answerAccountIDs.data);
            console.log(this.accountIDTable);
          })

          .then(answerAccountIDs => {
            //this routine loops through all transactions,
            //creates a deep copy and make the amount negative
            //finally a database-ready transaction is made and sent
            transactionsToUndo.forEach(transaction => {
              let deepCopyTransaction = JSON.parse(JSON.stringify(transaction));
              let newTransaction = this.createTransactionFromRawDatabaseData(
                deepCopyTransaction,
                answerGUID.data.guid,
                formattedDate
              );
              //console.log(newTransaction);
              undoneTransactions.push(newTransaction);
            });

            let transactionsToSend = {
              transactions: undoneTransactions,
              stack_id: answerGUID.data.guid
            };

            //double Code in transaction Mixin! To Do!
            Axios.post(
              "/api/insert-multiple-transactions",
              transactionsToSend
            ).then(
              answer => {
                //route as specified in routes/web.php //data
                //console.log(answer);
                this.getTransactionsGroupedByStacks();

                //show the snackbar depending on the answer

                snackBarEventBus.$emit("onShowSnackBar", {
                  message: answer.data.message,
                  icon: "check_circle"
                });
              },

              error => {
                //console.log(error);
                //show the snackbar depending on the error
                snackBarEventBus.$emit("onShowSnackBar", {
                  message: error.response.data.message,
                  icon: "warning"
                });
                // TODO What to do now (retry, inform user, etc.)?
              }
            );
          });
      });
    },

    //To Fix account id and account number
    createTransactionFromRawDatabaseData(
      rawTransaction,
      newStackID,
      timestamp
    ) {
      //first: map account id to account number

      var formattedTransaction = {
        stack_id: newStackID,
        timestamp_booking: timestamp,
        account_number: 1200,
        description: "Generalumkehr von Stapel " + rawTransaction.stack_id,
        amount: (rawTransaction.amount *= -1),
        counter_account_number: 1200,
        tags: rawTransaction.tags
      }; //can be null at this point
      return formattedTransaction;
    }
  }
};
</script>

<style>
</style>