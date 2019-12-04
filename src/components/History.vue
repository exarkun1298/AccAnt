<template>
  <div>
    <h1>History</h1>
    <accant-transaction-table :tableData="transactionTableDataRepresentation"></accant-transaction-table>
  </div>
</template>


<script>
import TransactionTable from "./reusables/TransactionTable.vue"; //component for displaying the TransactionsTable
import Axios from "axios";
import { basicDatabaseFetchersMixin } from "./reusables/basicDatabaseFetchersMixin.js";
export default {
  mixins: [basicDatabaseFetchersMixin],
  mounted: function() {
    this.getAllTransactionsOfUser();
  },

  components: {
    "accant-transaction-table": TransactionTable
  }
};
</script>

<style>
</style>