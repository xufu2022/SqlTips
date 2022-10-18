/* demo-04-providing-rowset-view-with-nodes */

DECLARE @xml xml
SET @xml = N'
<root>
  <Post>
    <Id>22</Id>
    <Title>K-Means clustering for mixed numeric and categorical data</Title>
    <Score>129</Score>
  </Post>
  <Post>
    <Id>155</Id>
    <Title>Publicly Available Datasets</Title>
    <Score>164</Score>
  </Post>
  <Post>
    <Id>694</Id>
    <Title>Best python library for neural networks</Title>
    <Score>131</Score>
  </Post>
  <Post>
    <Id>5706</Id>
    <Title>What is the "dying ReLU" problem in neural networks?</Title>
    <Score>104</Score>
  </Post>
  <Post>
    <Id>6107</Id>
    <Title>What are deconvolutional layers?</Title>
    <Score>176</Score>
  </Post>
  <Post>
    <Id>9302</Id>
    <Title>The cross-entropy error function in neural networks</Title>
    <Score>104</Score>
  </Post>
  <Post>
    <Id>13490</Id>
    <Title>How to set class weights for imbalanced classes in Keras?</Title>
    <Score>109</Score>
  </Post>
</root>'

SELECT
	doc.col.value('Id[1]', 'int') id,
	doc.col.value('Title[1]', 'nvarchar(100)') title,
	doc.col.value('Score[1]', 'int') score 
FROM @xml.nodes('/root/Post') doc(col)