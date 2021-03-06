describe "Processor" do

  before(:all) do
    @api = RSpec.configuration.node.api_description["processor"]
    @system = RSpec.configuration.node.ohai_description
  end

  it "should have the correct frequency" do
    freq_api = ""
    if @api
      freq_api = @api["clock_speed"]
    else
      freq_api = 0
    end

    # freq_ohai = @system[:cpu][:mhz] # not accurate

    freq_ohai = @system[:cpu]['clock_speed'].to_i * 1000 # from x86info

    err = (freq_ohai-freq_api).abs
    err.should be < 100000000, "#{freq_ohai}, #{freq_api}, processor, clock_speed"
  end

  it "should be of the correct instruction set" do
    instr_api = ""
    instr_api = @api["instruction_set"] if @api
    instr_ohai = @system[:kernel][:machine].sub('_','-')
    instr_ohai.should eql(instr_api), "#{instr_ohai}, #{instr_api}, processor, instruction_set"
  end

  it "should be of the correct model" do
    desc_api = ""
    desc_api = @api["model"] if @api
    desc_ohai = @system[:cpu][:model]
    desc_ohai.should eql(desc_api), "#{desc_ohai}, #{desc_api}, processor, model"
  end

  it "should be of the correct version" do
    version_api = ""
    version_api = @api["version"].to_s if @api
    version_ohai = @system[:cpu][:version]
    version_ohai.should eql(version_api), "#{version_ohai}, #{version_api}, processor, version"
  end

  it "should have the correct vendor" do
    vendor_api = ""
    vendor_api = @api["vendor"] if @api
    vendor_ohai = @system[:cpu][:vendor]
    vendor_ohai.should eql(vendor_api), "#{vendor_ohai}, #{vendor_api}, processor, vendor"
  end

  it "should have the correct description" do
    desc_api = ""
    desc_api = @api["other_description"] if @api
    desc_ohai = @system[:cpu][:'0'][:model_name]
    desc_ohai.should eql(desc_api), "#{desc_ohai}, #{desc_api}, processor, other_description"
  end

  it "should have the correct L1i" do
    l1i_api = ""
    l1i_api = @api["cache_l1i"] if @api
    l1i_ohai = @system[:cpu][:L1i].to_i*1024
    l1i_ohai.should eql(l1i_api), "#{l1i_ohai}, #{l1i_api}, processor, cache_l1i"
  end

  it "should have the correct L1d" do
    l1d_api = ""
    l1d_api = @api["cache_l1d"] if @api
    l1d_ohai = @system[:cpu][:L1d].to_i*1024
    l1d_ohai.should eql(l1d_api), "#{l1d_ohai}, #{l1d_api}, processor, cache_l1d"
  end

  it "should have the correct L2" do
    l2_api = ""
    l2_api = @api["cache_l2"] if @api
    l2_ohai = @system[:cpu][:L2].to_i*1024
    l2_ohai.should eql(l2_api), "#{l2_ohai}, #{l2_api}, processor, cache_l2"
  end

  it "should have the correct L3" do
    l3_api = ""
    l3_api = @api["cache_l3"] if @api
    l3_ohai = @system[:cpu][:L3].to_i*1024
    l3_ohai.to_i.should eql(l3_api), "#{l3_ohai}, #{l3_api}, processor, cache_l3"
  end

  [:ht_capable].each { |key|
    
    it "should have the correct value for #{key}" do
      key_ohai = @system[:cpu][key]
      
      key_api = nil
      key_api = @api[key.to_s] if @api
      
      key_ohai.should eq(key_api), "#{key_ohai}, #{key_api}, processor, #{key}"
    end
    
  }
  
end
