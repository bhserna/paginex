defmodule Paginex do
  defmodule Pagination do
    defstruct [:current_page, :total_items, :total_pages, :page_size,
      :has_previous_page?, :previous_page, :has_next_page?, :next_page, :pages]

    @pages_to_show 10

    def build(options) do
      Pagination
      |> struct(build_options(options))
      |> add_total_pages
      |> add_previous_page
      |> add_next_page
      |> add_pages
      |> convert_values_to_string
    end

    defp convert_values_to_string(pagination) do
      %{:pagination |
        current_page: to_string(pagination.current_page),
        total_items: to_string(pagination.total_items),
        total_pages: to_string(pagination.total_pages),
        page_size: to_string(pagination.page_size),
        previous_page: to_string(pagination.previous_page),
        next_page: to_string(pagination.next_page),
        pages: pagination.pages |> Enum.map(&to_string/1)}
    end

    defp add_pages(pagination) do
      pages = (first_page(pagination)..last_page(pagination)) |> Enum.to_list
      %{pagination | pages: pages}
    end

    defp first_page(pagination) do
      total_pages = pagination.total_pages
      current_page = pagination.current_page
      half_of_pages_to_show = to_int(@pages_to_show / 2)

      if current_page < half_of_pages_to_show do
        1
      else
        if current_page + (@pages_to_show - 1) > total_pages do
          total_pages - (@pages_to_show - 1)
        else
          current_page - half_of_pages_to_show
        end
      end
    end

    def last_page(pagination) do
      first_page = first_page(pagination)
      total_pages = pagination.total_pages

      if total_pages < @pages_to_show do
        total_pages
      else
        if (@pages_to_show - 1) + first_page > total_pages do
          total_pages
        else
          (@pages_to_show - 1) + first_page
        end
      end
    end

    defp add_next_page(pagination) do
      has_next? = pagination.current_page < pagination.total_pages
      next_page = if has_next?, do: pagination.current_page + 1
      %{pagination | has_next_page?: has_next?, next_page: next_page}
    end

    defp add_previous_page(pagination) do
      has_previous? = pagination.current_page > 1
      previous_page = if has_previous?, do: pagination.current_page - 1
      %{pagination | has_previous_page?: has_previous?, previous_page: previous_page}
    end

    defp add_total_pages(pagination) do
      total_pages = pagination.total_items / pagination.page_size
      %{pagination | total_pages: (total_pages |> to_int)}
    end

    defp to_int(float) do
      float |> Float.ceil |> trunc
    end

    defp build_options(options) do
      Enum.map [:current_page, :total_items, :page_size], fn(key) ->
        {key, Keyword.fetch!(options, key)}
      end
    end
  end

  def paginate(options) do
    Pagination.build(options)
  end
end
