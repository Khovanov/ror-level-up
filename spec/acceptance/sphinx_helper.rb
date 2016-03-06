RSpec.configure do |config|
  config.include SphinxHelpers, type: :feature

  config.before(:suite) do
    # Ensure sphinx directories exist for the test environment
    ThinkingSphinx::Test.init
    # Configure and start Sphinx, and automatically
    # stop Sphinx at the end of the test suite.
    ThinkingSphinx::Test.start_with_autostop
  end

  # config.before(:each) do
  #   # Index data when running an acceptance spec.
  #   index if example.metadata[:js]
  # end
end

