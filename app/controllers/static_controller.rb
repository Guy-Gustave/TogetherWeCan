class StaticController < ApplicationController
  def home
    render json: { thunder: 'This is a project for TONTON done by Gustave and Roy' }
  end
end
