class Copy
    attr_accessor :title, :description, :image, :keywords

    def initialize
        @title = 'Libris Adepti'
        @description = 'An archive of media relating to the esoteric and occult.'
        @image = '/img/embed_image.png'
        @keywords = %w(libris adepti occult esoteric library archive)
    end

    def but(title: nil, description: nil, image: nil, keywords: nil)
        copy = dup
        copy.title = title unless title.nil?
        copy.description = description unless description.nil?
        copy.image = image unless image.nil?
        copy.keywords = keywords unless keywords.nil?
        return copy
    end
end

$default_copy = Copy.new