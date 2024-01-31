class SessionsController < ApplicationController
  def new
  end

  def create
    user = User.find_by(email: params[:email])

    if user && User.authenticate_with_credentials(params[:email], params[:password])
      session[:user_id] = user.id
      redirect_to root_path, notice: 'Login successful!'
    else
      flash.now.alert = 'Invalid email or password'
      render 'new'
    end
  end

  def destroy
    session[:user_id] = nil
    redirect_to root_path, notice: 'Logged out successful!'
  end
end