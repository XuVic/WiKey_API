# frozen_string_literal: true


folders = %w[application infrastructure domain workers]
folders.each do |folder|
  require_relative "#{folder}/init.rb"
end

ENV['AWS_ACCESS_KEY_ID'] = app.config.AWS_ACCESS_KEY_ID
ENV['AWS_SECRET_ACCESS_KEY'] = app.config.AWS_SECRET_ACCESS_KEY
ENV['AWS_REGION'] = app.config.AWS_REGION


