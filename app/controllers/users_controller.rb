# class UsersController < ApplicationController
#   before_action :set_user, only: [:show, :edit, :update, :destroy]
#
#   # GET /users
#   # GET /users.json
#   def index
#     @users = User.all
#   end
#
#   # GET /users/1
#   # GET /users/1.json
#   def show
#   end
#
#   # GET /users/new
#   def new
#     @user = User.new
#   end
#
#   # GET /users/1/edit
#   def edit
#   end
#
#   # POST /users
#   # POST /users.json
#   def create
#     @user = User.new(user_params)
#
#     respond_to do |format|
#       if @user.save
#         format.html { redirect_to @user, notice: 'User was successfully created.' }
#         format.json { render :show, status: :created, location: @user }
#       else
#         format.html { render :new }
#         format.json { render json: @user.errors, status: :unprocessable_entity }
#       end
#     end
#   end
#
#   # PATCH/PUT /users/1
#   # PATCH/PUT /users/1.json
#   def update
#     respond_to do |format|
#       if @user.update(user_params)
#         format.html { redirect_to @user, notice: 'User was successfully updated.' }
#         format.json { render :show, status: :ok, location: @user }
#       else
#         format.html { render :edit }
#         format.json { render json: @user.errors, status: :unprocessable_entity }
#       end
#     end
#   end
#
#   # DELETE /users/1
#   # DELETE /users/1.json
#   def destroy
#     @user.destroy
#     respond_to do |format|
#       format.html { redirect_to users_url, notice: 'User was successfully destroyed.' }
#       format.json { head :no_content }
#     end
#   end
#
#   private
#     # Use callbacks to share common setup or constraints between actions.
#     def set_user
#       @user = User.find(params[:id])
#     end
#
#     # Never trust parameters from the scary internet, only allow the white list through.
#     def user_params
#       params.require(:user).permit(:loginname, :password_digest, :auth_token, :isresponsible, :company_id, :phone, :hasline)
#     end
# end


class UsersController < ApplicationController
  before_action :set_user, only: [:show, :edit, :update, :destroy]

  # GET /users
  # GET /users.json
  def index
    if !current_user
        flash.notice="请先登录"
      redirect_to :root
      return
    end
    if !current_user.isresponsible
       flash.notice="不是企业负责人，无权限管理"
       redirect_to :root
       return
    end
    @users = User.where(:company_id => current_user.company_id).all
  end

  # GET /users/1
  # GET /users/1.json
  def show
  end

  # GET /users/new
  def new
    @user = User.new
  end

  # GET /users/1/edit
  def edit
  end

  # POST /users
  # POST /users.json
  def create
    @user = User.new(user_params)
    if current_user
      @user.company_id = current_user.company_id
    else
      @company = Company.new(:name=>'物流公司',:phone=>'123456')
      @company.save
      @user.company_id=@company.id
      @user.isresponsible = true
    end
    if @user.save
      if !current_user
       cookies[:auth_token] = @user.auth_token
      end
      redirect_to :root
    else
      render :new
    end
    # respond_to do |format|
    #   if @user.save
    #     format.html { redirect_to @user, notice: 'User was successfully created.' }
    #     format.json { render :show, status: :created, location: @user }
    #   else
    #     format.html { render :new }
    #     format.json { render json: @user.errors, status: :unprocessable_entity }
    #   end
    # end
  end

  def create_login_session
    user = User.find_by_loginname(params[:loginname])
    if user && user.authenticate(params[:password])
      # if params[:rememberme]
      cookies.permanent[:auth_token] =user.auth_token #持久化保存
      # else
      #   cookies[:auth_token] = user.auth_token #临时性保存 类似 session
      # end
      redirect_to :root
    else
      flash.notice = "用户名密码错误!"
      redirect_to :login
    end
  end

  def logout
    cookies.delete(:auth_token)
    redirect_to :login
  end

  # PATCH/PUT /users/1
  # PATCH/PUT /users/1.json
  def update
    respond_to do |format|
      if @user.update(user_params)
        format.html { redirect_to @user, notice: 'User was successfully updated.' }
        format.json { render :show, status: :ok, location: @user }
      else
        format.html { render :edit }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /users/1
  # DELETE /users/1.json
  def destroy
    @user.destroy
    respond_to do |format|
      format.html { redirect_to users_url, notice: 'User was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_user
    @user = User.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def user_params
    params.require(:user).permit(:loginname, :password, :auth_token, :isresponsible,:company_id, :phone,:hasline)
  end
end