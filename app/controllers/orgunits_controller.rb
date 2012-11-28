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
            @results = Orgunit.agencies.find(:all, :order => 'name')
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
            @results = Orgunit.research.find(:all, :order => 'name')
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
    
    def download()
      csvName = (params[:scope] == 'funding') ? 'Funding Orgunits' : 'Research Orgunits'
      sqlFields1='o.id, o.origid, o.acronym, o.name, o.url, o.tel, o.fax, o.email, o.addrline1, o.postcode, o.city, s.origid as from, c.code as country, 0 AS rank'
      sqlFields2='o.id, o.origid, o.acronym, o.name, o.url, o.tel, o.fax, o.email, o.addrline1, o.postcode, o.city, s.origid as from, c.code as country, ts_rank(ts_index_col, query) AS rank'
      sqlJoins='left join cl.sources as s on s.id=o.source_id left join cl.countries as c on c.id=s.country_id'
      sqlWhere = (params[:scope] == 'funding') ? 'o.isFunding=true' : 'o.isFunding=false'
      sqlWhere1 = sqlWhere + " and s.country_id=?"
      sqlWhere2 = sqlWhere + " and query @@ ts_index_col and s.country_id=?"
      sqlWhere3 = sqlWhere + " and query @@ ts_index_col"
      
      if params.has_key?('country') && !params[:country].empty?
        if params[:query].empty?
          @results=Orgunit.select(sqlFields1).from('cl.orgunits o').joins(sqlJoins).where(sqlWhere1, params[:country]).order('name')
        else
          @results=Orgunit.select(sqlFields2).from(ts_query(params[:query], 'cl.orgunits o')).
          joins(sqlJoins).where(sqlWhere2, params[:country]).order('rank DESC, name')
        end
      else
        if params[:query].empty?
          @results = Orgunit.select(sqlFields1).from('cl.orgunits o').joins(sqlJoins).where(sqlWhere).order('name').all()
        else
          @results= Orgunit.select(sqlFields2).from(ts_query(params[:query], 'cl.orgunits o')).
          joins(sqlJoins).where(sqlWhere3).order('rank DESC, name')
        end
      end

          @csvpath= csvName + Time.now.strftime("%Y-%m-%d") + '.csv' 
          @signature= "from BiodivERsA database http://data.biodiversa.org on "

          csv_data = CSV.generate(:col_sep => "\t", :encoding => "UTF-8" ) do |csv|
              csv << [
              "id",
              "origid",
              "Acronym",
              "Name",
              "URL",
              "Tel",
              "Fax",
              "Email",
              "Address",
              "Postcode",
              "Locality",
              "Source",
              "Country",
              "Relevance("+params[:query]+") "+@signature+Time.now.to_s()
              ]
              @results.each do |orgunit|
                csv << [
                  orgunit.id,
                  orgunit.origid,
                  orgunit.acronym,
                  orgunit.name,
                  orgunit.url,
                  orgunit.tel,
                  orgunit.fax,
                  orgunit.email,
                  orgunit.addrline1,
                  orgunit.postcode,
                  orgunit.city,
                  orgunit.country,
                  orgunit.rank
                  ]
              end
          end
          send_data csv_data,
          # :type => 'text/csv; charset=iso-8859-1; header=present',
            :type => "text/csv; charset=UTF-8; header=present",
            :disposition => "attachment; filename=#{@csvpath}"

        flash[:notice] = "Download complete!"

    end

end
