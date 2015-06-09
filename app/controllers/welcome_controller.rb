class WelcomeController < ApplicationController
def index
    begin
      all_posts = Post.all
      respond_to do |f|
        f.html { render "index.html.erb", locals: { posts: all_posts } }
        f.json { render json: all_posts }
      end
      rescue ActiveRecord::RecordNotFound => error
        render json: error.message, status: 404
      rescue StandardError => error
        render json: error.message, status: 422
    end
  end

  def about
    begin
      new_post = Post.create
      respond_to do |f|
        f.html { render "new.html.erb", locals: { posts: new_post } }
        f.json { render json: new_post }
      end
      rescue ActiveRecord::RecordNotFound => error
        render json: error.message, status: 404
      rescue StandardError => error
        render json: error.message, status: 422
    end
  end
end
