# Human Attributes

Gem to convert ActiveRecord attributes and methods to human readable attributes

## Installation

Add to your Gemfile:

```ruby
gem "human_attributes"
```

```bash
bundle install
```

## Usage

Having the following model:

```ruby
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
    amount * commission / 100.0
  end
end
```

You can execute, inside the class definition, `humanize` to generate **Human Representations** of Purchase's attributes and methods.

### Human Representations

#### Numeric

With...

```ruby
pruchase = Purchase.new
purchase.quantity = 20
purchase.amount = 20_000_000.5
purchase.commission = 5.3
```

And having...

```ruby
class Purchase < ActiveRecord::Base
  humanize :amount, currency: { default: 0 }
  humanize :quantity, percentage: true
  humanize :commission, :commission_amount, currency: { unit: "R$", separator: ",", delimiter: "" }
end
```

You can do...

```ruby
purchase.human_amount #=> "$20,000,000.50"
purchase.human_quantity #=> "20.000%"
purchase.human_commission #=> "R$5,30"
purchase.human_commission_amount #=> R$1 060 000,03

purchase.amount = nil
purchase.human_amount #=> "$0" default value
```

The available numeric types are:`currency`, `number`, `size`, `percentage`, `phone`, `delimiter` and `precision`.

And the options to use with numeric types, are the same as in [NumberHelper](http://api.rubyonrails.org/v4.2/classes/ActionView/Helpers/NumberHelper.html)

#### Date

With...

```ruby
pruchase = Purchase.new
purchase.expired_at = "04/06/1984 09:20:00"
purchase.created_at = "04/06/1984 09:20:00"
purchase.updated_at = "04/06/1984 09:20:00"
```

And having...

```ruby
class Purchase < ActiveRecord::Base
  humanize :expired_at, date: { format: :short }
  humanize :created_at, date: true
  humanize :updated_at, , date: { format: "%Y" }
end
```

You can do...

```ruby
purchase.human_expired_at #=> "04 Jun 09:20"
purchase.human_created_at #=> "Mon, 04 Jun 1984 09:20:00 +0000"
purchase.human_updated_at #=> "1984"
```

The options you can use with the date type are the same as in [Rails guides](http://guides.rubyonrails.org/v4.2/i18n.html#adding-date-time-formats)

#### Boolean

With...

```ruby
pruchase = Purchase.new
purchase.paid = true
```

And `/your_app/config/locales/en.yml`

```yaml
en:
  boolean:
    positive: "Yes"
    negative: "No"
```

Having...

```ruby
class Purchase < ActiveRecord::Base
  humanize :paid, boolean: true
end
```

You can do...

```ruby
purchase.human_paid #=> "Yes"
purchase.paid = false
purchase.human_paid #=> "No"
```

## Testing

To run the specs you need to execute, **in the root path of the gem**, the following command:

```bash
bundle exec guard
```

You need to put **all your tests** in the `/human_attributes/spec/dummy/spec/` directory.

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

## Credits

Thank you [contributors](https://github.com/platanus/human_attributes/graphs/contributors)!

<img src="http://platan.us/gravatar_with_text.png" alt="Platanus" width="250"/>

Human Attributes is maintained by [platanus](http://platan.us).

## License

Human Attributes is © 2016 platanus, spa. It is free software and may be redistributed under the terms specified in the LICENSE file.
