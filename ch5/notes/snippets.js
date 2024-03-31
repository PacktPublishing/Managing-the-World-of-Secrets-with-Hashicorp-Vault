// Rules were deprecated in favor of Actions
// New Auth0 tenants have no option to user rules => after converting a rule to an action we have the following
exports.onExecutePostLogin = async (event, api) => {
    const namespace = "https://example.com/roles";
    event.user.app_metadata = event.user.app_metadata || {};
    api.idToken.setCustomClaim(`${namespace}`, event.user.app_metadata.roles || []);
    return;
  };
  