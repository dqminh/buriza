require_relative './spec_helper'

describe 'Buriza' do
  let(:tmp) { File.expand_path(File.join(File.dirname(__FILE__), '../', "tmp")) }
  let(:path) { File.join tmp, "test-cookbook" }
  let(:test_path) { File.join(path, "test", "cookbooks", "test-cookbook_test") }

  before do
    FileUtils.rm_rf tmp
    FileUtils.mkdir_p tmp
    Buriza::Generator.new(tmp, "test-cookbook").init!
  end

  after do
    FileUtils.rm_rf tmp
  end

  it 'generates a cookbook in specified location' do
    assert File.exist?(path), "cookbook must be generated but found none"

    %w(
    data_bags
    files/default
    templates/default
    attributes/default.rb
    recipes/default.rb
    .kitchen.yml
    Berksfile
    chefignore
    Gemfile
    metadata.rb
    CHANGELOG.md
    README.md
    Vagrantfile).each do |file|
      file_path = File.join(path, file)
      assert File.exist?(file_path), "#{file_path} must be generated but found none"
    end
  end

  it 'generates test files' do
    %w(
    files/default/tests/minitest/helper.rb
    files/default/tests/minitest/default_test.rb
    recipes/default.rb
    metadata.rb
    README.md
    ).each do |file|
      file_path = File.join(test_path, file)
      assert File.exist?(file_path), "#{file_path} must be generated but found none"
    end
  end

  it 'removes all .erb files from location' do
    erb_files = Dir.glob(File.join(path, "**", "{*,.*}.erb"))
    assert_empty erb_files, "must remove all erb files"
  end

  describe 'contents of generated cookbook' do
    it 'generates correctly recipes/default.rb' do
      content = IO.read File.join(path, 'recipes', 'default.rb')
      assert content.include?("test-cookbook")
    end

    it 'generates correctly attributes/default.rb' do
      content = IO.read File.join(path, 'attributes', 'default.rb')
      assert content.include?("test-cookbook")
    end

    it 'generates correctly .kitchen.yml' do
      content = IO.read File.join(path, '.kitchen.yml')
      assert content.include?("recipe[minitest-handler]")
      assert content.include?("recipe[test-cookbook_test")
    end

    it 'generates correctly Berksfile' do
      content = IO.read File.join(path, 'Berksfile')
      assert content.include?("cookbook \"minitest-handler\"")
      assert content.include?("cookbook \"test-cookbook_test\", path: \"./test/cookbooks/test-cookbook_test\"")
    end

    it 'generates correctly CHANGELOG.md' do
      content = IO.read File.join(path, 'CHANGELOG.md')
      assert content.include?("test-cookbook")
    end

    it 'generates correctly README.md' do
      content = IO.read File.join(path, 'README.md')
      assert content.include?("test-cookbook")
    end

    it 'generates correctly metadata.rb' do
      content = IO.read File.join(path, 'metadata.rb')
      assert content.include?("test-cookbook")
    end

    it 'generates correctly Vagrantfile' do
      content = IO.read File.join(path, 'Vagrantfile')
      assert content.include?("config.vm.hostname = \"test-cookbook\"")
      assert content.include?("recipe[test-cookbook::default]")
    end

    it 'generates correctly test/cookbooks/test-cookbook_test/files/default/tests/minitest/default_test.rb' do
      content = IO.read File.join(path, 'test/cookbooks/test-cookbook_test/files/default/tests/minitest/default_test.rb')
      assert content.include?("require_relative \"./helper\"")
      assert content.include?("describe_recipe \"test-cookbook_test::default\" do")
    end

    it 'generates correctly test/cookbooks/test-cookbook_test/metadata.rb' do
      content = IO.read File.join(path, 'test/cookbooks/test-cookbook_test/metadata.rb')
      assert content.include?("test-cookbook_test")
      assert content.include?("depends \"test-cookbook\"")
    end

    it 'generates correctly test/cookbooks/test-cookbook_test/recipes/default.rb' do
      content = IO.read File.join(path, 'test/cookbooks/test-cookbook_test/recipes/default.rb')
      assert content.include?("include_recipe \"test-cookbook\"")
    end
  end
end
