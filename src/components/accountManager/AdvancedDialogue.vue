<template>
  <v-dialog
    v-model="showDialogue"
    fullscreen
    hide-overlay
    transition="dialog-bottom-transition"
    scrollable
  >
    <v-card tile>
      <v-toolbar card dark color="blue-grey darken-4">
        <v-btn icon dark @click.native="showDialogue = false">
          <v-icon>close</v-icon>
        </v-btn>
        <v-toolbar-title>Kontenvorlage importieren</v-toolbar-title>
        <v-spacer></v-spacer>
        <v-toolbar-items>
          <v-btn dark flat @click.native="showDialogue = false">Importieren</v-btn>
        </v-toolbar-items>
        <v-menu bottom right offset-y>
          <v-btn slot="activator" dark icon>
            <v-icon>more_vert</v-icon>
          </v-btn>
          <v-list>
            <v-list-tile v-for="(item, i) in items" :key="i" @click="test">
              <v-list-tile-title>{{ item.title }}</v-list-tile-title>
            </v-list-tile>
          </v-list>
        </v-menu>
      </v-toolbar>
      <v-card-text>
        <v-list three-line subheader>
          <v-subheader>Vorlagen</v-subheader>
          <v-flex xs-10 ml-4>
            <v-radio-group v-model="radioGroup">
              <v-radio
                v-for="(name, index) in accountTemplates"
                :key="index"
                :label="accountTemplates[index].displayName"
                :value="index"
              ></v-radio>
            </v-radio-group>
          </v-flex>
        </v-list>
        <v-tooltip right>
          <v-btn
            slot="activator"
            color="blue-grey darken-4"
            dark
            @click.stop="loadAccountTemplate"
          >Vorlage Laden</v-btn>Es wird nur eine Vorschau erzeugt. Der Import erfolgt über "Speichern".
        </v-tooltip>
        <v-divider></v-divider>
        <v-list three-line subheader>
          <v-subheader>Importierter Kontenplan</v-subheader>
          <v-btn
            color="blue-grey darken-4"
            dark
            @click.stop="saveTemplate = true"
          >Diese Vorlage in der Datenbank speichern</v-btn>
          <v-layout row wrap>
            <v-flex xs-3 mr-5 ml-3>
              <v-text-field
                id="accnumber"
                name="inputaccnumber"
                label="Accountnummer"
                v-model="vModelNumberToTemplate"
              ></v-text-field>
            </v-flex>
            <v-flex xs-3 mr-5>
              <v-text-field
                id="accname"
                name="inputaccname"
                label="Accountname"
                v-model="vModelNameToTemplate"
              ></v-text-field>
            </v-flex>
            <v-flex xs-3 mr-5>
              <v-select
                :items="accounttypes"
                v-model="vModelTypeSelection"
                label="Kontentyp"
                single-line
              ></v-select>
            </v-flex>
            <v-flex xs-3 mr-5>
              <v-btn
                relative
                dark
                fab
                color="blue-grey darken-4"
                @click="addNewAccountToTemplate"
              >Add</v-btn>
            </v-flex>
          </v-layout>
          <v-data-table
            :headers="accountTableHeaders"
            :items="advancedDialogueTableData"
            hide-actions
            class="elevation-1"
          >
            <template slot="items" slot-scope="props">
              <td class="text-xs-center">{{ props.item.id}}</td>
              <td class="text-xs-center">{{ props.item.number }}</td>
              <td class="text-xs-center">{{ props.item.name }}</td>
              <td class="text-xs-center">
                <v-btn @click.native="deleteTemplateElement(props.index)">
                  <v-icon medium>delete</v-icon>
                </v-btn>
              </td>
            </template>
          </v-data-table>
        </v-list>
      </v-card-text>

      <div style="flex: 1 1 auto;"></div>
    </v-card>
  </v-dialog>
</template>

<script>
import { accountManagerEventBus } from "../../main.js"; //for communicating with the other components
import Axios from "axios";
import { snackBarEventBus } from "../../main.js"; //for displaying Snackbars

export default {
  props: {
    accountTableHeaders: {
      type: Array,
      default: []
    }
  },

  created() {
    accountManagerEventBus.$on("closeDialogue", dialogueType => {
      if (dialogueType == "advanced") {
        this.showDialogue = false;
      }
    });

    accountManagerEventBus.$on("openDialogue", dialogueType => {
      if (dialogueType == "advanced") {
        this.showDialogue = true;
      }
    });
  },

  data: () => ({
    showDialogue: false,

    advancedDialogueTableData: [],
    radioGroup: 0,

    vModelNumberToTemplate: "",
    vModelNameToTemplate: "",
    vModelTypeSelection: "",

    accounttypes: ["Aktiva", "Passiva", "Ertrag", "Aufwand"],

    notifications: false,
    sound: true,
    widgets: false,
    items: [
      {
        title: "Click Me"
      },
      {
        title: "Click Me"
      },
      {
        title: "Click Me"
      },
      {
        title: "Click Me 2"
      }
    ]
  }),

  computed: {
    accountTemplates() {
      return this.$store.state.accountTemplates;
    },
    accountType() {
      switch (this.vModelTypeSelection) {
        case "Aktiva":
          return "asset";
          break;
        case "Passiva":
          return "liability";
          break;
        case "Ertrag":
          return "income";
          break;
        case "Aufwand":
          return "expense";
          break;

        default:
          break;
      }
    }
  },

  methods: {
    deleteTemplateElement(itemIndex) {
      this.advancedDialogueTableData.splice(itemIndex, 1);
    },

    addNewAccountToTemplate() {
      let newAccount = {
        number: this.vModelNumberToTemplate,
        name: this.vModelNameToTemplate,
        type: this.accountType
      };

      this.advancedDialogueTableData.push(newAccount);
      this.advancedDialogueTableData.sort(
        this.sortAdvancedDialogueAccountNumber
      );
    },

    sortAdvancedDialogueAccountNumber(a, b) {
      if (a.number < b.number) return -1;
      if (a.number > b.number) return 1;
      return 0;
    },
    loadAccountTemplate() {
      this.advancedDialogueTableData = [];
      this.advancedDialogueTableData = JSON.parse(
        JSON.stringify(
          this.$store.state.accountTemplates[this.radioGroup].accounts
        )
      );
    },
    test() {
      alert("test");
    }
  }
};
</script>

<style>
</style>
