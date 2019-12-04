import PapaParser from 'papaparse';

export const bankAccountImporterMixin = {
    data() {
        return {
            importer: {
                accant: "AccAnt",
                sparkasse: "Sparkasse",
            },

            /**
             * The important columns that will be used in the backend as well.
             * Use this as a template inside the importer function.
             *
             * @type {{timestamp: null, description: null, amount: null, recipient: null}}
             */
            columns: {
                timestamp: null, // When the transaction was booked
                description: null, // The description text of the transaction
                amount: null, // The amount of the transaction (in EUR)
                recipient: null, // The recipient (destination / target) of the transaction
            },

            /**
             * A useful default Parse Config Object for Papa Parse. This was adjusted for this app.
             *
             * <b>From Papa Parse 4:</b><br/>
             * The parse function may be passed a configuration object. It defines settings, behavior,
             * and callbacks used during parsing. Any properties left unspecified will resort to their default values.
             *
             * @see https://www.papaparse.com/docs#config
             * @type {{complete: undefined, error: undefined, delimiter: string, newline: string, quoteChar: string, escapeChar: string, header: boolean, trimHeaders: boolean, dynamicTyping: boolean, preview: number, encoding: string, worker: boolean, comments: boolean, step: undefined, download: boolean, skipEmptyLines: boolean, chunk: undefined, fastMode: undefined, beforeFirstChunk: undefined, withCredentials: undefined, transform: undefined}}
             */
            papaConfig: {
                complete: undefined,
                error: undefined,

                // Optional
                delimiter: "", // auto-detect
                newline: "", // auto-detect
                quoteChar: '"',
                escapeChar: '"',
                header: false,  // default: false; If header is true data is an object keyed by the field name; Somehow required for vuetify data tables -_-!
                trimHeaders: false,
                dynamicTyping: false,
                preview: 0,
                encoding: "",
                worker: false,
                comments: false,
                step: undefined,
                download: false,
                skipEmptyLines: true,   // default: false; They are (in general) useless for AccAnt
                chunk: undefined,
                fastMode: undefined,
                beforeFirstChunk: undefined,
                withCredentials: undefined,
                transform: undefined
            }
        }
    },

    methods: {
        /**
         * Parse a given CSV file to an array.
         * <b>From Papa Parse doc</b> (<a href="https://www.papaparse.com/docs#results">The Parse Result Object</a>): <br/>
         *
         * <code>config.complete:</code><br/>
         * <ul><li>
         *     <code>complete:</code>
         *          The callback to execute when parsing is <code>complete</code>. It receives the parse <a href="#results">results</a> [...] and
         *          the passed in <a href="https://developer.mozilla.org/en-US/docs/Web/API/File">File</a>:
         * <pre>complete: function(results, file) {
         *   console.log("Parsing complete:", results.data, results.errors, results.meta, file);
         * } </pre>
         *   </li>
         *   <li>
         *     <code>results: {data, errors, meta}</code> The Parse Result Object<br/>
         *                           A parse result always contains three objects: data, errors, and meta. Data and errors are arrays, and meta is an object.
         *   </li>
         * </ul>
         *
         * @param {file} file The file that contains the CSVs.
         * @param {string} importer The used importer. @see this.importer
         * @param {function} onComplete The callback to execute when parsing is complete. It receives the parse results and the passed File. (from Papa Parse doc)

         * @param {function} onError [optional] The callback function that will be called (by Papa Parse) when an error occurs. <br/>
         *                           <b>From the Papa Parse doc:</b><br/>
         *                            A callback to execute if FileReader encounters an error. The function is passed two arguments: the error and the File.
         *
         * @see https://www.papaparse.com/docs#results
         */
        parseCSV: function(file, importer, onComplete, onError) {

            // Create basic config for Papa Parse - adjusted for AccAnt
            let config = JSON.parse(JSON.stringify(this.papaConfig));
            config.complete = onComplete;
            config.error = onError ? onError : undefined;

            switch (importer) {
                case this.importer.accant:
                    parseFromAccant(file, onError);
                    break;
                case this.importer.sparkasse:
                    parseFromSparkasse(file, onError);
                    break;
                default:
                    throw {
                        name: "NotImplementedException",
                        message: "The selected importer '" + importer + "' is not supported or not implemented.",
                        toString: function () {
                            return this.name + ": " + this.message;
                        }
                    };
            }



            /**
             * Import transactions form AccAnt.
             *
             * @param {file} file
             * @param {function} onError
             * @return void THERE IS NO RETURN VALUE! Asyncronous with callbacks!
             */
            function parseFromAccant(file, onError) {
                // TODO Implement this method...
                throw new Error('Not implemented yet.');

                // Asynchronous! => There is no return.
            }

            /**
             * Import transactions form Sparkasse.
             *
             * @param {file} file
             * @param {function} onError
             * @return void THERE IS NO RETURN VALUE! Asyncronous with callbacks!
             */
            function parseFromSparkasse(file, onError) {
                /*
                 * The names of the columns that contain the important data.
                 */
                const columnNames = {
                    timestamp: 'Buchungstag', // When the transaction was booked
                    description: 'Verwendungszweck', // The description text of the transaction
                    amount: 'Betrag', // The amount of the transaction (in EUR)
                    recipient: 'Beguenstigter/Zahlungspflichtiger', // The recipient (destination / target) of the transaction
                };


                // Adapt the basically adjusted Papa Parse config for Sparkasse
                config.delimiter = ";";
                config.encoding = "CP1252";


                // Parse the data...
                PapaParser.parse(file, config);

                // Asynchronous! => There is no return.
            }
        },
    } // END of methods
}