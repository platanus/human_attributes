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
    total * commission / 100.0
  end
end
```

You can execute, inside the class definition, `humanize` to generate **Human Representations** of Purchase's attributes and methods.

### Human Representations

#### Currency

```ruby
humanize :amount, currency: true
humanize :commission, :commission_amount, currency: { unit: "R$", separator: ",", delimiter: "" }
```

> `currency` option can receive the same options used in [number_to_currency](http://api.rubyonrails.org/v4.2/classes/ActionView/Helpers/NumberHelper.html#method-i-number_to_currency) ActionView's helper.


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
