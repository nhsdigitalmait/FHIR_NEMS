<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:fhir="http://hl7.org/fhir" xmlns:xs="http://www.w3.org/2001/XMLSchema" xpath-default-namespace="http://hl7.org/fhir">
	<xsl:output method="html" encoding="UTF-8" indent="yes" omit-xml-declaration="yes"/>
	<xsl:include href="business_rules_reporting_templates.xslt"/>
	<xsl:variable name="spec" select="'National Events Management Service (NEMS) 2.2.1-Beta'"/>
	<xsl:variable name="message" select="'Vaccinations'"/>
	<xsl:variable name="resource_name" select="'CareConnect-Location-1'"/>
	<xsl:variable name="resource_path" select="//Location"/>
	<xsl:variable name="rule1" select="'1: identifier	0..*	Where available the ODS Site Code slice should be populated.'"/>
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
		<xsl:variable name="odscode_bool" select="boolean(./identifier[system/@value='https://fhir.nhs.uk/Id/ods-site-code']/value/@value)"/>
		<xsl:variable name="odscode" select="./identifier[system/@value='https://fhir.nhs.uk/Id/ods-site-code']/value/@value"/>
		<xsl:choose>
			<xsl:when test="not($odscode_bool)">
				<xsl:call-template name="reportWarning">
					<xsl:with-param name="testString" select="$rule1"/>
					<xsl:with-param name="resultString" select="'ODS Site Code identifier not found, where available this should be included'"/>
				</xsl:call-template>
			</xsl:when>
			<xsl:when test="($odscode_bool)">
				<xsl:call-template name="reportPass">
					<xsl:with-param name="testString" select="$rule1"/>
					<xsl:with-param name="resultString" select="concat($odscode, ' - ODSCode Site Code identifier is included')"/>
				</xsl:call-template>
			</xsl:when>
		</xsl:choose>
	</xsl:template>
</xsl:stylesheet>
