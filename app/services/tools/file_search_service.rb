class Tools::FileSearchService < Tools::BaseService
  def name
    "file_search"
  end

  def description; end
  def parameters; end
  def execute(arguments); end

  def to_registry_format
    {
      type: name,
      vector_store_ids: [ params[:vector_store_id] ]
    }
  end
end
