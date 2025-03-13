const fbLoginCallback = (response) => {
  if (response.authResponse) {
    const code = response.authResponse.code;
    console.log("Code: ", code);
    // The returned code must be transmitted to your backend first and then
    // perform a server-to-server call from there to our servers for an access token.
  }
  document.getElementById("sdk-response").textContent = JSON.stringify(response, null, 2);
}

const launchWhatsAppSignup = () => {
  // Launch Facebook login
  FB.login(fbLoginCallback, {
    config_id: '1777754066122477', // configuration ID goes here
    response_type: 'code', // must be set to 'code' for System User access token
    override_default_response_type: true, // when true, any response types passed in the "response_type" will take precedence over the default types
    extras: {
      setup: {},
      featureType: '',
      sessionInfoVersion: '2',
    }
  });
}

window.addEventListener('message', (event) => {
  if (event.origin !== "https://www.facebook.com" && event.origin !== "https://web.facebook.com") {
    return;
  }
  try {
    const data = JSON.parse(event.data);
    if (data.type === 'WA_EMBEDDED_SIGNUP') {
      // if user finishes the Embedded Signup flow
      if (data.event === 'FINISH') {
        const {phone_number_id, waba_id} = data.data;
        console.log("Phone number ID ", phone_number_id, " WhatsApp business account ID ", waba_id);
        // if user cancels the Embedded Signup flow
      } else if (data.event === 'CANCEL') {
        const {current_step} = data.data;
        console.warn("Cancel at ", current_step);
        // if user reports an error during the Embedded Signup flow
      } else if (data.event === 'ERROR') {
        const {error_message} = data.data;
        console.error("error ", error_message);
      }
    }
    document.getElementById("session-info-response").textContent = JSON.stringify(data, null, 2);
  } catch {
    console.log('Non JSON Responses', event.data);
  }
});