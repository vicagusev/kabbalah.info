#SCRIPT_LINES__ = {} if ENV['RAILS_ENV'] == 'development' and not SCRIPT_LINES__

# Be sure to restart your web server when you modify this file.

# Uncomment below to force Rails into production mode when
# you don't control web/app server and can't set it the proper way
# ENV['RAILS_ENV'] ||= 'production'

# Specifies gem version of Rails to use when vendor/rails is not present
RAILS_GEM_VERSION = '2.1' unless defined? RAILS_GEM_VERSION

# Bootstrap the Rails environment, frameworks, and default configuration
require File.join(File.dirname(__FILE__), 'boot')

Rails::Initializer.run do |config|
  # Settings in config/environments/* take precedence over those specified here

  # Skip frameworks you're not going to use (only works if using vendor/rails)
  # config.frameworks -= [ :action_web_service, :action_mailer ]

  # Only load the plugins named here, by default all plugins in vendor/plugins are loaded
  # config.plugins = %W( exception_notification ssl_requirement )

config.action_mailer.delivery_method = :sendmail
config.action_mailer.default_charset = "utf-8"

  # Add additional load paths for your own custom dirs
  # config.load_paths += %W( #{RAILS_ROOT}/extras )

  # Force all environments to use the same logger level
  # (by default production uses :info, the others :debug)
  # config.log_level = :debug
	config.logger = Logger.new(config.log_path, 10, 5242880)

  # Use the database for sessions instead of the file system
  # (create the session table with 'rake db:sessions:create')
  config.action_controller.session_store = :active_record_store

  # Use SQL instead of Active Record's schema dumper when creating the test database.
  # This is necessary if your schema can't be completely dumped by the schema dumper,
  # like if you have constraints or database-specific column types
  # config.active_record.schema_format = :sql

  # Activate observers that should always be running
  # config.active_record.observers = :cacher, :garbage_collector
  config.active_record.observers = :user_observer

  # Make Active Record use UTC-base instead of local time
  # config.active_record.default_timezone = :utc

  # See Rails::Configuration for more options
end

# Add new inflection rules using the following format
# (all these examples are active by default):
# Inflector.inflections do |inflect|
#   inflect.plural /^(ox)$/i, '\1en'
#   inflect.singular /^(ox)en/i, '\1'
#   inflect.irregular 'person', 'people'
#   inflect.uncountable %w( fish sheep )
# end

# Add new mime types for use in respond_to blocks:
# Mime::Type.register "text/richtext", :rtf
# Mime::Type.register "application/x-mobile", :mobile
#Mime::Type.register "text/css", :css
Mime::Type.register "text/html", :htm
# Include your application configuration below

# load the redirection config file
path = "#{RAILS_ROOT}/config/redirection.yml"
if File.exists?(path)
	REDIRECTIONS = YAML.load_file(path)
	REVERSE_REDIRECTIONS = {}
	REDIRECTIONS.reject {|k,v| v[:action] != 303}.each_pair do |k,v|
		section = v[:section].to_sym
		id = v[:id] ? v[:id].to_sym : nil
		REVERSE_REDIRECTIONS[[section, id]] = k
	end
else
	REDIRECTIONS = {}
	REVERSE_REDIRECTIONS = {}
end

# load the base application config file
path = "#{RAILS_ROOT}/config/environment.yml"
if File.exists?(path)
	APP_CONFIG = YAML.load_file(path)
else
	APP_CONFIG = {}
end

# load and merge in the environment-specific application config info
# if present, overriding base config parameters as specified
path = "#{RAILS_ROOT}/config/environments/#{ENV['RAILS_ENV']}.yml"
if File.exists?(path) && (env_config = YAML.load_file(path))
	APP_CONFIG.merge!(env_config)
end
