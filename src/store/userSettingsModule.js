import Axios from 'axios'

const state = {
    name: "",
    email: "",
    standardCashAccount: null,
    standardBankAccount: null,
    loaded: false,
}

const mutations = {
    changeStandardAccounts: (state, {
        standardBank,
        standardCash
    }) => {
        state.standardBankAccount = standardBank
        state.standardCashAccount = standardCash
    },

    setUserInformation: (state, {
        bankNumber,
        cashNumber,
        name,
        email,
        loaded
    }) => {
        state.standardBankAccount = bankNumber
        state.standardCashAccount = cashNumber
        state.name = name;
        state.email = email;
        state.loaded = loaded;
    },
}

const actions = {
    /**
     * Get information from database
     */
    fetchUserData({
        commit,
        rootState
    }) {
        Axios.get("/api/get-basic-user-data").then(answer => {
            let userInformationObject = {
                bankNumber: answer.data.standard_bank,
                cashNumber: answer.data.standard_cash,
                name: answer.data.name,
                email: answer.data.email,
                loaded: true
            }

            commit("setUserInformation", userInformationObject)

        });
    }
}

export default {
    namespaced: true,
    state,
    mutations,
    actions
}