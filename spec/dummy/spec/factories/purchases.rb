FactoryBot.define do
  factory :purchase do
    paid { true }
    commission { 1000.99 }
    quantity { 1 }
    expired_at { "1984-04-06 09:00" }
    amount { 2_000_000.95 }
    description { "Just a text" }
    payment_method { 'debit' }
    shipping { 'express' }
    store { 'online' }
  end
end
