require 'spec_helper'

describe TaxonObserver do
  let!(:t1) { create(:taxon) }
  let!(:t2) { create(:taxon) }
  let!(:p2) { create(:simple_product, taxons: [t1], primary_taxon: t2) }

  it "refreshes the products cache on save" do
    expect(OpenFoodNetwork::ProductsCache).to receive(:product_changed).with(p2)
    t1.name = 'asdf'
    t1.save
  end

  it "refreshes the products cache on destroy" do
    expect(OpenFoodNetwork::ProductsCache).to receive(:product_changed).with(p2)
    t1.destroy
  end
end
