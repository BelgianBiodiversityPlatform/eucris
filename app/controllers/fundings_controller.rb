require 'kaminari'
require 'csv'

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
    @classification =Classification.new

    respond_to do |format|
       format.html  # new.html.erb
       format.json  { render :json => @classification }
     end
  end

  def addClass
    @funding = Funding.find(params[:id])
    @classification = Classification.find(params[:classification][:id])
    @funding.classifications<<@classification

    redirect_to funding_path(@funding)
  end

  def deleteClass
    @funding = Funding.find(params[:id])
    @classification = Classification.find(params[:classification_id])
    @funding.classifications.delete(@classification)

    redirect_to funding_path(@funding)    
  end

  
  def edit
    @funding = Funding.find(params[:id])

  end
  
  def update
    @funding = Funding.find(params[:id])

    respond_to do |format|
      if @funding.update_attributes(params[:funding])
        format.html  { redirect_to(@funding,
                      :notice => 'Funding was successfully updated.') }
        format.json  { head :no_content }
      else
        format.html  { render :action => "edit" }
        format.json  { render :json => @funding.errors,
                      :status => :unprocessable_entity }
      end
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
  
  def download()
    sqlFields1='f.id, f.origid, f.name, f.startdate, f.enddate, f.amount, f.granted, f.currency, 0 AS rank, s.origid as from, c.code as country'
    sqlFields2='f.id, f.origid, f.name, f.startdate, f.enddate, f.amount, f.granted, f.currency, ts_rank(ts_index_col, query) AS rank, s.origid as from, c.code as country '
    sqlJoins=' left join cl.sources as s on s.id=f.source_id left join cl.countries as c on c.id=s.country_id'

    if params.has_key?('country') && !params[:country].empty?
      if params[:query].empty?
        @results= Funding.select(sqlFields1).from('cl.fundings f ').joins(sqlJoins).where("s.country_id=?", params[:country]).order('name')
      else
        @results=Funding.select(sqlFields2).from(ts_query(params[:query], 'cl.fundings f')).
          joins(sqlJoins).where("query @@ ts_index_col and s.country_id=?", params[:country]).order('rank DESC, name')
      end
    else
      if params[:query].empty?
        @results= Funding.select(sqlFields1).from('cl.fundings f').joins(sqlJoins).order('name')
      else
        @results=Funding.select(sqlFields2).from(ts_query(params[:query], 'cl.fundings f')).
          joins(sqlJoins).where("query @@ ts_index_col").order('rank DESC, name')
      end
    end

        @csvpath= 'Fundings' + Time.now.strftime("%Y-%m-%d") + '.csv' 
        @signature= "from BiodivERsA database http://data.biodiversa.org on "
        csv_data = CSV.generate(:col_sep => "\t", :encoding => "UTF-8" ) do |csv|
            csv << [
            "id",
            "origid",
            "Name",
            "StartDate",
            "EndDate",
            "Amount",
            "Funds",
            "Currency",
            "Source",
            "Country",
            "Relevance("+params[:query]+") "+@signature+Time.now.to_s()
            ]
            @results.each do |funding|
              csv << [
                funding.id,
                funding.origid,
                funding.name,
                funding.startdate,
                funding.enddate,
                funding.amount,
                funding.granted,
                funding.currency,
                funding.from,
                funding.country,
                funding.rank
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
