source 'https://rubygems.org'

# зависим от рельсов 4.2.*
gem 'rails', '~> 4.2.6'

# гем для аутентификации
gem 'devise', '~> 4.1.1'

# гем для перевода сообщений девайса
gem 'devise-i18n'

# гем с русскими форматами (времени и пр.)
gem 'rails-i18n'

# гем, интегрирующий bootstrap
gem 'twitter-bootstrap-rails'

gem 'carrierwave','~>0.11.2'
gem 'rmagick'
gem 'fog-aws', '1.0.0'

gem 'uglifier', '>= 1.3.0'

# для поддержки jquery
gem 'jquery-rails'

gem 'annotate'

# в продакшен сервере heroku этот гем соединяет с базой данных Postgres
group :production do
  gem 'pg'
end

group :development, :test do
  gem 'sqlite3'
  gem 'byebug'
end

