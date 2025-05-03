# Pin npm packages by running ./bin/importmap

pin "application"
pin "@hotwired/turbo-rails", to: "turbo.min.js"
pin "@hotwired/stimulus", to: "stimulus.min.js"
pin "@hotwired/stimulus-loading", to: "stimulus-loading.js"
pin "@rails/activestorage", to: "activestorage.esm.js"
pin "@sentry/browser", to: "https://ga.jspm.io/npm:@sentry/browser@7.99.0/esm/index.js"
pin_all_from "app/javascript/controllers", under: "controllers"
pin "sentry", to: "sentry.js"
