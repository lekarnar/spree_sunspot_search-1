Spree::BaseHelper.module_eval do
  def link_to_facet(facet_name, facet_row)
    # if we are just linking to taxon, link to the permalink instead of query string

    if facet_name == :taxon_id
      # use seo_url when linking to a taxon
      link_to(facet_row.instance.name + " (#{facet_row.count})", nested_taxons_path(facet_row.instance.permalink, params.merge("page" => nil)), :class => "list-group-item")
    else
      link_to(facet_row.value + " (#{facet_row.count})", params.merge("#{facet_name}_facet" => facet_row.value, "page" => nil), :class => "list-group-item")
    end
  end
end