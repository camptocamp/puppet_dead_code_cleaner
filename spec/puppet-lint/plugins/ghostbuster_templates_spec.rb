require 'spec_helper'

describe 'ghostbuster_templates' do
  let(:code) { "" }

  context 'with fix disabled' do

    context 'when using full module name syntax' do
      let(:path) { "./modules/foo/templates/used_with_template" }

      it 'should not detect any problem' do
        expect(problems).to have(0).problems
      end
    end

    context 'when using $module_name syntax' do
      let(:path) { "./modules/foo/templates/used_with_template_and_module_name" }

      it 'should not detect any problem' do
        expect(problems).to have(0).problems
      end
    end

    context 'when using template in template' do
      let(:path) { "./modules/foo/templates/used_in_template.erb" }

      it 'should not detect any problem' do
        expect(problems).to have(0).problems
      end
    end

    context 'when template usage is not found in manifests' do
      let(:path) { "./modules/foo/templates/unused" }

      it 'should detect one problem' do
        expect(problems).to have(1).problems
      end

      it 'should create a warning' do
        expect(problems).to contain_warning("Template foo/unused seems unused")
      end
    end
  end
end
