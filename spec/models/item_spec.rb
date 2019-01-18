# frozen_string_literal: true

# == Schema Information
#
# Table name: items
#
#  id                  :bigint(8)        not null, primary key
#  original_price      :float            not null
#  has_discount        :boolean          default(FALSE)
#  discount_percentage :integer          default(0)
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#

require 'rails_helper'

RSpec.describe Item, type: :model do
  describe 'Model instantiation' do
    subject(:new_item) { described_class.new }

    describe 'Database' do
      it { is_expected.to have_db_column(:id).of_type(:integer) }
      it { is_expected.to have_db_column(:original_price).of_type(:float).with_options(null: false) }
      it { is_expected.to have_db_column(:has_discount).of_type(:boolean).with_options(default: false) }
      it { is_expected.to have_db_column(:discount_percentage).of_type(:integer).with_options(default: 0) }
      it { is_expected.to have_db_column(:created_at).of_type(:datetime).with_options(null: false) }
      it { is_expected.to have_db_column(:updated_at).of_type(:datetime).with_options(null: false) }
    end
  end

  describe 'validations' do
    subject(:item) { create(:item) }

    context 'when factory is valid' do
      it { expect{ item }.to change(described_class, :count).by(1) }
      it { is_expected.to be_valid }
    end

    context 'with :discount_percentage' do
      it {
        expect(item).to validate_numericality_of(:discount_percentage).
          is_greater_or_equal_to(0).
          is_less_or_equal_to(100)
      }
    end
  end

  describe '#price' do
    context "when the item doesn't have a discount" do
      subject(:item) { build(:item_without_discount) }

      it { expect(item.price).to eq(item.original_price) }
    end

    context '#price returns a float' do
      subject(:item) { build(:item) }

      it { expect(item.price.class).to be(Float) }
    end

    context "when the item has a nil discount_percentage" do
      subject(:item) { build(:item_with_discount, discount_percentage: nil) }

      it { expect(item.price).to eq(item.original_price) }
    end

    context 'when the item has a discount' do
      subject(:item) { build(:item_with_discount, original_price: 100, discount_percentage: 20) }

      it { expect(item.price).to eq(80.00) }
    end
  end

  describe '.average_price' do
    subject(:subject) { described_class }

    context 'when the database is empty .average_price returns nil' do
      it { expect(subject.average_price).to eq(nil) }
    end

    context '.average_price returns a float' do
      let!(:item) { create(:item) }
      it { expect(subject.average_price.class).to be(Float) }
    end

  end
end
