# frozen_string_literal: true

require 'spec_helper'

RSpec.describe FakeLink do
  it_behaves_like 'it has public link methods', object: FakeLink.new(junk, junk, junk, junk)
end
