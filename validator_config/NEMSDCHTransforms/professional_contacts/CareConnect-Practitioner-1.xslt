<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:fhir="http://hl7.org/fhir" xmlns:xs="http://www.w3.org/2001/XMLSchema" xpath-default-namespace="http://hl7.org/fhir">
	<xsl:output method="html" encoding="UTF-8" indent="yes" omit-xml-declaration="yes"/>
	<xsl:include href="business_rules_reporting_templates.xslt"/>
	<xsl:variable name="spec" select="'National Events Management Service (NEMS) 2.2.1-Beta'"/>
	<xsl:variable name="message" select="'Professional Contacts'"/>
	<xsl:variable name="resource_name" select="'CareConnect-Practitioner-1'"/>
	<xsl:variable name="resource_path" select="//Practitioner"/>
	<xsl:variable name="rule1" select="' No Business Rules Defined'"/>

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
		<xsl:call-template name="reportPass">
			<xsl:with-param name="testString" select="$rule1"/>
			<xsl:with-param name="resultString" select="'No additional validation executed.'"/>
		</xsl:call-template>

	</xsl:template>
</xsl:stylesheet>
