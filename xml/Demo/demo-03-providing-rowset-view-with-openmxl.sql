/* demo-03-providing-rowset-view-with-openmxl */


DECLARE @DocHandle int 
DECLARE @XmlDocument nvarchar(1000) 

SET @XmlDocument = N'
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

EXEC sp_xml_preparedocument @DocHandle OUTPUT, @XmlDocument 

SELECT * FROM OPENXML (@DocHandle, '/root/Post',2) 
WITH (
	Id int,
	Title nvarchar(100), 
	Score int) 

EXEC sp_xml_removedocument @DocHandle 