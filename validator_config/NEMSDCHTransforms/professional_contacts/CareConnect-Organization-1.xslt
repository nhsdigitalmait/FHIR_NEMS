<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:fhir="http://hl7.org/fhir" xmlns:xs="http://www.w3.org/2001/XMLSchema" xpath-default-namespace="http://hl7.org/fhir">
	<xsl:output method="html" encoding="UTF-8" indent="yes" omit-xml-declaration="yes"/>
	<xsl:include href="business_rules_reporting_templates.xslt"/>
	<xsl:variable name="spec" select="'National Events Management Service (NEMS) 2.2.1-Beta'"/>
	<xsl:variable name="message" select="'Professional Contacts'"/>
	<xsl:variable name="resource_name" select="'CareConnect-Organization-1'"/>
	<xsl:variable name="resource_path" select="//Organization"/>
	<xsl:variable name="rule1" select="'1: identifier	1..*	The organization ODS code identifier SHALL be included within the odsOrganizationCode identifier slice.'"/>
	<xsl:variable name="rule2" select="'2: name	1..1	A human readable name for the organization SHALL be included in the organization resource.'"/>
	<xsl:variable name="rule3" select="'3:telecom	0..*	Where the Organisation resource represents the organisation responsible for the EpisodeOfCare, referenced from the EpisodeOfCare resource managingOrganization element, the Organisation resource MUST include contact details for use by subscribers in relation to communications about this episode of care.'"/>
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
				<xsl:call-template name="rule3">
					<xsl:with-param name="ruletext" select="$rule3"/>
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
	<xsl:template name="rule3">
		<xsl:param name="ruletext"/>
		<xsl:variable name="responsibleorg_id" select="tokenize(//EpisodeOfCare/managingOrganization/reference/@value,':')[last()]"/>
		<xsl:variable name="curr_org_id" select="./id/@value"/>
		<xsl:variable name="responsibleorg_bool" select="boolean($responsibleorg_id = $curr_org_id)"/>
		<xsl:choose>
			<xsl:when test="($responsibleorg_bool and ./telecom/value/@value)">
				<xsl:for-each select="./telecom">
					<xsl:variable name="telecom_system" select="./system/@value"/>
					<xsl:variable name="telecom_value" select="./value/@value"/>
					<xsl:call-template name="reportPass">
						<xsl:with-param name="testString" select="$rule3"/>
						<xsl:with-param name="resultString" select="concat('telecom infomation is included for Organization resource responsible for the EpisodeOfCare, (id: ', $responsibleorg_id, ' system: ',$telecom_system, ' value: ', $telecom_value, ')')"/>
					</xsl:call-template>
				</xsl:for-each>
			</xsl:when>
			<xsl:when test="($responsibleorg_bool and not(./telecom/value/@value))">
				<xsl:call-template name="reportFail">
					<xsl:with-param name="testString" select="$rule3"/>
					<xsl:with-param name="resultString" select="concat('telecom infomation is not included for Organization resource responsible for the EpisodeOfCare, (id ', $responsibleorg_id, ')')"/>
				</xsl:call-template>
			</xsl:when>
		</xsl:choose>
	</xsl:template>
</xsl:stylesheet>
