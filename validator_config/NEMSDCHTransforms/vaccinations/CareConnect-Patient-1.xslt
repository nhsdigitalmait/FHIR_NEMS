<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:fhir="http://hl7.org/fhir" xmlns:xs="http://www.w3.org/2001/XMLSchema" xpath-default-namespace="http://hl7.org/fhir">
	<xsl:output method="html" encoding="UTF-8" indent="yes" omit-xml-declaration="yes"/>
	<xsl:include href="business_rules_reporting_templates.xslt"/>
	<xsl:variable name="spec" select="'National Events Management Service (NEMS) 2.2.1-Beta'"/>
	<xsl:variable name="message" select="'Vaccinations'"/>
	<xsl:variable name="resource_name" select="'CareConnect-Patient-1'"/>
	<xsl:variable name="resource_path" select="//Patient"/>
	<xsl:variable name="rule1" select="'1: identifier	1..1	Patient NHS Number identifier SHALL be included within the nhsNumber identifier slice.'"/>
	<xsl:variable name="rule2" select="'2: name (official)	1..1	Patients name as registered on PDS, included within the resource as the official name element slice.'"/>
	<xsl:variable name="rule3" select="'3: birthDate	1..1	The patients date of birth.'"/>
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
	<xsl:template name="rule2">
		<xsl:param name="ruletext"/>
		<xsl:variable name="officialname_bool" select="boolean(./name[use/@value='official'])"/>
		<xsl:variable name="officialname_given" select="boolean(./name[use/@value='official'])"/>
		<xsl:variable name="officialname_family" select="boolean(./name[use/@value='official'])"/>
		<xsl:variable name="officialname" select="concat(./name[use/@value='official']/given/@value,' ' , ./name[use/@value='official']/family/@value)"/>
		<xsl:choose>
			<xsl:when test="not($officialname_bool)">
				<xsl:call-template name="reportFail">
					<xsl:with-param name="testString" select="$rule2"/>
					<xsl:with-param name="resultString" select="'Official Name not included'"/>
				</xsl:call-template>
			</xsl:when>
			<xsl:when test="($officialname_bool)">
				<xsl:call-template name="reportPass">
					<xsl:with-param name="testString" select="$rule2"/>
					<xsl:with-param name="resultString" select="concat($officialname, ' - Offical name is included')"/>
				</xsl:call-template>
			</xsl:when>
		</xsl:choose>
	</xsl:template>
	<xsl:template name="rule3">
		<xsl:param name="ruletext"/>
		<xsl:variable name="birthDate_bool" select="boolean(./birthDate/@value)"/>
		<xsl:variable name="birthdate" select="./BirthDate/@value"/>
		<xsl:choose>
			<xsl:when test="not($birthDate_bool)">
				<xsl:call-template name="reportFail">
					<xsl:with-param name="testString" select="$rule3"/>
					<xsl:with-param name="resultString" select="'BirthDate not included'"/>
				</xsl:call-template>
			</xsl:when>
			<xsl:when test="($birthDate_bool)">
				<xsl:call-template name="reportPass">
					<xsl:with-param name="testString" select="$rule3"/>
					<xsl:with-param name="resultString" select="concat($birthdate, ' - BirthDate is included')"/>
				</xsl:call-template>
			</xsl:when>
		</xsl:choose>
	</xsl:template>
</xsl:stylesheet>
