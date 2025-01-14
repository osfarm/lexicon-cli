source 'https://rubygems.org'

git_source(:gitlab) do |repo_name|
  repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?('/')
  "https://gitlab.com/#{repo_name}.git"
end

gemspec
