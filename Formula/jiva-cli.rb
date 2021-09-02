class JivaCli < Formula
  RUBY_DEP = "ruby@3".freeze

  VERSION = "0.10.0".freeze
  REVISION = "bd5de6498cc890f741fa4257c630bfe07eba4339".freeze # Needed for brew test-bot
  RUNNING_BUILD = 0

  desc "Tools for managing Jiva installation"
  homepage "https://www.jiva.ag"
  version "#{VERSION}-#{RUNNING_BUILD}"
  license ""

  if File.exist? "#{ENV["HOME"]}/Downloads/jiva-cli-#{VERSION}.tar.gz"
    url "file://#{ENV["HOME"]}/Downloads/jiva-cli-#{VERSION}.tar.gz"
  else
    url "git@github.com:gaia-venture/jiva-cli.git", using: :git, tag: "v#{VERSION}", revision: REVISION
  end
  head "git@github.com:gaia-venture/jiva-cli.git", using: :git, branch: "main"

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

  test do
    system "jiva-cli"
  end
end
