class OptionTypeObserver < ActiveRecord::Observer

  def after_save(option_type)
    option_type.products(:reload).each do |product|
      OpenFoodNetwork::ProductsCache.product_changed(product)
    end
  end
end
