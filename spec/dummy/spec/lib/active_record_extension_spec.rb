require "rails_helper"

RSpec.describe "ActiveRecordExtension" do
  describe "#humanize" do
    let(:purchase) { build(:purchase) }

    it "raises error passing invalid options" do
      expect do
        class Purchase < ActiveRecord::Base
          humanize :amount, "invalid"
        end
      end.to raise_error(HumanAttributes::Error::InvalidOptions)
    end

    it "raises error passing multiple types" do
      expect do
        class Purchase < ActiveRecord::Base
          humanize :amount, currency: true, percentage: true
        end
      end.to raise_error(HumanAttributes::Error::UniqueAttributeType)
    end

    it "raises error passing multiple types" do
      expect do
        class Purchase < ActiveRecord::Base
          humanize :amount, invalid: true
        end
      end.to raise_error(HumanAttributes::Error::InvalidType)
    end

    it "raises error passing no type" do
      expect do
        class Purchase < ActiveRecord::Base
          humanize :amount, {}
        end
      end.to raise_error(HumanAttributes::Error::RequiredAttributeType)
    end

    it "raises error trying to pass invalid options" do
      expect do
        class Purchase < ActiveRecord::Base
          humanize :amount, currency: "invalid"
        end
      end.to raise_error(HumanAttributes::Error::InvalidAttributeOptions)
    end

    context "with currency type" do
      before do
        purchase.amount = 20_000_000.5
        purchase.commission = 5.3
      end

      context "with no options" do
        before do
          class Purchase < ActiveRecord::Base
            humanize :amount, currency: true
          end
        end

        it { expect(purchase.human_amount).to eq("$20,000,000.50") }
      end

      context "with valid options" do
        before do
          class Purchase < ActiveRecord::Base
            humanize :amount, currency: { unit: "R$", separator: ",", delimiter: " " }
          end
        end

        it { expect(purchase.human_amount).to eq("R$20 000 000,50") }
      end

      context "with multiple attributes" do
        before do
          class Purchase < ActiveRecord::Base
            humanize :amount, :commission, currency: true
          end
        end

        it { expect(purchase.human_amount).to eq("$20,000,000.50") }
        it { expect(purchase.human_commission).to eq("$5.30") }
      end

      context "with calculated attributes (instance methods)" do
        before do
          class Purchase < ActiveRecord::Base
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
          class Purchase < ActiveRecord::Base
            humanize :quantity, number: true
          end
        end

        it { expect(purchase.human_quantity).to eq("20 Million") }
      end

      context "with size type" do
        before do
          class Purchase < ActiveRecord::Base
            humanize :quantity, size: true
          end
        end

        it { expect(purchase.human_quantity).to eq("19.1 MB") }
      end

      context "with percentage type" do
        before do
          class Purchase < ActiveRecord::Base
            humanize :quantity, percentage: true
          end
        end

        it { expect(purchase.human_quantity).to eq("20000000.000%") }
      end

      context "with phone type" do
        before do
          class Purchase < ActiveRecord::Base
            humanize :quantity, phone: true
          end
        end

        it { expect(purchase.human_quantity).to eq("2-000-0000") }
      end

      context "with delimiter type" do
        before do
          class Purchase < ActiveRecord::Base
            humanize :quantity, delimiter: true
          end
        end

        it { expect(purchase.human_quantity).to eq("20,000,000") }
      end

      context "with precision type" do
        before do
          class Purchase < ActiveRecord::Base
            humanize :quantity, precision: true
          end
        end

        it { expect(purchase.human_quantity).to eq("20000000.000") }
      end
    end
  end
end
