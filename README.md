# Human Attributes

It's a Gem to convert ActiveRecord models' attributes and methods to human readable representations of these.

- [Installation](#installation)
- [Usage](#usage)
- [Formatters](#formatters)
  - [Numeric](#numeric)
  - [Date](#date)
  - [DateTime](#datetime)
  - [Boolean](#boolean)
  - [Enumerize](#enumerize)
  - [Custom Formatter](#custom-formatter)
- [Common Options](#common-options)
  - [Default](#default)
  - [Suffix](#suffix)
- [Multiple Formatters](#multiple-formatters)
- [Humanize Active Record Attributes](#humanize-active-record-attributes)
- [Rake Task](#rake-task)

## Installation

Add to your Gemfile:

```ruby
gem "human_attributes"
```

```bash
bundle install
```

## Usage

Suppose you have the following model:

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

Executing the `humanize` method, inside the class definition, will allow you to apply **Formatters** to `Purchase`'s attributes and methods.

### Formatters

#### Numeric

With...

```ruby
pruchase = Purchase.new
purchase.quantity = 20
purchase.commission = 5.3
```

And having...

```ruby
class Purchase < ActiveRecord::Base
  humanize :quantity, percentage: true
  humanize :commission, :commission_amount, currency: { unit: "R$", separator: ",", delimiter: "" }
end
```

You can do...

```ruby
purchase.human_quantity #=> "20.000%"
purchase.human_commission #=> "R$5,30"
purchase.human_commission_amount #=> R$1 060 000,03
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

And `/your_app/config/locales/en.yml`

```yaml
en:
  date:
    formats:
      default: "%Y-%m-%d"
      short: "%b %d"
```

And having...

```ruby
class Purchase < ActiveRecord::Base
  humanize :expired_at, date: { format: :short }
  humanize :created_at, date: true
  humanize :updated_at, date: { format: "%Y" }
end
```

You can do...

```ruby
purchase.human_expired_at #=> "04 Jun"
purchase.human_created_at #=> "1984-06-04"
purchase.human_updated_at #=> "1984"
```

#### DateTime

With...

```ruby
pruchase = Purchase.new
purchase.expired_at = "04/06/1984 09:20:00"
purchase.created_at = "04/06/1984 09:20:00"
purchase.updated_at = "04/06/1984 09:20:00"
```

And `/your_app/config/locales/en.yml`

```yaml
en:
  time:
    formats:
      default: "%a, %d %b %Y %H:%M:%S %z"
      short: "%d %b %H:%M"
```

And having...

```ruby
class Purchase < ActiveRecord::Base
  humanize :expired_at, datetime: { format: :short }
  humanize :created_at, datetime: true
  humanize :updated_at, datetime: { format: "%Y" }
end
```

You can do...

```ruby
purchase.human_expired_at #=> "04 Jun 09:20"
purchase.human_created_at #=> "Mon, 04 Jun 1984 09:20:00 +0000"
purchase.human_updated_at #=> "1984"
```

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

#### Enumerize

Installing [Enumerize](https://github.com/brainspec/enumerize) gem with...

```ruby
pruchase = Purchase.new
purchase.state = :finished
```

And `/your_app/config/locales/en.yml`

```yaml
en:
  enumerize:
    purchase:
      state:
        pending: "P."
        finished: "F."
        canceled: "C."
```

Having...

```ruby
class Purchase < ActiveRecord::Base
  humanize :state, enumerize: true
end
```

You can do...

```ruby
purchase.state = :finished
purchase.human_state #=> "F."
```

#### Custom Formatter

With...

```ruby
pruchase = Purchase.create!
```

And having...

```ruby
class Purchase < ActiveRecord::Base
  humanize :id, custom: { formatter: ->(purchase, value) { "Purchase: #{value}-#{purchase.id}" } }
end
```

You can do...

```ruby
purchase.human_id #=> "Purchase: 1-1"
```

### Common Options

The following options are available to use with all the formatters presented before.

#### Default

With...

```ruby
pruchase = Purchase.new
purchase.amount = nil
```

Having...

```ruby
class Purchase < ActiveRecord::Base
  humanize :amount, currency: { default: 0 }
end
```

You can do...

```ruby
purchase.human_amount #=> "$0"
```

#### Suffix

Useful when you want to define multiple formatters for the same attribute.

With...

```ruby
pruchase = Purchase.new
purchase.paid = true
purchase.amount = 20
```

Having...

```ruby
class Purchase < ActiveRecord::Base
  humanize :paid, boolean: { suffix: "with_custom_suffix" }
  humanize :amount, currency: { suffix: true }
end
```

You can do...

```ruby
purchase.paid_with_custom_suffix #=> "Yes"
purchase.amount_to_currency #=> "$20" # default suffix
```

### Multiple Formatters

With...

```ruby
pruchase = Purchase.new
purchase.amount = 20
```

Having...

```ruby
class Purchase < ActiveRecord::Base
  humanize :amount, currency: { suffix: true }, percentage: { suffix: true }
end
```

You can do...

```ruby
purchase.amount_to_currency #=> ""
purchase.amount_to_percentage #=> ""
```

> Remember to use `:suffix` option to avoid name collisions

### Humanize Active Record Attributes

You can generate human representations for all the atributes of your ActiveRecord model like this:

```ruby
class Purchase < ActiveRecord::Base
  humanize_attributes
end
```

The `humanize_attributes` method will infer from the attribute's data type which formatter to choose.
With our `Purchase` model we will get:

```ruby
purchase.human_id
purchase.human_paid
purchase.human_commission
purchase.human_quantity
purchase.human_expired_at
purchase.expired_at_to_short_date
purchase.expired_at_to_long_date
purchase.expired_at_to_short_datetime
purchase.expired_at_to_long_datetime
purchase.human_amount
purchase.human_created_at
purchase.created_at_to_short_date
purchase.created_at_to_long_date
purchase.created_at_to_short_datetime
purchase.created_at_to_long_datetime
purchase.human_updated_at
purchase.updated_at_to_short_date
purchase.updated_at_to_long_date
purchase.updated_at_to_short_datetime
purchase.updated_at_to_long_datetime
```

> You can pass to `humanize_attributes` the option `only: [:attr1, :attr2]` to humanize specific attributes. The `except` option works in similar way.

### Rake Task

You can run, from your terminal, the following task to show defined human attributes for a particular ActiveRecord model.

`$ rake human_attrs:show[your-model-name]`

So, with...

```ruby
class Purchase < ActiveRecord::Base
  extend Enumerize

  STATES = %i{pending canceled finished}

  enumerize :state, in: STATES, default: :pending

  humanize_attributes
  humanize :state, enumerize: true
  humanize :commission, percentage: true
  humanize :amount, currency: true
end
```

And running `rake human_attrs:show[purchase]`, you will see the following output:

```
human_id => Purchase: #1
human_paid => Yes
human_commission => 1000.990%
human_quantity => 1
human_expired_at => Fri, 06 Apr 1984 09:00:00 +0000
expired_at_to_short_date => Apr 06
expired_at_to_long_date => Apr 06
expired_at_to_short_datetime => 06 Apr 09:00
expired_at_to_long_datetime => 06 Apr 09:00
human_amount => $2,000,000.95
human_created_at => Sat, 10 Dec 2016 21:18:15 +0000
created_at_to_short_date => Dec 10
created_at_to_long_date => Dec 10
created_at_to_short_datetime => 10 Dec 21:18
created_at_to_long_datetime => 10 Dec 21:18
human_updated_at => Sat, 10 Dec 2016 21:18:15 +0000
updated_at_to_short_date => Dec 10
updated_at_to_long_date => Dec 10
updated_at_to_short_datetime => 10 Dec 21:18
updated_at_to_long_datetime => 10 Dec 21:18
human_state => Pending
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
