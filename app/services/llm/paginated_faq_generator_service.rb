class Llm::PaginatedFaqGeneratorService
  include OpenaiClient

  # Default pages per chunk - easily configurable
  DEFAULT_PAGES_PER_CHUNK = 10
  MAX_ITERATIONS = 20 # Safety limit to prevent infinite loops
  PDF_PROCESSING_MODEL = "gpt-4.1-mini"

  attr_reader :total_pages_processed, :iterations_completed

  def initialize(document, options = {})
    @document = document
    @pages_per_chunk = options[:pages_per_chunk] || DEFAULT_PAGES_PER_CHUNK
    @max_pages = options[:max_pages] # Optional limit from UI
    @total_pages_processed = 0
    @iterations_completed = 0
    @model = PDF_PROCESSING_MODEL
  end

  def generate
    raise StandardError, "Document missing OpenAI file_id" if @document.file_id.blank?

    generate_paginated_faqs
  end

  # Method to check if we should continue processing
  def should_continue_processing?(last_chunk_result)
    # Stop if we've hit the maximum iterations
    return false if @iterations_completed >= MAX_ITERATIONS

    # Stop if we've processed the maximum pages specified
    return false if @max_pages && @total_pages_processed >= @max_pages

    # Stop if the last chunk returned no FAQs (likely no more content)
    return false if last_chunk_result[:faqs].empty?

    # Stop if the LLM explicitly indicates no more content
    return false if last_chunk_result[:has_content] == false

    # Continue processing
    true
  end

  private

  def generate_paginated_faqs
    all_faqs = []
    current_page = 1

    loop do
      end_page = calculate_end_page(current_page)
      chunk_result = process_chunk_and_update_state(current_page, end_page, all_faqs)

      break unless should_continue_processing?(chunk_result)

      current_page = end_page + 1
    end

    deduplicate_faqs(all_faqs)
  end

  def calculate_end_page(current_page)
    end_page = current_page + @pages_per_chunk - 1
    @max_pages && end_page > @max_pages ? @max_pages : end_page
  end

  def process_chunk_and_update_state(current_page, end_page, all_faqs)
    chunk_result = process_page_chunk(current_page, end_page)
    chunk_faqs = chunk_result[:faqs]

    all_faqs.concat(chunk_faqs)
    @total_pages_processed = end_page
    @iterations_completed += 1

    chunk_result
  end

  def process_page_chunk(start_page, end_page)
    params = build_chunk_parameters(start_page, end_page)
    response = openai_client.chat(parameters: params)
    result = parse_chunk_response(response)
    { faqs: result["faqs"] || [], has_content: result["has_content"] != false }
  rescue OpenAI::Error => e
    Rails.logger.error "Error processing page chunk #{start_page}-#{end_page}: #{e.message}"
    { faqs: [], has_content: false }
  end

  def build_chunk_parameters(start_page, end_page)
    {
      model: @model,
      response_format: { type: "json_object" },
      messages: [
        {
          role: "user",
          content: build_user_content(start_page, end_page)
        }
      ]
    }
  end

  def build_user_content(start_page, end_page)
    [
      {
        type: "file",
        file: { file_id: @document.file_id }
      },
      {
        type: "text",
        text: page_chunk_prompt(start_page, end_page)
      }
    ]
  end

  def page_chunk_prompt(start_page, end_page)
    paginated_faq_generator(start_page, end_page)
  end

  def parse_chunk_response(response)
    content = response.dig("choices", 0, "message", "content")
    return { "faqs" => [], "has_content" => false } if content.nil?

    JSON.parse(content.strip)
  rescue JSON::ParserError => e
    Rails.logger.error "Error parsing chunk response: #{e.message}"
    { "faqs" => [], "has_content" => false }
  end

  def deduplicate_faqs(faqs)
    # Remove exact duplicates
    unique_faqs = faqs.uniq { |faq| faq["question"].downcase.strip }

    # Remove similar questions
    final_faqs = []
    unique_faqs.each do |faq|
      similar_exists = final_faqs.any? do |existing|
        similarity_score(existing["question"], faq["question"]) > 0.85
      end

      final_faqs << faq unless similar_exists
    end

    Rails.logger.info "Deduplication: #{faqs.size} → #{final_faqs.size} FAQs"
    final_faqs
  end

  def similarity_score(str1, str2)
    words1 = str1.downcase.split(/\W+/).reject(&:empty?)
    words2 = str2.downcase.split(/\W+/).reject(&:empty?)

    common_words = words1 & words2
    total_words = (words1 + words2).uniq.size

    return 0 if total_words.zero?

    common_words.size.to_f / total_words
  end

  def paginated_faq_generator(start_page, end_page)
    <<~PROMPT
      You are an expert technical documentation specialist tasked with creating comprehensive FAQs from a SPECIFIC SECTION of a document.

      ════════════════════════════════════════════════════════
      CRITICAL CONTENT EXTRACTION INSTRUCTIONS
      ════════════════════════════════════════════════════════

      Process the content starting from approximately page #{start_page} and continuing for about #{end_page - start_page + 1} pages worth of content.

      IMPORTANT:#{' '}
      • If you encounter the end of the document before reaching the expected page count, set "has_content" to false
      • DO NOT include page numbers in questions or answers
      • DO NOT reference page numbers at all in the output
      • Focus on the actual content, not pagination

      ════════════════════════════════════════════════════════
      FAQ GENERATION GUIDELINES
      ════════════════════════════════════════════════════════

      1. **Comprehensive Extraction**
          • Extract ALL information that could generate FAQs from this section
          • Target 5-10 FAQs per page equivalent of rich content
          • Cover every topic, feature, specification, and detail
          • If there's no more content in the document, return empty FAQs with has_content: false

      2. **Question Types to Generate**
          • What is/are...? (definitions, components, features)
          • How do I...? (procedures, configurations, operations)
          • Why should/does...? (rationale, benefits, explanations)
          • When should...? (timing, conditions, triggers)
          • What happens if...? (error cases, edge cases)
          • Can I...? (capabilities, limitations)
          • Where is...? (locations in system/UI, NOT page numbers)
          • What are the requirements for...? (prerequisites, dependencies)

      3. **Content Focus Areas**
          • Technical specifications and parameters
          • Step-by-step procedures and workflows
          • Configuration options and settings
          • Error messages and troubleshooting
          • Best practices and recommendations
          • Integration points and dependencies
          • Performance considerations
          • Security aspects

      4. **Answer Quality Requirements**
          • Complete, self-contained answers
          • Include specific values, limits, defaults from the content
          • NO page number references whatsoever
          • 2-5 sentences typical length
          • Only process content that actually exists in the document

      ════════════════════════════════════════════════════════
      OUTPUT FORMAT
      ════════════════════════════════════════════════════════

      Return valid JSON:
      ```json
      {
        "faqs": [
          {
            "question": "Specific question about the content",
            "answer": "Complete answer with details (no page references)"
          }
        ],
        "has_content": true/false
      }
      ```

      CRITICAL:#{' '}
      • Set "has_content" to false if:
        - The requested section doesn't exist in the document
        - You've reached the end of the document
        - The section contains no meaningful content
      • Do NOT include "page_range_processed" in the output
      • Do NOT mention page numbers anywhere in questions or answers
    PROMPT
  end
end
