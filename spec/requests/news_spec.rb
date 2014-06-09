require 'spec_helper'

describe "News" do
  it "should have the content 'News'" do
    visit '/news'
    expect(page).to have_content('News')
  end
end
