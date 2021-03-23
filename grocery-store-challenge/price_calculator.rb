require 'terminal-table'
require_relative './grocery_item_price_calculator.rb'

class PriceCalculator
	attr_accessor :total_price, :total_saved, :total_purchased_items, :store_item_details

	def initialize
		@store_item_details = {
			milk: {unit_price: 3.97, sale_unit_price: 2.5, minimum_unit_for_sale: 2},
			bread: {unit_price: 2.17, sale_unit_price: 2, minimum_unit_for_sale: 3},
			banana: {unit_price: 0.99},
			apple: {unit_price: 0.89},
		}
		@total_purchased_items = []
		@total_saved = 0
		@total_price = 0
	end

	def purchase_items
		puts "Please enter all the items purchased separated by a comma"
		items_bought = gets.chomp.split(',')
		group_items = Hash.new(0)
		items_bought.each {|v| group_items[v.downcase.strip] += 1}
		calculate_bill_price(group_items)		
		generate_bill
	end

	def calculate_bill_price(group_items)
		group_items.each do |item, quantity|
			if @store_item_details[item.to_sym]
				groceryitem = GroceryItemPriceCalculator.new(quantity, @store_item_details[item.to_sym])
				item_price, amount_saved = groceryitem.calculate_price
				@total_purchased_items << [item.capitalize, quantity, "$#{item_price}"]
				@total_saved += amount_saved
				@total_price += item_price
			end
		end
	end

	def generate_bill
		puts Terminal::Table.new :headings => ['Item', 'Quantity', 'Price'], :rows => @total_purchased_items
		puts"\n Total price : $#{@total_price.round(2)} \n You saved $#{@total_saved.round(2)} today."
	end
		
end

PriceCalculator.new.purchase_items