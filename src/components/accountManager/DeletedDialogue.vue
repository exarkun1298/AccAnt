<template>
  <v-dialog v-model="showDialogue" max-width="900px">
    <v-card>
      <v-card-title>Gelöschte Accounts</v-card-title>
      <div class="text-xs-center">
        <v-progress-circular size="30" v-if="isLoading" indeterminate color="primary"></v-progress-circular>
      </div>
      <div v-if="!isLoading">
        <accant-account-table
          :tableName="'deletedAccounts'"
          :tableaction="'redo'"
          :webrouteForTableData="'/api/get-deleted-table'"
          :accountTableHeaders="newTableHeaders"
        ></accant-account-table>
      </div>
    </v-card>
  </v-dialog>
</template>

<script>
import Axios from "axios";
import { snackBarEventBus } from "../../main.js"; //for displaying Snackbars
import { accountManagerEventBus } from "../../main.js"; //for communicating with the other components
import AccountTable from "./accountTable.vue";

export default {
  components: {
    "accant-account-table": AccountTable
  },

  props: {
    accountTableHeaders: {
      type: Array,
      default: []
    }
  },

  data() {
    return {
      showDialogue: false,
      newTableHeaders: [],
      isLoading: true
    };
  },

  watch: {
    showDialogue() {
      if (this.showDialogue == true) {
        accountManagerEventBus.$emit("updateAccountData", "deletedAccounts");
      }
    }
  },

  created() {
    accountManagerEventBus.$on("dataLoaded", () => {
      this.isLoading = false;
    });
    accountManagerEventBus.$on("closeDialogue", dialogueType => {
      if (dialogueType == "deleted") {
        this.showDialogue = false;
      }
    });

    accountManagerEventBus.$on("openDialogue", dialogueType => {
      if (dialogueType == "deleted") {
        this.showDialogue = true;
      }
    });
  },

  mounted() {
    this.newTableHeaders = JSON.parse(JSON.stringify(this.accountTableHeaders));
    this.newTableHeaders[4].text = "Account reaktivieren";
  }
};
</script>

<style>
</style>
