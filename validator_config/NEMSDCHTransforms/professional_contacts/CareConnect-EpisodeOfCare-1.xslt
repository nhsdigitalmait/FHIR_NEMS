<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:fhir="http://hl7.org/fhir" xmlns:xs="http://www.w3.org/2001/XMLSchema" xpath-default-namespace="http://hl7.org/fhir">
	<xsl:output method="html" encoding="UTF-8" indent="yes" omit-xml-declaration="yes"/>
	<xsl:include href="business_rules_reporting_templates.xslt"/>
	<xsl:variable name="spec" select="'National Events Management Service (NEMS) 2.2.1-Beta'"/>
	<xsl:variable name="message" select="'Vaccinations'"/>
	<xsl:variable name="resource_name" select="'CareConnect-EpisodeOfCare-1'"/>
	<xsl:variable name="resource_path" select="//resource/EpisodeOfCare"/>
	<xsl:variable name="rule1" select="'1: identifier	1..1	A publisher defined unique identifier for the episode of care which will be maintained across different event messages to allow subscribers to be identify the information within update or delete event messages.'"/>
	<xsl:variable name="rule2" select="'2: status	1..1	The status element MUST represent the current status of the organisations responsibility for the patient.'"/>
	<xsl:variable name="rule3" select="'3: type	1..*	The type element MUST represent the type of care/service the organisation is providing during this episode of care. The resource MUST contain a type from value set CareConnect-CareSettingType-1'"/>
	<xsl:variable name="rule4" select="'4: managingOrganization	1..1	This MUST reference the organisation who is responsibility for this episode of care, which contains contact details for that organisation in relation to this episode of care.'"/>
	<xsl:variable name="rule5" select="'5: period.start	0..1	Date on which the organisation took responsibility for the patients care.'"/>
	<xsl:variable name="rule6" select="'6: period.end	0..1	Date on which the organisation stopped being responsible for the patients care.'"/>
	<xsl:variable name="rule7" select="'7: team	0..*	The EpisodeOfCare may reference specific care teams for this episode of care.'"/>
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
			</xsl:for-each>
		</table>
	</xsl:template>
	<xsl:template name="rule1">
		<xsl:param name="ruletext"/>
		<xsl:variable name="identifier" select="./identifier/value/@value"/>
		<xsl:choose>
			<xsl:when test="(string-length($identifier)=0)">
				<xsl:call-template name="reportFail">
					<xsl:with-param name="testString" select="$rule1"/>
					<xsl:with-param name="resultString" select="'Identifier not included'"/>
				</xsl:call-template>
			</xsl:when>
			<xsl:when test="(string-length($identifier)>0)">
				<xsl:call-template name="reportPass">
					<xsl:with-param name="testString" select="$rule1"/>
					<xsl:with-param name="resultString" select="concat('Identifier: ', $identifier, ' is included')"/>
				</xsl:call-template>
			</xsl:when>
		</xsl:choose>
	</xsl:template>
	<xsl:template name="rule2">
		<xsl:param name="ruletext"/>
		<xsl:variable name="status" select="./status/@value"/>
		<xsl:choose>
			<xsl:when test="(string-length($status)=0)">
				<xsl:call-template name="reportFail">
					<xsl:with-param name="testString" select="$rule2"/>
					<xsl:with-param name="resultString" select="'status not included'"/>
				</xsl:call-template>
			</xsl:when>
			<xsl:when test="(string-length($status)>0)">
				<xsl:call-template name="reportPass">
					<xsl:with-param name="testString" select="$rule2"/>
					<xsl:with-param name="resultString" select="concat('status: ' ,$status, ' is included')"/>
				</xsl:call-template>
			</xsl:when>
		</xsl:choose>
	</xsl:template>
	<xsl:template name="rule3">
		<xsl:param name="ruletext"/>
		<xsl:variable name="system" select="./type/coding/system/@value"/>
		<xsl:variable name="code" select="./type/coding/code/@value"/>
		<xsl:variable name="displayName" select="./type/coding/display/@value"/>
		<xsl:variable name="output" select="concat('MANUAL CHECK - Passthrough SNOMED valueset. Confirm ' , $code,' ', $displayName, ' is in CareConnect-CareSettingType-1 value set')"/>
		<xsl:call-template name="reportInformation">
			<xsl:with-param name="testString" select="$rule3"/>
			<xsl:with-param name="resultString" select="$output"/>
		</xsl:call-template>
	</xsl:template>
	<xsl:template name="rule4">
		<xsl:param name="ruletext"/>
		<xsl:variable name="managing_org" select="tokenize(./managingOrganization/reference/@value,':')[last()]"/>
		<xsl:variable name="managing_org_bool" select="boolean(//Organization/id[@value=$managing_org])"/>
		<xsl:choose>
			<xsl:when test="$managing_org_bool">
				<xsl:call-template name="reportPass">
					<xsl:with-param name="testString" select="$rule4"/>
					<xsl:with-param name="resultString" select="concat('EpisodeOfCare managingOrganization ', $managing_org ,' references an Organization resource')"/>
				</xsl:call-template>
			</xsl:when>
			<xsl:when test="not($managing_org_bool)">
				<xsl:call-template name="reportFail">
					<xsl:with-param name="testString" select="$rule4"/>
					<xsl:with-param name="resultString" select="concat('EpisodeOfCare managingOrganization ', $managing_org ,' does not reference an Organization resource')"/>
				</xsl:call-template>
			</xsl:when>
		</xsl:choose>
	</xsl:template>
	<xsl:template name="rule5">
		<xsl:param name="ruletext"/>
		<xsl:variable name="period_start" select="./period/start/@value"/>
		<xsl:choose>
			<xsl:when test="string-length($period_start)>0">
				<xsl:call-template name="reportPass">
					<xsl:with-param name="testString" select="$rule5"/>
					<xsl:with-param name="resultString" select="concat('Optional Period Start: ',$period_start, ' is included')"/>
				</xsl:call-template>
			</xsl:when>
			<xsl:when test="string-length($period_start)=0">
				<xsl:call-template name="reportPass">
					<xsl:with-param name="testString" select="$rule5"/>
					<xsl:with-param name="resultString" select="'Optional Period Start is not included'"/>
				</xsl:call-template>
			</xsl:when>
		</xsl:choose>
	</xsl:template>
	<xsl:template name="rule6">
		<xsl:param name="ruletext"/>
		<xsl:variable name="period_end" select="./period/end/@value"/>
		<xsl:choose>
			<xsl:when test="string-length($period_end)>0">
				<xsl:call-template name="reportPass">
					<xsl:with-param name="testString" select="$rule6"/>
					<xsl:with-param name="resultString" select="concat('Optional Period End ',$period_end, ' is included')"/>
				</xsl:call-template>
			</xsl:when>
			<xsl:when test="string-length($period_end)=0">
				<xsl:call-template name="reportPass">
					<xsl:with-param name="testString" select="$rule6"/>
					<xsl:with-param name="resultString" select="'Optional Period End is not included'"/>
				</xsl:call-template>
			</xsl:when>
		</xsl:choose>
	</xsl:template>
	<xsl:template name="rule7">
		<xsl:param name="ruletext"/>
		<xsl:for-each select="./team/reference">
			<xsl:variable name="team" select="tokenize(./@value,':')[last()]"/>
			<xsl:variable name="team_bool" select="boolean(//CareTeam/id[@value=$team])"/>
			<xsl:choose>
				<xsl:when test="$team_bool">
					<xsl:call-template name="reportPass">
						<xsl:with-param name="testString" select="$rule7"/>
						<xsl:with-param name="resultString" select="concat('Team: ', $team, ' references a CareTeam resource')"/>
					</xsl:call-template>
				</xsl:when>
				<xsl:when test="not($team_bool)">
					<xsl:call-template name="reportFail">
						<xsl:with-param name="testString" select="$rule7"/>
						<xsl:with-param name="resultString" select="concat('Team: ', $team, ' does not reference a CareTeam resource')"/>
					</xsl:call-template>
				</xsl:when>
			</xsl:choose>
		</xsl:for-each>
	</xsl:template>
</xsl:stylesheet>
