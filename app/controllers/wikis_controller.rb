class WikisController < ApplicationController
  def index
    wikis = policy_scope(Wiki)
    @privatewikis = wikis.select {|w| w.private }
    publicwikis = wikis.select {|w| w.public? }
    #preferential to solve with active record relations/queries, but following suit with policy scope
    @publicwikis = publicwikis.paginate(:page => params[:page], :per_page => 12)
    #paginating public wikis only, under the premise that most users will have few private and many public wikis
  end

  def new
    @wiki = Wiki.new
    authorize @wiki
  end
  
  def create
    @wiki = current_user.wikis.build(wiki_params)
    authorize @wiki
    
    if @wiki.save
      redirect_to @wiki, notice: "New wiki created!"
    else
      flash[:error] = "Sorry there was an error creating this wiki."
      render :new
    end
  end

  def edit
    @wiki = Wiki.find(params[:id])
    authorize @wiki
  end

  def update
    @wiki = Wiki.find(params[:id])
    authorize @wiki
    
    if @wiki.update_attributes(wiki_params)
      if @wiki.private
        Collaborator.where(wiki: @wiki, user: current_user).first_or_create
        # Creates automatic collaborator for user that changes public wiki into private wiki (if doesn't exist already)
      end
      redirect_to @wiki, notice: "Thanks for contributing! Wiki updated."
    else
      flash[:error] = "Sorry, there was an error updating wiki."
      render :edit
    end
  end
  
  def show
    @wiki = Wiki.find(params[:id])
    authorize @wiki
  end
  
  def destroy
    @wiki = Wiki.find(params[:id])
    authorize @wiki
    
    if @wiki.destroy
      redirect_to wikis_path, notice: "Wiki has been deleted."
    else
      render :back, error: "Sorry, there was an error deleting that wiki."
    end
  end
  
  def wiki_params
    params.require(:wiki).permit(:title, :body, :private)
  end
end
