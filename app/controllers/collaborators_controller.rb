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
      flash[:notice] = "#{@user.username} has been added as a collaborator"
      redirect_to wiki_collaborators_path(@wiki)
    else
      flash[:error] = "There was an error. Please try again."
      redirect_to wiki_collaborators_path(@wiki)
    end
  end
  
  def destroy
    @wiki = Wiki.find(params[:wiki_id])
    authorize @wiki, :collaborate?
    @user = User.find(params[:user_id])
    @collaborator = Collaborator.where(wiki: @wiki, user: @user).first
    
    if @collaborator.destroy
      flash[:alert] = "#{@user.username} has been removed as a collaborator"
      redirect_to wiki_collaborators_path(@wiki)
    else
      flash[:error] = "There was an error. Please try again."
      redirect_to wiki_collaborators_path(@wiki)
    end
  end
end
