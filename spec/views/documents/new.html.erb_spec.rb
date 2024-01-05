require 'rails_helper'

RSpec.describe "documents/new", type: :view do
  before(:each) do
    assign(:document, Document.new(
      client: nil,
      name: "MyString"
    ))
  end

  it "renders new document form" do
    render

    assert_select "form[action=?][method=?]", documents_path, "post" do

      assert_select "input[name=?]", "document[client_id]"

      assert_select "input[name=?]", "document[name]"
    end
  end
end
