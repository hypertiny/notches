class Notches::HitsController < ActionController::Base
  def new
    Notches::Hit.log(
      :url => params[:url],
      :session_id => request.session_options[:id],
      :ip => request.remote_ip
    )

    # Don't cache the image.
    response.header["Last-Modified"] = Time.now.httpdate

    send_file Notches::Engine.root.join("app/assets/images/notches/hit.gif"),
              :type => "image/gif",
              :disposition => "inline"
  end
end
