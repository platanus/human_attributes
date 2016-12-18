class PurchaseDecorator < Draper::Decorator
  delegate_all

  humanize :quantity, currency: { suffix: "as_draper_example", default: 0 }
end
