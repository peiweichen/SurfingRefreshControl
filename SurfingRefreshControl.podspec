Pod::Spec.new do |s|
  s.name         = "SurfingRefreshControl"
  s.version      = "1.0"
  s.license      = { :type => "MIT", :file => "LICENSE" }
  s.summary      = "Customizable pull-to-refresh control,written in pure Swift"
  s.homepage     = "https://github.com/peiweichen/SurfingRefreshControl"
  s.author       = { "Peiwei" => "peiwei233@gmail.com" }
  s.source       = { :git => "https://github.com/peiweichen/SurfingRefreshControl.git", :tag => s.version }
  s.source_files = 'SurfingRefreshControl'
  s.description  = <<-DESC
                   This project is heavily inspired by CBStoreHouseRefreshControl which is Objective-C implemented. SurfingRefreshControl provides you a chance to use pure Swift alternative in your next app.
                   DESC
  s.platform     = :ios, '7.0'
  s.screenshots  = "http://peiweichen.github.io/outofwebsite/gif/surfing.gif", "http://peiweichen.github.io/outofwebsite/gif/storehouse.gif"
  s.requires_arc = true
end
