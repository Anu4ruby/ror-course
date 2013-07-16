require 'spec_helper'
describe ApplicationHelper do
  context 'check assets' do
    it 'should work' do
      asset_exist?('application.js').should == true
    end
    it 'should not work' do
      asset_exist?(Time.now.to_time.to_i.to_s + '.js').should == false
    end
  end
  context 'get page_items' do
    before(:all) do
      @collection = (1..105).to_a
    end
    it 'should return [] for page 0' do
      page_items(@collection, 0).should == []
    end
    it 'should return 1..10 for page 1' do
      page_items(@collection, 1).should == (1..10).to_a
    end
    it 'should return 51..60 for page 6' do
      page_items(@collection, 6).should == (51..60).to_a
    end
    it 'should return 101..105 for page 11 which is last page' do
      page_items(@collection, 11).should == (101..105).to_a
    end
    it 'should return [] for page 12 which is > max page' do
      page_items(@collection, 12).should == []
    end
  end
end