class Post < ApplicationRecord

  
  attribute :tag, :string
  after_create :create_tag
  after_update :update_tag
  has_one_attached :image

  belongs_to :user
  has_many :favorites, dependent: :destroy
  has_many :comments, dependent: :destroy
  #tag機能のアソシエーション
  has_many :post_tags,dependent: :destroy
  has_many :tags,through: :post_tags
  
  def favorited?(user)
   favorites.where(user_id: user.id).exists?
  end
  
  def get_image(width, height)
    unless image.attached?
      file_path = Rails.root.join('app/assets/images/no_image.jpg')
      image.attach(io: File.open(file_path), filename: 'default-image.jpg', content_type: 'image/jpeg')
    end
    image.variant(resize_to_limit: [width, height]).processed
  end
  
  
  #検索機能（完全一致、部分一致、前方一致、後方一致）
  def self.looks(search, word)
    if search == "perfect_match"
      @post = Post.where("title LIKE?","#{word}")
    elsif search == "forward_match"
      @post = Post.where("title LIKE?","#{word}%")
    elsif search == "backward_match"
      @post = Post.where("title LIKE?","%#{word}")
    elsif search == "partial_match"
      @post = Post.where("title LIKE?","%#{word}%")
    else
      @post = Post.all
    end
  end
  
  def create_tag
    tag_names = self.tag.gsub(/[[:blank:]]/, '').split(",").compact
    tag_names.each do |name|
      tag = Tag.find_or_create_by(name: name)
      self.post_tags.find_or_create_by(tag_id: tag.id)
    end
  end
  
  def set_tag
    self.tag = self.tags.pluck(:name).join(",")
  end
  
  def update_tag
    if self.tag
      sent_tags = self.tag.gsub(/[[:blank:]]/, '').split(",").compact
    # タグが存在していれば、タグの名前を配列として全て取得
      current_tags = self.tags.pluck(:name)
      # 現在取得したタグから送られてきたタグを除いてoldtagとする
      old_tags = current_tags - sent_tags
      # 送信されてきたタグから現在存在するタグを除いたタグをnewとする
      new_tags = sent_tags - current_tags
  
      # 古いタグを消す
      old_tags = Tag.where(name: old_tags).joins(:post_tags).distinct
      old_tags.each do |tag|
        t = tag.post_tags
        if t.size <= 1
          tag.destroy
        else
         # byebug
          t.find_by(post_id: self.id).destroy
        end
      end
  
      # 新しいタグを保存
      new_tags.each do |name|
        tag = Tag.find_or_create_by(name: name)
        self.post_tags.find_or_create_by(tag_id: tag.id)
      end
    end
  end
end
