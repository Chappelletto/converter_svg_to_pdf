RSpec.describe CreatePdfService do
  describe "#call" do
    subject(:convert_to_pdf) { described_class.new(file, "127.0.0.1").call }

    let(:file) { file_fixture("test.svg").open }

    it "converts svg to pdf" do
      expect(convert_to_pdf).to be_a(String)
    end

    context "when input file is not a svg" do
      let(:file) { file_fixture("test.txt").open }

      it "fails with error" do
        expect { convert_to_pdf }.to raise_error(Prawn::SVG::Document::InvalidSVGData)
      end
    end

    context "when input is not a file at all" do
      let(:file) { "" }

      it "fails with error" do
        expect { convert_to_pdf }
          .to raise_error(Prawn::SVG::Document::InvalidSVGData, "The data supplied is not a valid SVG document.")
      end
    end
  end
end
