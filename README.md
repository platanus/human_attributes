# Human Attributes
[![Gem Version](https://badge.fury.io/rb/human_attributes.svg)](https://badge.fury.io/rb/human_attributes)
[![CircleCI](https://circleci.com/gh/platanus/human_attributes.svg?style=shield)](https://app.circleci.com/pipelines/github/platanus/human_attributes)
[![Coverage Status](https://coveralls.io/repos/github/platanus/human_attributes/badge.svg)](https://coveralls.io/github/platanus/human_attributes)

It's a Gem to convert ActiveRecord models' attributes and methods to human readable representations of these.

- [Human Attributes](#human-attributes)
  - [Installation](#installation)
  - [Usage](#usage)
    - [Formatters](#formatters)
      - [Numeric](#numeric)
      - [Date](#date)
      - [DateTime](#datetime)
      - [Boolean](#boolean)
      - [Enumerize](#enumerize)
      - [Enum](#enum)
      - [Custom Formatter](#custom-formatter)
    - [Common Options](#common-options)
      - [Default](#default)
      - [Suffix](#suffix)
    - [Multiple Formatters](#multiple-formatters)
    - [Humanize Active Record Attributes](#humanize-active-record-attributes)
    - [Integration with Draper Gem](#integration-with-draper-gem)
    - [Rake Task](#rake-task)
  - [Testing](#testing)
  - [Publishing](#publishing)
  - [Contributing](#contributing)
  - [Credits](#credits)
  - [License](#license)

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
purchase = Purchase.new
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
purchase = Purchase.new
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
purchase = Purchase.new
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
purchase = Purchase.new
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
purchase = Purchase.new
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

#### Enum

Having...

```ruby
class Purchase < ActiveRecord::Base
  enum payment_method: [:credit, :debit, :cash, :bitcoin]
end
```

You can add
```ruby
class Purchase < ActiveRecord::Base
  enum payment_method: [:credit, :debit, :cash, :bitcoin]
  humanize :payment_method, enum: true
end
```

And `/your_app/config/locales/en.yml`

```yaml
en:
  activerecord:
   attributes:
    purchase:
      payment_methods:
        credit: "Credit Card"
        debit: "Debit Card"
        cash: "Cash"
        bitcoin: "Bitcoin"
```


And then you can do...

```ruby
purchase = Purchase.new
purchase.payment_method = :debit
purchase.human_payment_method #=> "Debit Card"
```

If you want to use the same enum translations for multiple models, use this locales structure:

`/your_app/config/locales/en.yml`

```yaml
en:
  enum:
    default:
      payment_methods:
        credit: "Credit Card"
        debit: "Debit Card"
        cash: "Cash"
        bitcoin: "Bitcoin"
```

and then in other models will also work:

```ruby
class Debt < ActiveRecord::Base
  enum payment_method: [:credit, :debit, :cash, :bitcoin]
  humanize :payment_method, enum: true
end
```

```ruby
purchase = Purchase.new
purchase.payment_method = :debit

debt = Debt.new
debt.payment_method = :bitcoin

purchase.human_payment_method #=> "Debit Card"
debt.human_payment_method #=> "Bitcoin"
```





#### Custom Formatter

With...

```ruby
purchase = Purchase.create!
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
purchase = Purchase.new
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
purchase = Purchase.new
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
purchase = Purchase.new
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

### Integration with Draper Gem

If you are thinking that the formatting functionality is a **view related issue**, you are right. Because of this, we made the integration with [Draper gem](https://github.com/drapergem/draper). Using draper, you can move all your humanizers to your model's decorator.

With...

```ruby
class Purchase < ActiveRecord::Base
  extend Enumerize

  STATES = %i{pending canceled finished}

  enumerize :state, in: STATES, default: :pending

  humanize :state, enumerize: true
  humanize :commission, percentage: true
  humanize :amount, currency: true
end
```

You can refactor your code like this:

```ruby
class Purchase < ActiveRecord::Base
  extend Enumerize

  STATES = %i{pending canceled finished}

  enumerize :state, in: STATES, default: :pending
end

class PurchaseDecorator < Draper::Decorator
  delegate_all

  humanize :state, enumerize: true
  humanize :commission, percentage: true
  humanize :amount, currency: true
end
```

Then, you can use it, like this:

```ruby
purchase.human_amount #=> NoMethodError: undefined method `human_amount'
purchase.decorate.human_amount #=> $2,000,000.95
```

It's not mandatory to use draper as decorator. You can extend whatever you want including `HumanAttributes::Extension`. For example:

```ruby
Draper::Decorator.send(:include, HumanAttributes::Extension)
```

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

## Publishing

On master/main branch...

1. Change `VERSION` in `lib/gemaker/version.rb`.
2. Change `Unreleased` title to current version in `CHANGELOG.md`.
3. Run `bundle install`.
4. Commit new release. For example: `Releasing v0.1.0`.
5. Create tag. For example: `git tag v0.1.0`.
6. Push tag. For example: `git push origin v0.1.0`.

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
