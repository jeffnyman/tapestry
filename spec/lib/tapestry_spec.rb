RSpec.describe Tapestry do
  it "has a version number" do
    expect(Tapestry::VERSION).not_to be nil
  end

  it "returns version information" do
    expect(Tapestry.version).to include("Tapestry v#{Tapestry::VERSION}")
    expect(Tapestry.version).to include("watir")
  end

  it "returns dependency information" do
    expect(Tapestry.dependencies.to_s).to include("watir")
  end

  context 'a tapestry driver is requested' do
    it "provides the default browser" do
      allow(Watir::Browser).to receive(:new).and_return(Tapestry.browser)
      Tapestry.start_browser
    end
  end
end
