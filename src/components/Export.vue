<template>
  <div>
    <h1>Export</h1>

    <br>
    <v-layout row>
      <v-flex xs-12 elevation-5>
        <v-tabs
        v-model="active"
        color="blue-grey darken-4"
        dark
        slider-color="blue-grey darken-1"
      >
        <v-tab
          v-for="tabs in tabData"
          :key="tabs.key"
          ripple
        >
          Download {{ tabs.name }}

        </v-tab>
        <v-tab-item
          v-for="tabContent in tabData"
          :key="tabContent.key"
        >
          <v-card dark>
          <v-card-title primary-title>
            <div>
              <h3 class="headline mb-0">{{tabContent.name}}</h3>
              <br>
              <p v-html="tabContent.text"></p>
            </div>
          </v-card-title>
          <v-card-actions>
            <v-btn outline
                   @click="downloadFile(tabContent.routeDataParameter,'xlsx')">
              <v-icon left>fas fa-download</v-icon>
              &nbsp; Excel &nbsp;
              <v-icon right color="green">fas fa-file-excel</v-icon>
            </v-btn>
            <v-btn outline
                   @click="downloadFile(tabContent.routeDataParameter,'csv')">
              <v-icon left>fas fa-download</v-icon>
              &nbsp; CSV &nbsp;
              <v-icon right color="indigo lighten-1">fas fa-file-alt</v-icon>
            </v-btn>
          </v-card-actions>

          </v-card>
        </v-tab-item>
      </v-tabs>
      </v-flex>
    </v-layout>
  </div>
</template>

<script>
import Axios from "axios";
export default {
  data: () => ({
    active: null,

    tabData: [
      {
        key: 1,
        name: "Buchungen",
        routeDataParameter: "transactions",
        text:
          "Der Download der Buchungen ist als <code>.xlsx</code> oder <code>.csv</code> möglich. Bitte Datentyp auswählen. <br/>\n"
          + "<strong>Achtung:</strong> Ein späterer Import ist (aktuell) nur mit CSV möglich."
      },
      {
        key: 2,
        name: "Konten",
        routeDataParameter: "accounts",
        text:
          "Der Download der Konten ist als <code>.xlsx</code> oder <code>.csv</code> möglich. Bitte Datentyp auswählen."
      }
    ]
  }),

  methods: {
    /**
     * prepares a file download
     * @params:
     * data: 'accounts', 'transactions' as String
     * format: 'xlsx', 'csv' as String
     */
    downloadFile(data, format) {
      let requestURL = "/api/expose-" + data + "-" + format;
      Axios({
        url: requestURL,
        method: "GET",
        responseType: "blob" // important
      }).then(response => {
        const url = window.URL.createObjectURL(new Blob([response.data]));
        const link = document.createElement("a");
        link.href = url;
        link.setAttribute("download", data + "." + format);
        document.body.appendChild(link);
        link.click();
      });
    }
  }
};
</script>

<style>
</style>