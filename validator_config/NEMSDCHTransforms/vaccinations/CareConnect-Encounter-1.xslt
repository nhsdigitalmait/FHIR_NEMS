<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:fhir="http://hl7.org/fhir" xmlns:xs="http://www.w3.org/2001/XMLSchema" xpath-default-namespace="http://hl7.org/fhir">
	<xsl:output method="html" encoding="UTF-8" indent="yes" omit-xml-declaration="yes"/>
	<xsl:include href="business_rules_reporting_templates.xslt"/>
	<xsl:variable name="spec" select="'National Events Management Service (NEMS) 2.2.1-Beta'"/>
	<xsl:variable name="message" select="'Vaccinations'"/>
	<xsl:variable name="resource_name" select="'CareConnect-Encounter-1'"/>
	<xsl:variable name="resource_path" select="//Encounter"/>
	<xsl:variable name="rule1" select="'1: Encounter.type	1..*	The encounter type SHOULD include a value from the EncounterType-1 value set. This value set is extensible so additional values and code systems may be added where required.'"/>
	<xsl:variable name="rule2" select="'2: location	0..1	Reference to the location at which the encounter took place'"/>
	<xsl:variable name="rule3" select="'3: subject	1..1	A reference to the patient resource representing the subject of this event'"/>
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
		<xsl:variable name="enctype_bool" select="boolean(./type/coding[system/@value= 'https://fhir.nhs.uk/STU3/CodeSystem/DCH-ChildHealthEncounterType-1']/code/@value)"/>
		<xsl:variable name="enctype_val" select="./type/coding[system/@value= 'https://fhir.nhs.uk/STU3/CodeSystem/DCH-ChildHealthEncounterType-1']/code/@value"/>
		<xsl:variable name="enctype_disp" select="./type/coding[system/@value= 'https://fhir.nhs.uk/STU3/CodeSystem/DCH-ChildHealthEncounterType-1']/display/@value"/>
		<xsl:variable name="enctype_ref" select="document('./CodeSystem-DCH-ChildHealthEncounterType-1.xml')"/>
		<xsl:variable name="enctype_inref_bool" select="boolean($enctype_ref//concept[code/@value=$enctype_val])"/>
		<xsl:variable name="enctype_inref_disp" select="$enctype_ref//concept[code/@value=$enctype_val]/display/@value"/>
		<xsl:choose>
			<xsl:when test="not($enctype_bool)">
				<xsl:call-template name="reportFail">
					<xsl:with-param name="testString" select="$rule1"/>
					<xsl:with-param name="resultString" select="'DCH-ChildHealthEncounterType-1 code element not found.'"/>
				</xsl:call-template>
			</xsl:when>
			<xsl:when test="not($enctype_inref_bool)">
				<xsl:call-template name="reportWarning">
					<xsl:with-param name="testString" select="$rule1"/>
					<xsl:with-param name="resultString" select="concat($enctype_val ,' not found in CodeSystem-DCH-ChildHealthEncounterType-1.xml, an extended value may have been used')"/>
				</xsl:call-template>
			</xsl:when>
			<xsl:when test="($enctype_inref_bool and ($enctype_disp=$enctype_inref_disp))">
				<xsl:call-template name="reportPass">
					<xsl:with-param name="testString" select="$rule1"/>
					<xsl:with-param name="resultString" select="concat('Concept code: ', $enctype_val, ' , display:  ', $enctype_disp ,' - found in CodeSystem-DCH-ChildHealthEncounterType-1.xml')"/>
				</xsl:call-template>
			</xsl:when>
			<xsl:when test="($enctype_inref_bool and not($enctype_disp=$enctype_inref_disp))">
				<xsl:call-template name="reportFail">
					<xsl:with-param name="testString" select="$rule1"/>
					<xsl:with-param name="resultString" select="concat('Concept code: ', $enctype_val, ' found in CodeSystem-DCH-ChildHealthEncounterType-1.xml, display name incorrect')"/>
				</xsl:call-template>
			</xsl:when>
		</xsl:choose>
	</xsl:template>
	<xsl:template name="rule2">
		<xsl:param name="ruletext"/>
		<xsl:variable name="loc_ref" select="tokenize(./location/reference/@value,':')[last()]"/>
		<xsl:variable name="locref_bool" select="boolean(//Location/id[@value=$loc_ref])"/>
		<xsl:choose>
			<xsl:when test="string-length($loc_ref)=0">
				<xsl:call-template name="reportPass">
					<xsl:with-param name="testString" select="$rule2"/>
					<xsl:with-param name="resultString" select="'Optional encounter location reference not included'"/>
				</xsl:call-template>
			</xsl:when>
			<xsl:when test="$locref_bool">
				<xsl:call-template name="reportPass">
					<xsl:with-param name="testString" select="$rule2"/>
					<xsl:with-param name="resultString" select="concat($loc_ref, ' references the id of a Location resource')"/>
				</xsl:call-template>
			</xsl:when>
			<xsl:when test="not($locref_bool)">
				<xsl:call-template name="reportFail">
					<xsl:with-param name="testString" select="$rule2"/>
					<xsl:with-param name="resultString" select="concat($loc_ref, ' does not reference the id of a Location resource')"/>
				</xsl:call-template>
			</xsl:when>
		</xsl:choose>
	</xsl:template>
	<xsl:template name="rule3">
		<xsl:param name="ruletext"/>
		<xsl:variable name="pat_ref" select="tokenize(./subject/reference/@value,':')[last()]"/>
		<xsl:variable name="patref_bool" select="boolean(//Patient/id[@value=$pat_ref])"/>
		<xsl:choose>
			<xsl:when test="string-length($pat_ref)=0">
				<xsl:call-template name="reportFail">
					<xsl:with-param name="testString" select="$rule3"/>
					<xsl:with-param name="resultString" select="'Optional subject Patient reference not included'"/>
				</xsl:call-template>
			</xsl:when>
			<xsl:when test="$patref_bool">
				<xsl:call-template name="reportPass">
					<xsl:with-param name="testString" select="$rule3"/>
					<xsl:with-param name="resultString" select="concat($pat_ref, ' references the id of a Patient resource')"/>
				</xsl:call-template>
			</xsl:when>
			<xsl:when test="not($patref_bool)">
				<xsl:call-template name="reportFail">
					<xsl:with-param name="testString" select="$rule3"/>
					<xsl:with-param name="resultString" select="concat($pat_ref, ' does not reference the id of a Patient resource')"/>
				</xsl:call-template>
			</xsl:when>
		</xsl:choose>
	</xsl:template>
</xsl:stylesheet>
