<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:fhir="http://hl7.org/fhir" xmlns:xs="http://www.w3.org/2001/XMLSchema" xpath-default-namespace="http://hl7.org/fhir">
	<xsl:output method="html" encoding="UTF-8" indent="yes" omit-xml-declaration="yes"/>
	<xsl:include href="business_rules_reporting_templates.xslt"/>
	<xsl:variable name="spec" select="'National Events Management Service (NEMS) 2.2.1-Beta'"/>
	<xsl:variable name="message" select="'Professional Contacts'"/>
	<xsl:variable name="resource_name" select="'Event-MessageHeader-1'"/>
	<xsl:variable name="resource_path" select="//resource/MessageHeader"/>
	<xsl:variable name="rule1" select="'1: meta.lastUpdated	1..1	The dateTime when the information was changed within the publishing system, for the use of event sequencing.'"/>
	<xsl:variable name="rule2" select="'2: extension(messageEventType)	1..1	Event Life Cycle'"/>
	<xsl:variable name="rule3" select="'3: event	1..1	Fixed Value: professional-contacts-1 (Professional Contacts)'"/>
	<xsl:variable name="rule4" select="'4: focus	1..1	This will reference the CareConnect-EpisodeOfCare-1 resource which contains information outlining the professional responsibility for the patient.'"/>
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
		<xsl:variable name="lastUpdated" select="./meta/lastUpdated/@value"/>
		<xsl:choose>
			<xsl:when test="(string-length($lastUpdated)=0)">
				<xsl:call-template name="reportFail">
					<xsl:with-param name="testString" select="$rule1"/>
					<xsl:with-param name="resultString" select="'lastUpdated dateTime not included'"/>
				</xsl:call-template>
			</xsl:when>
			<xsl:when test="not(string-length($lastUpdated)=0)">
				<xsl:call-template name="reportPass">
					<xsl:with-param name="testString" select="$rule1"/>
					<xsl:with-param name="resultString" select="$lastUpdated"/>
				</xsl:call-template>
			</xsl:when>
		</xsl:choose>
	</xsl:template>
	<xsl:template name="rule2">
		<xsl:param name="ruletext"/>
		<xsl:variable name="eventType" select="./extension[contains(@url,'Extension-MessageEventType')]//code/@value"/>
		<xsl:choose>
			<xsl:when test="(string-length($eventType)=0)">
				<xsl:call-template name="reportFail">
					<xsl:with-param name="testString" select="$rule2"/>
					<xsl:with-param name="resultString" select="'eventType not included'"/>
				</xsl:call-template>
			</xsl:when>
			<xsl:when test="$eventType='new' or $eventType='update' or $eventType='delete'">
				<xsl:call-template name="reportPass">
					<xsl:with-param name="testString" select="$rule2"/>
					<xsl:with-param name="resultString" select="concat($eventType, ' is a valid value.')"/>
				</xsl:call-template>
			</xsl:when>
			<xsl:when test="not($eventType='new' or $eventType='update' or $eventType='delete')">
				<xsl:call-template name="reportFail">
					<xsl:with-param name="testString" select="$rule2"/>
					<xsl:with-param name="resultString" select="concat($eventType, ' is an invalid value, valid values are new, update and delete.')"/>
				</xsl:call-template>
			</xsl:when>
		</xsl:choose>
	</xsl:template>
	<xsl:template name="rule3">
		<xsl:param name="ruletext"/>
		<xsl:variable name="eventCode" select="./event/code/@value"/>
		<xsl:variable name="fixedstring" select="'professional-contacts-1'"/>
		<xsl:choose>
			<xsl:when test="(string-length($eventCode)=0)">
				<xsl:call-template name="reportFail">
					<xsl:with-param name="testString" select="$rule3"/>
					<xsl:with-param name="resultString" select="'Event code not included.'"/>
				</xsl:call-template>
			</xsl:when>
			<xsl:when test="($eventCode=$fixedstring)">
				<xsl:call-template name="reportPass">
					<xsl:with-param name="testString" select="$rule3"/>
					<xsl:with-param name="resultString" select="'Event code is correct fixed value.'"/>
				</xsl:call-template>
			</xsl:when>
			<xsl:when test="not($eventCode=$fixedstring)">
				<xsl:call-template name="reportFail">
					<xsl:with-param name="testString" select="$rule3"/>
					<xsl:with-param name="resultString" select="concat($eventCode, ' is an invalid value, fixed value is vaccinations-1.')"/>
				</xsl:call-template>
			</xsl:when>
		</xsl:choose>
	</xsl:template>
	<xsl:template name="rule4">
		<xsl:param name="ruletext"/>
		<xsl:variable name="focus" select="tokenize(./focus/reference/@value,':')[last()]"/>
		<xsl:variable name="focus_bool" select="boolean(//EpisodeOfCare/id[@value=$focus])"/>
		<xsl:choose>
			<xsl:when test="$focus_bool">
				<xsl:call-template name="reportPass">
					<xsl:with-param name="testString" select="$rule4"/>
					<xsl:with-param name="resultString" select="'MessageHeader focus references the EpisodeOfCare resource'"/>
				</xsl:call-template>
			</xsl:when>
			<xsl:when test="not(focus_bool)">
				<xsl:call-template name="reportFail">
					<xsl:with-param name="testString" select="$rule4"/>
					<xsl:with-param name="resultString" select="'MessageHeader focus does not reference the EpisodeOfCare resource'"/>
				</xsl:call-template>
			</xsl:when>
		</xsl:choose>
	</xsl:template>
</xsl:stylesheet>
