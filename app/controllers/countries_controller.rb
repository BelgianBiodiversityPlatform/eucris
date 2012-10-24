class CountriesController < ApplicationController
  # GET /countries
  # GET /countries.xml
  def index
    @countries = Country.where('socount > 0').order('name').all()

    tags = Country.where('socount > 0').order('name')
    if tags.length > 0
        tags_by_count = Country.order('rocount DESC')
        maxOccurs = tags_by_count.first.rocount
        minOccurs = tags_by_count.last.rocount

        # Get relative size for each of the tags and store it in a hash
        minFontSize = 8
        maxFontSize = 50
        @tag_cloud_hash = Hash.new(0)
        tags.each do |tag|
            weight = (tag.rocount-minOccurs).to_f/(maxOccurs-minOccurs)
            size = minFontSize + ((maxFontSize-minFontSize)*weight).round
            @tag_cloud_hash[tag] = size if size > 10
        end
    end

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @countries }
    end
  end

  # GET /countries/1
  # GET /countries/1.xml
  def show
    @country = Country.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @country }
    end
  end

end
