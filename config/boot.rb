ENV['CRYSTAL_ENV'] ||= 'development'
ENV['BUNDLE_GEMFILE'] ||= File.expand_path('../Gemfile', __dir__)
ENV['DATABASE_PATH']  ||= File.expand_path("../db/#{ENV['CRYSTAL_ENV']}.sqlite3", __dir__)

require 'bundler/setup'
Bundler.require(:default)

require 'active_record'
Dir.glob(File.join('.', 'app', '**', '*.rb')) do |lib|
  autoload File.basename(lib, ".rb").capitalize.to_sym, lib
end

ActiveRecord::Base.establish_connection(:adapter => 'sqlite3',:database => ENV['DATABASE_PATH'])
