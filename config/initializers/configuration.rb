Workarea.configure do |config|
  config.seeds << 'Workarea::WishListSeeds'
  config.wish_list_pricing_calculators = Workarea::SwappableList.new(
    %w(
      Workarea::Pricing::Calculators::ItemCalculator
      Workarea::Pricing::Calculators::CustomizationsCalculator
      Workarea::WishList::Pricing::Calculators::TotalsCalculator
    )
  )
end
