<template>
  <v-menu
    v-if="dateShow"
    lazy
    :close-on-content-click="true"
    v-model="menu"
    transition="scale-transition"
    offset-y
    full-width
    :nudge-right="40"
    max-width="290px"
    min-width="290px"
  >
    <v-text-field
      slot="activator"
      label="Datum"
      :value="date"
      append-icon="event"
      :hide-details="!displayHelptext"
      required
      hint="Das Datum muss im Format DD.MM.YYYY eingegeben werden."
    ></v-text-field>
    <!-- 
      @blur="timestamp_booking = parseDate(dateFormatted)"
      
    -->
    <v-date-picker @input="updateDate($event)" no-title scrollable actions></v-date-picker>
  </v-menu>
</template>

<script>
export default {
  data() {
    return {
      menu: false,
      dateRules: [
        v => !!v || "Datum benötigt!",
        v =>
          /^\s*(3[01]|[12][0-9]|0?[1-9])\.(1[012]|0?[1-9])\.((?:19|20)\d{2})\s*$/.test(
            v
          ) || "Ungültiges Format! Bitte im Format DD.MM.YYYY eingeben"
      ]
    };
  },

  mounted: function() {
    var self = this;
    setTimeout(function() {
      self.setDateToDefaultToday();
    }, 1);
  },

  computed: {
    date() {
      return this.$store.state.transactionsForm.date;
    },
    dateShow() {
      //boolean, determines if datePicker should be displayed
      return this.$store.state.transactions.dateShow;
    },

    displayHelptext() {
      return this.$store.state.transactionsForm.displayhelptexts;
    }
  },

  methods: {
    updateDate(e) {
      this.$store.commit("transactionsForm/updateDate", e);
    },
    /* Set the default date of the date picker to today and format it correctly */
    setDateToDefaultToday() {
      let today = new Date().toISOString().substr(0, 10);
      this.updateDate(today);
      /**
       *       
       * var dd = today.getDate();
      var mm = today.getMonth() + 1; //January is 0!

      var yyyy = today.getFullYear();
      if (dd < 10) {
        dd = "0" + dd;
      }
      if (mm < 10) {
        mm = "0" + mm;
      }
      var today = dd + "." + mm + "." + yyyy;
       */
    },
    /* Helper function for the date picker */
    formatDate(date) {
      if (!date) {
        return null;
      }
    },
    /* Helper function for the date picker */
    parseDate(date) {
      if (!date) {
        return null;
      }

      const [day, month, year] = date.split(".");
      return `${year}-${month.padStart(2, "0")}-${day.padStart(2, "0")}`;
    }
  }
};
</script>

<style>
</style>
