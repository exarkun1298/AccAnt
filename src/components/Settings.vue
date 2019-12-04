<template>
  <v-container fluid px-0>
    <accant-account-dialogue-for-transactions></accant-account-dialogue-for-transactions>
    <v-layout justify-space-between align-center>
      <v-flex xs3>
        <v-text-field
          :label="'Standardkonto Bargeld'"
          ref="refaccno"
          :value="standardCash"
          @change="autocompleteAndSendAccount(standardCash, false)"
          @input="updateStandardCash($event)"
          required
          dense
          item-text="description"
          item-value="number"
          hint="Muss eine existierende Kontonummer enthalten."
        ></v-text-field>
      </v-flex>

      <v-flex xs1 ml-3 class="text-xs-left">
        <v-icon
          dark
          @click="showAccountDialogue({
                    displaytext: 'Bargeldkonto',
                    returnTo: 'cashname'
                    })"
        >book</v-icon>
      </v-flex>

      <v-flex xs8 align-end>
        <v-text-field
          dense
          :disabled="true"
          label="Kontoname"
          v-model="cashname"
          hint="Wird bei Eingabe der Kontonummer automatisch befüllt. Auswahl über Icon möglich."
        ></v-text-field>
      </v-flex>
    </v-layout>

    <v-layout justify-space-between align-center>
      <v-flex xs3>
        <v-text-field
          :label="'Standardkonto Bank'"
          ref="refaccno"
          :value="standardBank"
          @change="autocompleteAndSendAccount(standardBank, true)"
          @input="updateStandardBank($event)"
          required
          dense
          item-text="description"
          item-value="number"
          hint="Muss eine existierende Kontonummer enthalten."
        ></v-text-field>
      </v-flex>

      <v-flex xs1 ml-3 class="text-xs-left">
        <v-icon
          dark
          @click="showAccountDialogue({
                    displaytext: 'Bankkonto',
                    returnTo: 'bankname'
                    })"
        >book</v-icon>
      </v-flex>

      <v-flex xs8 align-end>
        <v-text-field
          dense
          :disabled="true"
          label="Kontoname"
          v-model="bankname"
          hint="Wird bei Eingabe der Kontonummer automatisch befüllt. Auswahl über Icon möglich."
        ></v-text-field>
      </v-flex>
    </v-layout>

    <v-checkbox :label="`Checkbox 1: ${checkbox.toString()}`" v-model="checkbox"></v-checkbox>
    <v-radio-group v-model="radioGroup">
      <v-radio v-for="n in 3" :key="n" :label="`Radio ${n}`" :value="n"></v-radio>
    </v-radio-group>
    <v-switch :label="`Switch 1: ${switch1.toString()}`" v-model="switch1"></v-switch>
  </v-container>
</template>

<script>
import AccountDialogue from "./transactions/elementals/AccountDialogue.vue"; //component for displaying avaliable accounts
import { snackBarEventBus } from "../main.js"; //for displaying Snackbars
import { transactionEventBus } from "../main.js"; //for communicating with te other transaction components
import { basicDatabaseFetchersMixin } from "./reusables/basicDatabaseFetchersMixin.js"; //mixin for basic database Queries
import Axios from "axios";

export default {
  mixins: [basicDatabaseFetchersMixin],
  methods: {
    updateStandardBank(e) {
      this.updateStandardAccounts({
        standardBank: e,
        standardCash: this.standardCash
      });
    },

    updateStandardCash(e) {
      this.updateStandardAccounts({
        standardBank: this.standardBank,
        standardCash: e
      });
    },

    updateStandardAccounts({ standardBank, standardCash }) {
      this.$store.commit("userSettings/changeStandardAccounts", {
        standardBank,
        standardCash
      });
    },

    autocompleteAndSendAccount(accountNumber, isBank) {
      let self = this;
      self
        .autocompleteAccount(accountNumber, isBank)
        .then(self.sendStandardAccounts());
    },

    /**
     * @todo solve redundancy with TransactionUI
     */
    autocompleteAccount(accountNumber, isBank) {
      let basicDatabaseFetchersMixin = this;
      return basicDatabaseFetchersMixin
        .searchForAccountName(accountNumber)
        .then(response => {
          let acc = response.account;
          if (isBank) {
            this.bankname = acc.name;
            updateStandardBank(acc.number);
          } else {
            this.cashname = acc.name;
            updateStandardCash(acc.number);
          }
        });
    },

    sendStandardAccounts() {
      Axios.post("/api/update-standard-accounts", {
        standard_bank: this.standardBank,
        standard_cash: this.standardCash
      }).then(() => {
        console.log(response);
      });
    },

    showAccountDialogue(source) {
      transactionEventBus.$emit("openAccDialogue", source);
    }
  },

  components: {
    "accant-account-dialogue-for-transactions": AccountDialogue
  },

  created() {
    /**
     * @todo solve redundancy with TransactionUI
     */
    transactionEventBus.$on("changeAccountNumber", (toNumber, target) => {
      console.log(target);
      switch (target) {
        case "bankname":
          this.updateStandardBank(toNumber);
          this.autocompleteAndSendAccount(toNumber, true);
          break;
        case "cashname":
          this.updateStandardCash(toNumber);
          this.autocompleteAndSendAccount(toNumber, false);
          break;
      }
    });
  },

  data() {
    return {
      cashname: null,
      bankname: null,
      checkbox: true,
      radioGroup: 1,
      switch1: true
    };
  },

  computed: {
    standardBank() {
      let bankAccountNumber = this.$store.state.userSettings
        .standardBankAccount;
      this.autocompleteAccount(bankAccountNumber, true);
      return bankAccountNumber;
    },
    standardCash() {
      let cashAccountNumber = this.$store.state.userSettings
        .standardCashAccount;
      this.autocompleteAccount(cashAccountNumber, false);
      return cashAccountNumber;
    }
  },

  mounted() {
    this.autocompleteAccount(this.standardBank, true);
    this.autocompleteAccount(this.standardCash, false);
  }
};
</script>

<style>
</style>