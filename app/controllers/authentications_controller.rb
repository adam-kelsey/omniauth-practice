class AuthenticationsController < ApplicationController
  skip_before_action :authenticate_user!, only: [:create, :new]
  before_action :set_authentication, only: [:show, :edit, :update, :destroy]

  # GET /authentications
  # GET /authentications.json
  def index
    @authentications = current_user.authentications
  end

  # GET /authentications/1
  # GET /authentications/1.json
  def show
  end

  # GET /authentications/new
  def new
    @authentication = Authentication.new
  end

  # GET /authentications/1/edit
  def edit
  end

  # POST /authentications
  # POST /authentications.json
  def create
    auth = request.env["omniauth.auth"]
    if a = User.create_with_omniauth(auth)
      a.authentications.create(provider: auth['provider'], uid: auth['uid'])
      sign_in(:user, a)
      flash[:notice] = 'Authentication Successful'
      redirect_to authentications_url
    end
  end

  # PATCH/PUT /authentications/1
  # PATCH/PUT /authentications/1.json
  def update
    respond_to do |format|
      if @authentication.update(authentication_params)
        format.html { redirect_to @authentication, notice: 'Authentication was successfully updated.' }
        format.json { render :show, status: :ok, location: @authentication }
      else
        format.html { render :edit }
        format.json { render json: @authentication.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /authentications/1
  # DELETE /authentications/1.json
  def destroy
    @authentication = current_user.authentications.find params[:id]
    @authentication.destroy
    respond_to do |format|
      format.html { redirect_to authentications_url, notice: 'Authentication was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_authentication
      @authentication = Authentication.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def authentication_params
      params.require(:authentication).permit(:user_id, :provider, :uid)
    end
end
