# spec/controllers/home_controller_spec.rb

RSpec.describe HomeController, type: :controller do
  let(:user) { User.create(email_address: 'foo@bar.com', password: 'password') }

  describe "GET #index" do
    it "allows unauthenticated access" do
      get :index
      expect(response).to have_http_status(:ok) # Expecting 200 OK
    end
  end

  describe "GET #dashboard" do
    context "when user is authenticated" do
      it "renders the dashboard template" do
        login_as user

        get :dashboard
        expect(response).to render_template(:dashboard)
      end
    end

    context "when user is not authenticated" do
      it "redirects to the login page" do
        get :dashboard
        expect(response).to redirect_to(new_session_path) # Adjust path as needed
      end
    end
  end
end
