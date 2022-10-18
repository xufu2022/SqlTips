/* demo-01-selecting-data-from-mxl */


DECLARE @docHandle int;  
DECLARE @xmlDocument nvarchar(max);

SET @xmlDocument = N'
<ROOT>
<Users Id="227" DisplayName="Amir Ali Akbari" Reputation="805">
    <Posts Title="Publicly Available Datasets" Tags="&lt;open-source&gt;&lt;dataset&gt;">
        <Comments Text="Cross-link: [A database of open databases?](http://opendata.stackexchange.com/questions/266/a-database-of-open-databases)"/>
        <Comments Text="This question might be more appropriate on the dedicated [opendata.SE](http://opendata.stackexchange.com/). That said, I cross my fingers for [dat](http://usodi.org/2014/04/02/dat), which aspires to become a &quot;Git for data&quot;."/>
        <Comments Text="@ojdo Thanks, I never heard of opendata.SE before, I also found [this](http://opendata.stackexchange.com/q/266/2872) interesting (and very similar) question there."/>
        <Comments Text="See http://www.quora.com/Where-can-I-find-large-datasets-open-to-the-public."/>
    </Posts>
</Users>
<Users Id="8820" DisplayName="Martin Thoma" Reputation="6748">
    <Posts Title="What are deconvolutional layers?" Tags="&lt;neural-network&gt;&lt;convnet&gt;&lt;convolution&gt;">
        <Comments Text="Hoping it could be useful to anyone, I made a [notebook](https://gist.github.com/akiross/754c7b87a2af8603da78b46cdaaa5598) to explore how convolution and transposed convolution can be used in TensorFlow (0.11). Maybe having some practical examples and figures may help a bit more to understand how they works."/>
    </Posts>
</Users>
<Users Id="227" DisplayName="Amir Ali Akbari" Reputation="805">
    <Posts Title="Publicly Available Datasets" Tags="&lt;open-source&gt;&lt;dataset&gt;">
        <Comments Text="https://zenodo.org/"/>
        <Comments Text="Reserve Bank of India have a huge database about India,\nWorld Bank have huge data set"/>
        <Comments Text="I havent found any good free comprehensive datasets for typical Business Intelligence applications.  The [Microsoft Contoso BI Demo Dataset for Retail Industry from Official Microsoft Download Center](http://www.microsoft.com/en-us/download/details.aspx?id=18279) download works with some Microsoft products (see [AndyGett on SharePoint and Other Business Software](http://bl
og.bullseyeconsulting.com/archive/2012/08/14/setting-up-sample-contoso-database-for-performancepoint-and-sharepoint.aspx)), but I dont see any plain sql or csv dumps of it, nor any license info."/>
        <Comments Text="A great place to find public data sets is http://opendata.stackexchange.com/"/>
        <Comments Text="Have you joined the Open Data Stack Exchange? http://opendata.stackexchange.com"/>
    </Posts>
</Users>
<Users Id="8820" DisplayName="Martin Thoma" Reputation="6748">
    <Posts Title="What are deconvolutional layers?" Tags="&lt;neural-network&gt;&lt;convnet&gt;&lt;convolution&gt;">
        <Comments Text="This video lecture explains deconvolution/upsampling:\nhttps://youtu.be/ByjaPdWXKJ4?t=16m59s"/>
        <Comments Text="For me, this page gave me a better explanation it also explains the difference between deconvolution and transpose convolution: https://towardsdatascience.com/types-of-convolutions-in-deep-learning-717013397f4d"/>
        <Comments Text="Isnt upsampling more like backwards pooling than backwards strided convolution, since it has no parameters?"/>
    </Posts>
</Users>
</ROOT>
'

EXEC sp_xml_preparedocument @docHandle OUTPUT, @xmlDocument;

SELECT * FROM 
OPENXML(@docHandle, N'/ROOT/Users/Posts/Comments') 
WITH (
	Author varchar(255) '../../@DisplayName',
	Title varchar(500) '../@Title',
	Tags varchar(500) '../@Tags',
	Comment varchar(500) '@Text'
); 

EXEC sp_xml_removedocument @docHandle; 