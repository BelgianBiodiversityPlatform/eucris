class ApplicationController < ActionController::Base
  protect_from_forgery
 include SessionsHelper
  # Require authentication for edit delete and download.
  before_filter :authorize, :only => [:edit, :delete, :download]

   layout "simple"

  private
    def authorize
      # Redirect to login unless authenticated.
      if current_user.nil?
        redirect_to :controller =>'sessions', :action => 'new'
      end
    end
    def ts_query(query, table)
      # Build Postgres text search query with to_tsquery or plainto_tsquery
      ts_query = query.index(/[&|!:*]/).nil? ? 'plainto' : 'to'
      ts_query << '_tsquery(\'' + query + '\') query, ' + table
      return ts_query
    end

end
