# frozen_string_literal: true

folders = %w[entities lib/gnews_api]
folders.each do |folder|
  require_relative "#{folder}/init.rb"
end

require_relative 'app.rb'
