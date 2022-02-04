json.pagy do
  json.count        pagy[:count]
  json.page         pagy[:page]
  json.items        pagy[:items]
  json.pages        pagy[:pages]
  json.last         pagy[:last]
  json.from         pagy[:from]
  json.to           pagy[:to]
  json.prev         pagy[:prev]
  json.next         pagy[:next]
end
