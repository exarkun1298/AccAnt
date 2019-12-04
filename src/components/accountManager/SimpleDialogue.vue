<template>
  <v-dialog v-model="showDialogue" max-width="500px">
    <v-dialog v-model="reactivationDialogue" width="500">
      <v-card>
        <v-card-title class="headline-grey-lighten-2">Konto existierte bereits!</v-card-title>
        <v-card-text>
          Sie sind im Begriff, ein Konto anzulegen, dessen Kontonummer bereits existiert hat,
          aber gelöscht wurde. Sie können das alte Konto reaktivieren (empfohlen):
          <br>
          <br>
          ID: {{accountForReactivation.id}}
          <br>
          Kontonummer: {{accountForReactivation.number}}
          <br>
          Kontoname: {{accountForReactivation.name}}
          <br>
          <br>
          <br>Sie können das alte Konto auch mit den neuen Daten überschreiben. Das ist
          nicht empfohlen da es zur schwerwiegenden Inkonsistenzen kommen kann
          (z.B. bei Auswertungen nach Konten).
        </v-card-text>
        <v-divider></v-divider>
        <v-card-actions>
          <v-spacer></v-spacer>
          <v-btn slot="activator" dark @click="overwriteAccount">Überschreiben</v-btn>
          <v-btn slot="activator" dark @click="reactivateAccount">Reaktivieren (empfohlen)</v-btn>
        </v-card-actions>
      </v-card>
    </v-dialog>

    <v-card>
      <v-card-title>Neuer Account</v-card-title>
      <v-card-text @keyup.enter="addNewAccount">
        <v-btn color="primary" dark @click.stop="addNewAccount">Hinzufügen</v-btn>
        <v-text-field
          id="accno"
          name="dialogueInputAccno"
          v-model="simpleDialogueAccountNumber"
          label="Accountnummer"
        ></v-text-field>
        <v-text-field
          id="accname"
          name="dialogueInputAccname"
          label="Accountname"
          v-model="simpleDialogueAccountName"
        ></v-text-field>
        <v-text-field
          id="accdesc"
          name="dialogueInputAccdesc"
          label="Beschreibung"
          v-model="simpleDialogueAccountDescription"
        ></v-text-field>
      </v-card-text>
      <v-card-actions>
        <v-btn color="primary" flat @click.stop="dialogueNewAccount=false">Close</v-btn>
      </v-card-actions>
    </v-card>
  </v-dialog>
</template>

<script>
import Axios from "axios";
import { snackBarEventBus } from "../../main.js"; //for displaying Snackbars
import { accountManagerEventBus } from "../../main.js"; //for communicating with the other components
import { basicDatabaseFetchersMixin } from "../reusables/basicDatabaseFetchersMixin.js";

export default {
  created() {
    accountManagerEventBus.$on("closeDialogue", dialogueType => {
      if (dialogueType == "simple") {
        this.reactivationDialogue = false;
        this.showDialogue = false;
      }
    });

    accountManagerEventBus.$on("openDialogue", dialogueType => {
      if (dialogueType == "simple") {
        this.showDialogue = true;
      }
    });

    accountManagerEventBus.$on("emptyDialogue", dialogueType => {
      if (dialogueType == "simple") {
        (this.simpleDialogueAccountNumber = null),
          (this.simpleDialogueAccountName = null),
          (this.simpleDialogueAccountDescription = null);
      }
    });
  },

  data() {
    return {
      showDialogue: false,

      reactivationDialogue: false,
      accountForReactivation: {},

      simpleDialogueAccountNumber: null,
      simpleDialogueAccountName: null,
      simpleDialogueAccountDescription: null
    };
  },

  methods: {
    updateAccountData() {
      accountManagerEventBus.$emit("updateAccountData", "accountsInUse");
    },

    addNewAccount() {
      let newAccount = this.buildAccountDataFromSimpleDialogue();

      Axios.post(
        "/api/insert-account-simple", //route as specified in routes/web.php
        newAccount //data
      ).then(
        answer => {
          let reactivateDialogue = answer.data.promptReactivation;
          let showError = answer.data.isError;

          console.log("isError: " + showError + typeof showError);
          console.log(
            "reactivate: " + reactivateDialogue + typeof reactivateDialogue
          );

          if (answer.data.isError == "true") {
            if (answer.data.promptReactivation == "true") {
              console.log(answer.data.promptReactivation);
              this.reactivationDialogue = true;
              this.accountForReactivation = {
                id: answer.data.accountID,
                number: answer.data.accountNumber,
                name: answer.data.accountNameOld
              };
              console.log("errorWithReactivation");
            } else {
              snackBarEventBus.$emit("onShowSnackBar", {
                message: answer.data.message,
                icon: "check_circle",
                duration: 5000
              });
            }
          } else {
            snackBarEventBus.$emit("onShowSnackBar", {
              message: answer.data.message,
              icon: "check_circle",
              duration: 5000
            });

            this.simpleDialogueAccountNumber = null;
            this.simpleDialogueAccountName = null;
            this.simpleDialogueAccountDescription = null;
            console.log("successful");
            this.showDialogue = false;
            accountManagerEventBus.$emit("closeAllDialogues");
            this.updateAccountData();
          }
        },

        error => {
          snackBarEventBus.$emit("onShowSnackBar", {
            message: error.message,
            icon: "warning",
            duration: 5000
          });
        }
      );
    },

    reactivateAccount() {
      accountManagerEventBus.$emit("reactivateAccount", {
        account_id: this.accountForReactivation.id,
        sourceDialogueName: "simple"
      });
    },

    overwriteAccount() {
      let newAccount = this.buildAccountDataFromSimpleDialogue();
      Axios.post(
        "/api/overwrite-single-account", //route as specified in routes/web.php
        newAccount //data
      ).then(
        answer => {
          snackBarEventBus.$emit("onShowSnackBar", {
            message: answer.data.message,
            icon: "check_circle",
            duration: 5000
          });
          this.reactivationDialogue = false;
          this.showDialogue = false;
          this.updateAccountData();
          accountManagerEventBus.$emit("closeAllDialogues");
          this.accountForReactivation = {};
        },

        error => {
          snackBarEventBus.$emit("onShowSnackBar", {
            message: error.message,
            icon: "warning",
            duration: 5000
          });
        }
      );
    },

    buildAccountDataFromSimpleDialogue() {
      let accountId = this.accountForReactivation.id;
      let accountNumber = this.simpleDialogueAccountNumber;
      let accountName = this.simpleDialogueAccountName;
      let accountDesc = this.simpleDialogueAccountDescription;
      let newAccount = {
        account_id: accountId,
        number: accountNumber,
        name: accountName,
        description: accountDesc
      };

      return newAccount;
    }
  }
};
</script>

<style>
</style>
