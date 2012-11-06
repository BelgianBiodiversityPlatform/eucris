require 'kaminari'
require "csv"

class ProjectsController < ApplicationController
  # GET /projects
  # GET /projects.xml
  def index
    @source = Source.find(params[:source])
    @projects= @source.projects

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @projects }
    end
  end

  # GET /projects/1
  # GET /projects/1.xml
  def show
    @project = Project.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @project }
    end
  end

  # GET /projects/search
  # GET /projects/search.xml
  def search()
    @countries = Country.partners.order('name').all()
    
    if params.has_key?('country') && !params[:country].empty?
      if params[:query].empty?
        @results= Project.
          select('p.id, p.title').from('cl.projects p').
          joins(' left join cl.sources s on s.id = p.source_id left join cl.countries c on c.id=s.country_id').
          where("s.country_id=?", params[:country]).
          order('title')
      else
        @results= Project.
          select('p.id, p.title, 100.0 * ts_rank(ts_index_col, query) AS rank ').from(ts_query(params[:query], 'cl.projects p')).
          joins(' left join cl.sources s on s.id = p.source_id left join cl.countries c on c.id=s.country_id').
          where("query @@ ts_index_col and s.country_id=?", params[:country]).
          order('rank DESC, title')
      end
    else
      if params[:query].empty?
          @results = Project.select('id, title').order('title').all()
      else
          @results= Project. 
          select('p.id, p.title, 100.0 * ts_rank(ts_index_col, query) AS rank ').from(ts_query(params[:query], 'cl.projects p')).
          where("query @@ ts_index_col").
          order('rank DESC, title')
      end
    end

      @projects=Kaminari.paginate_array(@results).page params[:page]
      flash[:notice] = @results.empty? ? 'No results for this search query': ''

    respond_to do |format|
      format.html # search.html.erb
      format.xml  { render :xml => @projects }
    end
  end

  def download()
    sqlFields1='p.origid, p.title, p.startdate, p.enddate,  p.amount, coalesce (p.currency, pf.currency) as currency, pf.amount as funds, s.origid as from, c.code as country, 0 AS rank'
    sqlFields2='p.origid, p.title, p.startdate, p.enddate,  p.amount, coalesce (p.currency, pf.currency) as currency, pf.amount as funds, s.origid as from, c.code as country, ts_rank(ts_index_col, query) AS rank'
    sqlJoins='left join cl.sources as s on s.id=p.source_id left join cl.countries as c on c.id=s.country_id left join cl.project_funding as pf on pf.project_id=p.id'

    if params.has_key?('country') && !params[:country].empty?
      if params[:query].empty?
        @results= Project.select(sqlFields1).from('cl.projects p').joins(sqlJoins).where("s.country_id=?", params[:country]).order('title')
      else
        @results=Project.select(sqlFields2).from(ts_query(params[:query], 'cl.projects p')).
        joins(sqlJoins).where("query @@ ts_index_col and s.country_id=?", params[:country]).order('rank DESC, title')
      end
    else
      if params[:query].empty?
        @results = Project.select(sqlFields1).from('cl.projects p').joins(sqlJoins).order('title').all()
      else
        @results= Project.select(sqlFields2).from(ts_query(params[:query], 'cl.projects p')).
        joins(sqlJoins).where("query @@ ts_index_col").order('rank DESC, title')
      end
    end

        @csvpath= 'Projects' + Time.now.strftime("%Y-%m-%d") + '.csv' 

        csv_data = CSV.generate(:col_sep => "\t", :encoding => "UTF-8" ) do |csv|
            csv << [
            "id",
            "origid",
            "Title",
            "StartDate",
            "EndDate",
            "Amount",
            "Funds",
            "Currency",
            "Source",
            "Country",
            "Relevance("+params[:query]+") from BiodivERsA database "+Time.now.to_s()
            ]
            @results.each do |project|
              csv << [
                project.id,
                project.origid,
                project.title,
                project.startdate,
                project.enddate,
                project.amount,
                project.funds,
                project.currency,
                project.from,
                project.country,
                project.rank
                ]
            end
        end
        send_data csv_data,
          :type => "text/csv; charset=UTF-8; header=present",
          :disposition => "attachment; filename=#{@csvpath}"
#            :type => 'text/csv; charset=iso-8859-1; header=present',

      flash[:notice] = "Export complete!"
    
  end
end
