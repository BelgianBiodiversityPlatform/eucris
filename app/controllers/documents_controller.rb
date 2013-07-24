class DocumentsController < ApplicationController
  skip_before_filter :authorize, :only => [:download]
  
  # GET /documents/1
  # GET /documents/1.xml
  def show
#    @document = Document.find(params[:id])
#    docpath= Rails.root.to_s + '/public/documents/' + @document.filename
#    send_file docpath, :type=>"application/pdf"
  end

  def download
    @document = Document.find(:first, :conditions =>'name =\'' + params[:name] + '\'')
    docpath= Rails.root.to_s + '/public/documents/' + @document.filename
    send_file docpath, :type=>"application/pdf"
  end

end
