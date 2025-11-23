class CsvUploadService
  def initialize(uploaded_file)
    @uploaded_file = uploaded_file
  end

  def save_tempfile
    raise ArgumentError, "No file provided" unless @uploaded_file

    # extensión segura
    ext = File.extname(@uploaded_file.original_filename)
    filename = "#{SecureRandom.hex}#{ext}"

    path = Rails.root.join("tmp", "uploads", filename)
    FileUtils.mkdir_p(File.dirname(path))

    File.binwrite(path, @uploaded_file.read)

    path.to_s
  end
end
