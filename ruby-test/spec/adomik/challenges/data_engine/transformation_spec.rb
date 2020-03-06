# frozen_string_literal: true

require 'spec_helper'
require 'adomik/challenges/data_engine/transformation'
require 'adomik/challenges/data_engine/transformation_template'

describe Adomik::Challenges::DataEngine::Transformation do
  describe '.initialize' do
    let(:transformation_template) { 'transformation_template' }
    let(:rank) { 'rank' }
    let(:params) { 'params' }

    subject { described_class.new(transformation_template, rank, params) }

    it 'set transformation_template' do
      expect(subject.transformation_template).to eql transformation_template
    end

    it 'set rank' do
      expect(subject.rank).to eql rank
    end

    it 'set params' do
      expect(subject.params).to eql params
    end

    it 'set errors' do
      expect(subject.errors).to eql []
    end
  end

  describe '.validate' do
    let(:name) { 'name' }
    let(:template) { Adomik::Challenges::DataEngine::TransformationTemplate.new(name, required_params) }
    let(:rank) { 1 }
    let(:required_params) { { 'name': 'String', 'age': 'Integer' } }
    let(:params) { { 'name': 'name', 'age': 1 } }
    let(:transformation) { described_class.new(template, rank, params) }

    subject { transformation.validate }

    class User; end

    context 'when template is not valid' do
      let(:required_params) { 1 }
      let(:params) { 1 }

      it 'returns false' do
        expect(template.validate).not_to be
        expect(subject).not_to be
        expect(transformation.errors).not_to be_empty
      end
    end

    context 'when params does not match to required_params' do
      let(:required_params) { 'String' }
      let(:params) { 1 }

      it 'returns false' do
        expect(template.validate).to be
        expect(subject).not_to be
        expect(transformation.errors).not_to be_empty
      end
    end

    context 'when rank is not an integer' do
      let(:rank) { 1.0 }

      it 'returns false' do
        expect(subject).not_to be
        expect(transformation.errors).not_to be_empty
      end
    end

    context 'when rank is negative' do
      let(:rank) { -1 }

      it 'returns false' do
        expect(subject).not_to be
        expect(transformation.errors).not_to be_empty
      end
    end

    context 'when params does match to required_params' do
      it 'returns true' do
        expect(subject).to be
        expect(transformation.errors).to be_empty
      end
    end
  end
end
