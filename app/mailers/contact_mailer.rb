class ContactMailer < ActionMailer::Base  

  default :to => "eucris@biodiversity.be"

  def contact(user_name, user_email, subject, message)  
    @message = message
    @subject = subject
    @user_name = user_name
    @user_email = user_email
    mail(:from => @user_email, :subject => @subject)  

  end  

end  
