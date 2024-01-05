require 'rails_helper'

RSpec.describe "documents/show", type: :view do
  before(:each) do
    assign(:document, Document.create!(
      client: nil,
      name: "Name"
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(//)
    expect(rendered).to match(/Name/)
  end
end
