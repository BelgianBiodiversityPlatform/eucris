class DocumentsController < ApplicationController

  # GET /documents/1
  # GET /documents/1.xml
  def show

    @document = Document.find(params[:id])
    docpath= Rails.root.to_s + '/public/documents/' + @document.filename
    send_file docpath, :type=>"application/pdf"
  end

end
