Pod::Spec.new do |s|
    s.name         = "REComposeViewController"
    s.version      = "2.3.2"
    s.summary      = "Sharing composers for the rest of us."
    s.homepage     = "https://github.com/REWMassimo/REComposeViewController"
    s.license      = { :type => "MIT", :file => "LICENSE" }
    s.author       = { "Roman Efimov" => "" }
    s.description  = <<-DESC
Replicates functionality of SLComposeViewController introduced in iOS 6.0. You can create composers
for any social network out there. REComposeViewController doesn't provide logic for sharing, only
its visual part.

Forked from Roman Efimov's original with a modified init method:

1. Added enum for mode, originally added by Andy Madan in 2013.
2. Changed init method to include mode as additional parameter

DESC

  s.platform              = :ios, '5.0'
  s.ios.deployment_target = '5.0'
  s.requires_arc          = true

  s.source       = { :git => "https://github.com/REWMassimo/REComposeViewController.git",
                     :tag => s.version.to_s }

  s.source_files = 'REComposeViewController'
  s.public_header_files = 'REComposeViewController/*.h'

  s.resources = "REComposeViewController/REComposeViewController.bundle"
end
