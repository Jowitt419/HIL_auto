<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:n1="urn:IEEE-1636.1:2013:TestResults" xmlns:c="urn:IEEE-1671:2010:Common" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:ts="www.ni.com/TestStand/ATMLTestResults/3.0" xmlns:msxsl="urn:schemas-microsoft-com:xslt" xmlns:user="http://www.ni.com/TestStand" id="TS5.1.0">
	<!--This alias is added so that the html output does not contain these namespaces. The omit-xml-declaration attribute of xsl:output element did not prevent the addition of these namespaces to the html output-->
	<xsl:namespace-alias stylesheet-prefix="xsl" result-prefix="#default"/>
	<xsl:namespace-alias stylesheet-prefix="n1" result-prefix="#default"/>
	<xsl:namespace-alias stylesheet-prefix="c" result-prefix="#default"/>
	<xsl:namespace-alias stylesheet-prefix="xsi" result-prefix="#default"/>
	<xsl:namespace-alias stylesheet-prefix="ts" result-prefix="#default"/>
	<xsl:namespace-alias stylesheet-prefix="msxsl" result-prefix="#default"/>
	<xsl:namespace-alias stylesheet-prefix="user" result-prefix="#default"/>
	<msxsl:script language="javascript" implements-prefix="user"><![CDATA[	
		var gPutAsFlatData = 'false';
		function SetFlatDataState(state)
		{
			gPutAsFlatData = "" + state;
			return "";
		}
		function GetFlatDataState()
		{
			return "" + gPutAsFlatData;
		}
	]]></msxsl:script>
	<xsl:output method="html" indent="no" omit-xml-declaration="yes" doctype-public="-//W3C//DTD HTML 4.01 Transitional//EN" media-type="text/html"/>
	<xsl:variable name="gShowTestStandSpecificInformation" select="false()"/>
	<xsl:template match="/">
		<html>
			<head>
				<title>ATML Report</title>
				<style type="text/css">
					li.EmptyLine{list-style-type:none;}
					li.SupportDummyUL{margin-left:-1.05cm;}
					ul.DummyUL{padding-top:0px;}
				</style>
			</head>
			<body style="font-family:verdana;font-size:0.81em">
				<h3>ATML Test Report</h3>
				<hr>
					<xsl:attribute name="style">border-width:0;width:87%;height:2px;text-align:left;margin-left:0;color:#0000FF;background-color:#0000FF</xsl:attribute>
				</hr>
				<xsl:apply-templates select="n1:TestResults"/>
				<hr>
					<xsl:attribute name="style">border-width:0;width:87%;height:2px;text-align:left;margin-left:0;color:#0000FF;background-color:#0000FF</xsl:attribute>
				</hr>
			</body>
		</html>
	</xsl:template>
	<xsl:template match="n1:TestResults">
		<xsl:apply-templates select="n1:TestStation"/>
		<xsl:if test="n1:Extension/ts:TSResultSetProperties/ts:TestSocketIndex">
			<b>Test Socket Index: </b>
			<xsl:call-template name="AddDatumValue">
				<xsl:with-param name="datumNode" select="n1:Extension/ts:TSResultSetProperties/ts:TestSocketIndex"/>
			</xsl:call-template>
			<br/>
		</xsl:if>
		<xsl:apply-templates select="n1:Personnel"/>
		<xsl:apply-templates select="n1:UUT"/>
		<xsl:if test="n1:UUT/c:Definition/c:Identification/c:IdentificationNumbers/c:IdentificationNumber[@type='Part']">
			<span style="font-weight:bold;">
									Part Number :
			</span>
			<xsl:value-of select="n1:UUT/c:Definition/c:Identification/c:IdentificationNumbers/c:IdentificationNumber[@type='Part']/@number"/>
			<br/>
		</xsl:if>
		<xsl:value-of select="user:SetFlatDataState('true')"/>
    <xsl:apply-templates select="n1:UUT/c:Definition/c:Extension/ts:TSCollection/c:Item[@name='AdditionalData']/c:Collection">
      <xsl:with-param name="DataNode" select="n1:UUT/c:Definition/c:Extension/ts:TSCollection/c:Item[@name='AdditionalData']"/>
      <xsl:with-param name="ObjectPath" select="''"/>
    </xsl:apply-templates>
    <xsl:value-of select="user:SetFlatDataState('false')"/>
		<xsl:if test="@securityClassification">
			<b>Security Classification: </b>
			<xsl:value-of select="@securityClassification"/>
			<br/>
		</xsl:if>
		<xsl:apply-templates select="n1:TestDescription"/>
		<xsl:apply-templates select="n1:References"/>
		<xsl:apply-templates select="n1:ResultSet"/>
	</xsl:template>
	<xsl:template match="n1:References">
		<ul>
			<li>
				<b>References</b>: 
			<ul>
					<xsl:for-each select="n1:Reference">
						<li>
							<b>Reference</b>:
						<ul>
								<li>UUID: <xsl:value-of select="@uuid"/>
								</li>
								<li>name: <xsl:value-of select="@name"/>
								</li>
								<xsl:if test="count(c:URL) = 1 or count(c:Text) = 1">
									<li>
										<xsl:apply-templates/>
									</li>
								</xsl:if>
							</ul>
						</li>
					</xsl:for-each>
				</ul>
			</li>
		</ul>
	</xsl:template>
	<xsl:template match="c:URL">
		URL: <xsl:value-of select="."/>
	</xsl:template>
	<xsl:template match="c:Text">
		Text: <xsl:value-of select="."/>
	</xsl:template>
	<xsl:template match="n1:TestStation">
		<b>TEST STATION: </b>
		<xsl:value-of select="c:SerialNumber"/>
		<br/>
	</xsl:template>
	<xsl:template match="n1:Personnel">
		<b>OPERATOR: </b>
		<xsl:value-of select="n1:SystemOperator/@name"/>
		<br/>
	</xsl:template>
	<xsl:template match="n1:UUT">
		<b>UUT </b>
		: <xsl:value-of select="c:SerialNumber"/>
		<br/>
		<b>UUT Type</b>
		: <xsl:value-of select="@UutType"/>
		<br/>
	</xsl:template>
	<xsl:template match="n1:TestDescription">
		<xsl:if test="c:DescriptionDocumentReference/@uuid">
			<b>Test Description document reference: </b>
			<xsl:value-of select="c:DescriptionDocumentReference/@uuid"/>
			<br/>
		</xsl:if>
	</xsl:template>
	<xsl:template match="n1:ResultSet">
		<b>RESULT SET </b>
		<xsl:if test="@ID != ''">
			(<xsl:value-of select="@ID"/>) 
		</xsl:if>				
		: <span style="color:brown">
			<xsl:value-of select="@name"/>
			<br/>
		</span>
		<xsl:if test="../n1:Extension/ts:TSResultSetProperties/ts:NumOfResults">
			<b>Number of Results: </b>
			<xsl:value-of select="../n1:Extension/ts:TSResultSetProperties/ts:NumOfResults/@value"/>
			<br/>
		</xsl:if>
		Date and Time Period: 			
		<span style="color:brown">
			<xsl:value-of select="@startDateTime"/>
		</span>
		through 
		<span style="color:brown">
			<xsl:value-of select="@endDateTime"/>
		</span>
		<br/> 
		Outcome: 
		<xsl:call-template name="GetOutcome">
			<xsl:with-param name="outcomeNode" select="n1:Outcome"/>
		</xsl:call-template>
		<xsl:if test="../n1:Extension/ts:TSResultSetProperties/ts:IsPartialExecution">
			<br/>Partial TPS Executed: <span style="color:brown">
				<xsl:value-of select="../n1:Extension/ts:TSResultSetProperties/ts:IsPartialExecution/@value"/>
			</span>
			<br/>
		</xsl:if>
		<xsl:if test="../n1:Extension/ts:TSResultSetProperties/ts:TSRData">
			<br/>
			<b>TSR File Name: </b>
			<xsl:value-of select="../n1:Extension/ts:TSResultSetProperties//ts:TSRData/@TSRFileName"/>
			<br/>
			<b>TSR File ID: </b>
			<xsl:value-of select="../n1:Extension/ts:TSResultSetProperties//ts:TSRData/@TSRFileID"/>
			<br/>
			<b>TSR File Closed: </b>
			<xsl:choose>
				<xsl:when test="../n1:Extension/ts:TSResultSetProperties//ts:TSRData/@TSRFileClosed = 'true'">OK</xsl:when>
				<xsl:otherwise>The .tsr file was not closed normally when written. This can indicate that the testing process was interrupted or aborted.</xsl:otherwise>
			</xsl:choose>
			<br/>
		</xsl:if>
		<xsl:apply-templates select="n1:Events/n1:Event"/>
		<xsl:choose>
			<xsl:when test="n1:TestGroup">
				<xsl:apply-templates select="n1:TestGroup"/>
			</xsl:when>
			<xsl:when test="n1:Test">
				<xsl:apply-templates select="n1:Test"/>
			</xsl:when>
		</xsl:choose>
	</xsl:template>
	<xsl:template match="n1:TestGroup">
		<ul>
			<li>
				<xsl:choose>
					<xsl:when test="@userDefinedType">
						<!-- Check if the userDefinedType attribute is present. TestStand stores the sequence call step name in this attribute-->
						<xsl:call-template name="AddSequenceCallStepName">
							<xsl:with-param name="userDefinedTypeAttrValue" select="@userDefinedType"/>
						</xsl:call-template> 
						TestGroup (<xsl:value-of select="@ID"/>) : 
						<span style="color:brown">
							<xsl:value-of select="@name"/>
						</span>
					</xsl:when>
					<xsl:when test="n1:Extension/ts:TSStepProperties/ts:CommonStepProperties/ts:StepType">
						<xsl:variable name="stepType" select="n1:Extension/ts:TSStepProperties/ts:CommonStepProperties/ts:StepType"/>
						<b>
							<xsl:value-of select="@name"/>
						</b>
						<xsl:choose>
							<xsl:when test="$stepType = 'PassFailTest' or $stepType = 'NumericLimitTest' or $stepType = 'NI_MultipleNumericLimitTest' or $stepType = 'StringValueTest'">
								Test 
							</xsl:when>
							<xsl:otherwise>
								SessionAction 
							</xsl:otherwise>
						</xsl:choose>
						(<xsl:value-of select="@ID"/>) : 
					</xsl:when>
					<xsl:otherwise>
						<b>
							<xsl:value-of select="@name"/>
						</b> TestGroup (<xsl:value-of select="@ID"/>) :
					</xsl:otherwise>
				</xsl:choose>
				<br/>
			Date and Time Period: 			
				<span style="color:brown">
					<xsl:value-of select="@startDateTime"/>
				</span>
			through 
				<span style="color:brown">
					<xsl:value-of select="@endDateTime"/>
				</span>
				<br/> 			
			Outcome: 
			<xsl:call-template name="GetOutcome">
					<xsl:with-param name="outcomeNode" select="n1:Outcome"/>
				</xsl:call-template>
				<br/>
				<xsl:apply-templates select="n1:Extension/ts:TSStepProperties">
					<xsl:with-param name="processTSStepProperties" select="true()"/>
				</xsl:apply-templates>
				<xsl:apply-templates/>
			</li>
		</ul>
	</xsl:template>
	<xsl:template match="n1:Test">
		<ul>
			<!--Use this to insert new line since <br/> is not valid to use here-->
			<li class="EmptyLine"/>
			<li>
				<xsl:choose>
					<xsl:when test="@userDefinedType">
						<xsl:call-template name="AddSequenceCallStepName">
							<xsl:with-param name="userDefinedTypeAttrValue" select="@userDefinedType"/>
						</xsl:call-template>
							TestGroup (<xsl:value-of select="@ID"/>) :
							<span style="color:brown">
							<xsl:value-of select="@name"/>
						</span>
					</xsl:when>
					<xsl:otherwise>
						<b>
							<xsl:value-of select="@name"/>
						</b> Test (<xsl:value-of select="@ID"/>) :
						</xsl:otherwise>
				</xsl:choose>
				<br/>
			Date and Time Period: 			
				<span style="color:brown">
					<xsl:value-of select="@startDateTime"/>
				</span>
			through 
				<span style="color:brown">
					<xsl:value-of select="@endDateTime"/>
					<br/>
				</span>
			Outcome: 
			<xsl:call-template name="GetOutcome">
					<xsl:with-param name="outcomeNode" select="n1:Outcome"/>
				</xsl:call-template>
				<br/>
				<xsl:apply-templates select="n1:Extension/ts:TSStepProperties">
					<xsl:with-param name="processTSStepProperties" select="true()"/>
				</xsl:apply-templates>
				<xsl:apply-templates select="n1:Description"/>
				<xsl:apply-templates select="n1:Events/n1:Event"/>
				<xsl:apply-templates select="n1:Parameters"/>
				<xsl:apply-templates select="n1:TestResult"/>
			</li>
		</ul>
	</xsl:template>
	<xsl:template match="n1:SessionAction">
		<ul>
			<!--Use this to insert new line since <br/> is not valid to use here-->
			<li class="EmptyLine"/>
			<li>
				<xsl:choose>
					<xsl:when test="@userDefinedType">
						<xsl:call-template name="AddSequenceCallStepName">
							<xsl:with-param name="userDefinedTypeAttrValue" select="@userDefinedType"/>
						</xsl:call-template>
						TestGroup (<xsl:value-of select="@ID"/>) :
						<span style="color:brown">
							<xsl:value-of select="@name"/>
						</span>
					</xsl:when>
					<xsl:otherwise>
						<b>
							<xsl:value-of select="@name"/>
						</b> SessionAction (<xsl:value-of select="@ID"/>) :
					</xsl:otherwise>
				</xsl:choose>
				<br/>
			Date and Time Period: 			
				<span style="color:brown">
					<xsl:value-of select="@startDateTime"/>
				</span>
			through 
				<span style="color:brown">
					<xsl:value-of select="@endDateTime"/>
					<br/>
				</span>
			Outcome: 
			<xsl:call-template name="GetOutcome">
					<xsl:with-param name="outcomeNode" select="n1:ActionOutcome"/>
				</xsl:call-template>
				<br/>
				<xsl:apply-templates select="n1:Extension/ts:TSStepProperties">
					<xsl:with-param name="processTSStepProperties" select="true()"/>
				</xsl:apply-templates>
				<xsl:apply-templates select="n1:Description"/>
				<xsl:apply-templates select="n1:Parameters"/>
				<xsl:apply-templates select="n1:Data"/>
			</li>
		</ul>
	</xsl:template>
	<xsl:template match="n1:Data">
		<xsl:choose>
			<xsl:when test="c:Collection/c:Item">
				<xsl:if test="count(c:Collection/c:Item[substring(@name, string-length(@name) - 10)='.Attributes'])!=count(c:Collection/c:Item)">
					<ul>
						<li>Data: 
						<br/>
							<xsl:apply-templates select="c:Collection">
								<xsl:with-param name="DataNode" select="."/>
								<xsl:with-param name="ObjectPath" select="'TestResult'"/>
							</xsl:apply-templates>
						</li>
					</ul>
				</xsl:if>
			</xsl:when>
			<xsl:when test="c:Datum">
				<ul>
					<li>Data: 
					<xsl:call-template name="AddDatumValue">
							<xsl:with-param name="datumNode" select="c:Datum"/>
						</xsl:call-template>
					</li>
				</ul>
			</xsl:when>
		</xsl:choose>
	</xsl:template>
	<xsl:template match="n1:Parameters">
		<xsl:if test="count(n1:Parameter)">
			<ul>
				<xsl:apply-templates select="n1:Parameter/n1:Data" mode="Parameter">
					<xsl:with-param name="StepNode" select=".."/>
				</xsl:apply-templates>
			</ul>
		</xsl:if>
	</xsl:template>
	<xsl:template match="n1:Parameter/n1:Data" mode="Parameter">
		<xsl:param name="StepNode"/>
		<xsl:variable name="parameterID" select="../@ID"/>
		<xsl:variable name="objectPath" select="concat('Parameter.',$parameterID)"/>
		<li>
			<b>Parameter</b>: <span style="color:brown">
				<xsl:value-of select="$parameterID"/>
			</span>
			<xsl:if test="../n1:Description">
				<xsl:apply-templates select="../n1:Description"/>
			</xsl:if>
			<xsl:choose>
				<xsl:when test="c:Collection/@xsi:type = 'ts:NI_TDMSReference'">
					<xsl:for-each select="c:Collection">
						<xsl:call-template name="ProcessTDMSReference">
							<xsl:with-param name="isProcessingParameter" select="true()"/>
							<xsl:with-param name="stepNode" select="$StepNode"/>
							<xsl:with-param name="objectPath" select="$objectPath"/>
						</xsl:call-template>
					</xsl:for-each>
				</xsl:when>
				<xsl:otherwise>
					<xsl:if test="c:Collection or c:Datum or c:IndexedArray">
						<xsl:apply-templates mode="Parameter">
							<xsl:with-param name="StepNode" select="$StepNode"/>
							<xsl:with-param name="ObjectPath" select="$objectPath"/>
						</xsl:apply-templates>
					</xsl:if>
				</xsl:otherwise>
			</xsl:choose>
		</li>
	</xsl:template>
	<xsl:template match="n1:TestResult">
		<ul>
			<li>
				<b>TestResult</b>: <span style="color:brown">
					<xsl:value-of select="@ID"/>
				</span>
				<xsl:if test="n1:Description">
					<xsl:apply-templates select="n1:Description"/>
				</xsl:if>
				<xsl:if test="n1:Outcome">
					<br/>
				Outcome: 
				<xsl:call-template name="GetOutcome">
						<xsl:with-param name="outcomeNode" select="n1:Outcome"/>
					</xsl:call-template>
					<br/>
				</xsl:if>
				<xsl:apply-templates select="n1:TestData"/>
				<xsl:apply-templates select="n1:Transform"/>
				<xsl:apply-templates select="n1:TestLimits">
					<xsl:with-param name="testResultID" select="@ID"/>
					<xsl:with-param name="stepNode" select=".."/>
				</xsl:apply-templates>
			</li>
		</ul>
	</xsl:template>
	<xsl:template match="n1:Transform">
		TestResult Transform:<xsl:value-of select="."/>
	</xsl:template>
	<!--Should start with either text data or <ul> but not </li> -->
	<xsl:template match="n1:TestData">
		<xsl:choose>
			<xsl:when test="c:Collection/@xsi:type = 'ts:NI_TDMSReference'">
				<xsl:for-each select="c:Collection">
					<xsl:call-template name="ProcessTDMSReference">
						<xsl:with-param name="dataNode" select="../../../n1:Data"/>
						<xsl:with-param name="objectPath" select="concat('TestResult',../../@ID)"/>
					</xsl:call-template>
				</xsl:for-each>
			</xsl:when>
			<xsl:otherwise>
				<xsl:apply-templates>
					<xsl:with-param name="DataNode" select="../../n1:Data"/>
					<xsl:with-param name="ObjectPath" select="concat('TestResult.',../@ID)"/>
				</xsl:apply-templates>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<xsl:template match="n1:TestLimits">
		<xsl:param name="testResultID"/>
		<xsl:param name="stepNode"/>
		<xsl:apply-templates select="n1:Limits">
			<xsl:with-param name="testResultID" select="$testResultID"/>
			<xsl:with-param name="stepNode" select="$stepNode"/>
		</xsl:apply-templates>
	</xsl:template>
	<xsl:template match="n1:Limits">
		<xsl:param name="testResultID"/>
		<xsl:param name="stepNode"/>
		<xsl:choose>
			<xsl:when test="c:Expected">
				<xsl:apply-templates select="c:Expected">
					<xsl:with-param name="testResultID" select="$testResultID"/>
					<xsl:with-param name="stepNode" select="$stepNode"/>
				</xsl:apply-templates>
			</xsl:when>
			<xsl:when test="c:SingleLimit">
				<xsl:apply-templates select="c:SingleLimit">
					<xsl:with-param name="testResultID" select="$testResultID"/>
					<xsl:with-param name="stepNode" select="$stepNode"/>
				</xsl:apply-templates>
			</xsl:when>
			<xsl:when test="c:LimitPair">
				<xsl:apply-templates select="c:LimitPair">
					<xsl:with-param name="testResultID" select="$testResultID"/>
					<xsl:with-param name="stepNode" select="$stepNode"/>
				</xsl:apply-templates>
			</xsl:when>
		</xsl:choose>
	</xsl:template>
	<xsl:template match="c:SingleLimit">
		<xsl:param name="testResultID"/>
		<xsl:param name="stepNode"/>
		<ul>
			<li>Limit Comparator: <span style="color:brown">
					<xsl:value-of select="@comparator"/>
				</span>
				<xsl:variable name="limitsCompHasAttribute">
					<xsl:call-template name="HasAttributes">
						<xsl:with-param name="node" select="$stepNode"/>
						<xsl:with-param name="objectPath" select="concat($testResultID, '.Limits.Comp')"/>
					</xsl:call-template>
				</xsl:variable>
				<xsl:if test="$limitsCompHasAttribute='true'">
					<xsl:call-template name="ProcessAttributes">
						<xsl:with-param name="attributeNode" select="$stepNode/n1:Data/c:Collection/c:Item[@name = concat($testResultID, '.Limits.Comp.Attributes')][1]"/>
						<xsl:with-param name="stepNode" select="$stepNode"/>
						<xsl:with-param name="objectPath" select="concat($testResultID, '.Limits.Comp.Attributes')"/>
					</xsl:call-template>
				</xsl:if>
			</li>
			<li>Limit Value Type: <xsl:call-template name="GetDatumTypeName">
					<xsl:with-param name="datumNode" select="c:Datum"/>
				</xsl:call-template>
			</li>
			<li>Limit Value: <xsl:call-template name="AddDatumValue">
					<xsl:with-param name="datumNode" select="c:Datum"/>
				</xsl:call-template>
				<xsl:variable name="limitsLowHasAttribute">
					<xsl:call-template name="HasAttributes">
						<xsl:with-param name="node" select="$stepNode"/>
						<xsl:with-param name="objectPath" select="concat($testResultID, '.Limits.Low')"/>
					</xsl:call-template>
				</xsl:variable>
				<xsl:if test="$limitsLowHasAttribute='true'">
					<xsl:call-template name="ProcessAttributes">
						<xsl:with-param name="attributeNode" select="$stepNode/n1:Data/c:Collection/c:Item[@name = concat($testResultID, '.Limits.Low.Attributes')][1]"/>
						<xsl:with-param name="stepNode" select="$stepNode"/>
						<xsl:with-param name="objectPath" select="concat($testResultID, '.Limits.Low.Attributes')"/>
					</xsl:call-template>
				</xsl:if>
			</li>
		</ul>
	</xsl:template>
	<xsl:template match="c:LimitPair">
		<xsl:param name="testResultID"/>
		<xsl:param name="stepNode"/>
		<ul>
			<li>Limit Pair Operator: <span style="color:brown">
					<xsl:value-of select="@operator"/>
				</span>
				<xsl:variable name="limitsCompHasAttribute">
					<xsl:call-template name="HasAttributes">
						<xsl:with-param name="node" select="$stepNode"/>
						<xsl:with-param name="objectPath" select="concat($testResultID, '.Limits.Comp')"/>
					</xsl:call-template>
				</xsl:variable>
				<xsl:if test="$limitsCompHasAttribute='true'">
					<xsl:call-template name="ProcessAttributes">
						<xsl:with-param name="attributeNode" select="$stepNode/n1:Data/c:Collection/c:Item[@name = concat($testResultID, '.Limits.Comp.Attributes')][1]"/>
						<xsl:with-param name="stepNode" select="$stepNode"/>
						<xsl:with-param name="objectPath" select="concat($testResultID, '.Limits.Comp.Attributes')"/>
					</xsl:call-template>
				</xsl:if>
				<xsl:for-each select="c:Limit">
					<xsl:call-template name="c:Limit">
						<xsl:with-param name="testResultID" select="$testResultID"/>
						<xsl:with-param name="stepNode" select="$stepNode"/>
						<xsl:with-param name="position" select="position()"/>
					</xsl:call-template>
				</xsl:for-each>
			</li>
		</ul>
	</xsl:template>
	<xsl:template match="c:Limit" name="c:Limit">
		<xsl:param name="testResultID"/>
		<xsl:param name="stepNode"/>
		<xsl:param name="position"/>
		<ul>
			<li>Limit Comparator: <span style="color:brown">
					<xsl:value-of select="@comparator"/>
				</span>
			</li>
			<xsl:variable name="lowHigh">
				<xsl:if test="$position = 1">
					<xsl:text>Low</xsl:text>
				</xsl:if>
				<xsl:if test="$position = 2">
					<xsl:text>High</xsl:text>
				</xsl:if>
			</xsl:variable>
			<li>Limit Value Type: <xsl:call-template name="GetDatumTypeName">
					<xsl:with-param name="datumNode" select="c:Datum"/>
				</xsl:call-template>
			</li>
			<li>Limit Value: <xsl:call-template name="AddDatumValue">
					<xsl:with-param name="datumNode" select="c:Datum"/>
				</xsl:call-template>
				<xsl:variable name="limitsHighHasAttribute">
					<xsl:call-template name="HasAttributes">
						<xsl:with-param name="node" select="$stepNode"/>
						<xsl:with-param name="objectPath" select="concat($testResultID, '.Limits.', $lowHigh)"/>
					</xsl:call-template>
				</xsl:variable>
				<xsl:if test="$limitsHighHasAttribute='true'">
					<xsl:call-template name="ProcessAttributes">
						<xsl:with-param name="attributeNode" select="$stepNode/n1:Data/c:Collection/c:Item[@name = concat($testResultID, '.Limits.', $lowHigh, '.Attributes')][1]"/>
						<xsl:with-param name="stepNode" select="$stepNode"/>
						<xsl:with-param name="objectPath" select="concat($testResultID, '.Limits.', $lowHigh, '.Attributes')"/>
					</xsl:call-template>
				</xsl:if>
			</li>
		</ul>
	</xsl:template>
	<xsl:template match="c:Expected">
		<xsl:param name="testResultID"/>
		<xsl:param name="stepNode"/>
		<ul>
			<li>Expected Comparator: <xsl:value-of select="@comparator"/>
				<xsl:variable name="limitsCompHasAttribute">
					<xsl:call-template name="HasAttributes">
						<xsl:with-param name="node" select="$stepNode"/>
						<xsl:with-param name="objectPath" select="concat($testResultID, '.Limits.Comp')"/>
					</xsl:call-template>
				</xsl:variable>
				<xsl:if test="$limitsCompHasAttribute='true'">
					<xsl:call-template name="ProcessAttributes">
						<xsl:with-param name="attributeNode" select="$stepNode/n1:Data/c:Collection/c:Item[@name = concat($testResultID, '.Limits.Comp.Attributes')][1]"/>
						<xsl:with-param name="stepNode" select="$stepNode"/>
						<xsl:with-param name="objectPath" select="concat($testResultID, '.Limits.Comp.Attributes')"/>
					</xsl:call-template>
				</xsl:if>
			</li>
			<li>Expected Type: <xsl:call-template name="GetDatumTypeName">
					<xsl:with-param name="datumNode" select="c:Datum"/>
				</xsl:call-template>
			</li>
			<li>Expected Value: <xsl:call-template name="AddDatumValue">
					<xsl:with-param name="datumNode" select="c:Datum"/>
				</xsl:call-template>
				<xsl:choose>
					<xsl:when test="c:Datum/@xsi:type = 'c:string'">
						<xsl:variable name="limitsStringHasAttribute">
							<xsl:call-template name="HasAttributes">
								<xsl:with-param name="node" select="$stepNode"/>
								<xsl:with-param name="objectPath" select="concat($testResultID, '.Limits.String')"/>
							</xsl:call-template>
						</xsl:variable>
						<xsl:if test="$limitsStringHasAttribute='true'">
							<xsl:call-template name="ProcessAttributes">
								<xsl:with-param name="attributeNode" select="$stepNode/n1:Data/c:Collection/c:Item[@name = concat($testResultID, '.Limits.String.Attributes')][1]"/>
								<xsl:with-param name="stepNode" select="$stepNode"/>
								<xsl:with-param name="objectPath" select="concat($testResultID, '.Limits.String.Attributes')"/>
							</xsl:call-template>
						</xsl:if>
					</xsl:when>
					<xsl:otherwise>
						<xsl:variable name="limitsLowHasAttribute">
							<xsl:call-template name="HasAttributes">
								<xsl:with-param name="node" select="$stepNode"/>
								<xsl:with-param name="objectPath" select="concat($testResultID, '.Limits.Low')"/>
							</xsl:call-template>
						</xsl:variable>
						<xsl:if test="$limitsLowHasAttribute='true'">
							<xsl:call-template name="ProcessAttributes">
								<xsl:with-param name="attributeNode" select="$stepNode/n1:Data/c:Collection/c:Item[@name = concat($testResultID, '.Limits.Low.Attributes')][1]"/>
								<xsl:with-param name="stepNode" select="$stepNode"/>
								<xsl:with-param name="objectPath" select="concat($testResultID, '.Limits.Low.Attributes')"/>
							</xsl:call-template>
						</xsl:if>
					</xsl:otherwise>
				</xsl:choose>
			</li>
		</ul>
	</xsl:template>
	<xsl:template match="n1:Events/n1:Event">
		<xsl:if test="@source != '' or @severity != '' ">
			<ul>
				<li>
					<b>Event: </b>
					<xsl:value-of select="@ID"/>
				</li>
				<xsl:if test="@source != ''">
					<li>Source: <xsl:value-of select="@source"/>
					</li>
				</xsl:if>
				<xsl:if test="@severity != ''">
					<li>Severity: <xsl:value-of select="@severity"/>
					</li>
				</xsl:if>
				<xsl:if test="n1:Message">
					<li>Message: <xsl:value-of select="n1:Message"/>
					</li>
				</xsl:if>
			</ul>
			<ul>
				<li>Data: <xsl:value-of disable-output-escaping="yes" select="n1:Data[@name='Error Message']/c:Datum/c:Value"/>
				</li>
			</ul>
		</xsl:if>
	</xsl:template>
	<xsl:template match="c:Collection">
		<xsl:param name="DataNode"/>
		<xsl:param name="ObjectPath"/>
		<xsl:variable name="putAsFlatData" select="user:GetFlatDataState()"/>
		<xsl:if test="$ObjectPath != '' or $ObjectPath!='TestResult'">
			<xsl:variable name="hasAttributes">
				<xsl:call-template name="HasAttributes">
					<xsl:with-param name="node" select="$DataNode/.."/>
					<xsl:with-param name="objectPath" select="$ObjectPath"/>
				</xsl:call-template>
			</xsl:variable>
			<xsl:if test="$hasAttributes='true'">
				<xsl:call-template name="ProcessAttributes">
					<xsl:with-param name="attributeNode" select="$DataNode/c:Collection/c:Item[@name = concat($ObjectPath, '.Attributes')][1]"/>
					<xsl:with-param name="stepNode" select="$DataNode/.."/>
					<xsl:with-param name="objectPath" select="concat($ObjectPath,'.Attributes')"/>
				</xsl:call-template>
			</xsl:if>
		</xsl:if>
		<xsl:apply-templates select="c:Item">
			<xsl:with-param name="DataNode" select="$DataNode"/>
			<xsl:with-param name="ObjectPath" select="$ObjectPath"/>
		</xsl:apply-templates>
	</xsl:template>
	<xsl:template match="c:Item">
		<xsl:param name="DataNode"/>
		<xsl:param name="ObjectPath"/>
		<xsl:variable name="ChildObjectPath">
			<xsl:if test="$ObjectPath != ''">
				<xsl:value-of select="concat($ObjectPath, '.' , @name)"/>
			</xsl:if>
			<xsl:if test="$ObjectPath = ''">
				<xsl:value-of select="@name"/>
			</xsl:if>
		</xsl:variable>
		<xsl:variable name="isAttributes">
			<xsl:call-template name="IsAttributes">
				<xsl:with-param name="itemName" select="@name"/>
			</xsl:call-template>
		</xsl:variable>
		<xsl:variable name="putAsFlatData" select="user:GetFlatDataState()"/>
		<xsl:if test="$isAttributes='false'">
			<xsl:choose>
				<xsl:when test="$putAsFlatData='true'">
					<xsl:if test="not(c:Collection)">
						<span style="font-weight:bold">
							<xsl:if test="$ObjectPath != ''">
								<xsl:value-of select="concat($ObjectPath, '.' , @name)"/>
							</xsl:if>
							<xsl:if test="$ObjectPath = ''">
								<xsl:value-of select="@name"/>
							</xsl:if> : 
					</span>
					</xsl:if>
					<xsl:choose>
						<xsl:when test="c:Collection/@xsi:type = 'ts:NI_TDMSReference'">
							<xsl:for-each select="c:Collection">
								<xsl:call-template name="ProcessTDMSReference">
									<xsl:with-param name="dataNode" select="$DataNode"/>
									<xsl:with-param name="objectPath" select="$ChildObjectPath"/>
								</xsl:call-template>
							</xsl:for-each>
						</xsl:when>
						<xsl:otherwise>
							<xsl:apply-templates>
								<xsl:with-param name="DataNode" select="$DataNode"/>
								<xsl:with-param name="ObjectPath" select="$ChildObjectPath"/>
							</xsl:apply-templates>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:when>
				<xsl:otherwise>
					<ul>
						<li>Item Name: <span style="color:brown">
								<xsl:value-of select="@name"/>
							</span>
							<xsl:choose>
								<xsl:when test="c:Collection/@xsi:type = 'ts:NI_TDMSReference'">
									<xsl:for-each select="c:Collection">
										<xsl:call-template name="ProcessTDMSReference">
											<xsl:with-param name="dataNode" select="$DataNode"/>
											<xsl:with-param name="objectPath" select="$ChildObjectPath"/>
										</xsl:call-template>
									</xsl:for-each>
								</xsl:when>
								<xsl:otherwise>
									<xsl:apply-templates>
										<xsl:with-param name="DataNode" select="$DataNode"/>
										<xsl:with-param name="ObjectPath" select="$ChildObjectPath"/>
									</xsl:apply-templates>
								</xsl:otherwise>
							</xsl:choose>
						</li>
					</ul>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:if>
	</xsl:template>
	<xsl:template match="c:Datum">
		<xsl:param name="DataNode"/>
		<xsl:param name="ObjectPath"/>
		<xsl:variable name="putAsFlatData" select="user:GetFlatDataState()"/>
		<xsl:choose>
			<xsl:when test="$putAsFlatData='true'">
				<xsl:call-template name="AddDatumValue">
					<xsl:with-param name="datumNode" select="."/>
				</xsl:call-template>
				<br/>
				<xsl:variable name="hasAttributes">
					<xsl:call-template name="HasAttributes">
						<xsl:with-param name="node" select="$DataNode"/>
						<xsl:with-param name="objectPath" select="$ObjectPath"/>
					</xsl:call-template>
				</xsl:variable>
				<xsl:if test="$hasAttributes='true'">
					<xsl:call-template name="ProcessAttributes">
						<xsl:with-param name="attributeNode" select="$DataNode/c:Collection/c:Item[@name = concat($ObjectPath, '.Attributes')][1]"/>
						<xsl:with-param name="stepNode" select="$DataNode/.."/>
						<xsl:with-param name="objectPath" select="concat($ObjectPath, '.Attributes')"/>
					</xsl:call-template>
				</xsl:if>
			</xsl:when>
			<xsl:otherwise>
				<ul class="DummyUL">
					<li class="SupportDummyUL">TestResult Type: <xsl:call-template name="GetDatumTypeName">
							<xsl:with-param name="datumNode" select="."/>
						</xsl:call-template>
					</li>
					<li class="SupportDummyUL">TestResult Value: <xsl:call-template name="AddDatumValue">
							<xsl:with-param name="datumNode" select="."/>
						</xsl:call-template>
						<xsl:variable name="hasAttributes">
							<xsl:call-template name="HasAttributes">
								<xsl:with-param name="node" select="$DataNode/.."/>
								<xsl:with-param name="objectPath" select="$ObjectPath"/>
							</xsl:call-template>
						</xsl:variable>
						<xsl:if test="$hasAttributes='true'">
							<xsl:call-template name="ProcessAttributes">
								<xsl:with-param name="attributeNode" select="$DataNode/c:Collection/c:Item[@name = concat($ObjectPath, '.Attributes')][1]"/>
								<xsl:with-param name="stepNode" select="$DataNode/.."/>
								<xsl:with-param name="objectPath" select="concat($ObjectPath, '.Attributes')"/>
							</xsl:call-template>
						</xsl:if>
					</li>
				</ul>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<xsl:template match="c:IndexedArray">
		<xsl:param name="DataNode"/>
		<xsl:param name="ObjectPath"/>
		<xsl:variable name="testResultType">
			<xsl:call-template name="GetArrayTypeName">
				<xsl:with-param name="indexedArrayNode" select="."/>
			</xsl:call-template>
		</xsl:variable>
		<xsl:variable name="putAsFlatData" select="user:GetFlatDataState()"/>
		<xsl:choose>
			<xsl:when test="$putAsFlatData='true'">
				<xsl:if test="@dimensions != '[0]'">
					<xsl:call-template name="AddIndexedArrayValues">
						<xsl:with-param name="indexedArrayNode" select="."/>
					</xsl:call-template>
					<br/>
				</xsl:if>
				<xsl:variable name="hasAttributes">
					<xsl:call-template name="HasAttributes">
						<xsl:with-param name="node" select="$DataNode"/>
						<xsl:with-param name="objectPath" select="$ObjectPath"/>
					</xsl:call-template>
				</xsl:variable>
				<xsl:if test="$hasAttributes='true'">
					<xsl:call-template name="ProcessAttributes">
						<xsl:with-param name="attributeNode" select="$DataNode/c:Collection/c:Item[@name = concat($ObjectPath, '.Attributes')][1]"/>
						<xsl:with-param name="stepNode" select="$DataNode/.."/>
						<xsl:with-param name="objectPath" select="concat($ObjectPath, '.Attributes')"/>
					</xsl:call-template>
				</xsl:if>
			</xsl:when>
			<xsl:otherwise>
				<xsl:if test="@dimensions != '[0]'">
					<ul class="DummyUL">
						<li class="SupportDummyUL">TestResult Type: <xsl:value-of select="$testResultType"/>
						</li>
						<li class="SupportDummyUL">TestResult Value:
							<xsl:call-template name="AddIndexedArrayValues">
								<xsl:with-param name="indexedArrayNode" select="."/>
							</xsl:call-template>
						</li>
					</ul>
				</xsl:if>
				<xsl:variable name="hasAttributes">
					<xsl:call-template name="HasAttributes">
						<xsl:with-param name="node" select="$DataNode/.."/>
						<xsl:with-param name="objectPath" select="$ObjectPath"/>
					</xsl:call-template>
				</xsl:variable>
				<xsl:if test="$hasAttributes='true'">
					<xsl:call-template name="ProcessAttributes">
						<xsl:with-param name="attributeNode" select="$DataNode/c:Collection/c:Item[@name = concat($ObjectPath, '.Attributes')][1]"/>
						<xsl:with-param name="stepNode" select="$DataNode/.."/>
						<xsl:with-param name="objectPath" select="concat($ObjectPath, '.Attributes')"/>
					</xsl:call-template>
				</xsl:if>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<xsl:template name="GetUnit">
		<xsl:param name="node"/>
		<xsl:choose>
			<xsl:when test="$node/@unit">
				<xsl:value-of select="$node/@unit"/>
			</xsl:when>
			<xsl:when test="$node/@nonStandardUnit">
				<xsl:value-of select="$node/@nonStandardUnit"/>
			</xsl:when>
			<xsl:otherwise/>
		</xsl:choose>
	</xsl:template>
	<xsl:template match="c:IndexedArray" mode="Parameter">
		<xsl:param name="StepNode"/>
		<xsl:param name="ObjectPath"/>
		<xsl:variable name="parameterType">
			<xsl:call-template name="GetArrayTypeName">
				<xsl:with-param name="indexedArrayNode" select="."/>
			</xsl:call-template>
		</xsl:variable>
		<xsl:if test="@dimensions != '[0]'">
			<ul class="DummyUL">
				<li class="SupportDummyUL">Parameter Type: <xsl:value-of select="$parameterType"/>
				</li>
				<li class="SupportDummyUL">Parameter Value:
			<xsl:call-template name="AddIndexedArrayValues">
						<xsl:with-param name="indexedArrayNode" select="."/>
					</xsl:call-template>
				</li>
			</ul>
		</xsl:if>
		<xsl:variable name="hasAttributes">
			<xsl:call-template name="HasAttributes">
				<xsl:with-param name="node" select="$StepNode"/>
				<xsl:with-param name="objectPath" select="$ObjectPath"/>
			</xsl:call-template>
		</xsl:variable>
		<xsl:if test="$hasAttributes='true'">
			<xsl:call-template name="ProcessAttributes">
				<xsl:with-param name="attributeNode" select="$StepNode/n1:Data/c:Collection/c:Item[@name = concat($ObjectPath, '.Attributes')][1]"/>
				<xsl:with-param name="stepNode" select="$StepNode"/>
				<xsl:with-param name="objectPath" select="concat($ObjectPath, '.Attributes')"/>
			</xsl:call-template>
		</xsl:if>
	</xsl:template>
	<xsl:template match="c:Datum" mode="Parameter">
		<xsl:param name="StepNode"/>
		<xsl:param name="ObjectPath"/>
		<ul class="DummyUL">
			<li class="SupportDummyUL">Parameter Type: <xsl:call-template name="GetDatumTypeName">
					<xsl:with-param name="datumNode" select="."/>
				</xsl:call-template>
			</li>
			<li class="SupportDummyUL">Parameter Value: <xsl:call-template name="AddDatumValue">
					<xsl:with-param name="datumNode" select="."/>
				</xsl:call-template>
				<xsl:variable name="hasAttributes">
					<xsl:call-template name="HasAttributes">
						<xsl:with-param name="node" select="$StepNode"/>
						<xsl:with-param name="objectPath" select="$ObjectPath"/>
					</xsl:call-template>
				</xsl:variable>
				<xsl:if test="$hasAttributes='true'">
					<xsl:call-template name="ProcessAttributes">
						<xsl:with-param name="attributeNode" select="$StepNode/n1:Data/c:Collection/c:Item[@name = concat($ObjectPath, '.Attributes')][1]"/>
						<xsl:with-param name="stepNode" select="$StepNode"/>
						<xsl:with-param name="objectPath" select="concat($ObjectPath, '.Attributes')"/>
					</xsl:call-template>
				</xsl:if>
			</li>
		</ul>
	</xsl:template>
	<xsl:template match="c:Collection" mode="Parameter">
		<xsl:param name="StepNode"/>
		<xsl:param name="ObjectPath"/>
		<xsl:variable name="hasAttributes">
			<xsl:call-template name="HasAttributes">
				<xsl:with-param name="node" select="$StepNode"/>
				<xsl:with-param name="objectPath" select="$ObjectPath"/>
			</xsl:call-template>
		</xsl:variable>
		<xsl:if test="$hasAttributes='true'">
			<xsl:call-template name="ProcessAttributes">
				<xsl:with-param name="attributeNode" select="$StepNode/n1:Data/c:Collection/c:Item[@name = concat($ObjectPath, '.Attributes')][1]"/>
				<xsl:with-param name="stepNode" select="$StepNode"/>
				<xsl:with-param name="objectPath" select="concat($ObjectPath, '.Attributes')"/>
			</xsl:call-template>
		</xsl:if>
		<xsl:apply-templates select="c:Item" mode="Parameter">
			<xsl:with-param name="StepNode" select="$StepNode"/>
			<xsl:with-param name="ObjectPath" select="$ObjectPath"/>
		</xsl:apply-templates>
	</xsl:template>
	<xsl:template match="c:Item" mode="Parameter">
		<xsl:param name="StepNode"/>
		<xsl:param name="ObjectPath"/>
		<ul>
			<li>Item Name: <span style="color:brown">
					<xsl:value-of select="@name"/>
				</span>
				<xsl:choose>
					<xsl:when test="c:Collection/@xsi:type = 'ts:NI_TDMSReference'">
						<xsl:for-each select="c:Collection">
							<xsl:call-template name="ProcessTDMSReference">
								<xsl:with-param name="isProcessingParameter" select="true()"/>
								<xsl:with-param name="stepNode" select="$StepNode"/>
								<xsl:with-param name="objectPath" select="concat($ObjectPath, '.' , @name)"/>
							</xsl:call-template>
						</xsl:for-each>
					</xsl:when>
					<xsl:otherwise>
						<xsl:apply-templates mode="Parameter">
							<xsl:with-param name="StepNode" select="$StepNode"/>
							<xsl:with-param name="ObjectPath" select="concat($ObjectPath, '.' , @name)"/>
						</xsl:apply-templates>
					</xsl:otherwise>
				</xsl:choose>
			</li>
		</ul>
	</xsl:template>
	<xsl:template match="n1:Description">
		<br/>Description: <b>
			<xsl:value-of select="."/>
		</b>
		<br/>
	</xsl:template>
	<xsl:template match="c:Collection" mode="Attributes">
		<xsl:param name="ObjectPath" select="''"/>
		<xsl:param name="StepNode"/>
		<xsl:if test="$ObjectPath != ''">
			<xsl:variable name="hasAttributes">
				<xsl:call-template name="HasAttributes">
					<xsl:with-param name="node" select="$StepNode"/>
					<xsl:with-param name="objectPath" select="$ObjectPath"/>
				</xsl:call-template>
			</xsl:variable>
			<xsl:if test="$hasAttributes='true'">
				<xsl:call-template name="ProcessAttributes">
					<xsl:with-param name="attributeNode" select="$StepNode/n1:Data/c:Collection/c:Item[@name = concat($ObjectPath, '.Attributes')][1]"/>
					<xsl:with-param name="stepNode" select="$StepNode"/>
					<xsl:with-param name="objectPath" select="concat($ObjectPath, '.Attributes')"/>
				</xsl:call-template>
			</xsl:if>
		</xsl:if>
		<xsl:apply-templates select="c:Item/c:Collection/c:Item[1]" mode="Attributes">
			<xsl:with-param name="StepNode" select="$StepNode"/>
			<xsl:with-param name="ObjectPath" select="$ObjectPath"/>
		</xsl:apply-templates>
	</xsl:template>
	<xsl:template match="c:Item" mode="Attributes">
		<xsl:param name="ObjectPath" select="''"/>
		<xsl:param name="StepNode"/>
		<xsl:variable name="putAsFlatData" select="user:GetFlatDataState()"/>
		<xsl:choose>
			<xsl:when test="$putAsFlatData='true'">
				<xsl:if test="not(c:Collection)">
					<span style="font-weight:bold;">
						<xsl:value-of select="$ObjectPath"/>.<xsl:value-of select="substring(@name,0,string-length(@name) - 5)"/> : 
				</span>
				</xsl:if>
				<xsl:choose>
					<xsl:when test="c:Collection/@xsi:type='ts:NI_TDMSReference'">
						<xsl:for-each select="c:Collection">
							<xsl:call-template name="ProcessTDMSReferenceAttribute">
								<xsl:with-param name="stepNode" select="$StepNode"/>
								<xsl:with-param name="objectPath" select="$ObjectPath"/>
							</xsl:call-template>
						</xsl:for-each>
					</xsl:when>
					<xsl:otherwise>
						<xsl:apply-templates mode="Attributes">
							<xsl:with-param name="StepNode" select="$StepNode"/>
							<xsl:with-param name="ObjectPath">
								<xsl:choose>
									<xsl:when test="$ObjectPath!=''">
										<xsl:value-of select="concat($ObjectPath,'.',substring(@name,0,string-length(@name) - 5))"/>
									</xsl:when>
									<xsl:otherwise>
										<xsl:value-of select="substring(@name,0,string-length(@name) - 5)"/>
									</xsl:otherwise>
								</xsl:choose>
							</xsl:with-param>
						</xsl:apply-templates>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:when>
			<xsl:otherwise>
				<ul>
					<li>Attribute Name: <span style="color:brown">
							<xsl:value-of select="substring(@name,0,string-length(@name) - 5)"/>
						</span>
						<xsl:choose>
							<xsl:when test="c:Collection/@xsi:type='ts:NI_TDMSReference'">
								<xsl:for-each select="c:Collection">
									<xsl:call-template name="ProcessTDMSReferenceAttribute">
										<xsl:with-param name="stepNode" select="$StepNode"/>
										<xsl:with-param name="objectPath" select="$ObjectPath"/>
									</xsl:call-template>
								</xsl:for-each>
							</xsl:when>
							<xsl:otherwise>
								<xsl:apply-templates mode="Attributes">
									<xsl:with-param name="StepNode" select="$StepNode"/>
									<xsl:with-param name="ObjectPath">
										<xsl:choose>
											<xsl:when test="$ObjectPath!=''">
												<xsl:value-of select="concat($ObjectPath,'.',substring(@name,0,string-length(@name) - 5))"/>
											</xsl:when>
											<xsl:otherwise>
												<xsl:value-of select="substring(@name,0,string-length(@name) - 5)"/>
											</xsl:otherwise>
										</xsl:choose>
									</xsl:with-param>
								</xsl:apply-templates>
							</xsl:otherwise>
						</xsl:choose>
					</li>
				</ul>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<xsl:template match="c:Datum" mode="Attributes">
		<xsl:param name="StepNode"/>
		<xsl:param name="ObjectPath" select="''"/>
		<xsl:variable name="putAsFlatData" select="user:GetFlatDataState()"/>
		<xsl:choose>
			<xsl:when test="$putAsFlatData='true'">
				<xsl:call-template name="AddDatumValue">
					<xsl:with-param name="datumNode" select="."/>
				</xsl:call-template>
				<br/>
				<xsl:variable name="hasAttributes">
					<xsl:call-template name="HasAttributes">
						<xsl:with-param name="node" select="$StepNode"/>
						<xsl:with-param name="objectPath" select="$ObjectPath"/>
					</xsl:call-template>
				</xsl:variable>
				<xsl:if test="$hasAttributes='true'">
					<xsl:call-template name="ProcessAttributes">
						<xsl:with-param name="attributeNode" select="$StepNode/n1:Data/c:Collection/c:Item[@name = concat($ObjectPath, '.Attributes')][1]"/>
						<xsl:with-param name="stepNode" select="$StepNode"/>
						<xsl:with-param name="objectPath" select="concat($ObjectPath, '.Attributes')"/>
					</xsl:call-template>
				</xsl:if>
			</xsl:when>
			<xsl:otherwise>
				<ul class="DummyUL">
					<li class="SupportDummyUL">Attribute Type: <xsl:call-template name="GetDatumTypeName">
							<xsl:with-param name="datumNode" select="."/>
						</xsl:call-template>
					</li>
					<li class="SupportDummyUL">Attribute Value: <xsl:call-template name="AddDatumValue">
							<xsl:with-param name="datumNode" select="."/>
						</xsl:call-template>
						<xsl:variable name="hasAttributes">
							<xsl:call-template name="HasAttributes">
								<xsl:with-param name="node" select="$StepNode"/>
								<xsl:with-param name="objectPath" select="$ObjectPath"/>
							</xsl:call-template>
						</xsl:variable>
						<xsl:if test="$hasAttributes='true'">
							<xsl:call-template name="ProcessAttributes">
								<xsl:with-param name="attributeNode" select="$StepNode/n1:Data/c:Collection/c:Item[@name = concat($ObjectPath, '.Attributes')][1]"/>
								<xsl:with-param name="stepNode" select="$StepNode"/>
								<xsl:with-param name="objectPath" select="concat($ObjectPath, '.Attributes')"/>
							</xsl:call-template>
						</xsl:if>
					</li>
				</ul>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<xsl:template match="c:IndexedArray" mode="Attributes">
		<xsl:param name="StepNode"/>
		<xsl:param name="ObjectPath" select="''"/>
		<xsl:variable name="putAsFlatData" select="user:GetFlatDataState()"/>
		<xsl:variable name="attributeType">
			<xsl:call-template name="GetArrayTypeName">
				<xsl:with-param name="indexedArrayNode" select="."/>
			</xsl:call-template>
		</xsl:variable>
		<xsl:choose>
			<xsl:when test="$putAsFlatData='true'">
				<xsl:if test="@dimensions != '[0]'">
					<xsl:call-template name="AddIndexedArrayValues">
						<xsl:with-param name="indexedArrayNode" select="."/>
					</xsl:call-template>
					<br/>
				</xsl:if>
				<xsl:variable name="hasAttributes">
					<xsl:call-template name="HasAttributes">
						<xsl:with-param name="node" select="$StepNode"/>
						<xsl:with-param name="objectPath" select="$ObjectPath"/>
					</xsl:call-template>
				</xsl:variable>
				<xsl:if test="$hasAttributes='true'">
					<xsl:call-template name="ProcessAttributes">
						<xsl:with-param name="attributeNode" select="$StepNode/n1:Data/c:Collection/c:Item[@name = concat($ObjectPath, '.Attributes')][1]"/>
						<xsl:with-param name="stepNode" select="$StepNode"/>
						<xsl:with-param name="objectPath" select="concat($ObjectPath, '.Attributes')"/>
					</xsl:call-template>
				</xsl:if>
			</xsl:when>
			<xsl:otherwise>
				<xsl:if test="@dimensions != '[0]'">
					<ul class="DummyUL">
						<li class="SupportDummyUL">Attribute Type: <xsl:value-of select="$attributeType"/>
						</li>
						<li class="SupportDummyUL">Attribute Value:
			<xsl:call-template name="AddIndexedArrayValues">
								<xsl:with-param name="indexedArrayNode" select="."/>
							</xsl:call-template>
						</li>
					</ul>
				</xsl:if>
				<xsl:variable name="hasAttributes">
					<xsl:call-template name="HasAttributes">
						<xsl:with-param name="node" select="$StepNode"/>
						<xsl:with-param name="objectPath" select="$ObjectPath"/>
					</xsl:call-template>
				</xsl:variable>
				<xsl:if test="$hasAttributes='true'">
					<xsl:call-template name="ProcessAttributes">
						<xsl:with-param name="attributeNode" select="$StepNode/n1:Data/c:Collection/c:Item[@name = concat($ObjectPath, '.Attributes')][1]"/>
						<xsl:with-param name="stepNode" select="$StepNode"/>
						<xsl:with-param name="objectPath" select="concat($ObjectPath, '.Attributes')"/>
					</xsl:call-template>
				</xsl:if>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<!-- Template to check whether processed property, specified by 'node', has attributes defined for it or not.-->
	<xsl:template name="HasAttributes">
		<xsl:param name="node"/>
		<xsl:param name="objectPath"/>
		<xsl:variable name="putAsFlatData" select="user:GetFlatDataState()"/>
		<xsl:choose>
			<xsl:when test="$node/n1:Data">
				<xsl:choose>
					<xsl:when test="$node/n1:Data/c:Collection/c:Item[@name=concat($objectPath,'.Attributes')]">
						<xsl:variable name="shouldIncludeAttribute">
							<xsl:call-template name="CheckIfIncludeInReportIsPresentForAttributes">
								<xsl:with-param name="attributeNode" select="$node/n1:Data/c:Collection/c:Item[@name=concat($objectPath,'.Attributes')]"/>
							</xsl:call-template>
						</xsl:variable>
						<xsl:value-of select="$shouldIncludeAttribute"/>
					</xsl:when>
					<xsl:otherwise>false</xsl:otherwise>
				</xsl:choose>
			</xsl:when>
			<xsl:when test="$node/c:Collection">
				<xsl:choose>
					<xsl:when test="$node/c:Collection/c:Item[@name=concat($objectPath,'.Attributes')]">
						<xsl:variable name="shouldIncludeAttribute">
							<xsl:call-template name="CheckIfIncludeInReportIsPresentForAttributes">
								<xsl:with-param name="attributeNode" select="$node/c:Collection/c:Item[@name=concat($objectPath,'.Attributes')]"/>
							</xsl:call-template>
						</xsl:variable>
						<xsl:value-of select="$shouldIncludeAttribute"/>
					</xsl:when>
					<xsl:otherwise>false</xsl:otherwise>
				</xsl:choose>
			</xsl:when>
			<xsl:otherwise>false</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<xsl:template name="ProcessAttributes">
		<xsl:param name="attributeNode"/>
		<xsl:param name="stepNode"/>
		<xsl:param name="objectPath" select="''"/>
		<xsl:variable name="putAsFlatData" select="user:GetFlatDataState()"/>
		<xsl:choose>
			<xsl:when test="$putAsFlatData='false'">
				<ul>
					<li>Attributes:
						<xsl:call-template name="ProcessAttributeValues">
							<xsl:with-param name="attributeNode" select="$attributeNode"/>
							<xsl:with-param name="objectPath" select="$objectPath"/>
							<xsl:with-param name="stepNode" select="$stepNode"/>
						</xsl:call-template>
					</li>
				</ul>
			</xsl:when>
			<xsl:otherwise>
				<xsl:call-template name="ProcessAttributeValues">
					<xsl:with-param name="attributeNode" select="$attributeNode"/>
					<xsl:with-param name="objectPath" select="$objectPath"/>
					<xsl:with-param name="stepNode" select="$stepNode"/>
				</xsl:call-template>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<xsl:template name="ProcessAttributeValues">
		<xsl:param name="attributeNode"/>
		<xsl:param name="stepNode"/>
		<xsl:param name="objectPath" select="''"/>
		<xsl:variable name="putAsFlatData" select="user:GetFlatDataState()"/>
		<xsl:for-each select="$attributeNode/c:Collection/c:Item">
			<xsl:variable name="shouldIncludeInReport">
				<xsl:call-template name="CheckIfIncludeFlagIsSet">
					<xsl:with-param name="flag" select="c:Collection/c:Item[2]/c:Datum/@value"/>
				</xsl:call-template>
			</xsl:variable>
			<xsl:choose>
				<xsl:when test="$shouldIncludeInReport='true'">
					<xsl:apply-templates select="c:Collection/c:Item[1]" mode="Attributes">
						<xsl:with-param name="StepNode" select="$stepNode"/>
						<xsl:with-param name="ObjectPath" select="$objectPath"/>
					</xsl:apply-templates>
				</xsl:when>
				<xsl:otherwise>
					<xsl:if test="c:Collection/c:Item[1]/c:Collection">
						<xsl:variable name="containerFields">
							<xsl:call-template name="ProcessAttributeValues">
								<xsl:with-param name="attributeNode" select="c:Collection/c:Item[1]"/>
								<xsl:with-param name="stepNode" select="$stepNode"/>
								<xsl:with-param name="objectPath">
									<xsl:choose>
										<xsl:when test="$objectPath!=''">
											<xsl:value-of select="concat($objectPath,'.',@name)"/>
										</xsl:when>
										<xsl:otherwise>
											<xsl:value-of select="@name"/>
										</xsl:otherwise>
									</xsl:choose>
								</xsl:with-param>
							</xsl:call-template>
						</xsl:variable>
						<xsl:if test="$containerFields != '' and $putAsFlatData='false'">
							<ul>
								<li>Attribute Name: <span style="color:brown">
										<xsl:value-of select="@name"/>
									</span>
									<xsl:copy-of select="$containerFields"/>
								</li>
							</ul>
						</xsl:if>
						<xsl:if test="$containerFields != '' and $putAsFlatData='true'">
							<xsl:choose>
								<xsl:when test="$objectPath!=''">
									<xsl:value-of select="concat($objectPath,'.',@name)"/>
								</xsl:when>
								<xsl:otherwise>
									<xsl:value-of select="@name"/>
								</xsl:otherwise>
							</xsl:choose>
							<xsl:copy-of select="$containerFields"/>
						</xsl:if>
					</xsl:if>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:for-each>
	</xsl:template>
	<xsl:template name="ProcessMainSequenceCallback">
		<xsl:param name="seqCallStepName"/>
		<xsl:value-of select="substring-before($seqCallStepName, ' Callback')"/>
	</xsl:template>
	<xsl:template match="ts:TSStepProperties">
		<xsl:param name="processTSStepProperties" select="false()"/>
		<xsl:if test="$gShowTestStandSpecificInformation and $processTSStepProperties">
			<xsl:if test="ts:StepId">
				TestStand Step Id: <span style="color:brown">
					<xsl:value-of select="ts:StepId"/>
				</span>
				<br/>
			</xsl:if>
			<xsl:if test="ts:StepType">
				Step Type: <span style="color:brown">
					<xsl:value-of select="ts:StepType"/>
				</span>
				<br/>
			</xsl:if>
			<xsl:if test="ts:StepGroup">
				Step Group: <span style="color:brown">
					<xsl:value-of select="ts:StepGroup"/>
				</span>
				<br/>
			</xsl:if>
			<xsl:if test="ts:BlockLevel">
				Block Level: <span style="color:brown">
					<xsl:value-of select="ts:BlockLevel/@value"/>
				</span>
				<br/>
			</xsl:if>
			<xsl:if test="ts:StepCausedSequenceFailure and (ts:StepCausedSequenceFailure/@value='true')">
			    Step Caused Sequence Failure: <span style="color:brown">True</span>
				<br/>
			</xsl:if>
			<xsl:if test="ts:Index">
				Index: <span style="color:brown">
					<xsl:value-of select="ts:Index/@value"/>
				</span>
				<br/>
			</xsl:if>
			<xsl:apply-templates select="ts:LoopingProperties"/>
			<xsl:if test="ts:RemoteServerId">
				Remote Server: <span style="color:brown">
					<xsl:value-of select="ts:RemoteServerId"/>
				</span>
				<br/>
			</xsl:if>
			<xsl:if test="ts:InteractiveExecutionId">
				Interactive Execution #: <span style="color:brown">
					<xsl:value-of select="ts:InteractiveExecutionId/@value"/>
				</span>
				<br/>
			</xsl:if>
		</xsl:if>
	</xsl:template>
	<xsl:template match="ts:LoopingProperties">
		<xsl:if test="ts:NumLoops">
			Number of Iterations: 
			<span style="color:brown">
				<xsl:call-template name="AddDatumValue">
					<xsl:with-param name="datumNode" select="ts:NumLoops"/>
				</xsl:call-template>
			</span>
			<br/>
		</xsl:if>
		<xsl:if test="ts:NumPassed">
			Number of Steps Passed: 
			<span style="color:brown">
				<xsl:call-template name="AddDatumValue">
					<xsl:with-param name="datumNode" select="ts:NumPassed"/>
				</xsl:call-template>
			</span>
			<br/>
		</xsl:if>
		<xsl:if test="ts:NumFailed">
			Number of Steps Failed: 
			<span style="color:brown">
				<xsl:call-template name="AddDatumValue">
					<xsl:with-param name="datumNode" select="ts:NumFailed"/>
				</xsl:call-template>
			</span>
			<br/>
		</xsl:if>
		<xsl:if test="ts:EndingLoopIndex">
			Ending Loop Index: 
			<span style="color:brown">
				<xsl:call-template name="AddDatumValue">
					<xsl:with-param name="datumNode" select="ts:EndingLoopIndex"/>
				</xsl:call-template>
			</span>
			<br/>
		</xsl:if>
		<xsl:if test="ts:LoopIndex">
			Loop Index: 
			<span style="color:brown">
				<xsl:call-template name="AddDatumValue">
					<xsl:with-param name="datumNode" select="ts:LoopIndex"/>
				</xsl:call-template>
			</span>
			<br/>
		</xsl:if>
	</xsl:template>
	<xsl:template name="IsAttributes">
		<xsl:param name="itemName"/>
		<xsl:choose>
			<xsl:when test="contains($itemName, '.')">
				<xsl:choose>
					<xsl:when test="substring($itemName, string-length($itemName) - 10) = '.Attributes'">true</xsl:when>
					<xsl:otherwise>false</xsl:otherwise>
				</xsl:choose>
			</xsl:when>
			<xsl:otherwise>false</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<xsl:template name="AddSequenceCallStepName">
		<xsl:param name="userDefinedTypeAttrValue"/>
		<xsl:variable name="sequenceCallStepNameWithQuotes" select="substring-after($userDefinedTypeAttrValue, 'SequenceCallStepName = ')"/>
		<xsl:if test="$sequenceCallStepNameWithQuotes != ''">
			<xsl:variable name="seqCallStepName" select="substring($sequenceCallStepNameWithQuotes, 2, string-length($sequenceCallStepNameWithQuotes) - 2)"/>
			<b>
				<xsl:choose>
					<xsl:when test="$seqCallStepName = 'MainSequence Callback' ">
						<xsl:call-template name="ProcessMainSequenceCallback">
							<xsl:with-param name="seqCallStepName" select="$seqCallStepName"/>
						</xsl:call-template>
					</xsl:when>
					<xsl:otherwise>
						<xsl:value-of select="$seqCallStepName"/>
					</xsl:otherwise>
				</xsl:choose>
			</b>
		</xsl:if>
	</xsl:template>
	<xsl:template name="AddIndexedArrayValues">
		<xsl:param name="indexedArrayNode"/>
		<xsl:variable name="xsiType" select="$indexedArrayNode/@xsi:type"/>
		<table cellpadding="0" cellspacing="0" rules="all" width="25%" border="1">
			<tbody>
				<tr>
					<th width="15%" align="center">
						<span style="font-size:0.81em"> Element Position </span>
					</th>
					<th width="10%" align="center">
						<span style="font-size:0.81em"> Value </span>
					</th>
				</tr>
				<xsl:for-each select="$indexedArrayNode/c:Element">
					<tr>
						<td align="center">
							<span style="font-size:0.81em">
								<xsl:value-of select="@position"/>
							</span>
						</td>
						<xsl:variable name="WrapAttributeValue">
							<xsl:choose>
								<xsl:when test="$xsiType = 'c:stringArray' or $xsiType = 'c:binaryArray'">
									<xsl:value-of select="'normal'"/>
								</xsl:when>
								<xsl:otherwise><xsl:value-of select="'nowrap'"/></xsl:otherwise>
							</xsl:choose>
						</xsl:variable>
						<td align="center" style="white-space:{$WrapAttributeValue};">
							<span style="font-size:0.81em">
								<xsl:choose>
									<xsl:when test="$xsiType = 'c:octalArray'">
										<xsl:value-of select="concat('0c',@value)"/>
									</xsl:when>
									<xsl:when test="$xsiType = 'c:binaryArray'">
										<xsl:value-of select="concat('0b',@value)"/>
									</xsl:when>
									<xsl:when test="$xsiType = 'c:stringArray'">
										<xsl:if test="c:Value != ''">
											<xsl:value-of select="c:Value"/>
										</xsl:if>&#160;
									</xsl:when>
									<xsl:otherwise>
										<xsl:value-of select="@value"/>
									</xsl:otherwise>
								</xsl:choose>
							</span>
						</td>
					</tr>
				</xsl:for-each>
			</tbody>
		</table>
	</xsl:template>
	<xsl:template name="GetArrayTypeName">
		<xsl:param name="indexedArrayNode"/>
		<xsl:variable name="xsiType" select="$indexedArrayNode/@xsi:type"/>
		<xsl:choose>
			<xsl:when test="$xsiType = 'c:doubleArray'">Double Array</xsl:when>
			<xsl:when test="$xsiType = 'c:hexadecimalArray'">Hexadecimal Array</xsl:when>
			<xsl:when test="$xsiType = 'c:booleanArray'">Boolean Array</xsl:when>
			<xsl:when test="$xsiType = 'c:integerArray'">Integer Array</xsl:when>
			<xsl:when test="$xsiType = 'c:unsignedIntegerArray'">Unsigned Integer Array</xsl:when>
			<xsl:when test="$xsiType = 'c:octalArray'">Octal Array</xsl:when>
			<xsl:when test="$xsiType = 'c:stringArray'">String Array</xsl:when>
			<xsl:when test="$xsiType = 'c:binaryArray'">Binary Array</xsl:when>
		</xsl:choose>
	</xsl:template>
	<xsl:template name="GetDatumTypeName">
		<xsl:param name="datumNode"/>
		<xsl:variable name="xsiType" select="$datumNode/@xsi:type"/>
		<xsl:choose>
			<xsl:when test="$xsiType = 'c:double'">Double</xsl:when>
			<xsl:when test="$xsiType = 'c:hexadecimal'">Hexadecimal</xsl:when>
			<xsl:when test="$xsiType = 'c:boolean'">Boolean</xsl:when>
			<xsl:when test="$xsiType = 'c:integer'">Integer</xsl:when>
			<xsl:when test="$xsiType = 'c:unsignedInteger'">Unsigned Integer</xsl:when>
			<xsl:when test="$xsiType = 'c:octal'">Octal</xsl:when>
			<xsl:when test="$xsiType = 'c:string'">String</xsl:when>
			<xsl:when test="$xsiType = 'c:binary'">Binary</xsl:when>
			<xsl:when test="$xsiType = 'ts:NI_TDMSReference'">TDMSReference</xsl:when>
			<xsl:when test="$xsiType = 'ts:NI_HyperlinkPath'">Hyperlink</xsl:when>
		</xsl:choose>
	</xsl:template>
	<xsl:template name="AddDatumValue">
		<xsl:param name="datumNode"/>
		<xsl:variable name="xsiType" select="$datumNode/@xsi:type"/>
		<xsl:variable name="unit">
			<xsl:call-template name="GetUnit">
				<xsl:with-param name="node" select="$datumNode"/>
			</xsl:call-template>
		</xsl:variable>
		<xsl:choose>
			<xsl:when test="$xsiType = 'c:binary'">
				<xsl:value-of select="concat('0b',$datumNode/@value)"/>&#160;<xsl:value-of select="$unit"/>
			</xsl:when>
			<xsl:when test="$xsiType = 'c:octal'">
				<xsl:value-of select="concat('0c',$datumNode/@value)"/>&#160;<xsl:value-of select="$unit"/>
			</xsl:when>
			<xsl:when test="$xsiType = 'c:boolean'">
				<xsl:value-of select="$datumNode/@value"/>
			</xsl:when>
			<xsl:when test="$xsiType = 'c:string'">
				<xsl:variable name="datumName">
					<xsl:choose>
						<xsl:when test="../@name">
							<xsl:value-of select="../@name"/>
						</xsl:when>
						<xsl:when test="../../@ID">
							<xsl:value-of select="../../@ID"/>
						</xsl:when>
					</xsl:choose>
				</xsl:variable>
				<!-- Verifies whether its step 'ReportText' -->
				<xsl:variable name="isReportText">
					<xsl:choose>
						<xsl:when test="$datumName='ReportText' and @xsi:type='c:string'">
							<xsl:choose>
								<xsl:when test="../../@ID and local-name(../../preceding-sibling::*[1])!='TestResult'">
									<xsl:text>True</xsl:text>
								</xsl:when>
								<xsl:when test="../@name and count(../preceding-sibling::*)=0">
									<xsl:text>True</xsl:text>
								</xsl:when>
								<xsl:otherwise>
									<xsl:text>False</xsl:text>
								</xsl:otherwise>
							</xsl:choose>
						</xsl:when>
						<xsl:otherwise>
							<xsl:text>False</xsl:text>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:variable>
				<xsl:choose>
					<xsl:when test="$datumNode/c:Value != ''">
						<xsl:choose>
							<xsl:when test="$isReportText='False'">
								<xsl:value-of select="$datumNode/c:Value"/>
							</xsl:when>
							<xsl:otherwise>
								<xsl:value-of select="$datumNode/c:Value" disable-output-escaping="yes"/>
							</xsl:otherwise>
						</xsl:choose>
					</xsl:when>
					<xsl:otherwise>''</xsl:otherwise>
				</xsl:choose>
			</xsl:when>
			<xsl:when test="$xsiType = 'ts:NI_HyperlinkPath'">
				<xsl:choose>
					<xsl:when test="$datumNode/c:Value = ''">''</xsl:when>
					<xsl:otherwise>
						<a>
							<xsl:attribute name="href"><xsl:value-of select="$datumNode/c:Value"/></xsl:attribute>
							<xsl:value-of select="translate($datumNode/c:Value,' ','&#160;')"/>
						</a>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:when>
			<xsl:otherwise>
				<span style="white-space:nowrap;"><xsl:value-of select="$datumNode/@value"/>&#160;<xsl:value-of select="$unit"/></span>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<xsl:template name="GetOutcome">
		<xsl:param name="outcomeNode"/>
		<b>
			<xsl:choose>
				<xsl:when test="$outcomeNode/@qualifier">
					<xsl:value-of select="$outcomeNode/@qualifier"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="$outcomeNode/@value"/>
				</xsl:otherwise>
			</xsl:choose>
		</b>
	</xsl:template>
	<!-- Template to add instances of NI_TDMSReference type-->
	<xsl:template name="ProcessTDMSReference">
		<xsl:param name="objectPath" select="''"/>
		<xsl:param name="stepNode"/>
		<xsl:param name="dataNode"/>
		<xsl:param name="isProcessingParameter" select="false()"/>
		<xsl:variable name="putAsFlatData" select="user:GetFlatDataState()"/>
		<!-- Except File, if all sub-properties is empty, then NI_TDMSReference should be displayed in single line -->
		<xsl:variable name="shouldCreateContainerIfStringLengthGreaterThanZero">
			<xsl:for-each select="./c:Item[@name!='File']">
				<xsl:value-of select="./c:Datum/c:Value"/>
			</xsl:for-each>
		</xsl:variable>
		<!-- Check if the container has any attributes to be processed -->
		<xsl:variable name="hasAttributes">
			<xsl:choose>
				<xsl:when test="$putAsFlatData='true'">
					<xsl:call-template name="HasAttributes">
						<xsl:with-param name="node" select="$dataNode"/>
						<xsl:with-param name="objectPath" select="$objectPath"/>
					</xsl:call-template>
				</xsl:when>
				<xsl:otherwise>
					<xsl:choose>
						<xsl:when test="$isProcessingParameter = true()">
							<xsl:call-template name="HasAttributes">
								<xsl:with-param name="node" select="$stepNode"/>
								<xsl:with-param name="objectPath" select="$objectPath"/>
							</xsl:call-template>
						</xsl:when>
						<xsl:otherwise>
							<xsl:call-template name="HasAttributes">
								<xsl:with-param name="node" select="$dataNode/.."/>
								<xsl:with-param name="objectPath" select="$objectPath"/>
							</xsl:call-template>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<!-- If NI_TDMSReference is displayed in multiple lines, then display non-empty sub-properties and process its attributes otherwise display value of File as either hyperlink or string -->
		<xsl:choose>
			<xsl:when test="$putAsFlatData='true'">
				<xsl:choose>
					<xsl:when test="string-length($shouldCreateContainerIfStringLengthGreaterThanZero) > 0">
						<!-- Process the attributes of the container -->
						<xsl:if test="$hasAttributes='true'">
								<xsl:call-template name="ProcessAttributes">
									<xsl:with-param name="attributeNode" select="$dataNode/c:Collection/c:Item[@name = concat($objectPath, '.Attributes')][1]"/>
									<xsl:with-param name="stepNode" select="$dataNode/.."/>
									<xsl:with-param name="objectPath" select="concat($objectPath, '.Attributes')"/>
								</xsl:call-template>
						</xsl:if>
						<!-- Process non-empty subproperties of the container -->
						<xsl:for-each select="./c:Item[@name = 'File'] | ./c:Item[./c:Datum/c:Value != '']">
							<span style="font-weight:bold;">
								<xsl:value-of select="$objectPath"/>.<xsl:value-of select="@name"/> : 
					</span>
							<xsl:apply-templates>
								<xsl:with-param name="DataNode" select="$dataNode"/>
								<xsl:with-param name="ObjectPath" select="concat($objectPath,'.',@name)"/>
							</xsl:apply-templates>
						</xsl:for-each>
					</xsl:when>
					<xsl:otherwise>
						<!-- Insert the typename and value for the File sub-property, and process the attributes of container -->
						<span style="font-weight:bold;">
							<xsl:value-of select="$objectPath"/>
							<xsl:if test="@name!=''">
							.<xsl:value-of select="@name"/>
							</xsl:if> : 
						</span>
						<xsl:call-template name="AddDatumValue">
							<xsl:with-param name="datumNode" select="c:Item[@name = 'File']/c:Datum"/>
						</xsl:call-template>
						<br/>
						<xsl:if test="$hasAttributes='true'">
							<xsl:call-template name="ProcessAttributes">
								<xsl:with-param name="attributeNode" select="$dataNode/c:Collection/c:Item[@name = concat($objectPath, '.Attributes')][1]"/>
								<xsl:with-param name="stepNode" select="$dataNode"/>
								<xsl:with-param name="objectPath" select="concat($objectPath, '.Attributes')"/>
							</xsl:call-template>
						</xsl:if>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:when>
			<xsl:otherwise>
				<xsl:choose>
					<xsl:when test="string-length($shouldCreateContainerIfStringLengthGreaterThanZero) > 0">
						<!-- Process the attributes of the container -->
						<xsl:if test="$hasAttributes='true'">
							<xsl:choose>
								<xsl:when test="$isProcessingParameter = false()">
									<xsl:call-template name="ProcessAttributes">
										<xsl:with-param name="attributeNode" select="$dataNode/c:Collection/c:Item[@name = concat($objectPath, '.Attributes')][1]"/>
										<xsl:with-param name="stepNode" select="$dataNode/.."/>
										<xsl:with-param name="objectPath" select="concat($objectPath, '.Attributes')"/>
									</xsl:call-template>
								</xsl:when>
								<xsl:otherwise>
									<xsl:call-template name="ProcessAttributes">
										<xsl:with-param name="attributeNode" select="$stepNode/n1:Data/c:Collection/c:Item[@name = concat($objectPath, '.Attributes')][1]"/>
										<xsl:with-param name="stepNode" select="$stepNode"/>
										<xsl:with-param name="objectPath" select="concat($objectPath, '.Attributes')"/>
									</xsl:call-template>
								</xsl:otherwise>
							</xsl:choose>
						</xsl:if>
						<!-- Process non-empty subproperties of the container -->
						<xsl:for-each select="./c:Item[@name = 'File'] | ./c:Item[./c:Datum/c:Value != '']">
							<ul>
								<li>Item Name: <span style="color:brown">
										<xsl:value-of select="@name"/>
									</span>
									<!-- Pass correct parameters based on wether processing Parameter/TestResult or Data or Attributes -->
									<xsl:choose>
										<xsl:when test="$isProcessingParameter = true()">
											<xsl:apply-templates mode="Parameter">
												<xsl:with-param name="StepNode" select="$stepNode"/>
												<xsl:with-param name="ObjectPath" select="concat($objectPath,'.',@name)"/>
											</xsl:apply-templates>
										</xsl:when>
										<xsl:otherwise>
											<xsl:apply-templates>
												<xsl:with-param name="DataNode" select="$dataNode"/>
												<xsl:with-param name="ObjectPath" select="concat($objectPath,'.',@name)"/>
											</xsl:apply-templates>
										</xsl:otherwise>
									</xsl:choose>
								</li>
							</ul>
						</xsl:for-each>
					</xsl:when>
					<xsl:otherwise>
						<!-- Insert the typename and value for the File sub-property, and process the attributes of container -->
						<xsl:variable name="objectTypeStr">
							<xsl:choose>
								<xsl:when test="$isProcessingParameter = true()">Parameter Type: </xsl:when>
								<xsl:otherwise>TestResult Type: </xsl:otherwise>
							</xsl:choose>
						</xsl:variable>
						<xsl:variable name="objectValueStr">
							<xsl:choose>
								<xsl:when test="$isProcessingParameter = true()">Parameter Value: </xsl:when>
								<xsl:otherwise>TestResult Value: </xsl:otherwise>
							</xsl:choose>
						</xsl:variable>
						<ul class="DummyUL">
							<li class="SupportDummyUL">
								<xsl:value-of select="$objectTypeStr"/>
								<xsl:call-template name="GetDatumTypeName">
									<xsl:with-param name="datumNode" select="."/>
								</xsl:call-template>
							</li>
							<li class="SupportDummyUL">
								<xsl:value-of select="$objectValueStr"/>
								<xsl:call-template name="AddDatumValue">
									<xsl:with-param name="datumNode" select="c:Item[@name = 'File']/c:Datum"/>
								</xsl:call-template>
							</li>
						</ul>
						<xsl:if test="$hasAttributes='true'">
							<xsl:choose>
								<xsl:when test="$isProcessingParameter = false()">
									<xsl:call-template name="ProcessAttributes">
										<xsl:with-param name="attributeNode" select="$dataNode/c:Collection/c:Item[@name = concat($objectPath, '.Attributes')][1]"/>
										<xsl:with-param name="stepNode" select="$dataNode/.."/>
										<xsl:with-param name="objectPath" select="concat($objectPath, '.Attributes')"/>
									</xsl:call-template>
								</xsl:when>
								<xsl:otherwise>
									<xsl:call-template name="ProcessAttributes">
										<xsl:with-param name="attributeNode" select="$stepNode/n1:Data/c:Collection/c:Item[@name = concat($objectPath, '.Attributes')][1]"/>
										<xsl:with-param name="stepNode" select="$stepNode"/>
										<xsl:with-param name="objectPath" select="concat($objectPath, '.Attributes')"/>
									</xsl:call-template>
								</xsl:otherwise>
							</xsl:choose>
						</xsl:if>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<!-- Template to add attributes of NI_TDMSReference type-->
	<xsl:template name="ProcessTDMSReferenceAttribute">
		<xsl:param name="objectPath" select="''"/>
		<xsl:param name="stepNode"/>
		<!-- Except File, if all sub-properties is empty, then NI_TDMSReference should be displayed in single line -->
		<xsl:variable name="shouldCreateContainerIfStringLengthGreaterThanZero">
			<xsl:for-each select="./c:Item[@name!='File']">
				<xsl:value-of select="./c:Collection/c:Item[1]/c:Datum/c:Value"/>
			</xsl:for-each>
		</xsl:variable>
		<!-- If NI_TDMSReference is displayed in multiple lines, then display non-empty sub-properties and process its attributes otherwise display value of File as either hyperlink or string -->
		<xsl:choose>
			<xsl:when test="string-length($shouldCreateContainerIfStringLengthGreaterThanZero) > 0">
				<!-- Process non-empty subproperties of the container -->
				<xsl:for-each select="./c:Item[@name = 'File']/c:Collection/c:Item[1] | ./c:Item/c:Collection/c:Item[1][./c:Datum/c:Value != '']">
					<ul>
						<li>Attribute Name:
							<span style="color:brown">
								<xsl:value-of select="substring(@name,0,string-length(@name) - 5)"/>
							</span>
							<xsl:apply-templates mode="Attributes">
								<xsl:with-param name="StepNode" select="$stepNode"/>
								<xsl:with-param name="ObjectPath" select="$objectPath"/>
							</xsl:apply-templates>
						</li>
					</ul>
				</xsl:for-each>
			</xsl:when>
			<xsl:otherwise>
				<!-- Insert the typename and value for the File sub-property, and process the attributes of container -->
				<li>Attribute Type: <xsl:call-template name="GetDatumTypeName">
						<xsl:with-param name="datumNode" select="."/>
					</xsl:call-template>
				</li>
				<li>Attribute Value: <xsl:call-template name="AddDatumValue">
						<xsl:with-param name="datumNode" select="c:Item[@name = 'File']/c:Collection/c:Item[1]/c:Datum"/>
					</xsl:call-template>
				</li>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<!--This method is used to check if atleast one of the attributes in the collection is marked to be included in the report-->
	<xsl:template name="CheckIfIncludeInReportIsPresentForAttributes">
		<xsl:param name="attributeNode"/>
		<xsl:variable name="result">
			<xsl:for-each select="$attributeNode/c:Collection/c:Item">
				<xsl:variable name="shouldIncludeInReport">
					<xsl:call-template name="CheckIfIncludeFlagIsSet">
						<xsl:with-param name="flag" select="c:Collection/c:Item[2]/c:Datum/@value"/>
					</xsl:call-template>
				</xsl:variable>
				<xsl:choose>
					<xsl:when test="$shouldIncludeInReport='true'">true</xsl:when>
					<xsl:otherwise>
						<xsl:choose>
							<xsl:when test="c:Collection/c:Item[1]/c:Collection">
								<xsl:variable name="includeInReport">
									<xsl:call-template name="CheckIfIncludeInReportIsPresentForAttributes">
										<xsl:with-param name="attributeNode" select="c:Collection/c:Item[1]"/>
									</xsl:call-template>
								</xsl:variable>
								<xsl:value-of select="$includeInReport"/>
							</xsl:when>
							<xsl:otherwise>false</xsl:otherwise>
						</xsl:choose>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:for-each>
		</xsl:variable>
		<xsl:choose>
			<xsl:when test="contains($result,'true')">true</xsl:when>
			<xsl:otherwise>false</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<!--This method is used to check if a particular attribute is marked to be included in the report-->
	<xsl:template name="CheckIfIncludeFlagIsSet">
		<xsl:param name="flag"/>
		<xsl:variable name="includeFlagHexDigit">
			<xsl:value-of select="substring($flag,string-length($flag)-3,1)"/>
		</xsl:variable>
		<xsl:choose>
			<xsl:when test="$includeFlagHexDigit='2' or $includeFlagHexDigit='3' or $includeFlagHexDigit='6' or $includeFlagHexDigit='7' or $includeFlagHexDigit='a' or $includeFlagHexDigit='b' or $includeFlagHexDigit='e' or $includeFlagHexDigit='f' or $includeFlagHexDigit='A' or $includeFlagHexDigit='B' or $includeFlagHexDigit='E' or $includeFlagHexDigit='F'">true</xsl:when>
			<xsl:otherwise>false</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
</xsl:stylesheet>
