class HomeController < ApplicationController
  skip_before_filter :authorize

  def links
    @sources = Source.order('origid').all
    @documents = Document.order('name').all
    
  end
  def faq
  end
  def dua
  end
  def index
    @acCount= 603; # To avoid confusion (booklet vs online database)
#    @fpCount= 216; # To avoid confusion (booklet vs online database)
    @fpCount= Funding.count();
    @faCount= Orgunit.agencies.count();
    @roCount= Orgunit.research.count();
    @prCount= Project.count();
    @peCount= Person.count();
    @soCount= Source.count();
    @coCount= Country.partners.count();
    
  end
  def contact
    @contact_message = Contact_Message.new    
    @countries = Country.order('name').all()
  end
  def send_contact_msg
    @contact_message = Contact_Message.new(params[:contact_message])

    respond_to do |format|
      if @contact_message.save
        ContactMailer.contact(@contact_message.name, @contact_message.email, @contact_message.subject, @contact_message.body).deliver  
        format.html  { render :action => "contact_msg_sent",
                    :notice => 'Contact_Message was successfully created.' }
        format.json  { render :json => @contact_message,
                                 :status => :created, :location => @contact_message }
      else
        format.html  { render :action => "contact" }
        format.json  { render :json => @contact_message.errors,
                                  :status => :unprocessable_entity }
      end
    end

  end

end
