require "test_helper"

class PdfConverterControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get pdf_converter_index_url
    assert_response :success
  end

  test "should get convert" do
    get pdf_converter_convert_url
    assert_response :success
  end
end
