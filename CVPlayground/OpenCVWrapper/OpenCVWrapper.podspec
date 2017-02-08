Pod::Spec.new do |s|
s.name         = "OpenCVWrapper"
s.version      = "0.0.1"
s.summary      = "All UI for 2pax"

s.homepage     = "http://github.com/smalleats"

s.license      = "MIT"

s.author       =  "Daniel Haight"

s.platform     = :ios, "9.0"

s.source       = { :git => "../../.git" }

s.source_files  = "**/*.{h,m,mm}"

s.requires_arc = true

s.dependency "OpenCV-iOS"


end
