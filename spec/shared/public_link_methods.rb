RSpec.shared_examples 'it has public link methods' do |object:|
  subject { object }

  it {is_expected.to respond_to :id }
  it {is_expected.to respond_to :url }
  it {is_expected.to respond_to :md }
  it {is_expected.to respond_to :basename }
  it {is_expected.to respond_to :directory }
  it {is_expected.to respond_to :remote_path }
  it {is_expected.to respond_to :size }
end
