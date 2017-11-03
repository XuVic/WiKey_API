# frozen_string_literal: true



folders = %w[domain infrastructure]
folders.each do |folder|
  require_relative "#{folder}/init.rb"
end

require_relative 'app.rb'