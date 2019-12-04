<template>
<div>
    <h1>Import</h1>

    <div>
        <v-layout fluid>
            <v-flex xs12 sm12>
                <v-card dark>

                    <v-card-title primary-title>
                        <h3 class="headline">Daten Importieren</h3>
                    </v-card-title>

                    <v-card-text> Hier können Daten aus AccAnt oder Ihrer Bank importiert werden. </v-card-text>


                    <v-stepper v-model="currentStep" vertical non-linear>

                        <!-- Misuse 'editable' to make it possible to click through the steps => All clickable elements are done -->
                        <v-stepper-step
                                :editable="importStep >= steps.sourceId"
                                edit-icon="$vuetify.icons.complete"
                                :complete="importStep > steps.sourceId && conditionStep1"
                                step="1" >
                            <span v-if="!selectedSource.name">Quelle auswählen</span>
                            <span v-else>Quelle: <b>{{ selectedSource.name }}</b></span>
                        </v-stepper-step>

                        <v-stepper-content :step="steps.sourceId">

                            <h2>1. Quelle auswählen</h2>
                            <v-flex xs12 sm6 d-flex>
                                <v-select
                                        v-model="selectedSource.name"
                                        :items="sources"
                                        item-text="name"
                                        @change="updateDescription(selectedSource.name)"
                                        label="Daten-Quelle"
                                        box
                                ></v-select>
                            </v-flex>
                            <div>Beschreibung: <span v-html="selectedSource.description"></span></div>

                            <v-divider></v-divider>

                            <p>
                                <v-btn color="secondary" disabled>Zurück</v-btn>
                                <v-btn color="primary" @click="transition(2)" :disabled="!conditionStep1">
                                    Weiter
                                </v-btn>
                            </p>

                        </v-stepper-content>



                        <v-stepper-step
                                :editable="importStep >= steps.fileId"
                                edit-icon="$vuetify.icons.complete"
                                :complete="importStep > steps.fileId && conditionStep3"
                                step="2">
                            <template v-if="!selectedFile">Datei hochladen</template>
                            <template v-else><span>Datei ausgewählt: <b class="text-bold">{{ selectedFile.name }}</b></span></template>
                        </v-stepper-step>

                        <v-stepper-content :step="steps.fileId">
                            <h2>2. Datei Uploaden</h2>

                            <div>
                                <upload-btn
                                        :fileChangedCallback="fileSelected"
                                        :icon="true"
                                        color="blue-grey"
                                >
                                    <template slot="icon">
                                        Datei hochladen
                                        <v-icon right dark>cloud_upload</v-icon>
                                    </template>
                                </upload-btn>
                            </div>

                            <div>
                                <h4>Dateien:</h4>
                                <!-- TODO File upload progress dingens like here: https://github.com/vuetifyjs/vuetify/issues/238#issuecomment-350406388 -->
                                <div v-if="selectedFile"
                                     class="upload-wrapper"
                                     >

                                    <v-text-field append-icon="mdi-close"
                                                  loading
                                                  readonly
                                                  v-model="selectedFile.name"
                                                  :label="selectedFile.label"
                                                  @click:append="() => remove(ix)"
                                                  class="ma-0">

                                        <v-progress-linear v-show="!selectedFile.finished"
                                                           slot="progress"
                                                           :value="selectedFile.progress"
                                                           :color="['lime', 'green', 'blue'][Math.floor(selectedFile.progress / 33.34)]"
                                                           height="4">
                                        </v-progress-linear>

                                    </v-text-field>
                                </div>
                            </div>

                            <v-divider></v-divider>

                            <p>
                                <v-btn color="secondary" @click="transition(1)">Zurück</v-btn>
                                <v-btn color="primary" @click="transition(3)" :disabled="!conditionStep2">
                                    Weiter
                                </v-btn>
                            </p>
                        </v-stepper-content>



                        <v-stepper-step
                                :editable="importStep >= steps.importId"
                                edit-icon="$vuetify.icons.complete"
                                :complete="importStep > steps.importId && conditionStep2"
                                step="3">
                            Import Details
                        </v-stepper-step>

                        <v-stepper-content :step="steps.importId">
                            <!-- Metadaten (Header) -->
                            <h2>3. Import Details</h2>
                            <p>Den relevanten Spalten aus dem Import die Entsprechungen von AccAnt zuordnen.</p>

                            <v-container fluid grid-list-xl>
                                <v-layout wrap align-center>
                                    <v-flex v-for="(item, key, index) in metaAssignments" :key="index" xs12 sm6 d-flex>
                                        <v-combobox
                                                v-model="metaAssignments[key]"
                                                :items="csvHeaders.map(data => data.value)"
                                                :label="key"
                                                chips
                                        ></v-combobox>
                                    </v-flex>
                                </v-layout>
                            </v-container>


                            <v-layout row wrap>
                                <v-flex xs12 sm4>
                                    <v-checkbox
                                            label="Accounts aus Import Daten erstellen"
                                            v-model="createAccountFromImport"
                                            disabled
                                    ></v-checkbox>  {{ ''/* TODO Implement create accounts from input data */}}
                                </v-flex>

                                <v-flex xs12 sm8
                                    v-if="!createAccountFromImport">
                                    <v-text-field
                                            v-model="importAccountName"
                                            label="Account Name"
                                            placeholder="Account Name für alle Transaktionen"
                                    ></v-text-field>
                                </v-flex>
                            </v-layout>



                            <v-divider></v-divider>

                            <p>
                                <v-btn color="secondary" @click="transition(2)">Zurück</v-btn>
                                <v-btn color="primary" @click="transition(4)" :disabled="!conditionStep3">
                                    Weiter
                                </v-btn>
                            </p>
                        </v-stepper-content>



                        <v-stepper-step
                                :editable="importStep >= steps.reviewId"
                                edit-icon="$vuetify.icons.complete"
                                :complete="importStep > steps.reviewId && conditionStep4"
                                step="4">
                            Daten überprüfen</v-stepper-step>

                        <v-stepper-content :step="steps.reviewId">
                            <h2>4. Daten überprüfen</h2>

                            <!-- Import daten -->
                            <h1>Daten-Import</h1>
                            <v-data-table
                                    :headers="importHeaders"
                                    :items="importData"
                                    class="elevation-1"
                            >
                                <template slot="items" slot-scope="rows">
                                    <td class="text-xs-right"
                                        v-for="cell in rows.item" :key="cell.name">
                                        {{ cell ? cell : '' }}
                                    </td>
                                </template>
                                <template slot="no-data">
                                    <v-alert :value="true" color="error" icon="warning">
                                        Sorry, nothing to display here :( <b>Irgendwas ist beim Import schief gelaufen ¯\_(ツ)_/¯ </b>
                                    </v-alert>
                                </template>
                            </v-data-table>

                            <p>
                                <v-btn color="secondary" @click="transition(3)">Zurück</v-btn>
                                <v-btn color="primary" @click="transition(5)" :disabled="!conditionStep4">
                                    Weiter
                                </v-btn>
                            </p>
                        </v-stepper-content>



                        <v-stepper-step
                                :editable="importStep >= steps.submitId"
                                edit-icon="$vuetify.icons.complete"
                                :complete="importStep > steps.submitId && conditionStep5"
                                step="5">
                            Daten abschicken
                        </v-stepper-step>

                        <v-stepper-content :step="steps.submitId">
                            <h2>5. Daten abschicken</h2>

                            <p>Sind die Daten richtig formatiert?</p>
                            <v-btn color="success"
                                   @click="submitTransactions()">
                                Ja, Transaktionen online eintragen
                            </v-btn>
                            <v-btn color="error" @click="currentStep = 3">
                                Nein! Nochmal überarbeiten
                            </v-btn>

                            <v-divider></v-divider>

                            <p>
                                <v-btn color="secondary" @click="transition(4)">Zurück</v-btn>
                                <v-btn color="primary" disabled>Weiter</v-btn>
                            </p>
                        </v-stepper-content>

                    </v-stepper>


                </v-card>
            </v-flex>
        </v-layout>

    </div>
</div>
</template>

<script>
/**
 * Source: https://github.com/doritobandito/vuetify-upload-button
 */
import UploadButton from "vuetify-upload-button";
import PapaParser from "papaparse";

import { basicStepperFunctionalityMixin } from "./basicStepperFunctionalityMixin.js";
import { bankAccountImporterMixin } from "./bankAccountImporterMixin.js";
import { importTableMixin } from "./importTableMixin.js";
import { importDatabaseMixin } from "./importDatabase";

export default {
  data: function () {
    return {
      /**
       * This array stores the assignment of the data to the database structure.
       */
      metaAssignments: [],

      // Filter CSV headers / data
      /**
       * The final headers to import
       * Filtered or processed csvHeaders displayed in the preview table.
       */
      importHeaders: [],
      /**
       * The final data to import.
       * Filtered or processed csvData displayed in the preview table.
       */
      importData: [],
      /**
       * Create the account of the transaction using the import data or use one single account for all imported transactions.
       */
      createAccountFromImport: false,
      /**
       * The Account name the user enters - if the accounts from the import data will NOT be used.
       */
      importAccountName: null,
    }
  },
  /**
   * All business logix distributed across the mixins in './'
   */
  components: {
    "upload-btn": UploadButton,
    "papa-parser-component": PapaParser
  },
  mixins: [
    basicStepperFunctionalityMixin,
    bankAccountImporterMixin,
    importTableMixin,
    importDatabaseMixin
  ]
};
</script>

<style>
/*
 * Style upload button
 */
.upload-btn {
  padding: 8px 16px;
  padding-top: 16px;
  margin: 8px 6px;
}
</style>