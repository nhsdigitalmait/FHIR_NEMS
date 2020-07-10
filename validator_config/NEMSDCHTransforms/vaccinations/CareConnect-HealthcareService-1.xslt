<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:fhir="http://hl7.org/fhir" xmlns:xs="http://www.w3.org/2001/XMLSchema" xpath-default-namespace="http://hl7.org/fhir">
	<xsl:output method="html" encoding="UTF-8" indent="yes" omit-xml-declaration="yes"/>
	<xsl:include href="business_rules_reporting_templates.xslt"/>
	<xsl:variable name="spec" select="'National Events Management Service (NEMS) 2.2.1-Beta'"/>
	<xsl:variable name="message" select="'Vaccinations'"/>
	<xsl:variable name="resource_name" select="'CareConnect-HealthcareService-1'"/>
	<xsl:variable name="resource_path" select="//HealthcareService"/>
	<xsl:variable name="rule1" select="'1: providedBy	1..1	Reference to the organization who provides the healthcare service'"/>
	<xsl:variable name="rule2" select="'2: type	1..1	This will represent the type of service responsible for the event message. This will have a fixed value from the ValueSet CareConnect-CareSettingType-1'"/>
	<xsl:variable name="rule3" select="'3: specialty	1..1	The specialty SHALL be a value from the Specialty-1 value set'"/>
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
		<xsl:variable name="provby_ref" select="tokenize(./providedBy/reference/@value,':')[last()]"/>
		<xsl:variable name="orgref_bool" select="boolean(//Organization/id[@value=$provby_ref])"/>
		<xsl:choose>
			<xsl:when test="$orgref_bool">
				<xsl:call-template name="reportPass">
					<xsl:with-param name="testString" select="$rule1"/>
					<xsl:with-param name="resultString" select="concat($provby_ref, ' references the id of an Organization resource')"/>
				</xsl:call-template>
			</xsl:when>
			<xsl:when test="not($orgref_bool)">
				<xsl:call-template name="reportFail">
					<xsl:with-param name="testString" select="$rule1"/>
					<xsl:with-param name="resultString" select="concat($provby_ref, ' does not reference the id of an Organization resource')"/>
				</xsl:call-template>
			</xsl:when>
		</xsl:choose>
	</xsl:template>
	<xsl:template name="rule2">
		<xsl:param name="ruletext"/>
		<xsl:variable name="system" select="./type/coding/system/@value"/>
		<xsl:variable name="code" select="./type/coding/code/@value"/>
		<xsl:variable name="displayName" select="./type/coding/display/@value"/>
		<xsl:variable name="output" select="concat('MANUAL CHECK - Passthrough SNOMED valueset. Confirm ' , $code,' ', $displayName, ' is in CareConnect-CareSettingType-1 value set')"/>
		<xsl:call-template name="reportInformation">
			<xsl:with-param name="testString" select="$rule2"/>
			<xsl:with-param name="resultString" select="$output"/>
		</xsl:call-template>
	</xsl:template>
	<xsl:template name="rule3">
		<xsl:param name="ruletext"/>
		<xsl:variable name="specialty_bool" select="boolean(./specialty/coding[system/@value= 'https://fhir.nhs.uk/STU3/CodeSystem/Specialty-1']/code/@value)"/>
		<xsl:variable name="specialty_val" select="./specialty/coding[system/@value= 'https://fhir.nhs.uk/STU3/CodeSystem/Specialty-1']/code/@value"/>
		<xsl:variable name="specialty_disp" select="./specialty/coding[system/@value= 'https://fhir.nhs.uk/STU3/CodeSystem/Specialty-1']/display/@value"/>
		<xsl:variable name="specialty_ref" select="document('./CodeSystem-Specialty-1.xml')"/>
		<xsl:variable name="specialty_inref_bool" select="boolean($specialty_ref//concept[code/@value=$specialty_val])"/>
		<xsl:variable name="specialty_inref_disp" select="$specialty_ref//concept[code/@value=$specialty_val]/display/@value"/>
		<xsl:choose>
			<xsl:when test="not($specialty_bool)">
				<xsl:call-template name="reportFail">
					<xsl:with-param name="testString" select="$rule3"/>
					<xsl:with-param name="resultString" select="'CodeSystem-Specialty-1 code element not found.'"/>
				</xsl:call-template>
			</xsl:when>
			<xsl:when test="not($specialty_inref_bool)">
				<xsl:call-template name="reportFail">
					<xsl:with-param name="testString" select="$rule3"/>
					<xsl:with-param name="resultString" select="concat($specialty_val ,' not found in CodeSystem-Specialty-1.xml')"/>
				</xsl:call-template>
			</xsl:when>
			<xsl:when test="($specialty_inref_bool and ($specialty_disp=$specialty_inref_disp))">
				<xsl:call-template name="reportPass">
					<xsl:with-param name="testString" select="$rule3"/>
					<xsl:with-param name="resultString" select="concat('Concept code: ', $specialty_val, ' , display:  ', $specialty_disp ,' - found in CodeSystem-Specialty-1.xml')"/>
				</xsl:call-template>
			</xsl:when>
			<xsl:when test="($specialty_inref_bool and not($specialty_disp=$specialty_inref_disp))">
				<xsl:call-template name="reportFail">
					<xsl:with-param name="testString" select="$rule3"/>
					<xsl:with-param name="resultString" select="concat('Concept code: ', $specialty_val, ' found in CodeSystem-Specialty-1.xml, display name incorrect')"/>
				</xsl:call-template>
			</xsl:when>
		</xsl:choose>
	</xsl:template>
</xsl:stylesheet>
