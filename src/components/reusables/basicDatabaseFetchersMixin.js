import Axios from "axios";

export const basicDatabaseFetchersMixin = {
  data() {
    return {
      tempAccountTable: [],
      transactionTableDataRepresentation: []
    };
  },
  methods: {
    /**
     * This method fetches the AccountTable for local use without soft deleted accounts
     * @param none
     * @return void
     * @async this.tempAccountTable will be provided with the existing accounts
     */

    getAccountTableFromDatabase() {
      this.tempAccountTable = [];
      Axios.get("/api/get-account-table").then(
        answer => {
          const serverAccountTable = JSON.parse(answer.data);
          for (let i = 0; i < serverAccountTable.length; i++) {
            const accID = serverAccountTable[i].id;
            const accNumber = serverAccountTable[i].number;
            const accName = serverAccountTable[i].name;
            const accDesc = serverAccountTable[i].description;
            const accountObject = {
              id: accID,
              number: accNumber,
              name: accName,
              description: accDesc
            };
            this.tempAccountTable.push(accountObject);
          }
        },
        error => {
          console.log("error at fetching account table:" + error);
        }
      );
    },
    getAllTransactionsOfUser() {
      Axios.get("localhost:8080/accant/api-auth/accTypeTemplates").then(
        answer => {
          const transactions = JSON.parse(JSON.stringify(answer.data));
          console.log(transactions);

          // formatting
          for (let i = 0; i < transactions.length; i++) {
            const day = transactions[i].timestamp_booking.substring(8, 10);
            const month = transactions[i].timestamp_booking.substring(5, 7);
            const year = transactions[i].timestamp_booking.substring(0, 4);
            transactions[i].timestamp_booking = day + "." + month + "." + year;
          }

          // TO DO sorting

          this.transactionTableDataRepresentation = transactions;
          return transactions;
        },
        error => {
          console.log("error in fetching user's transactions data:" + error);
        }
      );
    },

    // This method fetches all accounts (including soft deleted) from the Database
    getAccountFullTableFromDatabase() {
      this.tempAccountTable = [];
      Axios.get("/api/get-full-account-table").then(
        answer => {
          const serverAccountTable = JSON.parse(answer.data);
          for (let i = 0; i < serverAccountTable.length; i++) {
            const accID = serverAccountTable[i].id;
            const accNumber = serverAccountTable[i].number;
            const accName = serverAccountTable[i].name;
            const accountObject = {
              id: accID,
              number: accNumber,
              description: accName
            };
            this.tempAccountTable.push(accountObject);
          }
          console.log(this.tempAccountTable);
        },
        error => {
          console.log("error at fetching account table:" + error);
        }
      );
    },

    /**
     * Fetches the account name of a given account and assigns it to the property to be the
     * account or counter account
     *
     * @param {int} accountNumber search for this account number
     */
    async searchForAccountName(accountNumber) {
      console.log("autocomplete search for " + accountNumber + " pending....");
      return Axios.post("/api/search-for-account-by-number", {
        account_number: accountNumber
      });
    }
  }
};
