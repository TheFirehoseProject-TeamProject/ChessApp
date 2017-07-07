require 'pusher'

Pusher.app_id = ENV['PUSHER_ID']
Pusher.key = ENV['PUSHER_KEY']
Pusher.secret = ENV['PUSHER_SECRET']
Pusher.cluster = 'ap1'
Pusher.logger = Rails.logger
Pusher.encrypted = true
