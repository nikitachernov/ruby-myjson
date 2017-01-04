require 'spec_helper'
require 'myjson/resource'

class OtherKlass
end

class FakeKlass
  include Myjson::Resource

  myjson_attribute :name, String
  myjson_attribute :age, Integer
  myjson_attribute :interests, Array
end

describe FakeKlass do
  let(:id) { 'fakeid' }
  let(:data) { { name: 'Jhon', age: 28, interests: %w(foo bar) } }
  let(:bin) { double }

  before do
    allow(Myjson::Bin).to receive(:new) { bin }
    allow(bin).to receive(:show).with(id) { data }
  end

  describe '::myjson_attribute' do
    let(:fake_instance) { FakeKlass.new }

    it 'should set attribute reader' do
      expect(fake_instance).to responding_to(:name)
    end

    it 'should set attribute writter' do
      expect(fake_instance).to responding_to(:name=)
    end

    it 'should cast value' do
      fake_instance.age = '33'
      expect(fake_instance.age).to eq(33)
    end
  end

  describe '::find' do
    let(:fake_instance) { FakeKlass.find(id) }

    context 'when success' do
      it 'should create an instance with data' do
        expect(fake_instance.attributes).to eq(
          name: 'Jhon', age: 28, interests: %w(foo bar)
        )
      end
    end

    context 'when fail' do
      before { allow(bin).to receive(:show).with(id) { nil } }

      it 'should return nil' do
        expect(fake_instance).to be_nil
      end
    end
  end

  describe '#id' do
    let(:fake_instance) { FakeKlass.new }

    it 'should have id' do
      expect(fake_instance).to responding_to(:id)
    end
  end

  describe '#save' do
    let(:fake_instance) { FakeKlass.new }

    before do
      fake_instance.name = 'Jhon'
      fake_instance.age = 28
      fake_instance.interests = %w(foo bar)

      allow(bin).to receive(:create).with(data) do
        { 'uri' => 'https://api.myjson.com/bins/fakeid' }
      end
    end

    it 'should not have id' do
      expect(fake_instance.id).to be_nil
    end

    it 'should call save API' do
      expect(bin).to receive(:create).with(
        name: 'Jhon', age: 28, interests: %w(foo bar)
      )

      fake_instance.save
    end

    it 'should set ID' do
      fake_instance.save
      expect(fake_instance.id).to eq('fakeid')
    end

    it 'should return true' do
      expect(fake_instance.save).to eq true
    end
  end

  describe '#update' do
    let(:fake_instance) { FakeKlass.find(id) }

    let(:updated_data) do
      { name: 'Sam', age: 33, interests: %w(foo bar buzz) }
    end

    before do
      fake_instance.name = 'Sam'
      fake_instance.age = 33
      fake_instance.interests.push('buzz')
    end

    context 'when success' do
      before do
        allow(bin).to receive(:update).with(id, updated_data) { updated_data }
      end

      it 'should call save API' do
        expect(bin).to receive(:update).with(
          'fakeid', name: 'Sam', age: 33, interests: %w(foo bar buzz)
        )

        fake_instance.save
      end

      it 'should return true' do
        expect(fake_instance.save).to eq true
      end
    end

    context 'when fail' do
      before { allow(bin).to receive(:update).with(id, updated_data) { nil } }

      it 'should return false' do
        expect(fake_instance.save).to eq false
      end
    end
  end
end

describe OtherKlass do
  it 'class should not affected by Myjson::Resource' do
    expect(OtherKlass).not_to responding_to(:myjson_attributes)
  end

  it 'instance should not affected by Myjson::Resource' do
    other_intance = OtherKlass.new
    expect(other_intance).not_to responding_to(:id)
  end
end
