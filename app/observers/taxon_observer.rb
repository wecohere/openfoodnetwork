class TaxonObserver < ActiveRecord::Observer

  def after_save(taxon)
    taxon.products(:reload).each do |product|
      OpenFoodNetwork::ProductsCache.product_changed(product)
    end
  end
end
