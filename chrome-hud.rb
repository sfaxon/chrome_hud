require 'sinatra'

class ChromeHud < Sinatra::Base
  get '/' do
    if params[:go]
      chrome = ChromeRemoteDebug::Client.new("127.0.0.1", 9222)
  	  page = chrome.pages.first
      dest = params[:go] || "http://faxon.org"
      dest = dest.match(/^http:\/\//) ? dest : "http://#{dest}"
      system 'export DISPLAY=:0.0 && xdotool click 1'
      page.navigate(dest)
    else
      erb :index
    end
  end

  def local_ip
    orig, Socket.do_not_reverse_lookup = Socket.do_not_reverse_lookup, true  # turn off reverse DNS resolution temporarily
    UDPSocket.open do |s|
      s.connect '64.233.187.99', 1
      s.addr.last
    end
    ensure
    Socket.do_not_reverse_lookup = orig
  end
end
