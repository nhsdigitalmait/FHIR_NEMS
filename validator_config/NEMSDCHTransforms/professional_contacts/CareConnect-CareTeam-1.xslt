<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:fhir="http://hl7.org/fhir" xmlns:xs="http://www.w3.org/2001/XMLSchema" xpath-default-namespace="http://hl7.org/fhir">
	<xsl:output method="html" encoding="UTF-8" indent="yes" omit-xml-declaration="yes"/>
	<xsl:include href="business_rules_reporting_templates.xslt"/>
	<xsl:variable name="spec" select="'National Events Management Service (NEMS) 2.2.1-Beta'"/>
	<xsl:variable name="message" select="'Professional Contacts'"/>
	<xsl:variable name="resource_name" select="'CareConnect-CareTeam-1'"/>
	<xsl:variable name="resource_path" select="//resource/CareTeam"/>
	<xsl:variable name="rule1" select="'1: subject	0..1	This should reference the Patient resource representing the subject of the episode of care.'"/>
	<xsl:variable name="rule2" select="'2: name	0..1	The care team name should be included to assist subscribers of the information to contact the organisation if required.'"/>
	<xsl:variable name="rule3" select="'3: participant	0..*	The members of the care team may be referenced and should include their role within the care team.'"/>
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
		<xsl:variable name="subject" select="tokenize(./subject/reference/@value,':')[last()]"/>
		<xsl:variable name="subject_bool" select="boolean(//Patient/id[@value=$subject])"/>
		<xsl:choose>
			<xsl:when test="not(./subject)">
				<xsl:call-template name="reportWarning">
					<xsl:with-param name="testString" select="$rule1"/>
					<xsl:with-param name="resultString" select="'Optional CareTeam subject is not included'"/>
				</xsl:call-template>
			</xsl:when>
			<xsl:when test="$subject_bool">
				<xsl:call-template name="reportPass">
					<xsl:with-param name="testString" select="$rule1"/>
					<xsl:with-param name="resultString" select="'CareTeam subject is included and references the Patient resource'"/>
				</xsl:call-template>
			</xsl:when>
			<xsl:when test="not(subject_bool)">
				<xsl:call-template name="reportFail">
					<xsl:with-param name="testString" select="$rule1"/>
					<xsl:with-param name="resultString" select="'CareTeam subject is included but does not reference the Patient resource'"/>
				</xsl:call-template>
			</xsl:when>
		</xsl:choose>
	</xsl:template>
	<xsl:template name="rule2">
		<xsl:param name="ruletext"/>
		<xsl:variable name="name" select="./name/@value"/>
		<xsl:choose>
			<xsl:when test="not((string-length($name)=0))">
				<xsl:call-template name="reportPass">
					<xsl:with-param name="testString" select="$rule2"/>
					<xsl:with-param name="resultString" select="concat('team name included: ', $name)"/>
				</xsl:call-template>
			</xsl:when>
			<xsl:when test="string-length($name)=0">
				<xsl:call-template name="reportWarning">
					<xsl:with-param name="testString" select="$rule2"/>
					<xsl:with-param name="resultString" select="'Optional CareTeam subject is not included'"/>
				</xsl:call-template>
			</xsl:when>
		</xsl:choose>
	</xsl:template>
	<xsl:template name="rule3">
		<xsl:param name="ruletext"/>
		<xsl:for-each select="./participant">
			<xsl:variable name="member_reference" select="tokenize(./member/reference/@value,':')[last()]"/>
			<xsl:variable name="member_role_code" select="./role/coding/code/@value"/>
			<xsl:variable name="member_role_display" select="./role/coding/display/@value"/>
			<xsl:choose>
				<xsl:when test="string-length($member_reference) > 0  and string-length($member_role_code) > 0 and string-length($member_role_display) > 0">
					<xsl:call-template name="reportPass">
						<xsl:with-param name="testString" select="$rule3"/>
						<xsl:with-param name="resultString" select="concat('Optional CareTeam member ', $member_reference ,' is included with optional role information')"/>
					</xsl:call-template>
				</xsl:when>
				<xsl:when test="string-length($member_reference) > 0  and string-length($member_role_code) = 0 and string-length($member_role_display) = 0">
						<xsl:call-template name="reportPass">
							<xsl:with-param name="testString" select="$rule3"/>
							<xsl:with-param name="resultString" select="concat('Optional CareTeam member ', $member_reference ,' is included without optional role information')"/>
						</xsl:call-template>
					</xsl:when>
					<xsl:when test="string-length($member_reference) = 0  and string-length($member_role_code) = 0 and string-length($member_role_display) = 0">
						<xsl:call-template name="reportWarning">
							<xsl:with-param name="testString" select="$rule3"/>
							<xsl:with-param name="resultString" select="'Optional CareTeam member is not included'"/>
						</xsl:call-template>
					</xsl:when>
				</xsl:choose>
			</xsl:for-each>
		</xsl:template>
	</xsl:stylesheet>
	