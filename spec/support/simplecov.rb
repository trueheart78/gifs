# frozen_string_literal: true

require 'simplecov'
require 'simplecov-rcov'

SimpleCov.formatter = SimpleCov::Formatter::RcovFormatter
SimpleCov.minimum_coverage 87

SimpleCov.start do
  add_filter '/spec/'
end
