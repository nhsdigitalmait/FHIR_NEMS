<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:fhir="http://hl7.org/fhir" xmlns:xs="http://www.w3.org/2001/XMLSchema" xpath-default-namespace="http://hl7.org/fhir">
	<xsl:output method="html" encoding="UTF-8" indent="yes" omit-xml-declaration="yes"/>
	<xsl:include href="business_rules_reporting_templates.xslt"/>
	<xsl:variable name="spec" select="'National Events Management Service (NEMS) 2.2.1-Beta'"/>
	<xsl:variable name="message" select="'Professional Contacts'"/>
	<xsl:variable name="resource_name" select="'CareConnect-Patient-1'"/>
	<xsl:variable name="resource_path" select="//Patient"/>
	<xsl:variable name="rule1" select="'1: identifier	1..1	Patient NHS Number identifier SHALL be included within the nhsNumber identifier slice.'"/>
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
		<xsl:variable name="nhsno_bool" select="boolean(./identifier[system/@value='https://fhir.nhs.uk/Id/nhs-number']/value/@value)"/>
		<xsl:variable name="nhsno" select="./identifier[system/@value='https://fhir.nhs.uk/Id/nhs-number']/value/@value"/>
		<xsl:choose>
			<xsl:when test="not($nhsno_bool)">
				<xsl:call-template name="reportFail">
					<xsl:with-param name="testString" select="$rule1"/>
					<xsl:with-param name="resultString" select="'NHS number not included'"/>
				</xsl:call-template>
			</xsl:when>
			<xsl:when test="($nhsno_bool)">
				<xsl:call-template name="reportPass">
					<xsl:with-param name="testString" select="$rule1"/>
					<xsl:with-param name="resultString" select="concat($nhsno, ' - NHS number is included')"/>
				</xsl:call-template>
			</xsl:when>
		</xsl:choose>
	</xsl:template>
</xsl:stylesheet>
