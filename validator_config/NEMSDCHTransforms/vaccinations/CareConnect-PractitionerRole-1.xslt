<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:fhir="http://hl7.org/fhir" xmlns:xs="http://www.w3.org/2001/XMLSchema" xpath-default-namespace="http://hl7.org/fhir">
	<xsl:output method="html" encoding="UTF-8" indent="yes" omit-xml-declaration="yes"/>
	<xsl:include href="business_rules_reporting_templates.xslt"/>
	<xsl:variable name="spec" select="'National Events Management Service (NEMS) 2.2.1-Beta'"/>
	<xsl:variable name="message" select="'Vaccinations'"/>
	<xsl:variable name="resource_name" select="'CareConnect-PractitionerRole-1'"/>
	<xsl:variable name="resource_path" select="//PractitionerRole"/>
	<xsl:variable name="rule1" select="'1: organization	1..1	Reference to the Organization where the practitioner performs this role'"/>
	<xsl:variable name="rule2" select="'2: practitioner	1..1	Reference to the Practitioner who this role relates to'"/>
	<xsl:variable name="rule3" select="'3: code	1..*	The practitioner role SHALL included a value from the ProfessionalType-1 value set. The PractitionerRole.code should also include the SDS Job Role name where available.'"/>
	<xsl:variable name="rule4" select="'4: specialty	1..1	PractitionerRole.specialty SHALL use a value from Specialty-1 value set'"/>
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
				<xsl:call-template name="rule4">
					<xsl:with-param name="ruletext" select="$rule4"/>
				</xsl:call-template>
			</xsl:for-each>
		</table>
	</xsl:template>
	<xsl:template name="rule1">
		<xsl:param name="ruletext"/>
		<xsl:variable name="org_ref" select="tokenize(./organization/reference/@value,':')[last()]"/>
		<xsl:variable name="orgref_bool" select="boolean(//Organization/id[@value=$org_ref])"/>
		<xsl:choose>
			<xsl:when test="$orgref_bool">
				<xsl:call-template name="reportPass">
					<xsl:with-param name="testString" select="$rule1"/>
					<xsl:with-param name="resultString" select="concat($org_ref, ' references the id of an Organization resource')"/>
				</xsl:call-template>
			</xsl:when>
			<xsl:when test="not($orgref_bool)">
				<xsl:call-template name="reportFail">
					<xsl:with-param name="testString" select="$rule1"/>
					<xsl:with-param name="resultString" select="concat($org_ref, ' does not reference the id of an Organization resource')"/>
				</xsl:call-template>
			</xsl:when>
		</xsl:choose>
	</xsl:template>
	<xsl:template name="rule2">
		<xsl:param name="ruletext"/>
		<xsl:variable name="prac_ref" select="tokenize(./practitioner/reference/@value,':')[last()]"/>
		<xsl:variable name="pracref_bool" select="boolean(//Practitioner/id[@value=$prac_ref])"/>
		<xsl:choose>
			<xsl:when test="$pracref_bool">
				<xsl:call-template name="reportPass">
					<xsl:with-param name="testString" select="$rule2"/>
					<xsl:with-param name="resultString" select="concat($prac_ref, ' references the id of a Practitioner resource')"/>
				</xsl:call-template>
			</xsl:when>
			<xsl:when test="not($pracref_bool)">
				<xsl:call-template name="reportFail">
					<xsl:with-param name="testString" select="$rule2"/>
					<xsl:with-param name="resultString" select="concat($prac_ref, ' does not reference the id of a Practitioner resource')"/>
				</xsl:call-template>
			</xsl:when>
		</xsl:choose>
	</xsl:template>
	<xsl:template name="rule3">
		<xsl:param name="ruletext"/>
		<xsl:variable name="proftype_bool" select="boolean(./code/coding[system/@value= 'https://fhir.nhs.uk/STU3/CodeSystem/ProfessionalType-1']/code/@value)"/>
		<xsl:variable name="proftype_val" select="./code/coding[system/@value= 'https://fhir.nhs.uk/STU3/CodeSystem/ProfessionalType-1']/code/@value"/>
		<xsl:variable name="proftype_disp" select="./code/coding[system/@value= 'https://fhir.nhs.uk/STU3/CodeSystem/ProfessionalType-1']/display/@value"/>
		<xsl:variable name="proftype_ref" select="document('./CodeSystem-ProfessionalType-1.xml')"/>
		<xsl:variable name="proftype_inref_bool" select="boolean($proftype_ref//concept[code/@value=$proftype_val])"/>
		<xsl:variable name="proftype_inref_disp" select="$proftype_ref//concept[code/@value=$proftype_val]/display/@value"/>
		<xsl:choose>
			<xsl:when test="not($proftype_bool)">
				<xsl:call-template name="reportFail">
					<xsl:with-param name="testString" select="$rule3"/>
					<xsl:with-param name="resultString" select="'ProfessionalType-1 code element not found.'"/>
				</xsl:call-template>
			</xsl:when>
			<xsl:when test="not($proftype_inref_bool)">
				<xsl:call-template name="reportFail">
					<xsl:with-param name="testString" select="$rule3"/>
					<xsl:with-param name="resultString" select="concat($proftype_val ,' not found in CodeSystem-ProfessionalType-1.xml')"/>
				</xsl:call-template>
			</xsl:when>
			<xsl:when test="($proftype_inref_bool and ($proftype_disp=$proftype_inref_disp))">
				<xsl:call-template name="reportPass">
					<xsl:with-param name="testString" select="$rule3"/>
					<xsl:with-param name="resultString" select="concat('Concept code: ', $proftype_val, ' , display:  ', $proftype_disp ,' - found in CodeSystem-ProfessionalType-1.xml')"/>
				</xsl:call-template>
			</xsl:when>
			<xsl:when test="($proftype_inref_bool and not($proftype_disp=$proftype_inref_disp))">
				<xsl:call-template name="reportFail">
					<xsl:with-param name="testString" select="$rule3"/>
					<xsl:with-param name="resultString" select="concat('Concept code: ', $proftype_val, ' found in CodeSystem-ProfessionalType-1.xml, display name incorrect')"/>
				</xsl:call-template>
			</xsl:when>
		</xsl:choose>
		<xsl:variable name="sdsjob_bool" select="boolean(./code/coding[system/@value= 'https://fhir.hl7.org.uk/STU3/CodeSystem/CareConnect-SDSJobRoleName-1']/code/@value)"/>
		<xsl:variable name="sdsjob_val" select="./code/coding[system/@value= 'https://fhir.hl7.org.uk/STU3/CodeSystem/CareConnect-SDSJobRoleName-1']/code/@value"/>
		<xsl:variable name="sdsjob_disp" select="./code/coding[system/@value= 'https://fhir.hl7.org.uk/STU3/CodeSystem/CareConnect-SDSJobRoleName-1']/display/@value"/>
		<xsl:variable name="sdsjob_ref" select="document('./Care Connect SDS Job Role Name.xml')"/>
		<xsl:variable name="sdsjob_inref_bool" select="boolean($sdsjob_ref//concept[code/@value=$sdsjob_val])"/>
		<xsl:variable name="sdsjob_inref_disp" select="$sdsjob_ref//concept[code/@value=$sdsjob_val]/display/@value"/>
		<xsl:choose>
			<xsl:when test="not($sdsjob_bool)">
				<xsl:call-template name="reportWarning">
					<xsl:with-param name="testString" select="$rule3"/>
					<xsl:with-param name="resultString" select="'CareConnect-SDSJobRoleName-1 not found, this should be included if available.'"/>
				</xsl:call-template>
			</xsl:when>
			<xsl:when test="not($sdsjob_inref_bool)">
				<xsl:call-template name="reportFail">
					<xsl:with-param name="testString" select="$rule3"/>
					<xsl:with-param name="resultString" select="concat($sdsjob_val ,' not found in CareConnect-SDSJobRoleName-1.xml')"/>
				</xsl:call-template>
			</xsl:when>
			<xsl:when test="($sdsjob_inref_bool and ($proftype_disp=$sdsjob_inref_disp))">
				<xsl:call-template name="reportPass">
					<xsl:with-param name="testString" select="$rule3"/>
					<xsl:with-param name="resultString" select="concat('Concept code: ', $sdsjob_val, ' , display:  ', $sdsjob_disp ,' - found in CareConnect-SDSJobRoleName-1.xml')"/>
				</xsl:call-template>
			</xsl:when>
			<xsl:when test="($sdsjob_inref_bool and not($sdsjob_disp=$sdsjob_inref_disp))">
				<xsl:call-template name="reportFail">
					<xsl:with-param name="testString" select="$rule3"/>
					<xsl:with-param name="resultString" select="concat('Concept code: ', $sdsjob_val, ' found in CareConnect-SDSJobRoleName-1.xml, display name incorrect')"/>
				</xsl:call-template>
			</xsl:when>
		</xsl:choose>
	</xsl:template>
	<xsl:template name="rule4">
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
					<xsl:with-param name="testString" select="$rule4"/>
					<xsl:with-param name="resultString" select="'CodeSystem-Specialty-1 code element not found.'"/>
				</xsl:call-template>
			</xsl:when>
			<xsl:when test="not($specialty_inref_bool)">
				<xsl:call-template name="reportFail">
					<xsl:with-param name="testString" select="$rule4"/>
					<xsl:with-param name="resultString" select="concat($specialty_val ,' not found in CodeSystem-Specialty-1.xml')"/>
				</xsl:call-template>
			</xsl:when>
			<xsl:when test="($specialty_inref_bool and ($specialty_disp=$specialty_inref_disp))">
				<xsl:call-template name="reportPass">
					<xsl:with-param name="testString" select="$rule4"/>
					<xsl:with-param name="resultString" select="concat('Concept code: ', $specialty_val, ' , display:  ', $specialty_disp ,' - found in CodeSystem-Specialty-1.xml')"/>
				</xsl:call-template>
			</xsl:when>
			<xsl:when test="($specialty_inref_bool and not($specialty_disp=$specialty_inref_disp))">
				<xsl:call-template name="reportFail">
					<xsl:with-param name="testString" select="$rule4"/>
					<xsl:with-param name="resultString" select="concat('Concept code: ', $specialty_val, ' found in CodeSystem-Specialty-1.xml, display name incorrect')"/>
				</xsl:call-template>
			</xsl:when>
		</xsl:choose>
	</xsl:template>
</xsl:stylesheet>
