import * as Sentry from "@sentry/browser"

// 1) Initialize Sentry exactly once, on first load
Sentry.init({
  dsn: "https://025f4c0bb2e0f0b49011631b2e93528d@o4508166479413248.ingest.us.sentry.io/4509260589170688",
  // Setting this option to true will send default PII data to Sentry.
  // For example, automatic IP address collection on events
  sendDefaultPii: true,
  integrations: [
    Sentry.feedbackIntegration({
      autoInject: false,      // turn off the one-time auto-inject
      colorScheme: "light",
      showBranding: false,
      isEmailRequired: true,
    }),
  ]
});

// grab it once
const feedback = Sentry.getFeedback()

function mountWidget() {
  if (!feedback) return
  // 1) fully unmount whatever was there (and clear Sentry’s internal pointer)
  feedback.remove()
  // 2) rebuild the host + widget
  feedback.createWidget()
}

// run it on first load
mountWidget()

// and after *every* client-side navigation
document.addEventListener("turbo:render", () => {
  requestAnimationFrame(mountWidget)
})