# frozen_string_literal: true

require 'spec_helper'
require 'adomik/challenges/data_engine/transformation_template'

describe Adomik::Challenges::DataEngine::TransformationTemplate do
  describe '.initialize' do
    let(:name) { 'name' }
    let(:required_params) { 'required_params' }

    subject { described_class.new(name, required_params) }

    it 'set name' do
      expect(subject.name).to eql name
    end

    it 'set required_params' do
      expect(subject.required_params).to eql required_params
    end

    it 'set errors' do
      expect(subject.errors).to eql []
    end
  end

  describe '.validate' do
    let(:name) { 'name' }
    let(:template) { described_class.new(name, required_params) }
    subject { template.validate }

    class User; end

    context 'when required_params format is valid' do
      [
        'String',
        'Integer',
        'Float',
        'User',
        { '$Optional': 'String' },
        { 'user': 'User' },
        { 'name': 'String' },
        { 'name': 'String', 'mode': { '$Optional': 'String' } },
        { 'name': 'String', 'toys': { '$Optional': [{ '$Optional': 'String' }] } }
      ].each do |example|
        context "when required_params is #{example}" do
          let(:required_params) { example }

          it 'returns true' do
            expect(subject).to be
            expect(template.errors).to be_empty
          end
        end
      end
    end

    context 'when required_params format is not valid' do
      [
        'string',
        '1',
        'NotExistClass',
        { 'name': 1 },
        { 'class': 'NotExistClass' },
        ['name']
      ].each do |example|
        context "when required_params is #{example}" do
          let(:required_params) { example }

          it 'returns false' do
            expect(subject).not_to be
            expect(template.errors).not_to be_empty
          end
        end
      end
    end
  end
end
