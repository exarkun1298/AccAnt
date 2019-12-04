// App components
import DatabaseTypeORM from './database/DatabaseTestTypeORM.vue'
import Database from './database/DatabaseTest.vue'
import AccountManager from './components/accountManager/AccountManager.vue'
import Dashboard from './components/Dashboard.vue'
import Export from './components/Export.vue'
import Home from './components/Home.vue'
import Import from './components/importBankAccount/Import.vue'
import Info from './components/Info.vue'
import Settings from './components/Settings.vue'
import TagManager from './components/TagManager.vue'
import TransactionUI from './components/transactions/TransactionUI.vue'
import Templates from './components/Templates.vue'
import TransactionHistory from './components/History.vue'
import UndoTrans from './components/UndoTransaction.vue'
import UserPreferences from './components/UserPreferences.vue'

export const routes = [


  {
    path: '/accountmanager',
    component: AccountManager,
    meta: {
      requiresAuthentication: true
    }
  },
  {
    path: '/database',
    component: Database,
    meta: {
      requiresAuthentication: true
    }
  }, {
    path: '/databaseTypeORM',
    component: DatabaseTypeORM,
    meta: {
      requiresAuthentication: true
    }
  },
  {
    path: '/tagmanager',
    component: TagManager,
    meta: {
      requiresAuthentication: true
    }
  },
  {
    path: '/transaction-detail',
    component: TransactionUI,
    meta: {
      requiresAuthentication: true,
      storeMutation: 'switchTransactionStateToDetail',
      transactionUITab: 3
    }
  },
  {
    path: '/transaction-cash',
    component: TransactionUI,
    meta: {
      requiresAuthentication: true,
      storeMutation: 'switchTransactionStateToCash',
      transactionUITab: 1
    }
  },
  {
    path: '/transaction-cashsimple',
    component: TransactionUI,
    meta: {
      requiresAuthentication: true,
      storeMutation: 'switchTransactionStateToCashSimple',
      transactionUITab: 0
    }
  },
  {
    path: '/transaction-bank',
    component: TransactionUI,
    meta: {
      requiresAuthentication: true,
      storeMutation: 'switchTransactionStateToBank',
      transactionUITab: 2
    }
  },
  {
    path: '/history',
    component: TransactionHistory,
    meta: {
      requiresAuthentication: true
    }
  },
  {
    path: '/home',
    component: Home,
    meta: {
      requiresAuthentication: true
    }
  },
  {
    path: '/dashboard',
    component: Dashboard,
    meta: {
      requiresAuthentication: true
    }
  },
  {
    path: '/templates',
    component: Templates,
    meta: {
      requiresAuthentication: true
    }
  },
  {
    path: '/export',
    component: Export,
    meta: {
      requiresAuthentication: true
    }
  },
  {
    path: '/import',
    component: Import,
    meta: {
      requiresAuthentication: true
    }
  },
  {
    path: '/undo',
    component: UndoTrans,
    meta: {
      requiresAuthentication: true
    }
  },
  {
    path: '/user-preferences',
    component: UserPreferences,
    meta: {
      requiresAuthentication: true
    }
  },
  {
    path: '/settings',
    component: Settings,
    meta: {
      requiresAuthentication: true
    }
  },
  {
    path: '/info',
    component: Info,
    meta: {
      requiresAuthentication: true
    }
  }
]
