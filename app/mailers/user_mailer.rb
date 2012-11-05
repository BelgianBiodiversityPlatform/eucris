class UserMailer < ActionMailer::Base  

  default :from => "eucris@biodiversity.be"
      
  def registration_confirmation(user,new_password)  
    @user = user
    @new_password = new_password
    mail(:to => user.email, :subject => "Registered")  
  end  

  def new_password(user, new_password)  
    @user = user
    @new_password = new_password
    mail(:to => user.email, :subject => "New password")  
  end  
end  
