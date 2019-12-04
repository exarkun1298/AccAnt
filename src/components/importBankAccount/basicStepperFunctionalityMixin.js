export const basicStepperFunctionalityMixin = {
    data() {
        return {
            steps: {
                sourceId: 1,
                fileId: 2,
                importId: 3,
                reviewId: 4,
                submitId: 5
            },
            currentStep: 1,
            importStep: 1,
            selectedSource: {
                name: null,
                description: "Keine Datenquelle ausgewählt."
            },
            sources: [{
                    name: "AccAnt",
                    description: "Import data from the export function of AccAnt."
                },
                {
                    name: "Sparkasse",
                    description: "Import data exported from Sparkasse using <b>CSV-CAMT</b>"
                }
            ],
            selectedFile: null,
        }
    },
    computed: {
        conditionStep1: function () {
            return (
                this.importStep > this.steps.sourceId ||
                // Condition to continue
                (this.selectedSource != null && this.selectedSource.name != null)
            );
        },
        conditionStep2: function () {
            return this.importStep > this.steps.fileId ||
                // Condition to continue
                (this.selectedFile != null);
        },
        conditionStep3: function () {
            return this.importStep > this.steps.importId ||
                // Condition to continue
                (this.metaAssignments.timestamp
                && this.metaAssignments.description
                && this.metaAssignments.amount
                && this.metaAssignments.recipient
                && (!this.createAccountFromImport && this.importAccountName)
                && true); // && true converts to boolean to fix "Expected Boolean, got String."
        },
        conditionStep4: function () {
            return this.importStep > this.steps.reviewId ||
                // Condition to continue
                (true);    // There is none
        },
        conditionStep5: function () {
            return this.importStep >= this.steps.submitId;
        }
    },

    methods: {

        /**
         * Transition from one step to another.
         *
         * @param {int} targetStep The number of the next step to go to (forward and backwards).
         */
        transition: function (targetStep) {
            if(this.currentStep < targetStep) {
                // Go forward: (1) -> (2)

                // Transition logic
                switch(targetStep) {
                    case this.steps.fileId:
                        // Nothing to do...
                        break;
                    case this.steps.importId:
                        // Import data on first visit
                        if(this.importStep < this.steps.importId) {
                            // Import data from selected file and populate preview table on first visit.
                            this.showPreview();
                        }
                        break;
                    case this.steps.reviewId:
                        // Preview associated columns on first visit
                        if(this.importStep < this.steps.reviewId) {
                            // Filter imported data and populate preview table on first visit.
                            this.filterData();
                        }
                        break;
                    case this.steps.submitId:
                        // Nothing to do...
                        break;
                    default:
                        throw new Exception('Transition for step ' + this.currentStep + ' not implemented!');
                }

                // Go to next step
                this.currentStep = targetStep;

                // Store progress (for random accessing other steps)
                this.importStep = Math.max(targetStep, this.importStep);
            }
            else if(this.currentStep > targetStep) {
                // Go backwards: (5) -> (4)
                this.currentStep = targetStep;
            }
        },


        updateDescription(source) {
            let indexOfSearchedName;
            let sourcesCopy = JSON.parse(JSON.stringify(this.sources));
            indexOfSearchedName = sourcesCopy
                .map(function (obj) {
                    return obj.name;
                })
                .indexOf(source);

            this.selectedSource = sourcesCopy[indexOfSearchedName];
        },


        fileSelected: function (file) {
            this.selectedFile = file;
        },

    },

}