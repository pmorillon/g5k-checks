describe "Memory" do

  before do
    @api = RSpec.configuration.node.api_description['main_memory']
    @sytem = RSpec.configuration.node.ohai_description
  end

  it "should have the correct size" do
    size_api = 0
    if @api
      size_api = @api['ram_size'].to_i
    end
    size_ohai = @sytem[:memory][:total].to_i
    size_ohai = size_ohai*1024
    size_ohai.should eq(size_api), "#{size_ohai}, #{size_api}, main_memory, ram_size"
  end

end
