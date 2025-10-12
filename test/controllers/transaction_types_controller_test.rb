require "test_helper"

class TransactionTypesControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get transaction_types_index_url
    assert_response :success
  end
end
