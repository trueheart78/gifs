RSpec.shared_context 'dropbox api' do
  let(:default_gif_path) { existing_gif }
  let(:default_gif_basename) { File.basename default_gif_path }

  let(:dropbox_public_url) do
    "https://dl.dropboxusercontent.com/s/3lp0r29rcy3vi47/#{CGI.escape(default_gif_basename)}"
  end

  let(:link_exists_json) do
    {
      error_summary: 'shared_link_already_exists/..',
      error: { '.tag' => 'shared_link_already_exists' }
    }.to_json
  end

  let(:link_success) do
    {
      '.tag' => 'file',
      url: "https://www.dropbox.com/s/3lp0r29rcy3vi47/#{CGI.escape(default_gif_basename)}?dl=0",
      id: 'id:tKL3Db9bgnoAAAAAAAAbWA',
      name: default_gif_basename,
      path_lower: default_gif_path,
      link_permissions: {
        resolved_visibility: { '.tag' => 'public' },
        requested_visibility: { '.tag' => 'public' },
        can_revoke: true
      },
      client_modified: '2017-12-01T14:35:48Z',
      server_modified: '2017-12-01T14:36:04Z',
      rev: '5cc40301f24e',
      size: 934_998
    }
  end

  let(:link_success_json) { link_success.to_json }

  let(:existing_links_json) do
    {
      links: [link_success],
      has_more: false
    }.to_json
  end
  let(:non_existent_links_json) do
    {
      links: [],
      has_more: false
    }.to_json
  end

  def stub_create_success(file_path)
    stub_api_request file_path, type: :create, status: 200, json_body: link_success_json
  end

  def stub_link_exists(file_path)
    stub_api_request file_path, type: :list, status: 200, json_body: existing_links_json
  end

  def stub_link_non_existent(file_path)
    stub_api_request file_path, type: :list, status: 200, json_body: non_existent_links_json
  end

  def stub_file_not_found(file_path)
    stub_api_request file_path, type: :list, status: 400, json_body: ''
  end

  def stub_api_request(file_path, type:, status:, json_body:)
    file_path = '/gifs/' + file_path
    endpoint = type == :create ? 'create_shared_link_with_settings' : 'list_shared_links'
    stub_request(:post, "https://api.dropboxapi.com/2/sharing/#{endpoint}")
      .with(body: json_body(file_path, type: type),
            headers: { 'Authorization' => 'Bearer spec-helper-token',
                       'Content-Type' => 'application/json' })
      .to_return(status: status, body: json_body, headers: {})
  end

  def json_body(file_path, type:)
    { path: file_path }.tap do |body|
      body[:settings] = { requested_visibility: 'public' } if type == :create
    end
  end
end
