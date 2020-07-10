<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:fhir="http://hl7.org/fhir" xmlns:xs="http://www.w3.org/2001/XMLSchema" xpath-default-namespace="http://hl7.org/fhir">
	<xsl:output method="html" encoding="UTF-8" indent="yes" omit-xml-declaration="yes"/>
	<xsl:include href="business_rules_reporting_templates.xslt"/>
	<xsl:variable name="spec" select="'National Events Management Service (NEMS) 2.2.1-Beta'"/>
	<xsl:variable name="message" select="'Vaccinations'"/>
	<xsl:variable name="resource_name" select="'CareConnect-Organization-1'"/>
	<xsl:variable name="resource_path" select="//Organization"/>
	<xsl:variable name="rule1" select="'1: identifier	1..*	The organization ODS code identifier SHALL be included within the odsOrganizationCode identifier slice.'"/>
	<xsl:variable name="rule2" select="'2: name	1..1	A human readable name for the organization SHALL be included in the organization resource.'"/>
	<xsl:template match="/">
		<table border="0">
			<xsl:call-template name="writeHeader"/>
			<xsl:for-each select="$resource_path">
				<xsl:call-template name="rule1">
					<xsl:with-param name="ruletext" select="$rule1"/>
				</xsl:call-template>
				<xsl:call-template name="rule2">
					<xsl:with-param name="ruletext" select="$rule2"/>
				</xsl:call-template>
			</xsl:for-each>
		</table>
	</xsl:template>
	<xsl:template name="rule1">
		<xsl:param name="ruletext"/>
		<xsl:variable name="odscode_bool" select="boolean(./identifier[system/@value='https://fhir.nhs.uk/Id/ods-organization-code']/value/@value)"/>
		<xsl:variable name="odscode" select="./identifier[system/@value='https://fhir.nhs.uk/Id/ods-organization-code']/value/@value"/>
		<xsl:choose>
			<xsl:when test="not($odscode_bool)">
				<xsl:call-template name="reportFail">
					<xsl:with-param name="testString" select="$rule1"/>
					<xsl:with-param name="resultString" select="'ODS Code not included'"/>
				</xsl:call-template>
			</xsl:when>
			<xsl:when test="($odscode_bool)">
				<xsl:call-template name="reportPass">
					<xsl:with-param name="testString" select="$rule1"/>
					<xsl:with-param name="resultString" select="concat($odscode, ' - ODSCode is included')"/>
				</xsl:call-template>
			</xsl:when>
		</xsl:choose>
	</xsl:template>
	<xsl:template name="rule2">
		<xsl:param name="ruletext"/>
		<xsl:variable name="name_bool" select="boolean(./name/@value)"/>
		<xsl:variable name="name" select="./name/@value"/>
		<xsl:choose>
			<xsl:when test="not($name_bool)">
				<xsl:call-template name="reportFail">
					<xsl:with-param name="testString" select="$rule2"/>
					<xsl:with-param name="resultString" select="'Name not included'"/>
				</xsl:call-template>
			</xsl:when>
			<xsl:when test="($name_bool)">
				<xsl:call-template name="reportPass">
					<xsl:with-param name="testString" select="$rule2"/>
					<xsl:with-param name="resultString" select="concat($name, ' - Name is included')"/>
				</xsl:call-template>
			</xsl:when>
		</xsl:choose>
	</xsl:template>
</xsl:stylesheet>
