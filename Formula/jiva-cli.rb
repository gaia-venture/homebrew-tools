# Documentation: https://docs.brew.sh/Formula-Cookbook
#                https://rubydoc.brew.sh/Formula
# PLEASE REMOVE ALL GENERATED COMMENTS BEFORE SUBMITTING YOUR PULL REQUEST!
class JivaCli < Formula
  RUBY_VERSION = "3"
  version = "0.0.1"
  running_build = 0

  desc ""
  homepage ""
  url "file:///Users/gja/work/jiva/jiva-cli/foo.tar.gz"
  version "#{version}-#{running_build}"
  sha256 ""
  license ""

  depends_on "ruby@#{RUBY_VERSION}"

  def install
    ruby_formula = Formula.installed.find { |f| f.name == "ruby@#{RUBY_VERSION}" || f.aliases.include?("ruby@#{RUBY_VERSION}") }

    ruby_path = ruby_formula.bin
    system "#{ruby_path}/bundle", "config", "set", "--local", "deployment", "true"
    system "#{ruby_path}/bundle", "config", "set", "--local", "path", "vendor/bundle"
    system "#{ruby_path}/bundle", "install"

    inreplace "exe/jiva-cli" do |s|
      s.gsub! "/usr/bin/env ruby", "#{ruby_path}/ruby"
    end

    prefix.install Dir["./*"]
    mkdir "#{prefix}/.bundle"
    cp ".bundle/config", "#{prefix}/.bundle/config" # No idea why the prefix.install doesn't fix this rubbish

    bin.install_symlink "../exe/jiva-cli"
  end
end
