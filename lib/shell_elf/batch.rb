module ShellElf
  class Batch
    class <<self
      def execute(params)
        new(params).execute
      end
    end

    def initialize(params)
      options = params[:options] || {}
      @commands = 
        if params[:command]
          [params[:command]]
        elsif params[:commands]
          params[:commands]
        else
          []
        end
      @success_postback = options.delete(:success)
      @failure_postback = options.delete(:failure)
    end

    def execute
      return self if @commands.empty?
      if @commands.all? { |command| Job.execute(command).success? }
        if @success_postback
          ShellElf.logger.debug("Posting back to #{@success_postback}")
          Net::HTTP.post_form(URI.parse(@success_postback), {})
        else
          ShellElf.logger.debug("No success postback given")
        end
      elsif @failure_postback
        ShellElf.logger.debug("Posting back to #{@failure_postback}")
        Net::HTTP.post_form(URI.parse(@failure_postback), {})
      else
        ShellElf.logger.debug("No failure postback given")
      end
      self
    end
  end
end
