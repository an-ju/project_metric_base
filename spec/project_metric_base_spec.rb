RSpec.describe ProjectMetricBase do
  it "has a version number" do
    expect(ProjectMetricBase::VERSION).not_to be nil
  end

  describe 'ClassMethods' do
    let(:dummy_class) { Class.new }

    describe 'included' do
      it 'adds a new interface' do
        expect(dummy_class).to receive(:extend).with(ProjectMetricBase::ClassMethods)
        dummy_class.include ProjectMetricBase
      end
    end

    describe 'add_credentials' do
      it 'adds credentials' do
        dummy_class.include ProjectMetricBase
        expect { dummy_class.add_credentials %I[c1] }.to change { dummy_class.credentials }
      end
    end

    describe 'add_raw_data' do
      it 'adds data names' do
        dummy_class.include ProjectMetricBase
        expect { dummy_class.add_raw_data %I[d1] }.to change { dummy_class.data_names }
      end
    end

  end

  describe 'InstanceMethods' do
    before :each do
      @dummy_class = Class.new { include ProjectMetricBase }
      @dummy_class.add_raw_data %I[d1 d2]
      @dummy_instance = @dummy_class.new
    end

    describe 'refresh' do
      it 'calls proper methods when refreshed' do
        expect(@dummy_instance).to receive(:d1)
        expect(@dummy_instance).to receive(:d2)
        @dummy_instance.refresh
      end
    end

    describe 'raw_data=' do
      it 'sets raw_data given partial input' do
        expect(@dummy_instance).to receive(:d2)
        @dummy_instance.raw_data = { d1: 'test' }
        expect(@dummy_instance.instance_variable_get('@raw_data'.to_sym)).to have_key(:d1)
        expect(@dummy_instance.instance_variable_get('@raw_data'.to_sym)).to have_key(:d2)
      end

      it 'sets instance variable from given inputs' do
        @dummy_instance.raw_data = { d1: 'v1', d2: 'v2'}
        expect(@dummy_instance.instance_variable_get('@d1'.to_sym)).to eql('v1')
        expect(@dummy_instance.instance_variable_get('@d2'.to_sym)).to eql('v2')
      end

      it 'sets up all inputs when given nil input' do
        expect(@dummy_instance).to receive(:d1)
        expect(@dummy_instance).to receive(:d2)
        @dummy_instance.raw_data = nil
      end
    end

  end
end
