RSpec.shared_context 'database' do
  before(:each) do
    allow(Gifs).to receive(:db_path).and_return temp_database_path
    Gifs.db_connect unless skip_database_connection
  end

  after(:each) do
    Gifs.db_disconnect
    FileUtils.remove_entry temp_database_dir
  end

  def database_dir?
    File.exist? temp_database_dir
  end

  def remove_database_file
    ActiveRecord::Base.remove_connection
    File.unlink temp_database_path if File.exist? temp_database_path
  end

  def database_file?
    File.exist? temp_database_path
  end

  let(:skip_database_connection) { false }
  let(:temp_database_dir)        { Dir.mktmpdir }
  let(:temp_database_path)       { File.join temp_database_dir, "#{junk}.db" }
end
