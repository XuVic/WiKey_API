#frozen_string_literal: true

require_relative './init.rb'

ENV['AWS_ACCESS_KEY_ID'] = app.config.AWS_ACCESS_KEY_ID
ENV['AWS_SECRET_ACCESS_KEY'] = app.config.AWS_SECRET_ACCESS_KEY
ENV['AWS_REGION'] = app.config.AWS_REGION

run WiKey::Api.freeze.app

