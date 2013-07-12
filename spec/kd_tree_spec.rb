require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe KdTree do
  it "initializes" do
    t = KdTree.new([[1, 20], [30, 4], [50, 60], [7, 80], [90, 10]])
  end
end
