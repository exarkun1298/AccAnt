<template>
  <v-layout fluid>
    <v-flex fluid>
      <!-- This snackbar will provide information about the database communication -->
      <v-snackbar
        :timeout="snackTimeout"
        :top="snackY === 'top'"
        :bottom="snackY === 'bottom'"
        :right="snackX === 'right'"
        :left="snackX === 'left'"
        :multi-line="snackMode === 'multi-line'"
        :vertical="snackMode === 'vertical'"
        :color="snackbarColor"
        v-model="snackbar"
      >
        <v-icon class="mr-3">{{snackbarIcon}}</v-icon>
        {{ snackbarText }}
        <v-btn flat color="pink" @click.native="snackbar = false">
          <v-icon>close</v-icon>
        </v-btn>
      </v-snackbar>

      <router-view></router-view>
      <!--  The designated component is rendered here
              The information which component to render is provided by vue-router
              as seen in ./routes.js
      -->
      <!--  
          
          <component :is="component"></component>
          deprecated
      -->
    </v-flex>
  </v-layout>
</template>

<script>
import { snackBarEventBus } from "./main.js";

export default {
  props: {
    component: {
      type: String,
      default: "accant-transaction-detail"
    }
  },

  data() {
    return {
      /**
       * JavaScript object.
       * Data representation of the written transactions
       * Correct Formatting for database communication
       * transactionsToSend {
       *   transactions: [
       *   {...},
       *   {...},
       *   {...}
       *   ]
       * }
       */

      transactionsToSend: { transactions: [] },

      snackbar: false, //to show snackbar, set true

      //snackbar visuals
      snackY: "top", //alignment
      snackX: null, //alignment, null is center
      snackMode: "", //type "vertical" if wanted
      snackTimeout: 3000, //timeout when snackbar disappears again

      //snackbarData
      snackbarText: "Hello, I'm a snackbar",
      snackbarColor: "",
      snackbarIcon: ""
    };
  },

  created() {
    /*
     * Setting up the event listeners
     * Events on the snackBarEventBus -- Definition: ../main.js
     */
    snackBarEventBus.$on("onShowSnackBar", data => {
      this.snackbar = true;

      //simulating function overloading, with duration 3000 as default
      if (typeof data.duration === "undefined") {
        this.showSnackBar(data.message, data.icon, 3000);
      } else {
        this.showSnackBar(data.message, data.icon, data.duration);
      }
    });
  },

  methods: {
    /**
     * Show a snackbar with a custom text and icon
     */
    showSnackBar(snackText, answerStatus, duration) {
      //multiple implementation? TODO: cleanup
      if (this.snackbar === true) {
        this.snackbarBlink();
      }

      this.snackTimeout = duration;
      this.snackbarText = snackText;
      this.snackbar = true;
      this.snackbarIcon = answerStatus;
    },

    /**
     * TODO Draw attention to the snackbar
     */
    snackbarBlink() {
      this.snackbar = false;
      this.snackbar = true;
    }
  }
};
</script>

<style>
</style>
