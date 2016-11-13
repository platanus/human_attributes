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
    paid false
    commission "9.99"
    quantity 1
    state "MyString"
    expired_at "2016-11-13 00:23:08"
    amount "9.99"
    description "MyText"
  end
end
