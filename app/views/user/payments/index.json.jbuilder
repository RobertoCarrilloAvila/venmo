json.feeds @payments do |payment|
  json.title        "#{payment.origin.id} paid #{payment.target.id}" \
                     " on #{payment.created_at} - #{payment.amount} #{payment.description}"
  json.description  payment.description
end

json.partial! 'user/pagy/info', pagy: @pagy_metadata
