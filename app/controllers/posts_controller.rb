class PostsController < ApplicationController
  def index
    begin
      respond_to do |f|
        f.html { render "index.html.erb", locals: { posts: Post.all.order(created_at: :desc), post_inst: Post.new } }
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
      Post.create(post_params)
      respond_to do |f|
        f.html { redirect_to posts_path }
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
      updated_post = Post.find(params[:id])
      updated_post.title = params[:title] if params[:title]
      updated_post.body = params[:body] if params[:body]
      updated_post.save
      respond_to do |f|
        f.html { render "update.html.erb", locals: { posts: updated_post } }
        f.json { render json: updated_post}
      end
      rescue ActiveRecord::RecordNotFound => error
        render json: error.message, status: 404
      rescue StandardError => error
        render json: error.message, status: 422
    end
  end

  def destroy
    begin
      post = Post.find(params[:id])
      destroyed_post = post
      post.destroy
      respond_to do |f|
        f.html { render "destroy.html.erb", locals: { posts: destroyed_post } }
        f.json { render json: destroyed_post}
      end
      rescue ActiveRecord::RecordNotFound => error
        render json: error.message, status: 404
      rescue StandardError => error
        render json: error.message, status: 422
    end
  end

  private

  def post_params
    params.require(:post).permit(:title, :body)
  end
end
