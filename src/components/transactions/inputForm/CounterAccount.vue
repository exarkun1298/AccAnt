<template>
  <v-layout
    justify-space-between
    ref="accountNumberWrapper"
    :align-end="alignAccNoIconEnd"
    :align-center="alignAccNoIconCenter"
    v-if="counterbookingShow"
  >
    <v-flex xs3>
      <v-text-field
        @keyup.enter.stop="submit"
        ref="refcontra"
        label="Gegenkonto"
        required
        :value="counterAccountNumber"
        @input="updateCounterAccount($event)"
        :hide-details="!displayHelptext"
        persistent-hint
        hint="Bei Eingabe einer zulässigen Kontonummer wird automatisch die Gegenbuchung hinzugefügt."
        @change="autocompleteCounterAccountName(counterAccountNumber)"
      ></v-text-field>
    </v-flex>

    <v-flex xs1 ml-3 class="text-xs-left">
      <v-icon
        dark
        @click="showAccountDialogue({
                   sender: 'counteraccount'
                    })"
      >book</v-icon>
    </v-flex>

    <v-flex xs8 align-end>
      <v-text-field
        dense
        :disabled="true"
        label="Gegenkontoname"
        :value="counterAccountName"
        :hide-details="!displayHelptext"
        hint="Wird bei Eingabe der Gegenkontonummer automatisch befüllt. Auswahl über Icon möglich."
        persistent-hint
      ></v-text-field>
    </v-flex>
  </v-layout>
</template>

<script>
import { transactionEventBus } from "../../../main.js"; //for communicating with te other transaction components
import { basicDatabaseFetchersMixin } from "../../reusables/basicDatabaseFetchersMixin.js"; //mixin for basic database Queries

export default {
  mixins: [basicDatabaseFetchersMixin],
  data() {
    return {
      contraaccname: null,
      alignAccNoIconEnd: true,
      alignAccNoIconCenter: false
    };
  },
  computed: {
    contra() {
      return this.$store.state.transactions.counterAccount;
    },

    counterAccountNumber() {
      return this.$store.state.transactionsForm.counterAccountNumber;
    },

    counterAccountName() {
      return this.$store.state.transactionsForm.counterAccountName;
    },

    counterbookingShow() {
      //boolean, determines if counterBooking input field should be displayed
      return this.$store.state.transactions.counterbookingShow;
    },
    displayHelptext() {
      this.alignAccNoIconEnd = !this.alignAccNoIconEnd;
      this.alignAccNoIconCenter = !this.alignAccNoIconCenter;
      return this.$store.state.transactionsForm.displayhelptexts;
    }
  },

  created: function() {
    var self = this;
    transactionEventBus.$on("changeCounterAccountNumber", toNumber => {
      self.updateCounterAccount(toNumber);
      self.autocompleteCounterAccountName(toNumber);
    });
  },

  methods: {
    /**
     * @param {int} e
     * A Reactive Setter which takes an account number and updates the
     * corresponding VueX property
     */
    updateCounterAccount(e) {
      this.$store.commit("transactionsForm/updateCounterAccount", e);
      if (this.contra) {
        this.$store.commit(
          "transactions/changeCounterBookingCheckboxState",
          true
        );
      } else {
        this.$store.commit(
          "transactions/changeCounterBookingCheckboxState",
          false
        );
      }
    },

    updateCounterAccountName(e) {
      this.$store.commit("transactionsForm/updateCounterAccountName", e);
    },

    /**
     * Fetches the account name of a given account and assigns it to the property to be the
     * account or counter account
     *
     * @implements basicDataBaseFetchersMixin
     * @param {int} accountNumber search for this account number
     */
    autocompleteCounterAccountName(accountNumber) {
      let basicDataBaseFetchersMixin = this;
      let response = basicDataBaseFetchersMixin
        .searchForAccountName(accountNumber)
        .then(answer => {
          let accountName = answer.data.account.name;
          this.updateCounterAccountName(accountName);
          console.log("autocomplete search for " + accountName + " finished");
          this.$store.commit(
            "transactionsForm/toggleCheckboxCounterBooking",
            true
          );
          this.$store.commit(
            "transactionsForm/toggleCounterBookingCBValue",
            true
          );
        });
    },

    showAccountDialogue(source) {
      transactionEventBus.$emit("openAccDialogue", source);
    }
  }
};
</script>

<style>
</style>
