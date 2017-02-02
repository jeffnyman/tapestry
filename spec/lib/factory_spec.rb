RSpec.describe Tapestry::Factory do
  include_context :interface

  before(:each) do
    @factory = TestFactory.new
    @factory.browser = mock_driver
  end

  context "on view" do
    it "creates a new definition and provides the execution context" do
      expect(@factory.browser).to receive(:url).and_return 'http://localhost:9292'
      expect(@factory.browser).to receive(:goto)
      @factory.on_view(ValidPage)
    end

    it "creates a new definition and executes a block in the created execution context" do
      expect(@factory.browser).to receive(:url).and_return 'http://localhost:9292'
      expect(@factory.browser).to receive(:goto)
      @factory.on_visit ValidPage do |page|
        expect(page).to be_instance_of ValidPage
      end
    end
  end

  context "on" do
    it "uses an existing object reference with on" do
      expect(@factory.browser).to receive(:url).twice.and_return 'http://localhost:9292'
      expect(@factory.browser).to receive(:goto)
      obj1 = @factory.on_view ValidPage
      obj2 = @factory.on ValidPage
      expect(obj1).to be(obj2)
    end

    it "creates a new definition and executes a block in the existing execution context" do
      expect(@factory.browser).to receive(:url).and_return 'http://localhost:9292'
      expect(@factory.browser).not_to receive(:goto)
      @factory.on ValidPage do |page|
        expect(page).to be_instance_of ValidPage
      end
    end

    it "provides a context reference to be used outside the factory" do
      expect(@factory.browser).to receive(:url).and_return 'http://localhost:9292'
      page = @factory.on ValidPage
      current = @factory.instance_variable_get '@context'
      expect(current).to be(page)
    end
  end

  context "on new" do
    it "does not use an existing object reference with on_new" do
      expect(@factory.browser).to receive(:url).twice.and_return 'http://localhost:9292'
      expect(@factory.browser).to receive(:goto)
      obj1 = @factory.on_view ValidPage
      obj2 = @factory.on_new ValidPage
      expect(obj1).not_to be(obj2)
    end
  end

  it "raises an exception for url not matching" do
    expect(@factory.browser).to receive(:goto)
    expect(@factory.browser).to receive(:url).and_return 'http://example.com'
    expect {
      @factory.on_view(ValidPage)
    }.to raise_error(
      Tapestry::Errors::PageURLFromFactoryNotVerified,
      'The page URL was not verified during a factory setup.')
  end
end
