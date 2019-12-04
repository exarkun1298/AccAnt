<template>
  <v-layout row>
    <v-flex hidden-xs-only>
      <v-data-table
        :headers="accountTableHeaders"
        :items="accountTableData"
        hide-actions
        class="elevation-1"
      >
        <template slot="items" slot-scope="props">
          <td class="text-xs-center">{{ props.item.id}}</td>
          <td class="text-xs-center">{{ props.item.number }}</td>
          <td class="text-xs-center">{{ props.item.name }}</td>
          <td class="text-xs-center">{{ props.item.description }}</td>
          <td class="text-xs-center">
            <v-btn @click.native="executeTableAction(props.item.id)">
              <v-icon medium>{{tableaction}}</v-icon>
            </v-btn>
          </td>
        </template>
      </v-data-table>
    </v-flex>
  </v-layout>
</template>

<script>
import Axios from "axios";
import { snackBarEventBus } from "../../main.js"; //for displaying Snackbars
import { accountManagerEventBus } from "../../main.js"; //for communicating with the other components
import { basicDatabaseFetchersMixin } from "../reusables/basicDatabaseFetchersMixin.js";

export default {
  props: {
    webrouteForTableData: {
      type: String,
      default: "/api/get-account-table"
    },
    accountTableHeaders: {
      type: Array,
      default: []
    },
    tableaction: {
      type: String,
      default: ""
    },
    tableName: {
      type: String,
      default: ""
    }
  },

  data() {
    return {
      accountTableData: []
    };
  },

  mounted() {
    this.updateAccountData();
  },

  created() {
    accountManagerEventBus.$on("updateAccountData", tableNameParameter => {
      //this function updates the specific instance of an accountTable provided via Parameter
      if (this.tableName === tableNameParameter) {
        this.updateAccountData();
      }
    });
  },

  methods: {
    executeTableAction(account) {
      if (this.tableaction == "delete") {
        Axios.post(
          "/api/delete-account-simple", //route as specified in routes/web.php
          { account_id: account } //data
        ).then(
          answer => {
            snackBarEventBus.$emit("onShowSnackBar", {
              message: answer.data.message,
              icon: "check_circle",
              duration: 5000
            });

            this.updateAccountData();
          },

          error => {
            snackBarEventBus.$emit("onShowSnackBar", {
              message: error.message,
              duration: 8000
            });
          }
        );
      }

      if (this.tableaction == "redo") {
        accountManagerEventBus.$emit("reactivateAccount", {
          account_id: account,
          sourceDialogueName: "deleted"
        });
      }
    },

    updateAccountData() {
      this.getAccountTableFromDatabase();
    },

    getAccountTableFromDatabase() {
      this.accountTableData = [];
      Axios.get(this.webrouteForTableData).then(
        answer => {
          let serverAccountTable = JSON.parse(answer.data);
          for (let i = 0; i < serverAccountTable.length; i++) {
            let accID = serverAccountTable[i].id;
            let accNumber = serverAccountTable[i].number;
            let accName = serverAccountTable[i].name;
            let accDesc = serverAccountTable[i].description;
            let accountObject = {
              id: accID,
              number: accNumber,
              name: accName,
              description: accDesc
            };
            this.accountTableData.push(accountObject);
          }
          console.log(this.accountTableData);
          accountManagerEventBus.$emit("dataLoaded");
        },
        error => {
          console.log("error at fetching account table");
        }
      );
    },

    //This method fetches all accounts (including soft deleted) from the Database
    getAccountFullTableFromDatabase() {
      this.tempAccountTable = [];
      Axios.get("/api/get-full-account-table").then(
        answer => {
          let serverAccountTable = JSON.parse(answer.data);
          for (let i = 0; i < serverAccountTable.length; i++) {
            let accID = serverAccountTable[i].id;
            let accNumber = serverAccountTable[i].number;
            let accName = serverAccountTable[i].name;
            let accountObject = {
              id: accID,
              number: accNumber,
              description: accName
            };
            this.tempAccountTable.push(accountObject);
          }
          console.log(this.tempAccountTable);
        },
        error => {
          console.log("error at fetching account table");
        }
      );
    }
  }
};
</script>

<style>
</style>
