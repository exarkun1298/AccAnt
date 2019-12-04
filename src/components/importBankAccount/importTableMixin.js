export const importTableMixin = {
    data() {
        return {
            rawData: null,      // The raw data from parser

            // Preprocessed RAW data for preview table (especially headers).
            csvHeaders: [],     // Generated headers for data table
            csvData: [],        // Data for data table
        }
    },

    methods: {
        showPreview: function () {

            /*
             * Store Vue instance for sub-functions
             */
            const _this = this;

            // Parse and show the selected file
            this.parseCSV(this.selectedFile, this.selectedSource.name, parseCompleteCallback, errorCallback);

            /**
             * Callback for parse function that inserts the received data into the data source of the preview table.
             *
             * <b>From Papa Parse 4 doc:</b><br/>
             * The callback to execute when parsing is complete. It receives the parse <a href="#results">results</a>. If parsing a local file, the <a href="https://developer.mozilla.org/en-US/docs/Web/API/File">File</a> is passed in, too:
             *
             * <pre>complete: function(results, file) {
             *     console.log("Parsing complete:", results, file);
             * }</pre>
             * (When streaming, parse results are <i>not</i> available in this callback.)[not applicable here]
             *
             * @param results
             * @param file
             */
            function parseCompleteCallback(results, file) {
                let rowCount = 0, errorCount = 0, firstError;

                // Check result for errors...
                if (results) {
                    // Error handling
                    if (results.errors.length > 0) {
                        errorCount = results.errors.length;
                        firstError = results.errors[0];
                    }

                    // Process the data for preview table.
                    processData(results);

                    // Process the meta data
                    processMetaData(results);
                }
                else {
                    throw new Error('There is no parse result.');
                }
            }

            /**
             * Process the results for the preview table.
             *
             * @param results The results of Papa Parse
             */
            function processData(results) {
                if (results.data && results.data.length > 0) {
                    // Store a deep copy of the parsed raw data
                    _this.rawData = JSON.parse(JSON.stringify(results.data));

                    // Remove header (= 1st) row from data array.
                    const headerRow = results.data.shift();

                    // Store headers for preview table
                    let headers = [];
                    headerRow.forEach(function (headerName) {
                        headers.push({
                            text: headerName,
                            value: headerName,
                        })
                    });

                    // Insert parsed headers and data in data source of preview table
                    _this.csvHeaders = headers;
                    _this.csvData = results.data;
                }
            }


            /**
             * Call this function to process the data after parsing is done.
             * E.g. this function maps the header to the appropirate database values.
             */
            function processMetaData() {
                switch (_this.selectedSource.name) {
                    case _this.importer.accant:
                        processMetaAccant();
                        break;
                    case _this.importer.sparkasse:
                        processMetaSparkasse();
                        break;
                    default:
                        throw {
                            name: "NotImplementedException",
                            message: "The selected importer '" + _this.importer + "' is not supported or not implemented.",
                            toString: function () {
                                return this.name + ": " + this.message;
                            }
                        };


                }

                function processMetaAccant() {
                    // TODO Implement this method...
                    throw new Error('Not implemented yet.');
                }

                function processMetaSparkasse() {
                    // The mapping of the columns of the Sparkasse CSV to the database.
                    const assignedColumns = {
                        timestamp: 'Buchungstag',           // When the transaction was booked
                        description: 'Verwendungszweck',    // The description text of the transaction
                        amount: 'Betrag',                   // The amount of the transaction (in EUR)
                        recipient: 'Beguenstigter/Zahlungspflichtiger',        // The recipient (destination / target) of the transaction
                    };

                    // Set the assigned mappings
                    _this.metaAssignments = assignedColumns;
                }
            }

            /**
             * Use this function as callback for errors.
             * <b>From Papa Parse 4:</b><br/>
             *  A callback to execute if FileReader encounters an error. The function is passed two arguments: the error and the File.
             *
             * @param err
             * @param file
             */
            function errorCallback(err, file) {
                end = now();
                console.log("ERROR:", err, file);
                enableButton();
            }
        },


        /**
         * Filter the csvHeader and csvData for the associated columns (set in {@see this.columns} ).
         */
        filterData: function () {

            // Filter header
            this.importHeaders = [
                { text: "timestamp [" + this.metaAssignments.timestamp + "]",   value: this.metaAssignments.timestamp, },
                { text: "description [" + this.metaAssignments.description + "]", value: this.metaAssignments.description, },
                { text: "amount [" + this.metaAssignments.amount + "]",      value: this.metaAssignments.amount, },
                { text: "recipient [" + this.metaAssignments.recipient + "]",   value: this.metaAssignments.recipient, },
            ];

            // Filter data
            const headerRow = this.rawData[0];
            const headerIndex = {
                timestampIx:   headerRow.indexOf(this.metaAssignments.timestamp),
                descriptionIx: headerRow.indexOf(this.metaAssignments.description),
                amountIx:      headerRow.indexOf(this.metaAssignments.amount),
                recipientIx:   headerRow.indexOf(this.metaAssignments.recipient),
            };
            this.importData = this.csvData.map(row => {
                return [
                    row[ headerIndex.timestampIx ],
                    row[ headerIndex.descriptionIx ],
                    row[ headerIndex.amountIx ],
                    this.createAccountFromImport ? row[ headerIndex.recipientIx ] : this.importAccountName,
                ];
            });

        }
    },
}