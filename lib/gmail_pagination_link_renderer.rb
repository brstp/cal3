class GmailPaginationLinkRenderer < WillPaginate::ViewHelpers::LinkRenderer

  def container_attributes
    super.except(:first_label, :last_label, :summary_label)
  end

  protected

    def pagination
      items = []
      items << :first_page 
      items << :previous_page 
      items << :summary
      items << :next_page 
      items << :last_page 
      items
    end

    def first_page
      previous_or_next_page(1, @options[:first_label], "first_page")
    end

    def last_page
      previous_or_next_page(total_pages, @options[:last_label], "last_page")
    end

    def summary
      tag(:span, @options[:summary_label] % [ @collection.offset + 1, @collection.offset + @collection.count, @collection.total_entries ], :class => "summary")

    end

end
