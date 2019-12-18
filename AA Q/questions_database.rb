require "Singleton"
require "SQLite3"
class QuestionsDatabase < SQLite3::Database 
    include Singleton

    def initialize
        super('questions.db')
        self.results_as_hash = true
        self.type_translation = true
    end
end

#-------------------------------------------------------

class Users
    attr_accessor :id, :full_name
    def initialize(options)
        @id = options['id']
        @full_name = options['full_name']
    end

    def self.all 
        user_data = QuestionsDatabase.instance.execute("SELECT * FROM users")
        user_data.map {|row| Users.new(row)}
    end

    def self.find_by_name(full_name)
        user = QuestionsDatabase.instance.execute(<<-SQL, full_name)
        SELECT
            *
        FROM
            users
        WHERE
            full_name = ?
        SQL
        
        return nil unless user.length > 0
        Users.new(user.first)
    end
    
    def self.find_by_id(id)
        user = QuestionsDatabase.instance.execute(<<-SQL, id)
        SELECT
            *
        FROM
            users
        WHERE
            id = ?
        SQL
        return nil unless user.length > 0
        Users.new(user.first)
    end

    def create
        raise "#{self} already exists" if @id
        QuestionsDatabase.instance.execute(<<--SQL, @full_name)
            INSERT INTO
                users(full_name)
            VALUES
                (?)
        SQL
         @id = QuestionsDatabase.instance.execute.last_insert_row_id
    end

    def update
        raise "#{self} not in DB" if @id
        QuestionsDatabase.instance.execute(<<--SQL, @id, @full_name)
            UPDATE
                users
            SET 
                id = ?, full_name = ?
            WHERE
            id = ?
        SQL
    end
end

#-------------------------------------------------------

class Questions
    attr_accessor :id, :title, :body, :associated_author_id
    def initialize(options)
        @id = options['id']
        @title = options['title']
        @body = options['body']
        @associated_author_id = options['associated_author_id']
    end

    def self.all 
        question_data = QuestionsDatabase.instance.execute("SELECT * FROM questions")
        question_data.map {|row| Questions.new(row)}
    end

    def self.find_by_title(title)
        question = QuestionsDatabase.instance.execute(<<-SQL, title)
        SELECT
            *
        FROM
            questions
        WHERE
            title = ?
        SQL
        
        return nil unless question.length > 0
        Questions.new(question.first)
    end
    
    def self.find_by_id(id)
        question = QuestionsDatabase.instance.execute(<<-SQL, id)
        SELECT
            *
        FROM
            questions
        WHERE
            id = ?
        SQL
        return nil unless question.length > 0
        Questions.new(question.first)
    end

    def create
        raise "#{self} already exists" if @id
        QuestionsDatabase.instance.execute(<<--SQL, @title, @body, @associated_author_id)
            INSERT INTO
                questions(title, body, associated_author_id)
            VALUES
                (?, ?, ?)
        SQL
         @id = QuestionsDatabase.instance.execute.last_insert_row_id
    end

    def update
        raise "#{self} not in DB" if @id
        QuestionsDatabase.instance.execute(<<--SQL, @id, @title, @body, @associated_author_id)
            UPDATE
                questions
            SET 
                id = ?, title = ?, body = ?, associated_author_id = ?
            WHERE
            id = ?
        SQL
    end
end

#-------------------------------------------------------

class QuestionFollows
    attr_accessor :id, :question_id :follower_id
    def initialize(options)
        @id = options['id']
        @question_id = options['question_id']
        @follower_id = options['follower_id']
    end

    def self.all 
        follow_data = QuestionsDatabase.instance.execute("SELECT * FROM question_follows")
        follow_data.map {|row| QuestionFollows.new(row)}
    end

    def self.find_by_follower_id(follower_id)
        follower = QuestionsDatabase.instance.execute(<<-SQL, follower_id)
        SELECT
            *
        FROM
            question_follows
        WHERE
            follower_id = ?
        SQL
        
        return nil unless follower.length > 0
        QuestionFollows.new(follower.first)
    end

    def self.find_by_question_id(question_id)
        question = QuestionsDatabase.instance.execute(<<-SQL, question_id)
        SELECT
            *
        FROM
            question_follows
        WHERE
            question_id = ?
        SQL
        
        return nil unless question.length > 0
        QuestionFollows.new(question.first)
    end
    
    def self.find_by_id(id)
        follows = QuestionsDatabase.instance.execute(<<-SQL, id)
        SELECT
            *
        FROM
            question_follows
        WHERE
            id = ?
        SQL
        return nil unless follows.length > 0
        QuestionFollows.new(follows.first)
    end

    def create
        raise "#{self} already exists" if @id
        QuestionsDatabase.instance.execute(<<--SQL, @question_id, @follower_id)
            INSERT INTO
                question_follows(question_id, follower_id)
            VALUES
                (?, ?)
        SQL
         @id = QuestionsDatabase.instance.execute.last_insert_row_id
    end

    def update
        raise "#{self} not in DB" if @id
        QuestionsDatabase.instance.execute(<<--SQL, @id, @question_id, @follower_id)
            UPDATE
                question_follows\
            SET 
                id = ?, question_id = ?, follower_id = ?
            WHERE
            id = ?
        SQL
    end
