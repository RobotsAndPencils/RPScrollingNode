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
  s.license      = {
    :type => 'MIT',
    :text => <<-LICENSE
Copyright (c) 2013 Robots and Pencils, Inc. All rights reserved.
Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

"RPScrollingNode" is a trademark of Robots and Pencils, Inc. and may not be used to endorse or promote products derived from this software without specific prior written permission.

Neither the name of the Robots and Pencils, Inc. nor the names of its contributors may be used to endorse or promote products derived from this software without specific prior written permission. 

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
    LICENSE
  }

end
