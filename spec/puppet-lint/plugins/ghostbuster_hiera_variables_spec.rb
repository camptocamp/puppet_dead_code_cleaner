require 'spec_helper'

ENV['HIERA_YAML_PATH'] = './spec/fixtures/hiera.yaml'

describe 'ghostbuster_hiera_variables' do

  let(:code) { "" }

  context 'with fix disabled' do

    context 'when a variable is NOT used' do
      let (:path) { './spec/fixtures/hieradata/nodes/bar.example.com.yaml' }

      it 'should detect one problem' do
        expect(problems).to have(1).problems
      end

      it 'should create a warning' do
        expect(problems).to contain_warning("Hiera Variable bar::baz in nodes/bar.example.com.yaml seems unused")
      end
    end

    context 'when a variable is used with databinding' do
      let (:path) { './spec/fixtures/hieradata/nodes/baz.example.com.yaml' }

      it 'should not detect any problem' do
        expect(problems).to have(0).problems
      end
    end
  end
end
