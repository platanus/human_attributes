# == Schema Information
#
# Table name: purchases
#
#  id             :integer          not null, primary key
#  paid           :boolean
#  commission     :decimal(, )
#  quantity       :integer
#  state          :string
#  expired_at     :datetime
#  amount         :decimal(, )
#  description    :text
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  payment_method :integer
#  shipping      :integer
#  store          :integer
#

require "enumerize"

class Purchase < ApplicationRecord
  extend Enumerize

  STATES = %i{pending canceled finished}

  enumerize :state, in: STATES, default: :pending
  enum payment_method: [:credit, :debit, :cash, :bitcoin]
  enum shipping: [:standard, :express]
  enum store: [:physical, :online]

  humanize_attributes
  humanize :state, enumerize: true
  humanize :commission, percentage: true
  humanize :amount, currency: true
  humanize :payment_method, enum: true
  humanize :shipping, enum: true
  humanize :store, enum: true
end
