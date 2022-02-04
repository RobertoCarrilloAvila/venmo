json.feeds @payments do |payment|
  json.partial! 'info', payment: payment
end
