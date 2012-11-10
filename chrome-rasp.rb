require 'chrome_remote_debug'

chrome = ChromeRemoteDebug::Client.new("192.168.217.136", 9222)

puts chrome.pages
