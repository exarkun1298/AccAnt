import Vue from 'vue'
import './plugins/vuetify'
import App from './AccAntApp.vue'
import VueRouter from 'vue-router'
import {
  routes
} from './router.js'
import 'material-design-icons-iconfont'

import {
  store
} from './store/store'
import './registerServiceWorker'

Vue.use(VueRouter)

const router = new VueRouter({
  mode: 'history',
  routes
})

Vue.config.productionTip = false

/**
 * Then the <b>Event-Buses</b> get set up to enable proper communication across multiple components.
 *
 * --- transactionEventBus ---
 * Components can use the following events within this eventBus:
 * <code>
 *    "onDeleteTableElement", Parameter (index as Number)
 *    -> Deletes the indexed TransactionTable element
 * </code>
 *
 * --- snackBarEventBus ---
 * Snackbars are defines in ContentContainer.vue
 * Components can use the following events within this eventBus:
 * <code>
 *    "onShowSnackBar", Parameter (message as String, icon as String, [duration as Number])
 *    -> shows a Snackbar with given message and icon (duration optional, default is 3000ms)
 *  </code>
 *
 * -- accountManagerEventBus ---
 * Components can use the following events within this eventBus:
 * <code>
 *    "updateAccountData", no Parameter
 *    -> updates the Table which shows the stored Accounts on the Database
 *
 *    "openDialogue", Parameter("simple" / "advanced" / "delete" as String)
 *    -> opens the specified Dialogue
 *
 *    "closeDialogue", Parameter ("simple"/"advanced"/"delete" as String)
 *    -> closes the specified Dialogue
 *
 *    "updateAccountData", Parameter (tableNameParameter as String)
 *    -> updates a certain instance of an accountTable. Available Tables:
 *        'accountsInUse'     - Account Manager Main Table
 *        'deletedAccounts'   - Deleted Accounts Dialogue Table
 *
 *
 * </code>
 */
export const transactionEventBus = new Vue()
export const snackBarEventBus = new Vue()
export const accountManagerEventBus = new Vue()

new Vue({
  router,
  store,
  render: h => h(App)
}).$mount('#app')
