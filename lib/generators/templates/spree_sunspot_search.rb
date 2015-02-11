# Take a look at the Spree::Search::Configuration class for details
# it is important that all 'block fields' return an empty string and not nil

Spree::Search.configure do |conf|
    conf.price_ranges = ["$0 to $5", "$5 to $15", "$15 to $20", "$20 +"]
    conf.option_facets = []
    conf.property_facets = []
    conf.other_facets = []
    conf.show_facets = []

    conf.fields = [
      { :type => :text, :name => :name, :opts => {:stored => true} },
      { :type => :text, :name => :description, :opts => {:stored => true} },
      { :type => :text, :name => :sku },
      { :type => :double, :name => :price },
      { :type => :string, :name => :currency }
    ]
    
    conf.sort_fields = {}
end
