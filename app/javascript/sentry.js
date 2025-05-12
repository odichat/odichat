
import * as Sentry from "@sentry/browser"

Sentry.init({
  dsn: "https://025f4c0bb2e0f0b49011631b2e93528d@o4508166479413248.ingest.us.sentry.io/4509260589170688",
  // Setting this option to true will send default PII data to Sentry.
  // For example, automatic IP address collection on events
  sendDefaultPii: true,
  integrations: [
    Sentry.feedbackIntegration({
      colorScheme: "light",
      showBranding: false,
      isEmailRequired: true
    }),
  ]
});