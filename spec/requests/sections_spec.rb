require 'spec_helper'

describe "sections" do

  def section_record
    @section_record ||= Factory(:section, :title => "Section #{Section.count}")
  end

  describe "index" do

    context "no sections present" do

      it "renders successfully" do
        get sections_path
        response.should be_success
      end
    end

    context "with sections present" do

      it "renders a link to each section schedule" do
        section_record
        get sections_path
        response.should have_selector("a",
          :href => weekly_section_schedule_path(section_record), 
          :content => section_record.title
        )
      end
    end
  end

  describe "show" do

    context "a valid section" do

      it "renders the section title" do
        get section_path(section_record)
        response.should have_selector("h2", :content => section_record.title)
      end
    end

    context "a nonexistant section" do

      before(:each) do
        get section_path(:id => 0)
      end

      it "renders an error message" do
        flash[:error].should match(/Error:/)
      end

      it "redirects to the index" do
        response.should redirect_to(sections_path)
      end
    end
  end

  describe "new" do

    it "renders a form for a new section" do
      get new_section_path
      response.should have_selector("form", :action => sections_path)
    end
  end

  describe "create" do

    context "with valid parameters" do

      it "adds a new Section" do
        count = Section.count
        lambda {
          post sections_path, :section => {
            :title => "Foo", :description => "Bar"
          }
        }.should change{ Section.count }.from(count).to(count+1)
      end
    end

    context "with invalid parameters" do

      it "does not add a new Section" do
        lambda {
          post sections_path, :section => {}
        }.should_not change{ Section.count }
      end
    end
  end

  describe "edit" do

    context "an existing section" do

      it "renders a form for updating the section" do
        get edit_section_path(section_record)
        response.should have_selector("form",
          :action => section_path(section_record)
        )
      end
    end

    context "a nonexistant section" do

      before(:each) do
        get edit_section_path(:id => 0)
      end

      it "renders an error message" do
        flash[:error].should match(/Error:/)
      end

      it "redirects to the index" do
        response.should redirect_to(sections_path)
      end
    end
  end

  describe "update" do

    context "an existing section" do

      context "with valid parameters" do

        it "updates the requeted Section" do
          put section_path(section_record), :section => {
            :title => "New title!"
          }
          Section.find(:last, :order => :id).title.should == "New title!"
        end
      end

      context "with invalid parameters" do

        it "does not update the requested Section" do
          put section_path(section_record), :section => {
            :title => nil
          }
          Section.find(:last, :order => :id).title.should_not be_nil
        end
      end
    end

    context "a nonexistant section" do

      before(:each) do
        put section_path(:id => 0)
      end

      it "renders an error message" do
        flash[:error].should match(/Error:/)
      end

      it "redirects to the index" do
        response.should redirect_to(sections_path)
      end
    end
  end

  describe "destroy" do

    context "an existing section" do

      it "destroys the requested Section" do
        section_record
        count = Section.count
        lambda {
          delete section_path(section_record)
        }.should change{ Section.count }.from(count).to(count-1)
      end
    end

    context "a nonexistant section" do

      it "redirects to the index" do
        delete section_path(:id => 0)
        response.should redirect_to(sections_path)
      end
    end
  end
end
