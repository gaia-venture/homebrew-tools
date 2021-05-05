# Documentation: https://docs.brew.sh/Formula-Cookbook
#                https://rubydoc.brew.sh/Formula
# PLEASE REMOVE ALL GENERATED COMMENTS BEFORE SUBMITTING YOUR PULL REQUEST!
class JivaCli < Formula
  RUBY_DEP = "ruby@3"
  VERSION = "0.5.0"
  RUNNING_BUILD = 0

  desc ""
  homepage ""
  url ENV["X"] || ENV["JIVA_CLI_TARPATH"] || "file://#{ENV["HOME"]}/Downloads/jiva-cli-#{VERSION}.tar.gz"
  version "#{VERSION}-#{RUNNING_BUILD}"
  sha256 ""
  license ""

  depends_on RUBY_DEP

  def install
    ruby_formula = Formula.installed.find { |f| f.name == RUBY_DEP || f.aliases.include?(RUBY_DEP) }

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
