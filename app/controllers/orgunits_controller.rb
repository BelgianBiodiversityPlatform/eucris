require 'kaminari'

class OrgunitsController < ApplicationController
    # GET /orgunits
    # GET /orgunits.xml
    def index
      if params.has_key?('source')
        @source = Source.find(params[:source])
        @results= @source.orgunits
      else
        @results=Orgunit.order('name').all()
      end
      @orgunits=Kaminari.paginate_array(@results).page params[:page]
      respond_to do |format|
        format.html # index.html.erb
        format.xml  { render :xml => @orgunits }
      end
    end
    # GET /orgunits/1
    # GET /orgunits/1.xml
    def show
      @orgunit = Orgunit.find(params[:id])

      respond_to do |format|
        format.html # show.html.erb
        format.xml  { render :xml => @orgunit }
      end
    end
    
    # GET /orggunits/asearch
    # GET /orgunits/asearch.xml
    def search()
      @countries = Country.partners.order('name').all()
      if params[:scope] == 'funding'
        if params.has_key?('country') && !params[:country].empty?
          if params[:query].empty?
            @results = Orgunit.agencies.find(:all,
              :select => 'orgunits.* ',
              :from => 'cl.orgunits', 
              :joins => ' left join cl.sources on sources.id = orgunits.source_id left join cl.countries on countries.id=sources.country_id',
              :conditions => 'sources.country_id =' + params[:country],
              :order =>'name')
          else
            @results= Orgunit.agencies.find(:all, 
              :select => 'orgunits.*, 100.0 * ts_rank(ts_index_col, query) AS rank ', 
              :from => ts_query(params[:query], 'cl.orgunits'), 
              :joins => ' left join cl.sources on sources.id = orgunits.source_id left join cl.countries on countries.id=sources.country_id',
              :conditions => 'query @@ ts_index_col and sources.country_id=' + params[:country],
              :order => 'rank DESC, name')
          end
        else
          if params[:query].empty?
            @results = Orgunit.agencies.find(:all, :order => 'name', :limit =>'100')
          else
            @results= Orgunit.agencies.find(:all, 
              :select => 'orgunits.*, 100.0 * ts_rank(ts_index_col, query) AS rank ', 
              :from => ts_query(params[:query], 'cl.orgunits'), 
              :conditions => 'query @@ ts_index_col',
              :order => 'rank DESC, name')    
          end
        end
      else
        if params.has_key?('country') && !params[:country].empty?
          if params[:query].empty?
            @results = Orgunit.research.find(:all,
              :select => 'orgunits.* ',
              :from => 'cl.orgunits', 
              :joins => ' left join cl.sources on sources.id = orgunits.source_id left join cl.countries on countries.id=sources.country_id',
              :conditions => 'sources.country_id =' + params[:country],
              :order =>'name')
          else
            @results= Orgunit.research.find(:all, 
              :select => 'orgunits.*, 100.0 * ts_rank(ts_index_col, query) AS rank ', 
              :from => ts_query(params[:query], 'cl.orgunits'), 
              :joins => ' left join cl.sources on sources.id = orgunits.source_id left join cl.countries on countries.id=sources.country_id',
              :conditions => 'query @@ ts_index_col and sources.country_id=' + params[:country],
              :order => 'rank DESC, name')
          end
        else
          if params[:query].empty?
            @results = Orgunit.research.find(:all, :order => 'name', :limit =>'100')
          else
            @results= Orgunit.research.find(:all, 
              :select => 'orgunits.*, 100.0 * ts_rank(ts_index_col, query) AS rank ', 
              :from => ts_query(params[:query], 'cl.orgunits'), 
              :conditions => 'query @@ ts_index_col',
              :order => 'rank DESC, name')    
          end
        end
      end

      @orgunits=Kaminari.paginate_array(@results).page params[:page]
      flash[:notice] = @orgunits.empty? ? 'No results for this search query': ''

      respond_to do |format|
        format.html
        format.xml  { render :xml => @orgunits }
      end
    end
end
