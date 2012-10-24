class ClassificationsController < ApplicationController

  # GET /classifications/1
  # GET /classifications/1.xml
  def show
    @classification = Classification.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @classification }
    end
  end

  def create
    redirect_to(@funding,
                    :notice => 'Funding has been classified.')

  end
  
end
