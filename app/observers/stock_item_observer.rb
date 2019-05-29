class StockItemObserver < ActiveRecord::Observer
  observe Spree::StockItem

  def after_save(stock_item)
    OpenFoodNetwork::ProductsCache.variant_changed(stock_item.variant)
  end
end
