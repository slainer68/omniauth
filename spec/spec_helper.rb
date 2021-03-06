unless ENV['TRAVIS']
  require 'simplecov'
  SimpleCov.start
end

require 'rspec'
require 'rack/test'
require 'omniauth'
require 'omniauth/test'

RSpec.configure do |config|
  config.include Rack::Test::Methods
  config.extend  OmniAuth::Test::StrategyMacros, :type => :strategy
end

class ExampleStrategy
  include OmniAuth::Strategy
  option :name, 'test'
  def call(env); self.call!(env) end
  attr_reader :last_env
  def request_phase
    @fail = fail!(options[:failure]) if options[:failure]
    @last_env = env
    return @fail if @fail
    raise "Request Phase"
  end
  def callback_phase
    @fail = fail!(options[:failure]) if options[:failure]
    @last_env = env
    return @fail if @fail
    raise "Callback Phase"
  end
end