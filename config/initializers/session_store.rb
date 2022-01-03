# if Rails.env == 'production'
#   Rails.application.config.session_store :cookie_store, key: '_final', domain: 'final-json-api', same_site: :none, secure: true
# else
#   Rails.application.config.session_store :cookie_store, key: '_final'
# end

Rails.application.config.session_store :cookie_store, key: '_togetherWeCan'