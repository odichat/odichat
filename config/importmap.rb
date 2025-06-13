# Pin npm packages by running ./bin/importmap

pin "application"
pin "@hotwired/turbo-rails", to: "turbo.min.js"
pin "@hotwired/stimulus", to: "stimulus.min.js"
pin "@hotwired/stimulus-loading", to: "stimulus-loading.js"

pin "@rails/activestorage", to: "activestorage.esm.js"

pin_all_from "app/javascript/controllers", under: "controllers"

pin "@sentry/browser", to: "@sentry--browser.js" # @9.17.0
pin "@sentry-internal/browser-utils", to: "@sentry-internal--browser-utils.js" # @9.17.0
pin "@sentry-internal/feedback", to: "@sentry-internal--feedback.js" # @9.17.0
pin "@sentry-internal/replay", to: "@sentry-internal--replay.js" # @9.17.0
pin "@sentry-internal/replay-canvas", to: "@sentry-internal--replay-canvas.js" # @9.17.0
pin "@sentry/core", to: "@sentry--core.js" # @9.17.0

pin "sentry", to: "sentry.js", preload: true
pin "tailwindcss-stimulus-components" # @6.1.3
