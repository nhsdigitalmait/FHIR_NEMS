<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:fn="http://www.w3.org/2005/xpath-functions" xpath-default-namespace="http://hl7.org/fhir">
	<xsl:output method="html" encoding="UTF-8" indent="yes" omit-xml-declaration="yes"/>
	<xsl:template name="writeHeader">
		<tr>
			<td style="color:#008000">
				<xsl:text>BUSINESS RULES defined in '</xsl:text>
				<xsl:value-of select="$spec"/>
				<xsl:text>' for '</xsl:text>
				<xsl:value-of select="$message"/>
				<xsl:text>' message '</xsl:text>
				<xsl:value-of select="$resource_name"/>
				<xsl:text>' resource.</xsl:text>
			</td>
		</tr>
	</xsl:template>
	<xsl:template name="reportPass">
		<xsl:param name="testString"/>
		<xsl:param name="resultString"/>
		<tr>
			<td style="color:#008000">
				<xsl:text>Rule</xsl:text>
				<xsl:value-of select="$testString"/>
			</td>
		</tr>
		<tr>
			<td style="color:#008000">
				<xsl:text>PASS: </xsl:text>
				<xsl:value-of select="$resultString"/>
			</td>
		</tr>
	</xsl:template>
	<xsl:template name="reportFail">
		<xsl:param name="testString"/>
		<xsl:param name="resultString"/>
		<tr>
			<td style="color:#900000">
				<xsl:text>Rule</xsl:text>
				<xsl:value-of select="$testString"/>
			</td>
		</tr>
		<tr>
			<td style="color:#900000">
				<xsl:text>FAIL: </xsl:text>
				<xsl:value-of select="$resultString"/>
			</td>
		</tr>
	</xsl:template>
	<xsl:template name="reportInformation">
		<xsl:param name="testString"/>
		<xsl:param name="resultString"/>
		<tr>
			<td style="color:#008080">
				<xsl:text>Rule</xsl:text>
				<xsl:value-of select="$testString"/>
			</td>
		</tr>
		<tr>
			<td style="color:#008080">
				<xsl:text>INFORMATION: </xsl:text>
				<xsl:value-of select="$resultString"/>
			</td>
		</tr>
	</xsl:template>
	<xsl:template name="reportWarning">
		<xsl:param name="testString"/>
		<xsl:param name="resultString"/>
		<tr>
			<td style="color:#ffa700">
				<xsl:text>Rule</xsl:text>
				<xsl:value-of select="$testString"/>
			</td>
		</tr>
		<tr>
			<td style="color:#ffa700">
				<xsl:text>WARNING: </xsl:text>
				<xsl:value-of select="$resultString"/>
			</td>
		</tr>
	</xsl:template>
</xsl:stylesheet>
