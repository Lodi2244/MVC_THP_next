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
require 'pry'

class Item < ApplicationRecord
  validates :discount_percentage, numericality: { only_integer: true,
                                                  greater_than_or_equal_to: 0,
                                                  less_than_or_equal_to: 100 }
  def price
    has_discount ? (original_price * (1 - discount_percentage.to_f / 100)).round(2) : original_price
  end

  def self.average_price
    if count.zero?
      return nil
    else
      return (all.inject(0.0) {|total, item| total += item.price } / count).round(2)
    end
  end
end
