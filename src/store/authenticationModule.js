import Axios from "axios";

const state = {
    tokenType: "",
    accessToken: "",
    refreshToken: "",
};

const mutations = {

    /**
     * @param state
     * @param {string} tokenType
     */
    changeTokenType: (state, tokenType) => {
        // Change state
        state.tokenType = tokenType;

        // Update the auth header
        helpers.changeAuthorizationHeader(state.tokenType, state.accessToken);
    },

    /**
     * @param state
     * @param {string} accessToken
     */
    changeAccessToken: (state, accessToken) => {
        // Change state
        state.accessToken = accessToken;

        // Update the auth header
        helpers.changeAuthorizationHeader(state.tokenType, state.accessToken);
    },

    /**
     * @param state
     * @param {string} refreshToken
     */
    changeRefreshToken: (state, refreshToken) => {
        // Change state
        state.refreshToken = refreshToken;
    },

};

const actions = {

    /**
     * Submit a login request. Will store the received OAuth tokens in storage.
     *
     * @param context
     * @param {string} username
     * @param {string} password
     * @throws Rethrow the error while authenticating.
     */
    submitLogin: (context, {
        username,
        password
    }) => {
        //context as parameter, to be able to refer to the store module via context.method()

        // Build credentials from params
        const credentials = {
            username: username,
            password: password
        };

        // Send request
        return Axios.post("/api/login", credentials)
            .then(response => {
                // Fetch tokens form response
                const resData = response.data;

                // OAuth Tokens from response
                const tokens = {
                    tokenType: resData.token_type,
                    accessToken: resData.access_token,
                    refreshToken: resData.refresh_token,
                };

                // Store tokens
                context.commit('changeTokenType', tokens.tokenType);
                context.commit('changeAccessToken', tokens.accessToken);
                context.commit('changeRefreshToken', tokens.refreshToken);
            })
            .catch(error => {
                throw error;
            });
    },


    /**
     * Execute the logout logic.
     */
    logout: () => {
        // Clear stored tokens
        context.commit('changeTokenType', "");
        context.commit('changeAccessToken', "");
        context.commit('changeRefreshToken', "");
    },

};

/*
 * Helper functions
 *
 * @type {{changeAuthorizationHeader: helpers.changeAuthorizationHeader}}
 * @private
 */
const helpers = {
    /**
     * Update the "Authorization" value of default header of Axios.
     *
     * @param {string} tokenType - usually "Bearer"
     * @param {string} accessToken The OAuth access token.
     */
    changeAuthorizationHeader: (tokenType, accessToken) => {
        // The key of the value in the header
        const headerKey_Authorization = "Authorization";
        // Build the token
        const token = tokenType + " " + accessToken;

        // Set the authorization token.
        Axios.defaults.headers.common[headerKey_Authorization] = token;
    },
};

export default {
    namespaced: true,
    state,
    mutations,
    actions
}