FakeLink = Struct.new :id, :path, :size, :count, :url do
  def md
    "![#{basename}](#{url})"
  end

  def basename
    File.basename path
  end

  def directory
    File.dirname path
  end

  def remote_path
    File.dirname URI.parse(url).path
  end
end
