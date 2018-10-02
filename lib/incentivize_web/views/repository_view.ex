defmodule IncentivizeWeb.RepositoryView do
  use IncentivizeWeb, :view
  @page_links_to_show 2
  @max_number_of_links 3
  alias Incentivize.RepositoryLink

  def make_next_page_link(conn, current_page) do
    make_page_link(conn, current_page + 1)
  end

  def make_previous_page_link(conn, current_page) do
    make_page_link(conn, current_page - 1)
  end

  def make_page_link(conn, page) do
    query_params = conn.query_params

    search_params =
      query_params
      |> Map.get("search", %{})
      |> Map.put("page", page)

    query_params = Map.put(query_params, "search", search_params)

    repository_path(conn, :index, query_params)
  end

  def first_page?(1), do: true
  def first_page?(_), do: false

  def last_page?(page_number, total_pages) when page_number == total_pages, do: true
  def last_page?(_, _), do: false

  def show_pagination?(1), do: false
  def show_pagination?(_), do: true

  def selected_page_class(page_number, current_page) when page_number == current_page do
    "rev-Pagination-number--selected"
  end

  def selected_page_class(_, _) do
    ""
  end

  def show_previous_ellipsis?(1, _) do
    false
  end

  def show_previous_ellipsis?(page, page_number) do
    page == page_number - @page_links_to_show
  end

  def show_next_ellipsis?(page, page_number, total_pages) do
    page == page_number + @page_links_to_show and page != total_pages
  end

  def show_page_link?(page, page_number) do
    page >= page_number - @page_links_to_show and page <= page_number + @page_links_to_show
  end

  def append_links(repository) do
    links_needed = @max_number_of_links - length(repository.links)

    if links_needed <= 0 do
      []
    else
      Enum.map(1..links_needed, fn _ -> %RepositoryLink{} end)
    end
  end
end
