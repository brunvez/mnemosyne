defmodule MnemosyneWeb.Api.V1.FragmentView do
  use MnemosyneWeb, :view
  alias Mnemosyne.Fragments.Link

  def render("fragment.json", %{fragment: link}) do
    %{
      id: link.id,
      title: link.title,
      url: link.url,
      type: Link.fragment_type()
    }
  end
end
