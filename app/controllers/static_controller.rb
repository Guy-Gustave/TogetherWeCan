class StaticController < ApplicationController
  def home
    render json: { hapening: 'Gustave is working remotely with Ntaate' }
  end
end
