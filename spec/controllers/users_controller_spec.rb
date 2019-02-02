require 'rails_helper'

RSpec.describe UsersController, type: :controller do
  subject(:user){User.create(username: "test", password: "password")}

  describe "new" do
    it "renders the links page" do
      get :new
      expect(response).to render_template(:new)
      expect(response).to have_http_status(200)
    end
  end

  describe "create" do
    context "with valid params" do
      it "creates a user" do
        post :create, params: {user: {username: "steve", password: "password"}}
        expect(response).to redirect_to(user_url(User.last))
      end
    end
    context "with invalid params" do
      it "render errors" do
        post :create, params: {user: {username: "steve", password: "pass"}}
        expect(flash.now[:errors]).to be_present
        expect(response).to render_template(:new)
      end
    end
  end

  describe "show" do
    it "displays the users page" do
      get :show, params: {id: user.id}
      expect(response).to render_template(:show)
    end
  end

  describe "edit" do
    it "renders the edit page" do 
      get :edit, params: {id: user.id}
      expect(response).to render_template(:edit)
    end
  end

  describe "update" do 
    context "with valid params" do 
      it "edits a user" do
        patch :update, params: {id: user.id, user: {username: user.username, password: user.password}}
        expect(response).to redirect_to(user_url(user.id))
      end
    end
    
    context "without valid params" do
      it "renders errors" do
        patch :update, params: {id: user.id, user: {username: "update", password: "pass"}}
        expect(flash.now[:errors]).to be_present
        expect(response).to render_template(:edit)
      end
    end
  end

  describe "destroy" do
    it "annihilates a user" do
      delete :destroy, params: {id: user.id}
      expect(User.find_by(id: user.id)).to be nil
    end
  end

  describe "index" do
    it "shows all the index" do
      get :index
      expect(response).to render_template(:index)
    end
  end
end
