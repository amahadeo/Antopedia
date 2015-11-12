class WikisController < ApplicationController
  def index
    @wikis = Wiki.all
  end

  def new
    @wiki = Wiki.new
  end
  
  def create
    @wiki = current_user.wikis.build(wiki_params)
    
    if @wiki.save
      redirect_to @wiki, notice: "New wiki created!"
    else
      flash[:error] = "Sorry there was an error creating this wiki."
      render :new
    end
  end

  def edit
    @wiki = Wiki.find(params[:id])
  end

  def update
    @wiki = Wiki.find(params[:id])
    
    if @wiki.update_attributes(wiki_params)
      redirect_to @wiki, notice: "Thanks for contributing! Wiki updated."
    else
      flash[:error] = "Sorry, there was an error updating wiki."
      render :edit
    end
  end
  
  def show
    @wiki = Wiki.find(params[:id])
  end
  
  def destroy
    @wiki = Wiki.find(params[:id])
    
    if @wiki.destroy
      redirect_to wikis_path, notice: "Wiki has been deleted."
    else
      render :back, error: "Sorry, there was an error deleting that wiki."
    end
  end
  
  def wiki_params
    params.require(:wiki).permit(:title, :body)
  end
end
