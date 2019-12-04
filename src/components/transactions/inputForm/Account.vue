<template>
  <v-layout
    justify-space-between
    ref="accountNumberWrapper"
    :align-end="alignAccNoIconEnd"
    :align-center="alignAccNoIconCenter"
  >
    <v-flex xs3>
      <v-text-field
        :label="accountnumberDescription"
        ref="refaccno"
        :value="accountNumber"
        @input="updateAccountNumber($event)"
        @change="autocompleteAccountName(accountNumber)"
        required
        dense
        item-text="description"
        item-value="number"
        :hide-details="!displayHelptext"
        hint="Muss eine existierende Kontonummer enthalten."
        persistent-hint
      ></v-text-field>
    </v-flex>

    <v-flex xs1 ml-3 class="text-xs-left">
      <v-icon
        dark
        @click="showAccountDialogue({
                    sender: 'account'
                    })"
      >book</v-icon>
    </v-flex>

    <v-flex xs8 align-end>
      <v-text-field
        dense
        :disabled="true"
        label="Kontoname"
        :value="accountName"
        :hide-details="!displayHelptext"
        hint="Wird bei Eingabe der Kontonummer automatisch befüllt. Auswahl über Icon möglich."
        persistent-hint
      ></v-text-field>
    </v-flex>
  </v-layout>
</template>

<script>
import AccountDialogue from "../elementals/AccountDialogue.vue"; //component for displaying avaliable accounts
import { transactionEventBus } from "../../../main.js"; //for communicating with te other transaction components
import { basicDatabaseFetchersMixin } from "../../reusables/basicDatabaseFetchersMixin.js"; //mixin for basic database Queries

export default {
  mixins: [basicDatabaseFetchersMixin],
  data() {
    return {
      alignAccNoIconEnd: true,
      alignAccNoIconCenter: false
    };
  },

  created: function() {
    var self = this;
    transactionEventBus.$on("changeAccountNumber", toNumber => {
      self.updateAccountNumber(toNumber);
      self.autocompleteAccountName(toNumber);
    });
  },

  computed: {
    accountNumber() {
      return this.$store.state.transactionsForm.accountNumber;
    },

    accountName() {
      return this.$store.state.transactionsForm.accountName;
    },

    accountnumberDescription() {
      //label of the accno input field
      return this.$store.state.transactions.accountnumberDescription;
    },

    accountnameDescription() {
      //label of the accname input field
      return this.$store.state.transactions.accountnameDescription;
    },
    displayHelptext() {
      this.alignAccNoIconEnd = !this.alignAccNoIconEnd;
      this.alignAccNoIconCenter = !this.alignAccNoIconCenter;
      return this.$store.state.transactionsForm.displayhelptexts;
    }
  },

  methods: {
    updateAccountNumber(e) {
      this.$store.commit("transactionsForm/updateAccountNumber", e);
    },

    updateAccountName(e) {
      this.$store.commit("transactionsForm/updateAccountName", e);
    },

    /**
     * Fetches the account name of a given account and assigns it to the property to be the
     * account or counter account
     *
     * @implements basicDataBaseFetchersMixin
     * @param {int} accountNumber search for this account number
     */
    autocompleteAccountName(accountNumber) {
      let basicDataBaseFetchersMixin = this;
      let response = basicDataBaseFetchersMixin
        .searchForAccountName(accountNumber)
        .then(answer => {
          let accountName = answer.data.account.name;
          this.updateAccountName(accountName);
          console.log("autocomplete search for " + accountName + " finished");
        });
    },

    /**
     * Shows a dialogue to pick an account. The dialogue picker automatically fills in the account number into the form
     * @param source as Object
     * @example source = {displaytext: 'Konto', returnTo: 'Konto'}
     * @returns void
     * @see /AccountDialogue.vue
     */
    showAccountDialogue(source) {
      transactionEventBus.$emit("openAccDialogue", source);
    }
  }
};
</script>

<style>
</style>
