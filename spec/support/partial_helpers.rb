module PartialHelpers

  def should_render_partial(name)
    self.view.should_receive(:_render_partial).
      with(hash_including(:partial => name))
  end

  def should_not_render_partial(name)
    self.view.should_not_receive(:_render_partial).
      with(hash_including(:partial => name))
  end
end
