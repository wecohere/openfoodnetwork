class PropertyObserver < ActiveRecord::Observer
  def after_save(property)
    property.product_properties(:reload).each do |product|
      OpenFoodNetwork::ProductsCache.product_changed(product)
    end
  end
end
