/* demo-05-modifying-xml-data */
 
/* 
En este caso vamos a modificar el Titulo del segundo Post, aunque el documento 
con formato xml se encuentra almacenado en una variable, la funcion modify puede 
aplicarse tambien a una columna de una base de datos cuyo tipo sea XML
Cambiamos el titulo de Machine Learning por Neural Network
*/

DECLARE @xmlDocument xml;

SET @xmlDocument = N'
<root>
  <Post>
    <Id>155</Id>
    <Title>Publicly Available Datasets</Title>
    <Score>164</Score>
  </Post>
  <Post>
    <Id>694</Id>
    <Title>Best python library for Machine Learning</Title>
    <Score>131</Score>
  </Post>
  <Post>
    <Id>6107</Id>
    <Title>What are deconvolutional layers?</Title>
    <Score>176</Score>
  </Post>
</root>
'

SELECT @xmlDocument;  
  
-- update text in the first manufacturing step  
SET @xmlDocument.modify('  
	replace value of (/root/Post/Title/text())[2]  
	with	"Best python library for Neural Networks"
');

SELECT @xmlDocument;