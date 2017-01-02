require 'spec_helper'

module Myjson
  describe Bin do
    let(:bin) { Bin.new }
    let(:id) { 'fakeid' }

    describe '#show' do
      let(:response) { bin.show(id) }

      context 'when spam', vcr: { cassette_name: 'bin-show-200' } do
        it 'should return JSON' do
          expect(response).to eq(
            'hello' => 'world',
            'version' => 1,
            'active' => true,
            'tags' => %w(foo bar)
          )
        end
      end
    end

    describe '#create' do
      let(:response) { bin.create(data) }

      context 'when success', vcr: { cassette_name: 'bin-create-201' } do
        let(:data) do
          {
            hello: 'world',
            version: 1,
            active: true,
            tags: %w(foo bar)
          }
        end

        it 'should return JSON' do
          expect(response).to eq('uri' => 'https://api.myjson.com/bins/fakeid')
        end
      end
    end

    describe '#update' do
      let(:response) { bin.update(id, data) }

      context 'when success', vcr: { cassette_name: 'bin-update-200' } do
        let(:data) do
          {
            hello: 'world',
            version: 2,
            active: false,
            tags: %w(foo bar)
          }
        end

        it 'should return JSON' do
          expect(response).to eq(
            'hello' => 'world',
            'version' => 2,
            'active' => false,
            'tags' => %w(foo bar)
          )
        end
      end
    end
  end
end
