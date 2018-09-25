defmodule IncentivizeWeb.RepositoryView.Test do
  @moduledoc false
  use IncentivizeWeb.ConnCase, async: true
  alias IncentivizeWeb.RepositoryView

  test "make_next_page_link" do
    conn = build_conn()
    conn = get(conn, repository_path(conn, :index, search: [query: "sum"]))
    page = 1

    assert RepositoryView.make_next_page_link(conn, page) =~ "2"
  end

  test "make_previous_page_link" do
    conn = build_conn()
    conn = get(conn, repository_path(conn, :index, search: [query: "sum"]))
    page = 2

    assert RepositoryView.make_previous_page_link(conn, page) =~ "1"
  end

  test "make_page_link" do
    conn = build_conn()
    conn = get(conn, repository_path(conn, :index, search: [query: "sum"]))
    page = 3

    assert RepositoryView.make_page_link(conn, page) =~ "3"
  end

  test "first_page?" do
    assert RepositoryView.first_page?(1) == true
    assert RepositoryView.first_page?(2) == false
  end

  test "last_page?" do
    assert RepositoryView.last_page?(1, 10) == false
    assert RepositoryView.last_page?(10, 10) == true
  end

  test "show_pagination?" do
    assert RepositoryView.show_pagination?(1) == false
    assert RepositoryView.show_pagination?(10) == true
  end

  test "selected_page_class" do
    assert RepositoryView.selected_page_class(1, 1) == "rev-Pagination-number--selected"
    assert RepositoryView.selected_page_class(1, 10) == ""
  end

  test "show_previous_ellipsis?" do
    assert RepositoryView.show_previous_ellipsis?(1, 1) == false
    assert RepositoryView.show_previous_ellipsis?(8, 10) == true
    assert RepositoryView.show_previous_ellipsis?(9, 10) == false
  end

  test "show_next_ellipsis?" do
    assert RepositoryView.show_next_ellipsis?(7, 5, 10) == true
    assert RepositoryView.show_next_ellipsis?(10, 7, 10) == false
  end

  test "show_page_link?" do
    assert RepositoryView.show_page_link?(4, 10) == false
    assert RepositoryView.show_page_link?(8, 10) == true
  end
end
