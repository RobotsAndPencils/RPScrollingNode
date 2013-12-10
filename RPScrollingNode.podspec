Pod::Spec.new do |s|
  s.name         = "RPScrollingNode"
  s.version      = "0.0.1"
  s.summary      = "RPScrollingNode is basically like a table view but for CCNode (and children of)."
  s.homepage     = "https://github.com/RobotsAndPencils/rpscrollingnode"
  s.license      = { :type => 'MIT', :file => 'FILE_LICENSE' }
  s.authors      = { "Paul Thorsteinson" => "paul@robotsandpencils.com", "Reuben Lee" => "reuben.lee@robotsandpencils.com" }
  s.platform     = :ios, '5.0'
  s.source       = { :git => "https://github.com/RobotsAndPencils/RPScrollingNode.git" }
  s.source_files  = 'Classes', 'Classes/**/*.{h,m}'
  s.framework  = 'Foundation'
  s.requires_arc = false

end
