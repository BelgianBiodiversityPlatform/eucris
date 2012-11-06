class SourcesController < ApplicationController
  # GET /sources
  # GET /sources.xml
  def index
    @sources = Source.order('origid').all

    tags = Source.order('origid')
    if tags.length > 0
        tags_by_count = Source.order('count DESC')
        maxOccurs = tags_by_count.first.count
        minOccurs = tags_by_count.last.count

        # Get relative size for each of the tags and store it in a hash
        minFontSize = 8
        maxFontSize = 50
        @tag_cloud_hash = Hash.new(0)
        tags.each do |tag|
            weight = (tag.count-minOccurs).to_f/(maxOccurs-minOccurs)
            size = minFontSize + ((maxFontSize-minFontSize)*weight).round
            @tag_cloud_hash[tag] = size if size > 10
        end
    end



    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @sources }
    end
  end

  # GET /sources/1
  # GET /sources/1.xml
  def show
    @source = Source.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @source }
    end
  end

  def download
      @source = Source.find(params[:id])
      zippath= Rails.root.to_s + '/export/' + @source.origid + '.zip' 
      send_file zippath, :type=>"application/zip" 
  end


end
