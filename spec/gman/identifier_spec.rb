# frozen_string_literal: true

RSpec.describe 'Gman identifier' do
  let(:domain) { '' }
  subject { Gman.new(domain) }

  it 'parses the dotgov list' do
    expect(Gman.dotgov_list).to be_a(CSV::Table)
    expect(Gman.dotgov_list.first).to have_key('Domain Name')
  end

  context 'locality domains' do
    context 'a state domain' do
      let(:domain) { 'state.ak.us' }

      it "knows it's a state" do
        expect(subject).to be_a_state
        expect(subject.type).to eql(:state)
      end

      it 'knows the state' do
        expect(subject.state).to eql('AK')
      end

      it "knows it's not a dotgov" do
        expect(subject).to_not be_a_dotgov
      end

      it "know's it's not a city" do
        expect(subject).to_not be_a_city
      end

      it "know's it's not a county" do
        expect(subject).to_not be_a_county
      end
    end

    context 'a city domain' do
      let(:domain) { 'ci.champaign.il.us' }

      it "knows it's a city" do
        expect(subject).to be_a_city
        expect(subject.type).to eql(:city)
      end

      it 'knows the state' do
        expect(subject.state).to eql('IL')
      end

      it "knows it's not a dotgov" do
        expect(subject).to_not be_a_dotgov
      end

      it "know's it's not a state" do
        expect(subject).to_not be_a_state
      end

      it "know's it's not a county" do
        expect(subject).to_not be_a_county
      end
    end

    context 'dotgovs' do
      context 'A federal dotgov' do
        let(:domain) { 'whitehouse.gov' }

        it "knows it's federal" do
          expect(subject).to be_federal
          expect(subject.type).to eql(:federal)
        end

        it "knows it's a dotgov" do
          expect(subject).to be_a_dotgov
        end

        it "knows it's not a city" do
          expect(subject).to_not be_a_city
        end

        it "knows it's not a state" do
          expect(subject).to_not be_a_state
        end

        it "knows it's not a county" do
          expect(subject).to_not be_a_county
        end

        it 'knows the state' do
          expect(subject.state).to eql('DC')
        end

        it 'knows the city' do
          expect(subject.city).to eql('Washington')
        end

        it 'knows the agency' do
          expect(subject.agency).to eql('Executive Office of the President')
        end
      end

      context 'a state .gov' do
        let(:domain) { 'illinois.gov' }

        it "knows it's a state" do
          expect(subject).to be_a_state
          expect(subject.type).to eql(:state)
        end

        it "knows it's a dotgov" do
          expect(subject).to be_a_dotgov
        end

        it "knows it's not a city" do
          expect(subject).to_not be_a_city
        end

        it "knows it's not federal" do
          expect(subject).to_not be_federal
        end

        it "knows it's not a county" do
          expect(subject).to_not be_a_county
        end

        it 'knows the state' do
          expect(subject.state).to eql('IL')
        end

        it 'knows the city' do
          expect(subject.city).to eql('Springfield')
        end
      end

      context 'a county .gov' do
        let(:domain) { 'ALLEGHENYCOUNTYPA.GOV' }

        it "knows it's a county" do
          expect(subject).to be_a_county
          expect(subject.type).to eql(:county)
        end

        it "knows it's a dotgov" do
          expect(subject).to be_a_dotgov
        end

        it "knows it's not a city" do
          expect(subject).to_not be_a_city
        end

        it "knows it's not federal" do
          expect(subject).to_not be_federal
        end

        it "knows it's not a state" do
          expect(subject).to_not be_a_state
        end

        it 'knows the state' do
          expect(subject.state).to eql('PA')
        end

        it 'knows the city' do
          expect(subject.city).to eql('Pittsburgh')
        end
      end
    end
  end

  context "determining a domain's type" do
    {
      unknown:            'cityofperu.org',
      "Canada municipal": 'acme.ca',
      "Canada federal":   'canada.ca'
    }.each do |expected, domain|
      context "Given the #{domain} domain" do
        let(:domain) { domain }

        it "know's the domain's type" do
          expect(subject.type).to eql(expected)
        end
      end
    end
  end
end
