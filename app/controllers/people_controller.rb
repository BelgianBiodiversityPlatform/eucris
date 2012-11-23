require 'kaminari'

class PeopleController < ApplicationController
    # GET /people
    # GET /people.xml
    def index
      if params.has_key?('source')
        @source = Source.find(params[:source])
        @results= @source.people
      else
        @results= Person.order('familyname, firstname').all()
      end
      @people=Kaminari.paginate_array(@results).page params[:page]
      respond_to do |format|
        format.html # index.html.erb
        format.xml  { render :xml => @people }
      end
    end
    # GET /people/1
    # GET /people/1.xml
    def show
      @person = Person.find(params[:id])

      respond_to do |format|
        format.html # show.html.erb
        format.xml  { render :xml => @person }
      end
    end

    # GET /people/1
    # GET /people/1.xml
    def findById
      @origid='\'BB|' + params[:origid] + '\''
      @person = Person.find(:first, :conditions =>'origid =' + @origid)

      redirect_to person_url(@person)
    end

    # GET /people/search
    # GET /people/search.xml
    def search()

      @countries = Country.partners.order('name').all()
      if params.has_key?('country') && !params[:country].empty?
        if params[:query].empty?
          @results = Person.find(:all,
              :select => 'people.*',
              :from => 'cl.people', 
              :joins => ' left join cl.sources on sources.id = people.source_id left join cl.countries on countries.id=sources.country_id',
              :conditions => 'sources.country_id =' + params[:country],
              :order =>'familyname, firstname')
        else
          @results= Person.find(:all, 
              :select => 'people.*, 100.0 * ts_rank(ts_index_col, query) AS rank ', 
              :from => ts_query(params[:query], 'cl.people'), 
              :joins => ' left join cl.sources on sources.id = people.source_id left join cl.countries on countries.id=sources.country_id',
              :conditions => 'query @@ ts_index_col and sources.country_id=' + params[:country],
              :order => 'rank DESC, familyname, firstname')
        end
      else
        if params[:query].empty?
          @results = Person.find(:all, :order => 'familyname, firstname')
        else
          @results= Person.find(:all, 
            :select => 'id, origid, familyname, firstname, 100.0 * ts_rank(ts_index_col, query) AS rank ', 
            :from => ts_query(params[:query], 'cl.people'), 
            :conditions => 'query @@ ts_index_col',
            :order => 'rank DESC, familyname, firstname')
        end
      end

      
      @people=Kaminari.paginate_array(@results).page params[:page]
      flash[:notice] = @results.empty? ? 'No results for this search query': ''

      respond_to do |format|
        format.html # search.html.erb
        format.xml  { render :xml => @people }
      end
    end

end
