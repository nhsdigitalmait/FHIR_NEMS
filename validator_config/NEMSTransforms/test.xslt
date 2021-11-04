<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:fn="http://www.w3.org/2005/xpath-functions" xpath-default-namespace="http://hl7.org/fhir">
	<xsl:output method="html" encoding="UTF-8" indent="yes" omit-xml-declaration="yes"/>
	<xsl:include href="reporting_templates.xslt"/>
	<xsl:include href="referencing_templates.xslt"/>
	<xsl:template match="/">
		<table border="0">
			<!-- Load reference file-->
			<xsl:variable name="supportedevents" select="document('./SupportedEvents2.xml')"/>
			<!-- Get the counts of elements with business rules -->
	
<xsl:for-each select="//entry/resource/*[name()='Parameters']">
	
			<xsl:variable name="requestId_count" select="count(./parameter/name[@value='requestId'])"/>
	

				<tr>
					<td style="color:#008000">
						<xsl:text>Parameters Resouce Index: </xsl:text>
						<xsl:value-of select="./position()"/>

					</td>
				</tr>


<!--Check the count of each component against the cardinality values in the reference file-->
			<xsl:call-template name="cardinality_check">
				<xsl:with-param name="count" select="$requestId_count"/>
				<xsl:with-param name="ref_xpath" select="$supportedevents//CDS/parameters/elements/element"/>
				<xsl:with-param name="ref_attribute" select="'requestId'"/>
			</xsl:call-template>
			
</xsl:for-each>
			
		</table>
	</xsl:template>
</xsl:stylesheet>
