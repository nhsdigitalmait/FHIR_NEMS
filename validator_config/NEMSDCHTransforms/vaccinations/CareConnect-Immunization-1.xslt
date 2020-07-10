<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:fhir="http://hl7.org/fhir" xmlns:xs="http://www.w3.org/2001/XMLSchema" xpath-default-namespace="http://hl7.org/fhir">
	<xsl:output method="html" encoding="UTF-8" indent="yes" omit-xml-declaration="yes"/>
	<xsl:include href="business_rules_reporting_templates.xslt"/>
	<xsl:variable name="spec" select="'National Events Management Service (NEMS) 2.2.1-Beta'"/>
	<xsl:variable name="message" select="'Vaccinations'"/>
	<xsl:variable name="resource_name" select="'Immunization'"/>
	<xsl:variable name="resource_path" select="//resource/Immunization"/>
	<xsl:variable name="rule1" select="'1: extension(vaccinationProcedure)	1..1	Free text field should be used if no coded text available using extension(vaccinationProcedure).valueCodeableConcept.text'"/>
	<xsl:variable name="rule2" select="'2: identifier	1..1	A publisher defined unique identifier for the vaccination which will be maintained across different event messages to allow subscribers to be identify the information within update or delete event messages.'"/>
	<xsl:variable name="rule3" select="'3: notGiven	1..1	Value SHALL be FALSE when the vaccination was given or reported as given, TRUE when not given'"/>
	<xsl:variable name="rule4" select="'4: vaccineCode	1..1	Immunization.vaccineCode SHALL use a value from the CareConnect-VaccineCode-1 value set'"/>
	<xsl:variable name="rule5" select="'5: date	1..1	The date or partial date that the vaccination was administered, or reported vaccination was given in the opinion of the child and/or parent carer'"/>
	<xsl:variable name="rule6" select="'6: primarySource	1..1	Value should be FALSE if the vaccination was reported, TRUE if the vaccination was administered'"/>
	<xsl:variable name="rule7" select="'7: reportOrigin	0..1	If the vaccination was reported then the original source should be included'"/>
	<xsl:variable name="rule8" select="'8: manufacturer	0..1	Where available this should be included'"/>
	<xsl:variable name="rule9" select="'9: site	0..1	Where available this should be included'"/>
	<xsl:variable name="rule10" select="'10: route	0..1	Where available this should be included'"/>
	<xsl:variable name="rule11" select="'11: explanation.reasonNotGiven	0..1	If the vaccination was notGiven then the reasonNotGiven element SHALL be included'"/>
	<xsl:variable name="rule12" select="'12: vaccinationProtocol.doseSequence	0..1	Where available the doseSequence should be included'"/>
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
				<xsl:call-template name="rule5">
					<xsl:with-param name="ruletext" select="$rule5"/>
				</xsl:call-template>
				<xsl:call-template name="rule6">
					<xsl:with-param name="ruletext" select="$rule6"/>
				</xsl:call-template>
				<xsl:call-template name="rule7">
					<xsl:with-param name="ruletext" select="$rule7"/>
				</xsl:call-template>
				<xsl:call-template name="shouldinclude">
					<xsl:with-param name="ruletext" select="$rule8"/>
					<xsl:with-param name="element" select="tokenize($rule8,'\s')[1]"/>
				</xsl:call-template>
				<xsl:call-template name="shouldinclude">
					<xsl:with-param name="ruletext" select="$rule9"/>
					<xsl:with-param name="element" select="tokenize($rule9,'\s')[1]"/>
				</xsl:call-template>
				<xsl:call-template name="shouldinclude">
					<xsl:with-param name="ruletext" select="$rule10"/>
					<xsl:with-param name="element" select="tokenize($rule10,'\s')[1]"/>
				</xsl:call-template>
				<xsl:call-template name="rule11">
					<xsl:with-param name="ruletext" select="$rule11"/>
				</xsl:call-template>
				<xsl:call-template name="shouldinclude">
					<xsl:with-param name="ruletext" select="$rule12"/>
					<xsl:with-param name="element" select="substring-after(tokenize($rule12,'\s')[1],'.')"/>
				</xsl:call-template>
			</xsl:for-each>
		</table>
	</xsl:template>
	<xsl:template name="rule1">
		<xsl:param name="ruletext"/>
		<xsl:choose>
			<xsl:when test="(./extension[contains(@url, 'VaccinationProcedure')]/valueCodeableConcept/coding and not(./extension[contains(@url, 'VaccinationProcedure')]/valueCodeableConcept/text))">
				<xsl:call-template name="reportPass">
					<xsl:with-param name="testString" select="$rule1"/>
					<xsl:with-param name="resultString" select="'VaccinationProcedure contains coded entry and no free text'"/>
				</xsl:call-template>
			</xsl:when>
			<xsl:when test="(not(./extension[contains(@url, 'VaccinationProcedure')]/valueCodeableConcept/coding) and (./extension[contains(@url, 'VaccinationProcedure')]/valueCodeableConcept/text))">
				<xsl:call-template name="reportPass">
					<xsl:with-param name="testString" select="$rule1"/>
					<xsl:with-param name="resultString" select="'VaccinationProcedure extension contains free text and no coded entry'"/>
				</xsl:call-template>
			</xsl:when>
			<xsl:when test="((./extension[contains(@url, 'VaccinationProcedure')]/valueCodeableConcept/coding) and (./extension[contains(@url, 'VaccinationProcedure')]/valueCodeableConcept/text))">
				<xsl:call-template name="reportWarning">
					<xsl:with-param name="testString" select="$rule1"/>
					<xsl:with-param name="resultString" select="'VaccinationProcedure extension contains both coded entry and free text field'"/>
				</xsl:call-template>
			</xsl:when>
		</xsl:choose>
	</xsl:template>
	<xsl:template name="rule2">
		<xsl:param name="ruletext"/>
		<xsl:choose>
			<xsl:when test="(./identifier/value/@value)">
				<xsl:call-template name="reportPass">
					<xsl:with-param name="testString" select="$rule2"/>
					<xsl:with-param name="resultString" select="'A publisher defined identifier has be supplied'"/>
				</xsl:call-template>
			</xsl:when>
		</xsl:choose>
	</xsl:template>
	<xsl:template name="rule3">
		<xsl:param name="ruletext"/>
		<xsl:choose>
			<xsl:when test="not(./notGiven)">
				<xsl:call-template name="reportPass">
					<xsl:with-param name="testString" select="$rule3"/>
					<xsl:with-param name="resultString" select="'Vaccination is reported as not given'"/>
				</xsl:call-template>
			</xsl:when>
			<xsl:when test="(./notGiven)">
				<xsl:call-template name="reportPass">
					<xsl:with-param name="testString" select="$rule3"/>
					<xsl:with-param name="resultString" select="'Vaccination is reported as having been given'"/>
				</xsl:call-template>
			</xsl:when>
		</xsl:choose>
	</xsl:template>
	<xsl:template name="rule4">
		<xsl:param name="ruletext"/>
		<xsl:variable name="system" select="./vaccineCode/coding/system/@value"/>
		<xsl:variable name="code" select="./vaccineCode/coding/code/@value"/>
		<xsl:variable name="displayName" select="./vaccineCode/coding/display/@value"/>
		<xsl:variable name="output" select="concat('MANUAL CHECK - Passthrough SNOMED valueset. Confirm ' , $code,' ', $displayName, ' is in CareConnect-VaccineCode-1 value set')"/>
		<xsl:call-template name="reportInformation">
			<xsl:with-param name="testString" select="$rule4"/>
			<xsl:with-param name="resultString" select="$output"/>
		</xsl:call-template>
	</xsl:template>
	<xsl:template name="rule5">
		<xsl:param name="ruletext"/>
		<xsl:choose>
			<xsl:when test="(./date)">
				<xsl:variable name="date" select="./date/@value"/>
				<xsl:variable name="output" select="$date"/>
				<xsl:call-template name="reportPass">
					<xsl:with-param name="testString" select="$rule5"/>
					<xsl:with-param name="resultString" select="$output"/>
				</xsl:call-template>
			</xsl:when>
			<xsl:when test="not(./date)">
				<xsl:call-template name="reportPass">
					<xsl:with-param name="testString" select="$rule5"/>
					<xsl:with-param name="resultString" select="'Date is not present'"/>
				</xsl:call-template>
			</xsl:when>
		</xsl:choose>
	</xsl:template>
	<xsl:template name="rule6">
		<xsl:param name="ruletext"/>
		<xsl:choose>
			<xsl:when test="./notGiven/@value='true' and ./primarySource/@value='false'">
				<xsl:call-template name="reportPass">
					<xsl:with-param name="testString" select="$rule6"/>
					<xsl:with-param name="resultString" select="'Vaccination is reported as not given primarySource should be false'"/>
				</xsl:call-template>
			</xsl:when>
			<xsl:when test="(./notGiven)">
				<xsl:call-template name="reportPass">
					<xsl:with-param name="testString" select="$rule6"/>
					<xsl:with-param name="resultString" select="'Vaccination is reported as having been given'"/>
				</xsl:call-template>
			</xsl:when>
		</xsl:choose>
	</xsl:template>
	<xsl:template name="rule7">
		<xsl:param name="ruletext"/>
		<xsl:choose>
			<xsl:when test="(./primarySource/@value='true' and not(./reportOrigin)) or (./primarySource/@value='false' and ./reportOrigin) ">
				<xsl:call-template name="reportPass">
					<xsl:with-param name="testString" select="$rule7"/>
					<xsl:with-param name="resultString" select="''"/>
				</xsl:call-template>
			</xsl:when>
			<xsl:when test="./primarySource/@value='true' and ./reportOrigin">
				<xsl:call-template name="reportFail">
					<xsl:with-param name="testString" select="$rule7"/>
					<xsl:with-param name="resultString" select="'Immunization/primarySource is true and Immunization/reportOrigin present'"/>
				</xsl:call-template>
			</xsl:when>
			<xsl:when test="./primarySource/@value='false' and not(./reportOrigin)">
				<xsl:call-template name="reportFail">
					<xsl:with-param name="testString" select="$rule7"/>
					<xsl:with-param name="resultString" select="'Immunization/primarySource is false, Immunization/reportOrigin is not present'"/>
				</xsl:call-template>
			</xsl:when>
		</xsl:choose>
	</xsl:template>
	<xsl:template name="rule11">
		<xsl:param name="ruletext"/>
		<xsl:choose>
			<xsl:when test="(./notGiven/@value='true' and (./reasonNotGiven))">
				<xsl:call-template name="reportPass">
					<xsl:with-param name="testString" select="$rule11"/>
					<xsl:with-param name="resultString" select="'notGiven is true and reasonNotGiven is included'"/>
				</xsl:call-template>
			</xsl:when>
			<xsl:when test="(./notGiven/@value='false' and not(./reasonNotGiven))">
				<xsl:call-template name="reportPass">
					<xsl:with-param name="testString" select="$rule11"/>
					<xsl:with-param name="resultString" select="'notGiven is false and reasonNotGiven is not included'"/>
				</xsl:call-template>
			</xsl:when>
			<xsl:when test="(./notGiven/@value='false' and ./reasonNotGiven)">
				<xsl:call-template name="reportFail">
					<xsl:with-param name="testString" select="$rule11"/>
					<xsl:with-param name="resultString" select="'notGiven is false and reasonNotGiven is included'"/>
				</xsl:call-template>
			</xsl:when>
			<xsl:when test="(./notGiven/@value='true' and not(./reasonNotGiven))">
				<xsl:call-template name="reportFail">
					<xsl:with-param name="testString" select="$rule11"/>
					<xsl:with-param name="resultString" select="'notGiven is true and reasonNotGiven is not included'"/>
				</xsl:call-template>
			</xsl:when>
		</xsl:choose>
	</xsl:template>
	<xsl:template name="shouldinclude">
		<xsl:param name="ruletext"/>
		<xsl:param name="element"/>
		<xsl:choose>
			<xsl:when test="./*/name()=$element">
				<xsl:call-template name="reportPass">
					<xsl:with-param name="testString" select="$ruletext"/>
					<xsl:with-param name="resultString" select="'Element included'"/>
				</xsl:call-template>
			</xsl:when>
			<xsl:when test="not(./*/name()=$element)">
				<xsl:call-template name="reportWarning">
					<xsl:with-param name="testString" select="$ruletext"/>
					<xsl:with-param name="resultString" select="'Element not found, where available this should be included'"/>
				</xsl:call-template>
			</xsl:when>
		</xsl:choose>
	</xsl:template>
</xsl:stylesheet>
