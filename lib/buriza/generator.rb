require 'erb'
require 'fileutils'

module Buriza
  class Generator
    def initialize(dest, name)
      @name = name
      @test_name = "#{name}_test"
      @path = File.join(dest, @name)
      @test_path = File.join(@path, "test", "cookbooks", @test_name)
    end

    def init!
      mkdir!
      copy_default_template!
      copy_test_template!
      replace_content!
    end

    def get_binding
      binding
    end

    def mkdir!
      FileUtils.mkdir_p @path
      FileUtils.mkdir_p @test_path
    end

    def copy_default_template!
      default_templates = File.expand_path(File.join(current_dir, '..', "..",
                                                     "templates", "default"))
      default_files = Dir.glob File.join(default_templates, '*')
      default_files << File.join(default_templates, ".kitchen.yml.erb")
      FileUtils.cp_r default_files, @path
    end

    def copy_test_template!
      test_templates = File.expand_path(File.join(current_dir, '..', "..", "templates", "test"))
      test_files = Dir.glob File.join(test_templates, '*')
      FileUtils.cp_r test_files, @test_path
    end

    def replace_content!
      Dir.glob(File.join(@path, "**", "{*,.*}.erb")).each do |template|
        filename = File.basename template, ".*"
        dest = File.join(File.dirname(template), filename)
        template_content = IO.read template
        File.open dest, "w" do |file|
          file.write ERB.new(template_content).result get_binding
        end
        FileUtils.rm template
      end
    end

    def current_dir
      File.expand_path File.dirname(__FILE__)
    end
  end
end
