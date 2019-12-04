<template>
  <div>
    <v-layout fluid>
      <v-flex xs12 sm12>
        <v-card dark>
          <v-card-title primary-title>
            <h3 class="headline">Kontenverwaltung</h3>
          </v-card-title>
          <v-card-text>Diese Seite dient zum Konten erstellen, Konten löschen oder zur Anwendung einer Standardvorlage</v-card-text>
          <v-card-actions>
            <v-btn flat color="indigo accent-1" @click.stop="openDialogue('simple')">Neues Konto</v-btn>
            <v-btn flat color="indigo accent-1" @click.stop="openDialogue('advanced')">Vorlagen</v-btn>
            <v-btn
              flat
              color="indigo accent-1"
              @click.stop="openDialogue('deleted')"
            >gelöschte Konten</v-btn>
          </v-card-actions>
        </v-card>

        <accant-account-manager-deleted-dialogue :accountTableHeaders="accountHeaders"></accant-account-manager-deleted-dialogue>

        <accant-account-manager-simple-dialogue></accant-account-manager-simple-dialogue>

        <accant-account-manager-advanced-dialogue :accountTableHeaders="accountHeaders"></accant-account-manager-advanced-dialogue>
      </v-flex>
    </v-layout>

    <accant-account-table
      :tableName="'accountsInUse'"
      :tableaction="'delete'"
      :webrouteForTableData="'/api/get-account-table'"
      :accountTableHeaders="accountHeaders"
    ></accant-account-table>
  </div>
</template>

<script>
import Axios from "axios";
import { accountManagerEventBus } from "../../main.js"; //for communicating with the other components
import { snackBarEventBus } from "../../main.js"; //for displaying Snackbars
import AccountTable from "./accountTable.vue";
import AdvancedDialogue from "./AdvancedDialogue.vue";
import SimpleDialogue from "./SimpleDialogue.vue";
import DeletedDialogue from "./DeletedDialogue.vue";

export default {
  components: {
    "accant-account-table": AccountTable,
    "accant-account-manager-advanced-dialogue": AdvancedDialogue,
    "accant-account-manager-simple-dialogue": SimpleDialogue,
    "accant-account-manager-deleted-dialogue": DeletedDialogue
  },

  data() {
    return {
      accountHeaders: [
        {
          text: "AccountID",
          value: "accountid",
          align: "center",
          sortable: "true"
        },
        {
          text: "Accountnummer",
          value: "accountnummer",
          align: "center",
          sortable: true
        },
        {
          text: "Accountname",
          value: "accountname",
          align: "center",
          sortable: true
        },
        {
          text: "Beschreibung",
          value: "accountdesc",
          align: "center",
          sortable: true
        },
        {
          text: "Account Löschen",
          value: "deleteaccount",
          align: "center",
          sortable: false
        }
      ]
    };
  },

  created() {
    accountManagerEventBus.$on("reactivateAccount", data => {
      this.reactivateAccount(data.account_id, data.sourceDialogueName);
    });
  },

  methods: {
    openDialogue(type) {
      accountManagerEventBus.$emit("openDialogue", type);
    },

    reactivateAccount(account_id, sourceDialogue) {
      Axios.post(
        "/api/reactivate-single-account", //route as specified in routes/web.php
        { account_id: account_id } //data
      ).then(answer => {
        accountManagerEventBus.$emit("closeDialogue", sourceDialogue);
        accountManagerEventBus.$emit("updateAccountData", "accountsInUse");
        accountManagerEventBus.$emit("emptyDialogue", sourceDialogue);

        snackBarEventBus.$emit("onShowSnackBar", {
          message: answer.data.message,
          icon: "check_circle",
          duration: 5000
        });

        this.accountForReactivation = {};
      });
    }
  }
};
</script>

<style scoped>
</style>