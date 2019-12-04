<template>
  <v-layout row justify-center>
    <v-dialog v-model="show" scrollable max-width="600px">
      <v-card>
        <div v-if="loading" class="text-xs-center">
          <v-progress-circular :size="50" color="primary" indeterminate></v-progress-circular>
        </div>
        <v-data-table
          v-else
          :items="accountData"
          :headers="accountHeaders"
          hide-actions
          class="elevation-3"
        >
          <template slot="items" slot-scope="props">
            <td class="text-xs-center">{{props.item.number}}</td>
            <td class="text-xs-center">{{props.item.name}}</td>
            <td class="text-xs-center">
              <v-btn @click.native="changeAccNumber(props.item.number)">
                <v-icon medium>add</v-icon>
              </v-btn>
            </td>
          </template>
        </v-data-table>
      </v-card>
    </v-dialog>
  </v-layout>
</template>

<script>
import Axios from "axios";
import { transactionEventBus } from "../../../main.js"; //for communicating with te other transaction components

export default {
  data() {
    return {
      show: false,
      target: null,
      loading: false,
      accountHeaders: [
        {
          text: "Nummer",
          value: "number",
          align: "center"
        },
        {
          text: "Name",
          value: "name",
          align: "center"
        },
        {
          text: "Hinzufügen",
          value: "add",
          align: "center"
        }
      ],
      accountData: []
    };
  },

  created() {
    transactionEventBus.$on("openAccDialogue", source => {
      this.target = source.sender;
      this.show = true;
      this.loading = true;
      this.getAccountData().then(() => {
        this.loading = false;
      });
    });
    transactionEventBus.$on("closeAccDialogue", () => {
      this.show = false;
    });
  },

  methods: {
    getAccountData() {
      return Axios.get("/api/get-account-table").then(answer => {
        let tableData = JSON.parse(JSON.stringify(answer.data));
        let parsed = JSON.parse(tableData);
        this.accountData = parsed;
      });
    },

    changeAccNumber(toNumber) {
      if (this.target == "account") {
        transactionEventBus.$emit("changeAccountNumber", toNumber);
        this.show = false;
      } else {
        transactionEventBus.$emit("changeCounterAccountNumber", toNumber);
        this.show = false;
      }
    }
  }
};
</script>

<style>
</style>
