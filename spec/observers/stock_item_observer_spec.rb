require 'spec_helper'

describe StockItemObserver do
  before :all do
    ActiveRecord::Base.observers.disable
  end

  after :all do
    ActiveRecord::Base.observers.enable
  end

  let!(:variant) { create(:variant) }

  it 'refreshes the products cache on save' do
    ActiveRecord::Base.observers.enable(:stock_item_observer) do
      expect(OpenFoodNetwork::ProductsCache).to receive(:variant_changed).with(variant)
      variant.on_hand = -2
    end
  end
end
