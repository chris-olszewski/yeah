describe Game do
  subject { Class.new(described_class) }

  describe '::resolution' do
    include_examples :reader, :resolution

    its(:resolution) { should be_nil }
  end

  describe '::resolution=' do
    include_examples :writer, :resolution=
  end
end