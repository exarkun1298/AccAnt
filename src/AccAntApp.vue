<!--
This is the main file which gets rendered by the Vue instance.

It serves as the root component of the whole app.

The template divides the page in 4 Sections:
      Top bar
      Navigation Bar
      Content Frame
      Footer

The content is replaced by the respective component selected on the Navigation Bar / Top Bar.

There is very little business logic in here, just whats needed for navigation and logging out.
-->

<template>
  <div>
    <v-app id="accant-app" dark>
      <!-- Navigation Bar Start -->
      <v-navigation-drawer clipped fixed v-model="drawer" app class="blue-grey darken-3">
        <!-- Navigation Menu Start -->
        <v-layout>
          <v-flex>
            <v-card class="elevation-0">
              <!-- Element List Render Start -->
              <v-list
                dark
                dense
                class="blue-grey darken-3"
                v-model="item.active"
                v-for="item in items"
                :key="item.text"
                no-action
              >
                <!-- Render (empty) subheader if a corresponding object exists -->
                <v-subheader v-if="item.subheader"></v-subheader>

                <!-- Parent elements Start, render if element is no subheader and has a child  -->
                <v-list-group
                  v-else-if="item.children"
                  :prepend-icon="item.icon"
                  :value="containsCurrentRoute(item.children)"
                >
                  <!-- Open or close the list group -->
                  <v-list-tile slot="activator">
                    <v-list-tile-content>
                      <v-list-tile-title>{{ item.text }}</v-list-tile-title>
                    </v-list-tile-content>
                  </v-list-tile>

                  <!-- Child elements Start -->
                  <v-list-tile
                    ripple
                    :to="{path: subItem.route}"
                    class="ml-3"
                    v-for="subItem in item.children"
                    :key="subItem.text"
                    @click="changeCmp(subItem.cmp, subItem.route)"
                  >
                    <v-list-tile-action>
                      <v-icon>{{ subItem.icon }}</v-icon>
                    </v-list-tile-action>
                    <v-list-tile-content>
                      <v-list-tile-title class="no-linkstyle">{{ subItem.text }}</v-list-tile-title>
                    </v-list-tile-content>
                  </v-list-tile>

                  <!-- Child elements End -->
                </v-list-group>
                <!-- Parent elements End, don't render if no child elements -->
                <!-- Childless element render Start, render if no child or subheader property found  -->
                <v-list-tile
                  ripple
                  :to="{path: item.route}"
                  v-else-if="!item.logout"
                  :prepend-icon="item.icon"
                  @click="changeCmp(item.cmp, item.route)"
                >
                  <v-list-tile-action>
                    <v-icon>{{ item.icon }}</v-icon>
                  </v-list-tile-action>
                  <v-list-tile-content>
                    <v-list-tile-title class="no-linkstyle">{{ item.text }}</v-list-tile-title>
                  </v-list-tile-content>
                </v-list-tile>
                <!-- Childless element render End -->
                <!-- Logout Button render start -->
                <v-list-tile ripple :prepend-icon="item.icon" v-else @click="logout()">
                  <v-list-tile-action>
                    <v-icon>{{ item.icon }}</v-icon>
                  </v-list-tile-action>
                  <v-list-tile-content>
                    <router-link :to="{path: '/login'}" class="no-linkstyle stylelessLink">
                      <v-list-tile-title>{{ item.text }}</v-list-tile-title>
                    </router-link>
                  </v-list-tile-content>
                </v-list-tile>
                <!-- Logout Button render end -->
              </v-list>
              <!-- Element List Render End -->
            </v-card>
          </v-flex>
        </v-layout>
        <!-- Navigation Menu End -->
      </v-navigation-drawer>
      <!-- Navigation Bar End -->
      <!-- Upper Toolbar Start -->
      <v-toolbar dark app clipped-left fixed color="blue-grey darken-4">
        <v-toolbar-title
          :style="$vuetify.breakpoint.mdAndUp ? 'width: 230px; min-width: 150px' : 'min-width: 72px'"
          class="ml-0 pl-3"
        >
          <v-toolbar-side-icon @click.stop="drawer = !drawer"></v-toolbar-side-icon>
          <span class="hidden-xs-only">AccAnt</span>
        </v-toolbar-title>

        <v-text-field
          class="hidden-sm-and-down"
          light
          solo
          prepend-icon="search"
          placeholder="Search"
          style="max-width: 300px; min-width: 128px"
        ></v-text-field>
        <div v-if="user.loaded" class="d-flex align-center" style="margin-left: auto">
          <v-tooltip :close-delay="1000" bottom>
            <v-toolbar-title
              class="hidden-sm-and-down"
              mr-4
              slot="activator"
            >{{greetMessage}}, {{user.name}}</v-toolbar-title>
            <span>Logged in as {{user.email}}</span>
            <v-btn @click="logout" flat>Not you?</v-btn>
          </v-tooltip>
          <v-toolbar-title class="hidden-md-and-up" mr-4>Hi {{user.name}}</v-toolbar-title>
        </div>

        <div class="d-flex align-center" style="margin-left: auto">
          <v-btn icon>
            <v-icon>settings</v-icon>
          </v-btn>
          <v-btn icon large>
            <v-avatar size="64px" tile>
              <img src="./assets/ant2.png" alt="AccAnt">
            </v-avatar>
          </v-btn>
        </div>
      </v-toolbar>
      <!-- Upper Toolbar End -->
      <!-- Content Start -->
      <v-content>
        <v-container fluid pa-2>
          <accant-content-container :component="contentComponent" :subcomponent="cmpParameter"></accant-content-container>
        </v-container>
      </v-content>
      <!-- Content End -->
      <!-- Footer Start -->
      <v-footer app color="blue-grey darken-4">
        <span class="ml-2">Version {{version}} - 14.07.2018</span>
      </v-footer>
      <!-- Footer End -->
    </v-app>
  </div>
