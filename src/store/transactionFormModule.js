const state = {
    displayhelptexts: false, //toggles the display of UI Form Helptexts

    date: null,
    accountName: null,
    accountNumber: null,
    booktext: null,
    amount: null,
    counterAccountNumber: null,
    counterAccountName: null,
    automaticCounterBooking: false,
    autoCounterbookingShow: null, //determines if the counterbooking checkbox is shown        //
    tags: null,

    record: null,
    counterRecord: null,

    recordQueue: [],
}

const mutations = {
    setStandardAccounts: (state, relevantCounterAccount) => {
        state.counterAccountNumber = relevantCounterAccount
    },

    buildRecord: (state) => {
        state.record = {
            timestamp_booking: state.date,
            account_number: state.accountNumber,
            account_name: state.accountName,
            description: state.booktext,
            amount: state.amount,
            counter_account_number: state.counterAccountNumber,
            tags: state.tags
        }
    },

    buildCounterRecord: (state) => {
        state.counterRecord = {
            timestamp_booking: state.date,
            account_number: state.counterAccountNumber,
            account_name: state.counterAccountName,
            description: state.booktext,
            amount: state.amount * (-1),
            counter_account_number: state.accountNumber,
            tags: state.tags
        }
    },

    updateRecordQueue: (state, record) => {
        state.recordQueue.push(record)
    },

    deleteRecordQueueElement: (state, itemIndex) => {
        state.recordQueue.splice(itemIndex, 1);
    },

    emptyRecordQueue: (state) => {
        state.recordQueue = []
    },

    toggleCounterBookingCBValue: (state, boolean) => {
        state.automaticCounterBooking = boolean
    },

    toggleDisplay: (state, isChecked) => {
        state.displayhelptexts = isChecked
    },

    toggleCheckboxCounterBooking: (state, boolean) => {
        state.autoCounterbookingShow = boolean
    },

    updateDate: (state, value) => {
        let ISOformattedDate = value
        const [year, month, day] = ISOformattedDate.split("-");
        state.date = `${day}.${month}.${year}`;

    },
    updateAccountName: (state, value) => {
        state.accountName = value
    },
    updateAccountNumber: (state, value) => {
        state.accountNumber = value
    },
    updateBooktext: (state, value) => {
        state.booktext = value
    },
    updateAmount: (state, value) => {
        state.amount = value
    },
    updateCounterAccount: (state, value) => {
        state.counterAccountNumber = value
    },
    updateCounterAccountName: (state, value) => {
        state.counterAccountName = value
    },
    updateTags: (state, value) => {
        state.tags = value
    },

    removeTags: (state, tag) => {
        state.tags.splice(state.tags.indexOf(tag), 1)
        //state.tags = [...state.tags];
    },
    clearTransactionForm: (state) => {
        state.displayhelptexts = false //toggles the display of UI Form Helptexts
        state.date = null
        state.accountName = null
        state.accountNumber = null
        state.booktext = null
        state.amount = null
        state.counterAccountNumber = null
        state.counterAccountName = null
        state.tags = null
    },

}

export default {
    namespaced: true,
    state,
    mutations,
    //actions
}