end

#-------------------------------------------------------

class Replies
    attr_accessor :id, :question_id :writer, :body, :parent_reply
    def initialize(options)
        @id = options['id']
        @question_id = options['question_id']
        @writer = options['writer']
        @body = options['body']
        @parent_reply = options['parent_reply']
    end

    def self.all 
        reply_data = QuestionsDatabase.instance.execute("SELECT * FROM replies")
        reply_data.map {|row| replies.new(row)}
    end

    def self.find_by_writer(writer)
        writer = QuestionsDatabase.instance.execute(<<-SQL, writer)
        SELECT
            *
        FROM
            replies
        WHERE
            writer = ?
        SQL
        
        return nil unless writer.length > 0
        Replies.new(writer.first)
    end

    def self.find_by_reply_id(reply_id)
        reply = QuestionsDatabase.instance.execute(<<-SQL, reply_id)
        SELECT
            *
        FROM
            replies
        WHERE
            reply_id = ?
        SQL
        
        return nil unless r.length > 0
        QuestionFollows.new(r.first)
    end
    
    def self.find_by_id(id)
        reply = QuestionsDatabase.instance.execute(<<-SQL, id)
        SELECT
            *
        FROM
           replies
        WHERE
            id = ?
        SQL
        return nil unless reply.length > 0
        Replies.new(reply.first)
    end

    def self.find_by_parent_reply(parent_reply)
        parent = QuestionsDatabase.instance.execute(<<-SQL, parent_reply)
        SELECT
            *
        FROM
           replies
        WHERE
           parent_reply = ?
        SQL
        return nil unless parent.length > 0
        Replies.new(parent.first)
    end

    

    def create
        raise "#{self} already exists" if @id
        QuestionsDatabase.instance.execute(<<--SQL, @question_id, @writer, @body, @parent_reply)
            INSERT INTO
                replies(question_id, writer, body, parent_reply)
            VALUES
                (?, ?, ?, ?)
        SQL
         @id = QuestionsDatabase.instance.execute.last_insert_row_id
    end

    def update
        raise "#{self} not in DB" if @id
        QuestionsDatabase.instance.execute(<<--SQL, @id, @question_id @writer, @body, @parent_reply)
            UPDATE
                replies
            SET 
                id = ?, question_id = ?, writer = ?, body = ?, parent_reply = ?
            WHERE
            id = ?
        SQL
    end
end

#-------------------------------------------------------
    
class QuestionLikes
    attr_accessor :id, :question_id :follower_id
    def initialize(options)
        @id = options['id']
        @question_id = options['question_id']
        @user_id = options['follower_id']
    end

    def self.all 
        like_data = QuestionsDatabase.instance.execute("SELECT * FROM question_follows")
        like_data.map {|row| QuestionLikes.new(row)}
    end

    def self.find_by_user_id(user_id)
        user = QuestionsDatabase.instance.execute(<<-SQL, user_id)
        SELECT
            *
        FROM
            question_likes
        WHERE
            user_id = ?
        SQL
        
        return nil unless user.length > 0
        QuestionLikes.new(user.first)
    end

    def self.find_by_question_id(question_id)
        question = QuestionsDatabase.instance.execute(<<-SQL, question_id)
        SELECT
            *
        FROM
            question_likes
        WHERE
            question_id = ?
        SQL
        
        return nil unless question.length > 0
        QuestionLikes.new(question.first)
    end
    
    def self.find_by_id(id)
        likes = QuestionsDatabase.instance.execute(<<-SQL, id)
        SELECT
            *
        FROM
            question_likes
        WHERE
            id = ?
        SQL
        return nil unless likes.length > 0
        Questionlikes.new(likes.first)
    end

    def create
        raise "#{self} already exists" if @id
        QuestionsDatabase.instance.execute(<<--SQL, @question_id, @user_id)
            INSERT INTO
                question_likes(question_id, user_id)
            VALUES
                (?, ?)
        SQL
            @id = QuestionsDatabase.instance.execute.last_insert_row_id
    end

    def update
        raise "#{self} not in DB" if @id
        QuestionsDatabase.instance.execute(<<--SQL, @id, @question_id, @user_id)
            UPDATE
                question_likes
            SET 
                id = ?, question_id = ?, user_id = ?
            WHERE
            id = ?
        SQL
    end
end     
