#!/usr/bin/env ruby

require 'fileutils'

def prompt(message, default)
  print "#{message} (or press enter to use: #{default}) > "
  input = gets.chomp
  input = nil if input.strip.empty?
  input
end

folder_path = __dir__

default_package_name = File.basename(Dir.getwd)
default_bundle_domain = 'no.hyper'
default_author_name = `git config user.name`.strip
default_author_email = `git config user.email`.strip
default_username = default_author_email.split('@').first
default_storyboards = 'no'

package_name = ARGV.shift || prompt('🏆  Package name', default_package_name) || default_package_name
bundle_domain = prompt('💼  Bundle Id ', default_bundle_domain) || default_bundle_domain
author_name = prompt('😎  Author', default_author_name) || default_author_name
author_email = prompt('📧  E-mail', default_author_email) || default_author_email
username = prompt('👑  Username', default_username) || default_username
use_storyboards = prompt('🤖  Example with Storyboards? - yes/no', default_storyboards) || default_storyboards
storyboards_example = use_storyboards.downcase == "yes"

file_names = Dir["#{folder_path}/**/*.*"]

file_names.push("#{folder_path}/circle.yml")

file_names.push("#{folder_path}/SwiftPackage.xcodeproj/project.pbxproj")
file_names.push("#{folder_path}/SwiftPackage.xcodeproj/project.xcworkspace/contents.xcworkspacedata")
file_names.push("#{folder_path}/SwiftPackage.xcodeproj/xcshareddata/xcschemes/SwiftPackage-iOS.xcscheme")
file_names.push("#{folder_path}/SwiftPackage.xcodeproj/xcshareddata/xcschemes/SwiftPackage-macOS.xcscheme")

file_names.push("#{folder_path}/Example/CodeDemo/SwiftPackageDemo.xcodeproj/project.pbxproj")
file_names.push("#{folder_path}/Example/CodeDemo/SwiftPackageDemo.xcodeproj/project.xcworkspace/contents.xcworkspacedata")
file_names.push("#{folder_path}/Example/CodeDemo/SwiftPackageDemo.xcodeproj/xcshareddata/xcschemes/SwiftPackageDemo.xcscheme")
file_names.push("#{folder_path}/Example/CodeDemo/Podfile")

file_names.push("#{folder_path}/Example/StoryboardsDemo/SwiftPackageDemo.xcodeproj/project.pbxproj")
file_names.push("#{folder_path}/Example/StoryboardsDemo/SwiftPackageDemo.xcodeproj/project.xcworkspace/contents.xcworkspacedata")
file_names.push("#{folder_path}/Example/StoryboardsDemo/SwiftPackageDemo.xcodeproj/xcshareddata/xcschemes/SwiftPackageDemo.xcscheme")
file_names.push("#{folder_path}/Example/StoryboardsDemo/Podfile")

file_names.each do |file_name|
  ignored_file_types = ['.xccheckout',
    '.xcodeproj',
    '.xcworkspace',
    '.xcuserdatad',
    '.xcuserstate',
    '.xcassets',
    '.appiconset',
    '.png',
    '.lproj',
    '.rb',
    '.framework',
    '.playground'
  ]

  next if file_name.include?('DerivedData')

  if !ignored_file_types.include?(File.extname(file_name))
    text = File.read(file_name)

    new_contents = text.gsub(/<PACKAGENAME>/, package_name)
    new_contents = new_contents.gsub(/SwiftPackage/, package_name)
    new_contents = new_contents.gsub(/BundleDomain/, bundle_domain)
    new_contents = new_contents.gsub(/<AUTHOR_NAME>/, author_name)
    new_contents = new_contents.gsub(/<AUTHOR_EMAIL>/, author_email)
    new_contents = new_contents.gsub(/<USERNAME>/, username)

    File.open(file_name, "w") {|file| file.puts new_contents }
  end
end

FileUtils.rm('README.md')
File.rename('SwiftPackage-README.md', 'README.md')
File.rename("#{folder_path}/SwiftPackage.podspec", "#{folder_path}/#{package_name}.podspec")
File.rename("#{folder_path}/SwiftPackageTests", "#{folder_path}/#{package_name}Tests")
File.rename("#{folder_path}/SwiftPackage.xcodeproj/xcshareddata/xcschemes/SwiftPackage-iOS.xcscheme",
  "#{folder_path}/SwiftPackage.xcodeproj/xcshareddata/xcschemes/#{package_name}-iOS.xcscheme")
File.rename("#{folder_path}/SwiftPackage.xcodeproj/xcshareddata/xcschemes/SwiftPackage-macOS.xcscheme",
  "#{folder_path}/SwiftPackage.xcodeproj/xcshareddata/xcschemes/#{package_name}-macOS.xcscheme")
File.rename("#{folder_path}/SwiftPackage.xcodeproj", "#{folder_path}/#{package_name}.xcodeproj")

example_folder = "CodeDemo"
example_name = "#{package_name}Demo"

if storyboards_example
  FileUtils.rm_rf("#{folder_path}/Example/CodeDemo")
  example_folder = "StoryboardsDemo"
else
  FileUtils.rm_rf("#{folder_path}/Example/StoryboardsDemo")
end

File.rename("#{folder_path}/Example/#{example_folder}", "#{folder_path}/Example/#{example_name}")
File.rename("#{folder_path}/Example/#{example_name}/SwiftPackageDemo.xcodeproj/xcshareddata/xcschemes/SwiftPackageDemo.xcscheme",
  "#{folder_path}/Example/#{example_name}/SwiftPackageDemo.xcodeproj/xcshareddata/xcschemes/#{example_name}.xcscheme")
File.rename("#{folder_path}/Example/#{example_name}/SwiftPackageDemo.xcodeproj",
  "#{folder_path}/Example/#{example_name}/#{example_name}.xcodeproj")
File.rename("#{folder_path}/Example/#{example_name}/SwiftPackageDemo",
  "#{folder_path}/Example/#{example_name}/#{example_name}")

git_directory = "#{folder_path}/.git"
FileUtils.rm_rf git_directory
FileUtils.rm('init.rb')

system("cd #{folder_path}/Example/#{example_name}; pod install; cd #{folder_path}")
system("git init && git add . && git commit -am 'Initial commit'")
system("git remote add origin https://github.com/#{username}/#{package_name}.git")
system("open \"#{folder_path}/#{package_name}.xcodeproj\"")
