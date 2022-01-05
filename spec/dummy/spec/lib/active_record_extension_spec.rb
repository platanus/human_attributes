require "rails_helper"
require "enumerize"

# rubocop:disable Lint/ConstantDefinitionInBlock
RSpec.describe "ActiveRecordExtension" do
  after do
    class Purchase < ApplicationRecord
      humanizers.each do |method|
        remove_method method
      end
    end
  end

  describe "#humanize" do
    let(:purchase) { build(:purchase) }

    it "raises error passing invalid options" do
      expect do
        class Purchase < ApplicationRecord
          humanize :amount, "invalid"
        end
      end.to raise_error(HumanAttributes::Error::InvalidHumanizeConfig)
    end

    it "raises error passing multiple types" do
      expect do
        class Purchase < ApplicationRecord
          humanize :amount, invalid: true
        end
      end.to raise_error(HumanAttributes::Error::InvalidType)
    end

    it "raises error passing no type" do
      expect do
        class Purchase < ApplicationRecord
          humanize :amount, {}
        end
      end.to raise_error(HumanAttributes::Error::RequiredAttributeType)
    end

    it "raises error trying to pass invalid options" do
      expect do
        class Purchase < ApplicationRecord
          humanize :amount, currency: "invalid"
        end
      end.to raise_error(HumanAttributes::Error::InvalidAttributeOptions)
    end

    context "with default value" do
      before do
        class Purchase < ApplicationRecord
          humanize :amount, currency: { default: 666 }
        end

        purchase.amount = nil
      end

      it { expect(purchase.human_amount).to eq("$666.00") }
    end

    context "with default value" do
      before do
        class Purchase < ApplicationRecord
          humanize :amount, percentage: { suffix: true }, currency: { suffix: true }
        end

        purchase.amount = 20
      end

      it { expect(purchase.amount_to_currency).to eq("$20.00") }
      it { expect(purchase.amount_to_percentage).to eq("20.000%") }
    end

    context "with suffix" do
      before { purchase.amount = 20_000_000.5 }

      context "with default suffix" do
        before do
          class Purchase < ApplicationRecord
            humanize :amount, currency: { suffix: true }
          end
        end

        it { expect(purchase.amount_to_currency).to eq("$20,000,000.50") }
      end

      context "with custom suffix" do
        before do
          class Purchase < ApplicationRecord
            humanize :amount, currency: { suffix: "to_cur" }
          end
        end

        it { expect(purchase.amount_to_cur).to eq("$20,000,000.50") }
      end
    end

    context "with currency type" do
      before do
        purchase.amount = 20_000_000.5
        purchase.commission = 5.3
      end

      context "with no options" do
        before do
          class Purchase < ApplicationRecord
            humanize :amount, currency: true
          end
        end

        it { expect(purchase.human_amount).to eq("$20,000,000.50") }
      end

      context "with valid options" do
        before do
          class Purchase < ApplicationRecord
            humanize :amount, currency: { unit: "R$", separator: ",", delimiter: " " }
          end
        end

        it { expect(purchase.human_amount).to eq("R$20 000 000,50") }
      end

      context "with multiple attributes" do
        before do
          class Purchase < ApplicationRecord
            humanize :amount, :commission, currency: true
          end
        end

        it { expect(purchase.human_amount).to eq("$20,000,000.50") }
        it { expect(purchase.human_commission).to eq("$5.30") }
      end

      context "with calculated attributes (instance methods)" do
        before do
          class Purchase < ApplicationRecord
            humanize :commission_amount, currency: true

            def commission_amount
              amount * commission / 100.0
            end
          end
        end

        it { expect(purchase.human_commission_amount).to eq("$1,060,000.03") }
      end
    end

    context "with other numeric types" do
      before { purchase.quantity = 20_000_000 }

      context "with number type" do
        before do
          class Purchase < ApplicationRecord
            humanize :quantity, number: true
          end
        end

        it { expect(purchase.human_quantity).to eq("20 Million") }
      end

      context "with size type" do
        before do
          class Purchase < ApplicationRecord
            humanize :quantity, size: true
          end
        end

        it { expect(purchase.human_quantity).to eq("19.1 MB") }
      end

      context "with percentage type" do
        before do
          class Purchase < ApplicationRecord
            humanize :quantity, percentage: true
          end
        end

        after { purchase.instance_eval('undef :human_quantity') }

        it { expect(purchase.human_quantity).to eq("20000000.000%") }
      end

      context "with phone type" do
        before do
          class Purchase < ApplicationRecord
            humanize :quantity, phone: true
          end
        end

        it { expect(purchase.human_quantity).to eq("2-000-0000") }
      end

      context "with delimiter type" do
        before do
          class Purchase < ApplicationRecord
            humanize :quantity, delimiter: true
          end
        end

        it { expect(purchase.human_quantity).to eq("20,000,000") }
      end

      context "with precision type" do
        before do
          class Purchase < ApplicationRecord
            humanize :quantity, precision: true
          end
        end

        it { expect(purchase.human_quantity).to eq("20000000.000") }
      end
    end

    context "with boolean format" do
      before { purchase.paid = true }

      context "passing true value" do
        before do
          class Purchase < ApplicationRecord
            humanize :paid, boolean: true
          end
        end

        it { expect(purchase.human_paid).to eq("Yes") }
      end

      context "passing false value" do
        before do
          purchase.paid = false

          class Purchase < ApplicationRecord
            humanize :paid, boolean: true
          end
        end

        it { expect(purchase.human_paid).to eq("No") }
      end
    end

    context "with custom formatter" do
      it "raises error with missing formatter option" do
        expect do
          class Purchase < ApplicationRecord
            humanize :id, custom: true
          end
        end.to raise_error(HumanAttributes::Error::MissingFormatterOption)
      end

      context "passing valid formatter" do
        before do
          purchase.id = 1
          purchase.paid = true

          class Purchase < ApplicationRecord
            humanize :id, custom: { formatter: ->(purchase, value) { "#{value}:#{purchase.paid}" } }
          end
        end

        it { expect(purchase.human_id).to eq("1:true") }
      end
    end

    context "with Enumerize attribute" do
      context "passing valid value" do
        before do
          class Purchase < ApplicationRecord
            extend Enumerize
            enumerize :state, in: %i{canceled finished}
            humanize :state, enumerize: true
          end

          purchase.state = :finished
        end

        it { expect(purchase.human_state).to eq("Finished") }
      end

      context "passing no enum value" do
        before do
          class Purchase < ApplicationRecord
            extend Enumerize
            humanize :quantity, enumerize: true
          end
        end

        it do
          expect { purchase.human_quantity }.to(
            raise_error(HumanAttributes::Error::NotEnumerizeAttribute)
          )
        end
      end
    end

    context "with Enum attributes" do
      context "with attribute translation" do
        before do
          class Purchase < ApplicationRecord
            humanize :payment_method, enum: true
          end
        end

        it { expect(purchase.human_payment_method).to eq("Debit Card") }
      end
      context "with enum default translation" do
        before do
          class Purchase < ApplicationRecord
            humanize :shipping, enum: true
          end
        end

        it { expect(purchase.human_shipping).to eq("Express") }
      end
      context "without translation" do
        before do
          class Purchase < ApplicationRecord
            humanize :store, enum: true
          end
        end

        it { expect(purchase.human_store).to eq("online") }
      end
      context "with no enum value" do
        before do
          class Purchase < ApplicationRecord
            humanize :quantity, enum: true
          end
        end

        it do
          expect { purchase.human_quantity }.to(
            raise_error(HumanAttributes::Error::NotEnumAttribute)
          )
        end
      end
    end

    context "with date and datetime format" do
      before { purchase.expired_at = "04/06/1984 09:20:00" }
      before { purchase.created_at = "04/06/1985 09:20:00" }

      context "passing custom format" do
        before do
          class Purchase < ApplicationRecord
            humanize :expired_at, date: { format: "%Y" }
            humanize :created_at, datetime: { format: "%Y" }
          end
        end

        it { expect(purchase.human_expired_at).to eq("1984") }
        it { expect(purchase.human_created_at).to eq("1985") }
      end

      context "without options" do
        before do
          class Purchase < ApplicationRecord
            humanize :expired_at, date: true
            humanize :created_at, datetime: true
          end
        end

        it { expect(purchase.human_expired_at).to eq("1984-06-04") }
        it { expect(purchase.human_created_at).to eq("Tue, 04 Jun 1985 09:20:00 +0000") }
      end

      context "with short format" do
        before do
          class Purchase < ApplicationRecord
            humanize :expired_at, date: { format: :short }
            humanize :created_at, datetime: { format: :short }
          end
        end

        it { expect(purchase.human_expired_at).to eq("Jun 04") }
        it { expect(purchase.human_created_at).to eq("04 Jun 09:20") }
      end

      context "with long format" do
        before do
          class Purchase < ApplicationRecord
            humanize :expired_at, date: { format: :long }
            humanize :created_at, datetime: { format: :long }
          end
        end

        it { expect(purchase.human_expired_at).to eq("June 04, 1984") }
        it { expect(purchase.human_created_at).to eq("June 04, 1985 09:20") }
      end
    end
  end

  describe "#humanize_attributes" do
    let(:purchase) { create(:purchase) }

    context "without options" do
      before do
        class Purchase < ApplicationRecord
          humanize_attributes
        end
      end

      it { expect(purchase.human_id).to eq("Purchase: ##{purchase.id}") }
      it { expect(purchase.human_paid).to eq("Yes") }
      it { expect(purchase.human_quantity).to eq("1") }
      it { expect(purchase.human_commission).to eq("1,000.99") }
      it { expect(purchase.human_amount).to eq("2,000,000.95") }
      it { expect(purchase.human_expired_at).to eq("Fri, 06 Apr 1984 09:00:00 +0000") }
      it { expect(purchase.expired_at_to_short_datetime).to eq("06 Apr 09:00") }
      it { expect(purchase.human_payment_method).to eq("Debit Card") }
      it { expect(purchase.human_shipping).to eq("Express") }
      it { expect(purchase.human_store).to eq("online") }
      it { expect(purchase).to respond_to(:human_created_at) }
      it { expect(purchase).to respond_to(:created_at_to_short_datetime) }
      it { expect(purchase).to respond_to(:human_updated_at) }
      it { expect(purchase).to respond_to(:updated_at_to_short_datetime) }
    end

    context "with only option" do
      before do
        class Purchase < ApplicationRecord
          humanize_attributes only: [:id, :paid, :amount]
        end
      end

      it { expect(purchase.human_id).to eq("Purchase: ##{purchase.id}") }
      it { expect(purchase.human_paid).to eq("Yes") }
      it { expect(purchase).not_to respond_to(:human_quantity) }
      it { expect(purchase).not_to respond_to(:human_commission) }
      it { expect(purchase.human_amount).to eq("2,000,000.95") }
      it { expect(purchase).not_to respond_to(:human_expired_at) }
      it { expect(purchase).not_to respond_to(:expired_at_to_short_datetime) }
      it { expect(purchase).not_to respond_to(:human_created_at) }
      it { expect(purchase).not_to respond_to(:created_at_to_short_datetime) }
      it { expect(purchase).not_to respond_to(:human_updated_at) }
      it { expect(purchase).not_to respond_to(:updated_at_to_short_datetime) }
    end

    context "with except option" do
      before do
        class Purchase < ApplicationRecord
          humanize_attributes except: [:id, :paid, :amount]
        end
      end

      it { expect(purchase).not_to respond_to(:human_id) }
      it { expect(purchase).not_to respond_to(:human_paid) }
      it { expect(purchase.human_quantity).to eq("1") }
      it { expect(purchase.human_commission).to eq("1,000.99") }
      it { expect(purchase).not_to respond_to(:human_amount) }
      it { expect(purchase.human_expired_at).to eq("Fri, 06 Apr 1984 09:00:00 +0000") }
      it { expect(purchase.expired_at_to_short_datetime).to eq("06 Apr 09:00") }
      it { expect(purchase).to respond_to(:human_created_at) }
      it { expect(purchase).to respond_to(:created_at_to_short_datetime) }
      it { expect(purchase).to respond_to(:human_updated_at) }
      it { expect(purchase).to respond_to(:updated_at_to_short_datetime) }
    end
  end
end
# rubocop:enable Lint/ConstantDefinitionInBlock
