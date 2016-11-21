module Spree
  module Search
    class Sunspot < defined?(Spree::Search::MultiDomain) ? Spree::Search::MultiDomain : Spree::Core::Search::Base

      def retrieve_products
        retrieve_results.results
      end

      def retrieve_hits
        retrieve_results.hits
      end

      protected

      def retrieve_results
        conf = Spree::Search.configuration

        # send(name) looks in @properties
        @properties[:sunspot] = ::Sunspot.search(Spree::Product) do
          # This is a little tricky to understand
          #     - we are sending the block value as a method
          #     - Spree::Search::Base is using method_missing() to return the param values
          conf.display_facets.each do |name|
            with("#{name}_facet", send(name)) if send(name).present?
            facet("#{name}_facet")
          end

          if price
            _, min_price, max_price = price.split(/[^\d]+/)
            max_price ||= 1e5
            with(:price, Range.new(min_price.to_f, max_price.to_f-0.001))
          elsif !Spree::Config.show_products_without_price
            with(:price, Range.new(0.0, 1e5-0.001))
            # with(:currency, currency)
          end
          facet(:price) do
            conf.price_ranges.each do |range|
              row(range) do
                _, min_price, max_price = range.split(/[^\d]+/)
                max_price ||= 1e5
                with(:price, Range.new(min_price.to_f, max_price.to_f-0.001))
              end
            end

            # TODO add greater than range
          end

          facet(:taxon_ids)
          with(:taxon_ids, send(:taxon).id) if send(:taxon)

          order_by sort.to_sym, order.to_sym
          with(:is_active, true)
          keywords(query) if query
          paginate(:page => page, :per_page => per_page)
        end

        self.sunspot
      end

      def prepare(params)
        # super copies over :taxon and other variables into properties
        # as well as handles pagination
        super

        # TODO should do some parameter cleaning here: only allow valid search params to be passed through
        # the faceting partial is kind of 'dumb' about the params object: doesn't clean it out and just
        # dumps all the params into the query string

        @properties[:query] = params[:keywords]
        @properties[:price] = params[:price]

        @properties[:sort] = params[:sort] || :score
        @properties[:order] = params[:order] || :desc

        @properties[:currency] = params[:currency] || Spree::Config[:currency]

        Spree::Search.configuration.display_facets.each do |name|
          @properties[name] ||= params["#{name}_facet"]
        end
      end

    end

  end
end
