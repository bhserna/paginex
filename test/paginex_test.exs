defmodule PaginexTest do
  use ExUnit.Case, async: true
  doctest Paginex

  test "total pages" do
    pagination = pagination_for current_page: 1, total_items: 4, page_size: 10
    assert pagination.total_pages == "1"

    pagination = pagination_for current_page: 1, total_items: 15, page_size: 10
    assert pagination.total_pages == "2"

    pagination = pagination_for current_page: 3, total_items: 60, page_size: 10
    assert pagination.total_pages == "6"

    pagination = pagination_for current_page: 3, total_items: 62, page_size: 10
    assert pagination.total_pages == "7"

    pagination = pagination_for current_page: 3, total_items: 998, page_size: 20
    assert pagination.total_pages == "50"
  end

  test "previous page" do
    pagination = pagination_for current_page: 1, total_items: 4, page_size: 10
    refute pagination.has_previous_page?
    assert pagination.previous_page == ""

    pagination = pagination_for current_page: 1, total_items: 15, page_size: 10
    refute pagination.has_previous_page?
    assert pagination.previous_page == ""

    pagination = pagination_for current_page: 3, total_items: 62, page_size: 10
    assert pagination.has_previous_page?
    assert pagination.previous_page == "2"

    pagination = pagination_for current_page: 5, total_items: 62, page_size: 10
    assert pagination.has_previous_page?
    assert pagination.previous_page == "4"
  end

  test "next page" do
    pagination = pagination_for current_page: 1, total_items: 4, page_size: 10
    refute pagination.has_next_page?
    assert pagination.next_page == ""

    pagination = pagination_for current_page: 1, total_items: 15, page_size: 10
    assert pagination.has_next_page?
    assert pagination.next_page == "2"

    pagination = pagination_for current_page: 3, total_items: 62, page_size: 10
    assert pagination.has_next_page?
    assert pagination.next_page == "4"

    pagination = pagination_for current_page: 7, total_items: 62, page_size: 10
    refute pagination.has_next_page?
    assert pagination.next_page == ""
  end

  test "pages" do
    pagination = pagination_for current_page: 1, total_items: 4, page_size: 10
    assert pagination.pages == ["1"]

    pagination = pagination_for current_page: 1, total_items: 15, page_size: 10
    assert pagination.pages == ["1", "2"]

    pagination = pagination_for current_page: 3, total_items: 62, page_size: 10
    assert pagination.pages == ["1", "2", "3", "4", "5", "6", "7"]

    pagination = pagination_for current_page: 3, total_items: 998, page_size: 10
    assert pagination.pages == ["1", "2", "3", "4", "5", "6", "7", "8", "9", "10"]

    pagination = pagination_for current_page: 7, total_items: 998, page_size: 10
    assert pagination.pages == ["2", "3", "4", "5", "6", "7", "8", "9", "10", "11"]

    pagination = pagination_for current_page: 15, total_items: 998, page_size: 10
    assert pagination.pages == ["10", "11", "12", "13", "14", "15", "16", "17", "18", "19"]

    pagination = pagination_for current_page: 99, total_items: 998, page_size: 10
    assert pagination.pages == ["91", "92", "93", "94", "95", "96", "97", "98", "99", "100"]

    pagination = pagination_for current_page: 50, total_items: 998, page_size: 20
    assert pagination.pages == ["41", "42", "43", "44", "45", "46", "47", "48", "49", "50"]
  end

  defp pagination_for(options) do
    Paginex.paginate(options)
  end
end
