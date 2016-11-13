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

class Purchase < ActiveRecord::Base
  extend Enumerize

  STATES = %i{pending canceled finished}

  enumerize :state, in: STATES, default: :pending

  def commission_amount
    total * commission / 100.0
  end
end
