window.sentryOnLoad = function() {
  Sentry.init({
    dsn: "https://025f4c0bb2e0f0b49011631b2e93528d@o4508166479413248.ingest.us.sentry.io/4509260589170688",
    // add other configuration here
  });

  Sentry.lazyLoadIntegration("feedbackIntegration")
    .then((feedbackIntegration) => {
      Sentry.addIntegration(feedbackIntegration({
        // User Feedback configuration options
        autoInject: true,
        showBranding: false
      }));
    })
    .catch(() => {
      // this can happen if e.g. a network error occurs,
      // in this case User Feedback will not be enabled
    });
};