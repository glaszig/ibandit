require "spec_helper"

describe Ibandit::PseudoIBANAssembler do
  subject(:pseudo_iban) { described_class.new(local_details).assemble }

  context "for Sweden" do
    context "with valid parameters" do
      let(:local_details) do
        {
          country_code: "SE",
          branch_code: "1281",
          account_number: "0105723",
        }
      end

      it { is_expected.to eq("SEZZX1281XXX0105723") }
    end

    context "without a branch code" do
      let(:local_details) do
        {
          country_code: "SE",
          account_number: "0105723",
        }
      end

      it { is_expected.to be_nil }
    end

    context "without an account number" do
      let(:local_details) do
        {
          country_code: "SE",
          branch_code: "1281",
        }
      end

      it { is_expected.to be_nil }
    end
  end

  context "for Australia" do
    context "with valid parameters" do
      let(:local_details) do
        {
          country_code: "AU",
          branch_code: "123456",
          account_number: "A123456789",
        }
      end

      it { is_expected.to eq("AUZZ123456A123456789") }
    end

    context "with valid parameters and padding" do
      let(:local_details) do
        {
          country_code: "AU",
          branch_code: "123456",
          account_number: "XABC",
        }
      end

      it { is_expected.to eq("AUZZ123456______XABC") }
    end

    context "without a branch code" do
      let(:local_details) do
        {
          country_code: "AU",
          account_number: "123456789",
        }
      end

      it { is_expected.to be_nil }
    end

    context "without an account number" do
      let(:local_details) do
        {
          country_code: "AU",
          branch_code: "123456",
        }
      end

      it { is_expected.to be_nil }
    end
  end

  context "for a country that does not have pseudo-IBANs" do
    let(:local_details) do
      {
        country_code: "GB",
        bank_code: "WEST",
        branch_code: "123456",
        account_number: "98765432",
      }
    end

    it { is_expected.to be_nil }
  end
end
