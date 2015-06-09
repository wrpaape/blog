class PostsControllerController < ApplicationController
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

  def new
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

  def create
    begin
      create_params = params.select{ |k,v| k == :title || k == :body }
      new_post = Post.create(create_params)
      respond_to do |f|
        f.html { render "create.html.erb", locals: { posts: new_post } }
        f.json { render json: new_post }
      end
      rescue ActiveRecord::RecordNotFound => error
        render json: error.message, status: 404
      rescue StandardError => error
        render json: error.message, status: 422
    end
  end

  def show
    begin
      post_inst = Post.new
      match_params = params.select{ |k,v| k == :title || k == :body || k == :created_at || k == :updated_at }
      matched_posts = post_inst.where(match_params)
      respond_to do |f|
        f.html { render "show.html.erb", locals: { posts: matched_posts } }
        f.json { render json: matched_posts }
      end
      rescue ActiveRecord::RecordNotFound => error
        render json: error.message, status: 404
      rescue StandardError => error
        render json: error.message, status: 422
    end
  end

  def update
    begin
      post = Post.find(params[:id])
      post.completed = params[:completed] if params[:completed]
      post.body = params[:body] if params[:body]
      post.save
      render_json(post, 200)
      rescue ActiveRecord::RecordNotFound => error
        render json: error.message, status: 404
      rescue StandardError => error
        render json: error.message, status: 422
    end
  end

  def destroy
    begin
      post = Post.find(params[:id])
      response = post
      post.destroy
      response_code = "200"
      respond_to do |f|
        f.html { render_html("destroy.html.erb", response, response_code) }
        f.json { render_json(response, response_code) }
      end
      rescue ActiveRecord::RecordNotFound => error
        render json: error.message, status: 404
      rescue StandardError => error
        render json: error.message, status: 422
    end
  end

end