</template>


<script>
/**
 * Import all existing ("middle") components locally
 * Middle Components can have their subcomponents, which are loaded locally as well
 */

import ContentContainer from "./ContentContainer.vue";
import pjson from "../package.json";
import { transactionEventBus } from "./main.js";
import Axios from "axios";

/* import { mapMutations } from "vuex"; */

export default {
  /**
   * Registering all components locally
   */
  components: {
    "accant-content-container": ContentContainer
  },

  mounted: function() {
    this.$store.dispatch("userSettings/fetchUserData");
  },

  data: () => ({
    version: pjson.version,

    xsrfToken: null,

    //currently loaded component is stored in this variable
    contentComponent: "",

    //property to pass an argument to a loaded component. Should be used to load certain subcomponents
    cmpParameter: "",

    //handles the state of the navigation drawer (expanded or not)
    drawer: null,

    user: {
      name: "error",
      email: "error",
      loaded: false
    },

    /**
     * "items" defines an array of Javascript Objects
     * This can be seen as a list of entities displayed by the navigation bar
     *
     * The icon and text property get rendered directly to the navigation bar
     * The cmp property is assigned to let the app know, which component to load on click
     * The children property enables a tree-like naviagion structure
     * The cmpProp property is needed to pass the subcomponent to the middlecomponent. So that a parent knows which
     * child to render
     * The logout property is assigned so a button is treated as a logout button.
     *
     * The items array loads into the DOM based on certain conditons specified in the html template (if-else-directives)
     */

    items: [
      {
        icon: "home",
        text: "Home",
        cmp: "accant-home",
        route: "/home"
      },
      {
        icon: "dashboard",
        text: "Dashboard",
        cmp: "accant-dashboard",
        route: "/dashboard"
      },

      {
        icon: "create",
        text: "Buchungen",
        cmp: "accant-transaction-ui",
        route: "/transaction-cashsimple"
      },

      {
        icon: "description",
        text: "Buchungsvorlagen",
        cmp: "accant-templates",
        route: "/templates"
      },
      {
        icon: "undo",
        text: "Stornieren",
        cmp: "accant-undo",
        route: "/undo"
      },

      {
        icon: "trending_up",
        text: "Auswertung",
        model: false,
        children: [
          {
            text: "Jahr",
            cmp: "accant-year"
          },
          {
            text: "Monat",
            cmp: "accant-month"
          },
          {
            text: "usw",
            cmp: "accant-usw"
          }
        ]
      },

      {
        icon: "more_vert",
        text: "Mehr",
        model: false,
        children: [
          {
            icon: "history",
            text: "Historie",
            cmp: "accant-history",
            route: "/history"
          },
          {
            icon: "book",
            text: "Kontenverwaltung",
            cmp: "accant-account-manager",
            route: "/accountmanager"
          },
          {
            icon: "comment",
            text: "Tags",
            cmp: "accant-tag-manager",
            route: "/tagmanager"
          },
          {
            icon: "publish",
            text: "Export",
            cmp: "accant-export",
            route: "/export"
          },
          {
            icon: "unarchive",
            text: "Import",
            cmp: "accant-import",
            route: "/import"
          },

          {
            icon: "people",
            text: "Benutzerverwaltung",
            cmp: "accant-user-preferences",
            route: "/user-preferences"
          }
        ]
      },

      {
        subheader: true
      },

      {
        icon: "settings",
        text: "Einstellungen",
        cmp: "accant-options",
        route: "/settings"
      },
      {
        icon: "info",
        text: "Info & Kontakt",
        cmp: "accant-info",
        route: "/info"
      },
      {
        icon: "exit_to_app",
        text: "Logout",
        cmp: "accant-logout",
        logout: "true"
      }
    ]
  }),

  computed: {
    greetMessage() {
      let today = new Date();
      let hour = today.getHours();
      let message = "";

      switch (hour) {
        case 1:
        case 2:
        case 3:
        case 4:
          return "You should go to sleep";
          break;

        case 5:
        case 6:
        case 7:
        case 8:
        case 9:
          return "Good Morning";
          break;

        case 10:
        case 11:
        case 12:
        case 13:
          return "Good Day";
          break;

        case 14:
        case 15:
        case 16:
        case 17:
          return "Good Afternoon";
          break;

        case 18:
        case 19:
        case 20:
        case 21:
          return "Good Evening";
          break;

        case 22:
        case 23:
        case 24:
        case 0:
          return "Good Night";
          break;
      }
    }
  },

  methods: {
    /**
     * Check if the current route matches a route of one of the children of the group element.
     * This method is intended to check if a list group should
     *
     * @param {array} listGroupChildren An array of objects with an <code>path</code> attribute.
     */
    containsCurrentRoute: function(listGroupChildren) {
      let paths = listGroupChildren.map(child => child.route);
      const currentPath = this.$route.path;
      return paths.includes(currentPath);
    },

    /**
     * executed when a item of the navbar gets clicked. Changes the content by switching components
     */
    changeCmp: function(component) {
      /*
       * The following block checks, which one of th ecomponents is selected
       */
      this.contentComponent = component;
    },

    //logging out, handled by laravel
    //submits a form, defined in views/home.blade.php
    logout: () => {
      Axios.post("/api/logout").then(response => {
        window.location.replace("/login");
      });
    }
  }
};
</script>

<style lang="scss">
.no-linkstyle {
  color: white !important;
  text-decoration: none;
}
</style>