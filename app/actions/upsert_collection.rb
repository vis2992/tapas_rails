class UpsertCollection
  include Concerns::Upserter

  def execute
    begin
      collection = Collection.find_by_did params[:did]

      if collection
        collection = Collection.find_by_did params[:did]
      else
        collection = Collection.new
        collection.did = params[:did]
        collection.depositor = params[:depositor]
        collection.og_reference = [params[:project_did]]
        collection.save!

        community = Community.find_by_did(params[:project_did])
        if community
          collection.community = community
        else
          collection.collection = Collection.phantom_collection
        end
      end

      if params[:thumbnail].present?
        collection.add_thumbnail(:filepath => params[:thumbnail])
      end
      upsert_logger.info("Collection upsert for #{collection.pid} has did #{collection.did}")
      update_metadata!(collection)
    rescue => e
      ExceptionNotifier.notify_exception(e, :data => { :params => params })
      raise e
    ensure
      FileUtils.rm(params[:thumbnail]) if should_delete_file? params[:thumbnail]
    end
  end

  private

    def update_metadata!(collection)
      collection.mods.title = params[:title] if params.has_key? :title
      collection.mods.abstract = params[:description] if params.has_key? :description
      collection.drupal_access = params[:access] if params.has_key? :access
      collection.save!
    end

    def upsert_logger
      @@upsert_logger ||= Logger.new("#{Rails.root}/log/#{Rails.env}_upsert.log")
    end
end
