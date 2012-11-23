require 'fastercsv'

class FundingsController < ApplicationController
  # GET /fundings
  # GET /fundings.xml
  before_filter :authorize, :only => [:addClass, :deleteClass]

  def index
    if params.has_key?('source')
      @source = Source.find(params[:source])
      @results= @source.fundings
    elsif params.has_key?('country')
        @country = Country.find(params[:country])
        @sources = @country.sources
        @results = Array.new
        @sources.each do |source|
          @results += source.fundings
        end 
    else
      @results = Funding.order('origid').all()
    end

    @fundings=Kaminari.paginate_array(@results).page params[:page]

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @fundings }
    end
  end

  # GET /fundings/1
  # GET /fundings/1.xml
  def show
    @funding = Funding.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @funding }
    end
  end
  
  def chooseClass
    @funding = Funding.find(params[:id])
    @classschemes = Classscheme.originals.all()
    @classification =Classification.new

    respond_to do |format|
       format.html  # new.html.erb
       format.json  { render :json => @classification }
     end
  end
  

  # GET /fundings/search
  # GET /fundings/search.xml
  def search()
    @countries = Country.partners.order('name').all()
    if params.has_key?('country') && !params[:country].empty?
      if params[:query].empty?
        @results = Funding.find(:all,
            :select => 'fundings.* ',
            :from => 'cl.fundings', 
            :joins => ' left join cl.sources on sources.id = fundings.source_id left join cl.countries on countries.id=sources.country_id',
            :conditions => 'sources.country_id =' + params[:country],
            :order =>'name')
      else
        @results= Funding.find(:all, 
            :select => 'fundings.*, 100.0 * ts_rank(ts_index_col, query) AS rank ', 
            :from =>  ts_query(params[:query], 'cl.fundings'), 
            :joins => ' left join cl.sources on sources.id = fundings.source_id left join cl.countries on countries.id=sources.country_id',
            :conditions => 'query @@ ts_index_col and sources.country_id=' + params[:country],
            :order => 'rank DESC, name')
      end
    else  
      if params[:query].empty?
        @results = Funding.order('name').all()
      else
        @results= Funding.find(:all, 
            :select => 'fundings.*, 100.0 * ts_rank(ts_index_col, query) AS rank ', 
            :from =>  ts_query(params[:query], 'cl.fundings'), 
            :joins => ' left join cl.sources on sources.id = fundings.source_id left join cl.countries on countries.id=sources.country_id',
            :conditions => 'query @@ ts_index_col',
            :order => 'rank DESC, name')
      end
      
    end

    @fundings=Kaminari.paginate_array(@results).page params[:page]
    flash[:notice] = @fundings.empty? ? 'No results for this search query': ''

    respond_to do |format|
      format.html
      format.xml  { render :xml => @fundings}
          end
  end
  
#  before_filter :login_required
  def download()
    if params[:query].empty? 
      @fundings= Funding.find(:all, 
        :select => 'f.origid, f.name, f.startdate, f.endate, f.amount, f.currency, 0 AS rank, s.origid as from, c.code as country', 
        :from => 'cl.fundings ', 
        :joins =>'as f left join cl.sources as s on s.id=f.source_id left join cl.countries as c on c.id=s.country_id ',
        :order => 'name')    

    else
      @fundings= Funding.find(:all, 
        :select => 'f.origid, f.name, f.startdate, f.endate, f.amount, f.currency, ts_rank(ts_index_col, query) AS rank, s.origid as from, c.code as country ', 
        :from => 'to_tsquery(\''+ params[:query] +'\') query, cl.fundings ', 
        :conditions => 'query @@ ts_index_col' , 
        :joins =>'as f left join cl.sources as s on s.id=f.source_id left join cl.countries as c on c.id=s.country_id',
        :order => 'rank DESC')    
    end

    @csvpath= 'Fundings' + Time.now.strftime("%Y-%m-%d")  + '.csv' 

    csv_data = FasterCSV.generate(:col_sep => "\t", :encoding => "UTF-8" ) do |csv|
        csv << [
        "origid",
        "Name",
        "StartDate",
        "EndDate",
        "Amount",
        "Currency",
        "Source",
        "Country",
        "Relevance("+params[:query]+") from Biodiversa database "+Time.now.to_s()
        ]
        @fundings.each do |funding|
          csv << [
            funding.origid,
            funding.name,
            funding.startdate,
            funding.endate,
            funding.amount,
            funding.currency,
            funding.from,
            funding.country,
            funding.rank
            ]
        end
    end
    send_data csv_data,
      :type => "text/csv; charset=UTF-8; header=present",
      :disposition => "attachment; filename=#{@csvpath}"
#        :type => 'text/csv; charset=iso-8859-1; header=present',

#  flash[:notice] = "Export complete!"
    

  end
end
