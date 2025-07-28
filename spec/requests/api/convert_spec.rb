RSpec.describe "/api/create", type: :request do
  describe "POST /" do
    subject(:create_response) do
      post "/api/create", headers: request_headers, params: request_body
      response
    end

    let(:request_body) { {svg_file: fixture_file_upload("test.svg", "image/svg+xml")} }
    let(:request_headers) { {"CONTENT_TYPE" => "image/svg+xml"} }

    it "success create" do
      expect(create_response).to have_http_status(200)
    end

    context "when no file in request" do
      let(:request_body) { {} }
      it "fail create" do
        create_response # выполняет запрос
        expect(JSON.parse(create_response.body, symbolize_names: true)).to eq({error: "SVG файл не предоставлен"})
      end
    end

    context "when file is too big" do
      it "return error"
    end

    context "when file is not svg" do
      let(:request_body) { {svg_file: fixture_file_upload("test.txt")} }
      it "return error"
    end
  end
end
