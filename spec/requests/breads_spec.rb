RSpec.describe "パン登録", type: :request do
  let(:user) { create(:user) }
  let!(:bread_type) { create(:bread_type) }

  before do
    sign_in user
  end

  it "入力した情報がカードに正しく表示される" do
    post breads_path, params: {
      bread: {
        bread_type_id: bread_type.id,
        total_count: 6,
        daily_consumption: 2,
        expiration_date: Time.zone.today + 3
      }
    }

    follow_redirect!

    expect(response.body).to include("6")
  end
end
