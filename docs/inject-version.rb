# frozen_string_literal: true

# This script parses the version from phwriter.psd1 and injects it into Jekyll files.
# It is run during the GitLab Pages deploy build stage to ensure the documentation version matches the manifest.

psd1_path = File.expand_path('../phwriter.psd1', __dir__)
unless File.exist?(psd1_path)
  puts "Error: Manifest file phwriter.psd1 not found at #{psd1_path}."
  exit 1
end

psd1_content = File.read(psd1_path)
version_match = psd1_content.match(/ModuleVersion\s*=\s*['"]([^'"]+)['"]/)

unless version_match
  puts "Error: Could not extract ModuleVersion from phwriter.psd1."
  exit 1
end

version = version_match[1]
puts "Extracted ModuleVersion from manifest: #{version}"

# 1. Update docs/_config.yml
config_path = File.expand_path('_config.yml', __dir__)
if File.exist?(config_path)
  config_content = File.read(config_path)
  if config_content.gsub!(/project_version:\s*['"]?[^'"\n]+['"]?/, "project_version: \"v#{version}\"")
    File.write(config_path, config_content)
    puts "Updated project_version in _config.yml to v#{version}"
  else
    puts "Warning: project_version key not found or not changed in _config.yml"
  end
end

# 2. Update docs/_data/downloads.yml
downloads_path = File.expand_path('_data/downloads.yml', __dir__)
if File.exist?(downloads_path)
  downloads_content = File.read(downloads_path)
  # Replace v2.0.0 with v[version], and 2.0.0 with [version]
  updated_downloads = downloads_content
    .gsub(/v2\.0\.0/, "v#{version}")
    .gsub(/2\.0\.0/, version)
  File.write(downloads_path, updated_downloads)
  puts "Updated versions in _data/downloads.yml"
end

# 3. Update docs/downloads.md
downloads_md_path = File.expand_path('downloads.md', __dir__)
if File.exist?(downloads_md_path)
  downloads_md_content = File.read(downloads_md_path)
  updated_downloads_md = downloads_md_content.gsub(/v2\.0\.0/, "v#{version}")
  File.write(downloads_md_path, updated_downloads_md)
  puts "Updated versions in downloads.md"
end
