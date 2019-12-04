<template>
  <div>
    <!-- If on Screen bigger 600 px display table -->
    <v-layout row>
      <v-flex hidden-xs-only>
        <v-data-table :headers="headers" :items="getRecordQueue" hide-actions class="elevation-1">
          <template slot="items" slot-scope="props">
            <td class="text-xs-center">{{ props.item.timestamp_booking }}</td>
            <td class="text-xs-center">{{ props.item.account_name }}</td>
            <td class="text-xs-center">{{ props.item.account_number }}</td>
            <td class="text-xs-center">{{ props.item.description }}</td>
            <td class="text-xs-center">{{ props.item.amount }}</td>
            <td class="text-xs-center">{{ props.item.counter_account_number }}</td>
            <td v-if="!useFormattedTags" class="text-xs-center">{{ props.item.tags }}</td>
            <td v-if="useFormattedTags" class="text-xs-center">{{ props.item.formattedTags }}</td>
            <td v-if="showDeletionButton" class="text-xs-center">
              <v-btn icon @click.native="deleteElement(props.index)">
                <v-icon size="20px">delete</v-icon>
              </v-btn>
            </td>
          </template>
        </v-data-table>
      </v-flex>
    </v-layout>

    <!--  If on mobile - display data cards -->
    <v-layout row>
      <v-flex hidden-sm-and-up fluid grid-list-md>
        <v-data-iterator
          content-tag="v-layout"
          row
          wrap
          :items="getRecordQueue"
          :rows-per-page-items="rowsPerPageItems"
          :pagination.sync="pagination"
        >
          <v-flex slot="item" slot-scope="props" xs12 sm6 md4 lg3>
            <v-card>
              <v-card-title>
                <h4>{{ props.item.number}}</h4>
              </v-card-title>
              <v-divider></v-divider>
              <v-list dense>
                <v-list-tile>
                  <v-list-tile-content>Datum:</v-list-tile-content>
                  <v-list-tile-content class="align-center">{{ props.item.date }}</v-list-tile-content>
                </v-list-tile>
                <v-list-tile>
                  <v-list-tile-content>Accountname:</v-list-tile-content>
                  <v-list-tile-content class="align-center">{{ props.item.account_name }}</v-list-tile-content>
                </v-list-tile>
                <v-list-tile>
                  <v-list-tile-content>Account:</v-list-tile-content>
                  <v-list-tile-content class="align-center">{{ props.item.account_number }}</v-list-tile-content>
                </v-list-tile>
                <v-list-tile>
                  <v-list-tile-content>Text:</v-list-tile-content>
                  <v-list-tile-content class="align-center">{{ props.item.description }}</v-list-tile-content>
                </v-list-tile>
                <v-list-tile>
                  <v-list-tile-content>Wert:</v-list-tile-content>
                  <v-list-tile-content class="align-center">{{ props.item.amount }}</v-list-tile-content>
                </v-list-tile>
                <v-list-tile>
                  <v-list-tile-content>Gegenaccount:</v-list-tile-content>
                  <v-list-tile-content class="align-center">{{ props.item.counter_account_number }}</v-list-tile-content>
                </v-list-tile>
                <v-list-tile>
                  <v-list-tile-content>Journal:</v-list-tile-content>
                  <v-list-tile-content class="align-center">{{ props.item.journal }}</v-list-tile-content>
                </v-list-tile>
                <hr>
              </v-list>
            </v-card>
          </v-flex>
        </v-data-iterator>
      </v-flex>
    </v-layout>
  </div>
</template>

<script>
import { transactionEventBus } from "../../../main.js"; //for communicating with the other transaction components

export default {
  data() {
    return {
      rowsPerPageItems: [4, 8, 12],
      pagination: {
        rowsPerPage: 4
      },
      headers: [
        { text: "Datum", value: "datum", align: "center", sortable: true },
        {
          text: "Accountname",
          value: "accountname",
          align: "center",
          sortable: true
        },
        {
          text: "Accountnummer",
          value: "accountnummer",
          align: "center",
          sortable: true
        },
        {
          text: "Buchtext",
          value: "buchtext",
          align: "center",
          sortable: false
        },
        { text: "Betrag", value: "betrag", align: "center", sortable: true },
        {
          text: "Gegenkonto",
          value: "gegenkonto",
          align: "center",
          sortable: true
        },
        { text: "Tags", value: "tags", align: "center", sortable: false },
        { text: "X", value: "delete", align: "center", sortable: false }
      ]
    };
  },

  computed: {
    getRecordQueue() {
      return this.$store.state.transactionsForm.recordQueue;
    }
  },

  props: {
    showDeletionButton: {
      type: Boolean,
      default: false
    },
    useFormattedTags: {
      type: Boolean,
      default: false
    },
    sortDescending: {
      type: Boolean,
      default: false
    }
  },

  methods: {
    deleteElement(itemIndex) {
      transactionEventBus.$emit("onDeleteTableElement", itemIndex);
    }
  }
};
</script>

<style scoped>
</style>