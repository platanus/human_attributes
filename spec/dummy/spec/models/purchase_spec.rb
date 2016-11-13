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

require 'rails_helper'

RSpec.describe Purchase, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
