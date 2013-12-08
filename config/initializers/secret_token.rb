ProductCatalogue::Application.config.secret_token = ENV['SECRET_TOKEN'] || 'nope'*20
ProductCatalogue::Application.config.secret_key_base = ENV['SECRET_KEY_BASE'] || 'nope'*5
