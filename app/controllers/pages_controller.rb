class PagesController < ApplicationController
  # GET /pages
  # GET /pages.json
  def index
    @pages = Page.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @pages }
    end
  end

  # GET /pages/1
  # GET /pages/1.json
  def show
    @page = Page.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @page }
    end
  end

  # GET /pages/new
  # GET /pages/new.json
  def new
    @page = Page.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @page }
    end
  end

  # GET /pages/1/edit
  def edit
    @page = Page.find(params[:id])
  end

  # POST /pages
  # POST /pages.json
  def create
    @page = Page.new(params[:page])

    respond_to do |format|
      if @page.save
        format.html { redirect_to @page, notice: 'Page was successfully created.' }
        format.json { render json: @page, status: :created, location: @page }
      else
        format.html { render action: "new" }
        format.json { render json: @page.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /pages/1
  # PUT /pages/1.json
  def update
    @page = Page.find(params[:id])

    respond_to do |format|
      if @page.update_attributes(params[:page])
        format.html { redirect_to @page, notice: 'Page was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @page.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /pages/1
  # DELETE /pages/1.json
  def destroy
    @page = Page.find(params[:id])
    @page.destroy

    respond_to do |format|
      format.html { redirect_to pages_url }
      format.json { head :no_content }
    end
  end
  
  def go_get_mp3
    @page = Page.find(params[:page_id])
    text = "Alternatives to bank accounts. Banks aren't the only organizations where you can keep your money. You can also open an account with a building society or credit union. These are organisations like banks, but with some important differences. What is a building society? Building societies are similar to banks. The most important difference is that they are owned by the customers. This means that if you open an account you will get to have a say on things like how much interest people are charged on an overdraft. Building societies offer similar services to banks, like basic and current accounts. They also have a focus on mortgages and saving. If these services are important to you, you can find out more about them on the Building Society Association's website: http://www.bsa.org.uk/ What is a credit union? A credit union is also similar to a bank but is usually a smaller, local organisation. Credit unions are focused on the local community and aim to offer affordable banking. They are owned by their members, like building societies."

    text_array = text.split(" ");
    
    new_text_array = []
    
    index = 0
    
    text_array.each do |word|
      if(new_text_array[index].nil?)
        new_text_array[index]=word;
        next
      end
      
      if(!new_text_array[index].nil? && new_text_array[index].length + word.length >= 100)
        index = index +1
        new_text_array[index] = word
      else
        new_text_array[index] = new_text_array[index]+" "+word
      end
    end
    
    #text_array = text.split(/((?<=[a-z0-9)][.?!,])|(?<=[a-z0-9][.?!,]"))\s+(?="?[A-Z])/)
    
    mp3_file_paths = []
    new_text_array.each_with_index do |text_at_100_chars,index|       
      response = RestClient.get 'http://translate.google.com/translate_tts', {:params => {:ie => "utf-8", :tl => "en", :q => text_at_100_chars}}
      response.force_encoding('UTF-8')
      file_name = Time.new.to_time.to_i.to_s+index.to_s+".mp3"
      File.open(Rails.root.join('public','mp3s', file_name), 'w') {|f| f.write(response) }
      mp3_file_paths << Rails.root.join('public','mp3s', file_name)
    end
    
    joined_file_paths = '"'+mp3_file_paths.join('" "')+'"'
    
    compiled_file_name = "compiled"+Time.new.to_time.to_i.to_s+".mp3";
    complied_file_path = Rails.root.join('public','mp3s','compiled',compiled_file_name )
    
    command = "ruby -p -e '' #{joined_file_paths} > '#{complied_file_path}'"
    worked = `#{command}`
        
    render :json => {:status => :ok, :file_path=> "/mp3s/compiled/#{compiled_file_name}"}
  end
end
