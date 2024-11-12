# frozen_string_literal: true

ENV['RAILS_ENV'] ||= 'test'

require File.expand_path('../config/environment', __dir__)
abort('The Rails environment is running in production mode!') if Rails.env.production?

require 'rspec/rails'

Rails.root.glob('spec/support/*.rb').each { |f| require f }

ActiveRecord::Migration.maintain_test_schema! if Rails.env.test?

RSpec.configure do |config|
  config.include AuthenticationHelper, type: :controller

  config.order = :random
  config.profile_examples = 10
  config.infer_spec_type_from_file_location!
  config.filter_rails_from_backtrace!
  config.render_views

  config.mock_with :rspec do |mocks|
    mocks.verify_partial_doubles = true
  end

  config.shared_context_metadata_behavior = :apply_to_host_groups

  config.before do
    DatabaseCleaner.strategy = :transaction
    DatabaseCleaner.start
    ActiveJob::Base.queue_adapter = :test
  end

  config.include ActiveJob::TestHelper
  config.after do
    DatabaseCleaner.clean
    clear_enqueued_jobs
  end
end
