const fbLoginCallback = (response) => {
  if (response.authResponse) {
    const code = response.authResponse.code;
    const chatbotId = document.querySelector('button[data-chatbot-id]').getAttribute('data-chatbot-id');

    fetch(`/wabas/exchange_token_and_subscribe_app`, {
      method: 'POST',
      body: JSON.stringify({ chatbot_id: chatbotId, waba: { code } }),
      headers: {
        "Content-Type": "application/json",
        "Accept": "text/vnd.turbo-stream.html, application/json",
        "X-CSRF-Token": document.querySelector("[name='csrf-token']").content
      }
    })
    .then(response => {
      const contentType = response.headers.get("content-type");
      if (contentType && contentType.includes("text/vnd.turbo-stream.html")) {
        return response.text().then(html => {
          setTimeout(() => {
            Turbo.renderStreamMessage(html);
          }, 300);
        });
      }
      return response.json();
    })
    .then(data => {
      if (data && data.success) {
        console.log("Token exchanged successfully");
      } else if (data && data.error) {
        console.error("Failed to exchange token:", data.error);
      }
    })
    .catch(error => {
      console.error("Error exchanging token:", error);
    });
  }
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
        const chatbotId = document.querySelector('button[data-chatbot-id]').getAttribute('data-chatbot-id');
        const { phone_number_id, waba_id } = data.data;

        fetch(`/wabas`, {
          method: 'POST',
          body: JSON.stringify({ chatbot_id: chatbotId, waba: { phone_number_id, waba_id } }),
          headers: {
            "Content-Type": "application/json",
            "X-CSRF-Token": document.querySelector("[name='csrf-token']").content
          }
        })
        .then(response => response.json())
        .then(data => {
          console.info("Phone number ID ", phone_number_id, " WhatsApp business account ID ", waba_id);
        })
        .catch(error => {
          console.error("Error saving WhatsApp account: ", error);
          alert("Error saving WhatsApp account: " + error.message);
        });
        // if user cancels the Embedded Signup flow
      } else if (data.event === 'CANCEL') {
        const {current_step} = data.data;
        alert("Cancel at " + current_step);
        console.warn("Cancel at ", current_step);
        // if user reports an error during the Embedded Signup flow
      } else if (data.event === 'ERROR') {
        const {error_message} = data.data;
        alert("Error: " + error_message);
        console.error("error ", error_message);
      }
    }
  } catch {
    console.log('Non JSON Responses', event.data);
  }
});
