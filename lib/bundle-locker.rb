require File.expand_path("bundle-locker/version", File.dirname(__FILE__))
require 'bundler'
module Bundle
  module Locker
    class Parser
      def initialize(gemfile_name)
        @gemfile_name = gemfile_name
        @gemfile_lock = Bundler::LockfileParser.new(File.read("#{@gemfile_name}.lock"))
      end

      def call
        gem_dictionary = {}
        File.readlines(@gemfile_name).each do |line|
          if /\A(\s*gem\s+['"])([^'"]+)(['"])/ =~ line
            prefix = $1
            gem_name = $2
            suffix = $3
            gem_dictionary[gem_name] = {:prefix => prefix, :original => line, :suffix => suffix, :gem_name => gem_name}
          end
        end

        @gemfile_lock.specs.each do |spec|
          if gem_dictionary[spec.name]
            gem_dictionary[spec.name][:locked_version] = spec.version.to_s
            gem_dictionary[spec.name][:source] = spec.source.to_s
          end
        end
        contents = File.read(@gemfile_name)
        File.open(@gemfile_name, 'w+') do |file|
          gem_dictionary.each do |key, dictionary|
            if dictionary[:locked_version]
              replacement = "#{dictionary[:prefix]}#{dictionary[:gem_name]}#{dictionary[:suffix]}, "
              if dictionary[:source] =~ /git/
                replacement << ":git => '#{dictionary[:source].sub(/\s.*\Z/,'')}'\n"
              else
                replacement << "'#{dictionary[:locked_version]}'\n"
              end
              # not replace prefix `require` and `path`
              unless dictionary[:original].match(/(require|path)/)
                contents.gsub!(dictionary[:original], replacement)
              end
            end
          end
          file.puts contents
        end
      end
    end

    def self.lock(gemfile_name)
      Parser.new(gemfile_name).call
    end
  end
end
