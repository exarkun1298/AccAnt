import Vue from "vue";
import Vuex from "vuex";

import authentication from "./authenticationModule.js"
import userSettings from "./userSettingsModule.js"
import transactions from "./transactionModule.js"
import transactionsForm from "./transactionFormModule.js"

import VuexPersistence from 'vuex-persist'

Vue.use(Vuex);

const authenticationLocal = new VuexPersistence({
  storage: window.localStorage,
  reducer: state => ({
    authentication: state.authentication
  }), // only save authentication module
  //    filter: mutation => (mutation.type == 'changeTokenType'       //  Default returns true for all mutations
  //                        || mutation.type == 'changeAccessToken'
  //                        || mutation.type == 'changeRefreshToken')
});

export const store = new Vuex.Store({
  modules: {
    authentication,
    userSettings,
    transactions,
    transactionsForm
  },
  plugins: [authenticationLocal.plugin]
});