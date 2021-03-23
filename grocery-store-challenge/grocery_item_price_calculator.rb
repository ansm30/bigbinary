class GroceryItemPriceCalculator
  attr_reader :item_quantity, :item_detail

  def initialize(item_quantity, item_detail)
    @item_quantity = item_quantity
    @item_detail = item_detail
  end

  def calculate_price
    total_without_discount = (@item_quantity * @item_detail[:unit_price])
    return [total_without_discount.round(2), 0] if !@item_detail.has_key?(:sale_unit_price) || @item_detail[:minimum_unit_for_sale] > @item_quantity
        
    if (@item_quantity % @item_detail[:minimum_unit_for_sale]) == 0
      total_price = @item_quantity * @item_detail[:sale_unit_price] 
    else
      no_discount_quantities = @item_quantity % @item_detail[:minimum_unit_for_sale] 
      total_for_discount_items = (@item_quantity - no_discount_quantities) * @item_detail[:sale_unit_price] 
      total_for_non_discount_items = no_discount_quantities * @item_detail[:unit_price] 
      total_price = total_for_discount_items + total_for_non_discount_items
    end
    
    return [total_price.round(2), (total_without_discount - total_price).round(2)]
  end
  
end