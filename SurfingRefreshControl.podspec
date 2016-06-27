Pod::Spec.new do |s|
  s.name         = "SurfingRefreshControl"
  s.version      = "1.0"
  s.license      = { :type => "MIT", :file => "LICENSE" }
  s.summary      = "Fully customizable pull-to-refresh control inspired by Storehouse iOS app"
  s.homepage     = "https://github.com/Sufi-Al-Hussaini/SurfingRefreshControl"
  s.author       = { "Peiwei" => "peiwei233@gmail.com" }
  s.source       = { :git => "https://github.com/Sufi-Al-Hussaini/SurfingRefreshControl.git", :tag => s.version }
  s.source_files = 'SurfingRefreshControl'
  s.description  = <<-DESC
                   A fully customizable pull-to-refresh control for iOS inspired by Storehouse iOS app. 
      You can use any shape through a plist file.
                   DESC
  s.platform     = :ios, '7.0'
  s.screenshots  = "https://s3.amazonaws.com/suyu.test/CBStoreHouseRefreshControl1.gif", "https://s3.amazonaws.com/suyu.test/CBStoreHouseRefreshControl2.gif"
  s.requires_arc = true
end