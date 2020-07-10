<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:fhir="http://hl7.org/fhir" xmlns:xs="http://www.w3.org/2001/XMLSchema" xpath-default-namespace="http://hl7.org/fhir">
	<xsl:output method="html" encoding="UTF-8" indent="yes" omit-xml-declaration="yes"/>
	<xsl:include href="business_rules_reporting_templates.xslt"/>
	<xsl:variable name="spec" select="'National Events Management Service (NEMS) 2.2.1-Beta'"/>
	<xsl:variable name="message" select="'Professional Contacts'"/>
	<xsl:variable name="resource_name" select="'Bundle'"/>
	<xsl:variable name="resource_path" select="/Bundle"/>
	<xsl:variable name="rule1" select="'1: type	1..1	Fixed value: message'"/>
	<xsl:template match="/">
		<table border="0">
			<xsl:call-template name="writeHeader"/>
			<xsl:for-each select="$resource_path">
				<xsl:call-template name="rule1">
					<xsl:with-param name="ruletext" select="$rule1"/>
				</xsl:call-template>
			</xsl:for-each>
		</table>
	</xsl:template>
	<xsl:template name="rule1">
		<xsl:param name="ruletext"/>
		<xsl:variable name="output" select="./type/@value"/>
		<xsl:choose>
			<xsl:when test="(not(./type/@value) or not(./type))">
				<xsl:call-template name="reportFail">
					<xsl:with-param name="testString" select="$rule1"/>
					<xsl:with-param name="resultString" select="'Bundle type not included'"/>
				</xsl:call-template>
			</xsl:when>
			<xsl:when test="(./type/@value = 'message')">
				<xsl:call-template name="reportPass">
					<xsl:with-param name="testString" select="$rule1"/>
					<xsl:with-param name="resultString" select="concat('Bundle type is ',$output)"/>
				</xsl:call-template>
			</xsl:when>
			<xsl:when test="(not(./type/@value = 'message'))">
				<xsl:call-template name="reportFail">
					<xsl:with-param name="testString" select="$rule1"/>
					<xsl:with-param name="resultString" select="concat('Bundle type is ',$output)"/>
				</xsl:call-template>
			</xsl:when>
		</xsl:choose>
	</xsl:template>
</xsl:stylesheet>
