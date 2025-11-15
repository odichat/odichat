module RedcarpetHelper
  DEFAULT_MARKDOWN_EXTENSIONS = {
    autolink: true,
    fenced_code_blocks: true,
    filter_html: true,
    highlight: true,
    no_intra_emphasis: true,
    prettify: true,
    underline: true
  }.freeze

  # Custom Redcarpet HTML Renderer
  class CustomHtmlRenderer < Redcarpet::Render::HTML
    # Called for explicit Markdown links like [text](url)
    # The `content` parameter is the already-rendered HTML content of the link.
    def link(link_url, title, content)
      processed_url = if schemeless_whatsapp_link?(link_url)
                        "https://#{link_url}"
      else
                        link_url
      end

      attributes = @options[:link_attributes] || {}
      attributes_str = attributes.map { |key, value| %( #{key}="#{CGI.escapeHTML(value.to_s)}") }.join

      title_attr = title.present? ? %( title="#{CGI.escapeHTML(title)}") : ""

      %(<a href="#{CGI.escapeHTML(processed_url)}"#{title_attr}#{attributes_str}>#{content}</a>)
    end

    # Called for bare URLs when the :autolink extension is enabled
    def autolink(link_text, link_type)
      attributes = @options[:link_attributes] || {}
      attributes_str = attributes.map { |key, value| %( #{key}="#{CGI.escapeHTML(value.to_s)}") }.join

      escaped_link_text = CGI.escapeHTML(link_text)

      if link_type == :email
        %(<a href="mailto:#{escaped_link_text}"#{attributes_str}>#{escaped_link_text}</a>)
      else # URL
        href = link_text # Start with the original link_text for the href

        if schemeless_whatsapp_link?(link_text)
          href = "https://#{link_text}"
        elsif !link_text.match?(%r{\A[a-zA-Z][a-zA-Z0-9+.-]*://}) && link_text.include?(".")
          # If no scheme (e.g., "www.example.com", "example.com") and it looks like a domain,
          # prepend "http://" to make it an absolute URL.
          href = "http://#{link_text}"
        end
        # If it already has a scheme (e.g., "ftp://example.com"), it will be used as is.

        %(<a href="#{CGI.escapeHTML(href)}"#{attributes_str}>#{escaped_link_text}</a>)
      end
    end

    private

    def schemeless_whatsapp_link?(url)
      # Check if the URL starts with "wa.me/" but not with "http://" or "https://".
      url.start_with?("wa.me/") && !url.start_with?(/\Ahttps?:\/\//)
    end
  end

  def markdown(content, user_extensions = {})
    # Merge default extensions with any user-provided extensions.
    # User-provided extensions will override defaults if keys conflict.
    current_options = DEFAULT_MARKDOWN_EXTENSIONS.merge(user_extensions)

    # Prepare options for the HTML renderer.
    # These are specific to Redcarpet::Render::HTML and our CustomHtmlRenderer.
    render_opts = {
      link_attributes: { target: "_blank", rel: "noopener noreferrer" } # Add rel for security
    }
    # Extract known renderer options from current_options.
    # The `delete` method removes the key and returns its value, so current_options will then only contain parser extensions.
    render_opts[:filter_html] = current_options.delete(:filter_html) if current_options.key?(:filter_html)
    render_opts[:prettify] = current_options.delete(:prettify) if current_options.key?(:prettify)
    # Add any other Redcarpet::Render::HTML options here if they are in DEFAULT_MARKDOWN_EXTENSIONS or passed by user.
    # For example: :hard_wrap, :xhtml, :with_toc_data (if you were to use them, ensure they are renderer options)

    # The remaining current_options are considered Markdown parser extensions.
    markdown_parser_extensions = current_options

    # Instantiate our custom renderer with its specific options.
    html_renderer_instance = CustomHtmlRenderer.new(render_opts)

    # Instantiate the Markdown processor with the custom renderer and parser extensions.
    markdown_processor = Redcarpet::Markdown.new(html_renderer_instance, markdown_parser_extensions)

    markdown_processor.render(content).html_safe
  end
end
