# == Schema Information
#
# Table name: purchases
#
#  id          :integer          not null, primary key
#  paid        :boolean
#  commission  :decimal(, )
#  quantity    :integer
#  state       :string
#  expired_at  :datetime
#  amount      :decimal(, )
#  description :text
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

FactoryGirl.define do
  factory :purchase do
    paid true
    commission 1000.99
    quantity 1
    expired_at "1984-04-06 09:00"
    amount 2_000_000.95
    description "Just a text"
  end
end
