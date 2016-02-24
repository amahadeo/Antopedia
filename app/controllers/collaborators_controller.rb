class CollaboratorsController < ApplicationController
  def index
    @wiki = Wiki.find(params[:wiki_id])
    authorize @wiki, :collaborate?
    @collaborators = @wiki.users
    @users = User.all
  end
  
  def create
    @wiki = Wiki.find(params[:wiki_id])
    authorize @wiki, :collaborate?
    @user = User.find(params[:user_id])
    @collaborator = Collaborator.new(wiki: @wiki, user: @user)
    
    if @collaborator.save
      flash[:notice] = "Thank you for adding collaborators!"
    else
      flash[:error] = "There was an error. Please try again."
    end
    
    respond_to do |format|
      format.html
      format.js
    end
  end
  
  def destroy
    @wiki = Wiki.find(params[:wiki_id])
    authorize @wiki, :collaborate?
    @user = User.find(params[:user_id])
    @collaborator = Collaborator.where(wiki: @wiki, user: @user).first
    
    if @collaborator.destroy
      flash[:alert] = "Collaborators have been removed."
    else
      flash[:error] = "There was an error. Please try again."
    end
    
    respond_to do |format|
      format.html
      format.js
    end
  end
end
