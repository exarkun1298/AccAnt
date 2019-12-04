<!--
  The TransactionUI Component shows an input form based on the selection in the navbar

  There are different rendering options.
  These options are determined by the VueX store ../../store/transactionModule.js
  Depending on the users selection, a certain mutation gets executed ../../AccAntAoo.vue, method changeCmp
  The adjusted values get updated by the computed properties

  Logic and validation is handled by the folders mixins

-->
<template>
  <div>
    <accant-account-dialogue-for-transactions></accant-account-dialogue-for-transactions>

    <v-tabs v-model="tabActive" color="blue-grey darken-4" dark slider-color="blue-grey darken-1">
      <v-tab
        ripple
        @click="changeUIState({
          state: 'fastcash', 
          mutation: 'switchTransactionStateToCashSimple'
          })"
      >Schnellbuchung</v-tab>
      <v-tab
        @click="changeUIState({
          state: 'cash', 
          mutation: 'switchTransactionStateToCash'
          })"
        ripple
      >Barbuchung</v-tab>

      <v-tab
        ripple
        @click="changeUIState({
          state: 'bank', 
          mutation: 'switchTransactionStateToBank'
          })"
      >Bankbuchung</v-tab>

      <v-tab
        ripple
        @click="changeUIState({
          state: 'detail',
          mutation: 'switchTransactionStateToDetail'
          })"
      >Detailbuchung</v-tab>
      <v-tab-item v-for="n in 4" :key="n">
        <v-card>
          <v-card-text>
            <v-form v-model="valid" ref="form" lazy-validation>
              <v-flex>
                <accant-uiform-checkboxhelp></accant-uiform-checkboxhelp>
                <!-- A Checkbox to determine the verbosity of the input form -->
                <accant-uiform-datepicker></accant-uiform-datepicker>
              </v-flex>

              <accant-uiform-account></accant-uiform-account>
              <accant-uiform-booktext></accant-uiform-booktext>
              <accant-uiform-amount></accant-uiform-amount>
              <accant-uiform-counteraccount></accant-uiform-counteraccount>
              <accant-uiform-checkbox-counterbooking></accant-uiform-checkbox-counterbooking>
              <accant-uiform-tags></accant-uiform-tags>
              <v-subheader></v-subheader>
            </v-form>
          </v-card-text>
        </v-card>
      </v-tab-item>
    </v-tabs>

    <accant-data-arranger></accant-data-arranger>
    <accant-data-sender></accant-data-sender>
    <accant-checksum-indicator></accant-checksum-indicator>

    <!-- component DataTable -->
    <accant-transaction-table :showDeletionButton="true">
      <!--
      @tableData  
      Prop for component
      see also transactionDataMixin
      -->
    </accant-transaction-table>

    <v-subheader></v-subheader>
  </div>
</template>

<script>
import Axios from "axios";
import TransactionTable from "./elementals/TransactionTable.vue"; //component for displaying the TransactionsTable
import AccountDialogue from "./elementals/AccountDialogue.vue"; //component for displaying avaliable accounts
import DataArranger from "./elementals/DataArranger.vue";
import DataSender from "./elementals/DataSender.vue";
import ChecksumIndicator from "./elementals/ChecksumIndicator.vue";

import FormCheckBoxHelp from "./inputForm/CheckboxHelp.vue";
import FormDatePicker from "./inputForm/DatePicker.vue";
import FormAccount from "./inputForm/Account.vue";
import FormBooktext from "./inputForm/Booktext.vue";
import FormAmount from "./inputForm/Amount.vue";
import FormCounterAccount from "./inputForm/CounterAccount.vue";
import FormCheckBoxCounterBooking from "./inputForm/CheckboxCounterBooking.vue";
import FormTags from "./inputForm/Tags.vue";

import { snackBarEventBus } from "../../main.js"; //for displaying Snackbars
import { transactionEventBus } from "../../main.js"; //for communicating with te other transaction components

import { basicDatabaseFetchersMixin } from "../reusables/basicDatabaseFetchersMixin.js"; //mixin for basic database Queries

/* import { mapGetters } from "vuex";  */ export default {
  mixins: [basicDatabaseFetchersMixin], //registering mixins

  props: {
    storeMutation: {
      type: String,
      default: "transactions/switchTransactionStateToDetail"
    }
  },

  components: {
    "accant-transaction-table": TransactionTable,
    "accant-account-dialogue-for-transactions": AccountDialogue,
    "accant-data-arranger": DataArranger,
    "accant-data-sender": DataSender,
    "accant-checksum-indicator": ChecksumIndicator,
    "accant-uiform-checkboxhelp": FormCheckBoxHelp,
    "accant-uiform-datepicker": FormDatePicker,
    "accant-uiform-account": FormAccount,
    "accant-uiform-booktext": FormBooktext,
    "accant-uiform-amount": FormAmount,
    "accant-uiform-counteraccount": FormCounterAccount,
    "accant-uiform-checkbox-counterbooking": FormCheckBoxCounterBooking,
    "accant-uiform-tags": FormTags
  },

  data() {
    return {
      tabActive: null,
      valid: true

      /*Default input field values */
    };
  },

  computed: {
    heading() {
      //subheader
      return this.$store.state.transactions.heading;
    }
  },

  //on mounting the Transactions scaffold
  mounted: function() {
    //this.$store.commit(this.storeMutation);
    this.$store.commit("transactionsForm/clearTransactionForm");
    this.determineUIState();
    //this.$refs.refaccno.focus(); //focus the Accountnumber input field
    this.getAccountTableFromDatabase();
  },

  methods: {
    /**
     * sets UI state and Navigation Tabs to routed UI State
     */
    determineUIState() {
      let url = this.$route.path;
      let mutation = this.$route.meta.storeMutation;
      let tab = this.$route.meta.transactionUITab;

      this.changeUIState({ mutation: mutation });
      this.tabActive = tab;
    },

    /**
     * @param {Object} to
     * sets the UI state in VueX depending on users choice
     */
    changeUIState(to) {
      this.$store.dispatch("transactions/changeState", {
        mutation: to.mutation
      });
    }
  }
};
</script>

<style>
</style>