import AccountTemplates from "./accountTemplates.json";

const state = {
    fastCash: false, //determines if the fast cash UI is clicked

    heading: "Detailbuchung", //written headline
    accountnameDescription: "Accountname", //written accountname
    accountnumberDescription: "Accountnummer", //written accountnumber
    booktextDescription: "Buchtext", //written booktext

    dateShow: true, //determines if a date picker is shown
    counterbookingShow: true, //determines if the counterbooking slot is shown        //
    incomeExpenseShow: false, //determines on fixed counter accounts if the Sign slot is shown
    showHelpCheckbox: true, //determines if the Checkbox activating the Helptexts is shown

    counterAccountMode: "custom", //determines if the frontend should work with a fixed counter account
    showCounterBookingCheckbox: false, //determines if the counterbooking checkbox is shown to the user
    clickableCounterBookingCheckbox: true, //determines if the counterbooking checkbox can be manipulated

    accountTemplates: AccountTemplates //local account templates


};

const mutations = {
    /**
     * @param {boolean} value to show the counterBooking checkbox
     */
    changeCounterBookingCheckboxState: (state, value) => {
        state.showCounterBookingCheckbox = value
    },


    switchTransactionStateToCashSimple: (state) => {
        (state.counterAccountMode = "cash"),
        (state.heading = "Bargeldbuchung"),
        (state.accountnameDescription = "Kontoname"),
        (state.accountnumberDescription = "Kontonummer"),
        (state.booktextDescription = "Beschreibung"),
        (state.dateShow = false),
        (state.counterbookingShow = false),
        (state.incomeExpenseShow = true),
        (state.fastCash = true),
        (state.showHelpCheckbox = false),
        (state.showCounterBookingCheckbox = false),
        (state.clickableCounterBookingCheckbox = false)
    },


    //if Cash Transaction gets selected in the nav bar
    switchTransactionStateToCash: (state) => {
        (state.counterAccountMode = "cash"),
        (state.heading = "Bargeldbuchung"),
        (state.accountnameDescription = "Kontoname"),
        (state.accountnumberDescription = "Kontonummer"),
        (state.booktextDescription = "Beschreibung"),
        (state.dateShow = true),
        (state.counterbookingShow = false),
        (state.incomeExpenseShow = true),
        (state.fastCash = false),
        (state.showHelpCheckbox = false),
        (state.showCounterBookingCheckbox = true),
        (state.clickableCounterBookingCheckbox = false)
    },


    switchTransactionStateToBank: (state) => {
        (state.counterAccountMode = "bank"),
        (state.heading = "Bankbuchung"),
        (state.accountnameDescription = "Kontoname"),
        (state.accountnumberDescription = "Kontonummer"),
        (state.booktextDescription = "Beschreibung"),
        (state.dateShow = true),
        (state.counterbookingShow = false),
        (state.incomeExpenseShow = true),
        (state.fastCash = false),
        (state.showHelpCheckbox = false),
        (state.showCounterBookingCheckbox = true),
        (state.clickableCounterBookingCheckbox = false)
    },

    //if Detail Transaction gets selected in the nav bar
    switchTransactionStateToDetail: (state) => {
        (state.counterAccount = null),
        (state.counterAccountMode = "custom"),
        (state.heading = "Detailbuchung"),
        (state.accountnameDescription = "Accountname"),
        (state.accountnumberDescription = "Accountnummer"),
        (state.booktextDescription = "Buchtext"),
        (state.dateShow = true),
        (state.counterbookingShow = true),
        (state.incomeExpenseShow = false),
        (state.fastCash = false),
        (state.showHelpCheckbox = true),
        (state.showCounterBookingCheckbox = false),
        (state.clickableCounterBookingCheckbox = true)
    },
};

const actions = {
    changeState: ({
        commit,
        rootState
    }, transactionVariant) => {
        let standardBank = rootState.userSettings.standardBankAccount
        let standardCash = rootState.userSettings.standardCashAccount
        let relevantCounterAccount = null

        console.log(state.counterAccountMode)

        commit(transactionVariant.mutation)
        if (state.counterAccountMode = "cash") {
            relevantCounterAccount = standardCash
        }
        if (state.counterAccountMode = "bank") {
            relevantCounterAccount = standardBank
        }

        console.log(state.counterAccountMode)
        commit("transactionsForm/setStandardAccounts", relevantCounterAccount, {
            root: true
        })

    },

    autocompleteAccountName: ({
        commit,
        rootState
    }, number) => {

    },

    autocompleteCounterAccountName: ({
        commit,
        rootState
    }, number) => {

    }
}




export default {
    namespaced: true,
    state,
    mutations,
    actions
}