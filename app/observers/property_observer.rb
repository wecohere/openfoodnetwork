class PropertyObserver < ActiveRecord::Observer
  observe Spree::Property

  def after_save(property)
    property.product_properties(:reload).each do |product_property|
      OpenFoodNetwork::ProductsCache.product_changed(product_property.product)
    end
  end
end
