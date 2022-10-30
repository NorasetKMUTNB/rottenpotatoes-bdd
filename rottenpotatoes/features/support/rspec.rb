require 'rspec/core'

rspec.configure do |config|
    config.expect_with :rspec do |exceptions|
        exceptions.syntax = [:execpt,:should]
    end
end