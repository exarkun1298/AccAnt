<template>
  <v-layout row wrap justify-space-between>
    <v-flex>
      <v-card>
        <v-card-actions>
          <v-btn @click="submit">submit</v-btn>
          <v-btn @click="clear">clear</v-btn>
        </v-card-actions>
      </v-card>
    </v-flex>
  </v-layout>
</template>

<script>
import { transactionEventBus } from "../../../main.js"; //for communicating with te other transaction components
import { snackBarEventBus } from "../../../main.js"; //for displaying Snackbars

import { basicDatabaseFetchersMixin } from "../../reusables/basicDatabaseFetchersMixin.js"; //mixin for basic database Queries

export default {
  data: () => ({
    counterRecord: {},
    accountTable: [],
    transactionTableDataRepresentation: []
  }),

  computed: {
    getRecord() {
      return this.$store.state.transactionsForm.record;
    },

    automaticCounterBooking() {
      return this.$store.state.transactionsForm.automaticCounterBooking;
    },

    getCounterRecord() {
      return this.$store.state.transactionsForm.counterRecord;
    },

    getRecordQueue() {
      return this.$store.state.transactionsForm.recordQueue;
    }
  },

  created: function() {
    transactionEventBus.$on("onDeleteTableElement", itemIndex => {
      this.$store.commit(
        "transactionsForm/deleteRecordQueueElement",
        itemIndex
      );
    });
  },

  methods: {
    updateRecordQueue(record) {
      this.$store.commit("transactionsForm/updateRecordQueue", record);
    },
    buildRecordFromForm() {
      this.$store.commit("transactionsForm/buildRecord");
    },

    buildCounterRecordFromForm() {
      this.$store.commit("transactionsForm/buildCounterRecord");
    },

    pushToRecordQueue() {
      this.buildRecordFromForm();
      this.buildCounterRecordFromForm();
      this.updateRecordQueue(this.getRecord);
      if (this.automaticCounterBooking) {
        this.updateRecordQueue(this.getCounterRecord);
      }
      this.showSuccessfulSnackbar();
    },

    showSuccessfulSnackbar() {
      snackBarEventBus.$emit("onShowSnackBar", {
        message: "Hinzugefügt",
        icon: "check_circle",
        duration: 1000
      });
    },

    clear() {
      this.$store.commit("transactionsForm/clearData");
    },

    submit() {
      this.pushToRecordQueue();
    }
  }
};
</script>

<style>
</style>
