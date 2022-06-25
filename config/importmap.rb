# Pin npm packages by running ./bin/importmap

pin "application", preload: true
pin "list", preload: true
pin "@hotwired/turbo-rails", to: "turbo.min.js", preload: true
pin "@hotwired/stimulus", to: "stimulus.min.js", preload: true
pin "@hotwired/stimulus-loading", to: "stimulus-loading.js", preload: true
pin_all_from "app/javascript/controllers", under: "controllers"
pin "string-natural-compare", to: "https://ga.jspm.io/npm:string-natural-compare@2.0.3/natural-compare.js"
pin "tablefilter", to: "https://ga.jspm.io/npm:tablefilter@0.7.0/index.js"
