class SchemesController < ApplicationController
  # GET /schemes
  # GET /schemes.xml
  def index
    @classschemes = Classscheme.originals.all()

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @classchemes }
    end
  end

  # GET /schemes/1
  # GET /schemes/1.xml
  def show
    @classscheme = Classscheme.find(params[:id])

    tags = @classscheme.classifications
    if tags.length > 0
        tags_by_count = Classification.where(["classscheme_id = ?", params[:id]]).order('count DESC')
        maxOccurs = tags_by_count.first.count
        minOccurs = tags_by_count.last.count
                
        if (minOccurs != maxOccurs)
          # Get relative size for each of the tags and store it in a hash
          minFontSize = 8
          maxFontSize = 32
          @tag_cloud_hash = Hash.new(0)
          tags.each do |tag|
              weight = (tag.count-minOccurs).to_f/(maxOccurs-minOccurs)
              size = minFontSize + ((maxFontSize-minFontSize)*weight).round
              @tag_cloud_hash[tag] = size  if size > 8
          end
        end
    end

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @classscheme }
    end
  end
end
