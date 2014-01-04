describe Vector, '#==' do
  let(:components) { [1, 3, 5].shuffle }
  subject { described_class.new(components) }

  it { (subject == described_class[*subject.components]).should eq true }
  it { (subject == described_class[*subject.components.reverse]).should eq false }
  it { (subject == nil).should eq false }
end