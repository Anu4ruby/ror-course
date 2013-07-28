require 'spec_helper'
describe ChallengesHelper do
  
  describe 'setup question' do
    def dup_question(question)
      q = Question.new
      q.qtype = question.qtype
      q.description = question.description
      q.options = question.options
      q
    end
    def build_options(number, content = nil)
      number.times.inject([]){|result| result << Option.new(:content => content)}
    end
    let(:q) { Question.new(:qtype => type) }
    let(:opts) { build_options(num, cont)}
    let(:cont) { 'some content' }
    before(:each) do
      setup_question(q)
    end
    
    describe 'new record' do
      let(:type) {nil}
      it 'become type of text' do
        q.should be_type('text')
      end
      it 'has 1 option' do
        q.options.should have(1).items
      end
      it 'option selected' do
        q.options.first.should be_selected
      end
    end
    
    [1, 4, 5, 7].each do |size|
      describe "new record with defined #{size} options" do
        let(:type) { nil }
        let(:num){ size }
        before(:each) do
          q.options = opts#build_options(size, cont)
          setup_question(q)
        end
        it 'match type of text' do
          q.should be_type('text')
        end
        it 'only 1 option' do
          q.options.should have(1).items
        end
        it 'option selected' do
          q.options.first.should be_selected
        end
        it 'option not change' do
          q.options.first.content.should == cont
        end
      end# size.each
    end
    
    ['text','single-select', 'multi-select'].each do |type|
      describe "with defined type #{type}" do
        let(:type){ type }
        it 'matches' do
          q.should be_type(type)
        end
        it 'description remain blank' do
          q.description.should be_blank
        end
        num = type == 'text' ? 1 : 5
        it "has #{num} options" do
          q.options.should have(num).items
        end
      end
    end
    ['text','single-select', 'multi-select'].each do |type|
      describe "with defined type and defined options" do
        let(:type){ type }
        [0, 1, 5].each do |idx|
          describe "#{type} with #{idx}" do
            let(:num) { idx }
            before(:each) do
              q.options = opts
              setup_question(q)
            end
            it "matches #{type}" do
              q.should be_type(type)
            end
            num = type == 'text' ? 1 : 5
            it "has #{num} options" do
              q.options.should have(num).items
            end
            blank_num = type == 'text' ? idx == 0 ? 1 : 0 : 5-idx
            it "has #{ blank_num } blank options" do
              q.options.select{|o| o.content.blank? }.should have(blank_num).items
            end
          end
        end
      end
    end
  end

  describe 'init_type!' do
    let(:q){Question.new}
    it 'new record match type text' do
      init_type!(q)
      q.should be_type('text')
    end
    
    describe 'with valid type' do
      ['text', 'single-select', 'multi-select'].each do |type|
        it "matches #{type}" do
          q.qtype = type
          init_type!(q)
          q.should be_type(type)
        end
      end
      
      it 'matches text with invalid type' do
        q.qtype = 'invalid_type'
        init_type!(q)
        q.should be_type('text')
      end
    end
  end
  
  describe 'set_text_options' do
    
    context 'always size of 1' do
      [0, 1, 5].each do |number|
        it "starts with #{number} options" do
          options = number.times.inject([]){|result| result << Option.new }
          options = set_text_options(options)
          options.should have(1).items
        end
      end
    end
    
    context 'will be selected' do
      it 'come with selected' do
        options = [Option.new(:selected => true)]
        options = set_text_options(options)
        options.first.should be_selected
      end
      it 'come without selected' do
        options = [Option.new]
        options = set_text_options(options)
        options.first.should be_selected
      end
    end
    
    context 'will not change content' do
      ['', 'some content'].each do |content|
        it "with '#{content}'" do
          options = [Option.new(:content => content)]
          options = set_text_options(options)
          options.first.content.should == content
        end
      end
    end
  end

  describe 'set_selection_options' do
    context 'at least 5 options' do
      [0, 1, 5, 8].each do |number|
        it "start with #{number} options" do
          options = number.times.inject([]){|result| result << Option.new }
          options = set_selection_options(options)
          options.should have_at_least(5).items
        end
      end
    end
    
    context 'fill up to 5 options if options < 5' do
      [0, 1, 4].each do |number|
        it "starts with #{number} options with content" do
          options = number.times.inject([]) do |result| 
            result << Option.new(content: 'content')
          end
          options = set_selection_options(options)
          options.select{|o| o.content.blank?}.should have(5-number).items
        end
      end
    end
    
    context 'no change if options >= 5' do
      [5, 8, 12].each do |number|
        it "starts with #{number} options" do
          options = number.times.inject([]) do |result| 
            result << Option.new(content: 'content')
          end
          dup = options.dup
          options = set_selection_options(options)
          options.should == dup
        end
      end
    end
  end
  
  context 'output_stat' do
    it do
      data = {:size => 10, :pending => 2, :percentage => "80 % "}
      output_stat(data).should =~ /div.*span/
    end
    it do
      data = {}
      output_stat(data).should == ""
    end
  end
#   
  # describe 'result_classes' do
    # let(:range) { (1..20).to_a }
    # let(:correct) { range.shuffle.first(13) }
    # let(:pending) { (range - correct).shuffle.first(3) }
    # let(:wrong) { range - correct - pending }
    # let(:data) { {:correct => correct, 
                  # :wrong => wrong, 
                  # :pending => pending, 
                  # :size => range.size}}
    # let(:classes) { result_classes(data) }
#     
    # def select(selected)
      # classes.select { |k, v| v == selected.to_s }.keys
    # end 
#     
    # ["wrong", "correct", "pending"].each do |sel|
      # it "has #{sel} classes matched" do
        # select(sel).should == data[sel.to_sym]
      # end
    # end
  # end
end
