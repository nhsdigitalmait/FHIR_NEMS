<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:fn="http://www.w3.org/2005/xpath-functions" xpath-default-namespace="http://hl7.org/fhir">
	<xsl:output method="html" encoding="UTF-8" indent="yes" omit-xml-declaration="yes"/>
	<xsl:template match="/">
		<table border="0">
			<th style="color:#008000;text-align:center">Minimum Viable Product Element Existence Check</th>
			<xsl:call-template name="MVPcheck">
				<xsl:with-param name="ref_filename" select="'ePMA_1_0_2_beta.xml'"/>
				<xsl:with-param name="resource" select="'MedicationDispense'"/>
				<xsl:with-param name="set" select="'common'"/>
			</xsl:call-template>
			<xsl:call-template name="MVPcheck">
				<xsl:with-param name="ref_filename" select="'ePMA_1_0_2_beta.xml'"/>
				<xsl:with-param name="resource" select="'MedicationRequest'"/>
				<xsl:with-param name="set" select="'common'"/>
			</xsl:call-template>
<!-- NOT YET SUPPORTED
			<xsl:call-template name="MVPcheck">
				<xsl:with-param name="ref_filename" select="'ePMA_1_0_2_beta.xml'"/>
				<xsl:with-param name="resource" select="'MedicationAdministration'"/>
				<xsl:with-param name="set" select="'common'"/>
			</xsl:call-template>
			<xsl:call-template name="MVPcheck">
				<xsl:with-param name="ref_filename" select="'ePMA_1_0_2_beta.xml'"/>
				<xsl:with-param name="resource" select="'MedicationStatement'"/>
				<xsl:with-param name="set" select="'common'"/>
			</xsl:call-template>
NOT YET SUPPORTED -->
			<xsl:call-template name="MVPcheck">
				<xsl:with-param name="ref_filename" select="'ePMA_1_0_2_beta.xml'"/>
				<xsl:with-param name="resource" select="'Patient'"/>
				<xsl:with-param name="set" select="'common'"/>
			</xsl:call-template>
			
			<xsl:call-template name="MVPcheck">
				<xsl:with-param name="ref_filename" select="'ePMA_1_0_2_beta.xml'"/>
				<xsl:with-param name="resource" select="'Practitioner'"/>
				<xsl:with-param name="set" select="'common'"/>
			</xsl:call-template>
		</table>
	</xsl:template>
	<xsl:template name="MVPcheck">
		<xsl:param name="ref_filename"/>
		<xsl:param name="resource"/>
		<xsl:param name="set"/>
		<xsl:variable name="test_resource" select="//*[name()=$resource][1]"/>
		<xsl:choose>
			<xsl:when test="$test_resource">
				<xsl:variable name="MVPelements" select="document(concat('./',$ref_filename))"/>
				<table border="0">
					<tr>
						<td style="color:#008000;font-weight:bold">
							<xsl:value-of select="$resource"/>
							<xsl:text> resource FOUND in test message</xsl:text>
						</td>
					</tr>
					<tr>
						<td style="color:#008000">
							<xsl:text>Checking against MVP set: </xsl:text>
							<xsl:value-of select="$MVPelements/reference/resource[@name=$resource]/set[@name=$set]/@display"/>
						</td>
					</tr>
					<tr>
						<td style="color:#008000">
							<xsl:text>MVP Reference: </xsl:text>
							<xsl:value-of select="$MVPelements/reference/@name"/>
							<xsl:text> Version: </xsl:text>
							<xsl:value-of select="$MVPelements/reference/@version"/>
						</td>
					</tr>
				</table>
				<table border="1|0">
					<tr style="font-weight:bold">
						<td style="color:#008000">
							<xsl:text>Element Required for MVP</xsl:text>
						</td>
						<!-- see if it is in the message -->
						<td style="color:#008000">
							<xsl:text>Element present in Test Message</xsl:text>
						</td>
					</tr>
					<!--For each element with a min of 1 in the reference file-->
					<xsl:for-each select="$MVPelements/reference/resource[@name=$resource]/set[@name=$set]/elements/element[@min='1']">
						<xsl:variable name="MVPelement" select="./@name"/>
						<!-- SPECIAL CASES -->
						<xsl:choose>
							<xsl:when test="matches($MVPelement , '^identifier \(nhsNumber\)$')">
								<xsl:variable name="result" select="boolean($test_resource/*[name()='identifier'][system/@value='https://fhir.nhs.uk/Id/nhs-number'])"/>
								<xsl:call-template name="report_result">
									<xsl:with-param name="report_element" select="$MVPelement"/>
									<xsl:with-param name="report_result" select="$result"/>
								</xsl:call-template>
							</xsl:when>
							<xsl:otherwise>
								<xsl:variable name="result" select="boolean($test_resource/*[name()=$MVPelement])"/>
								<xsl:call-template name="report_result">
									<xsl:with-param name="report_element" select="$MVPelement"/>
									<xsl:with-param name="report_result" select="$result"/>
								</xsl:call-template>
							</xsl:otherwise>
						</xsl:choose>
						<!-- SPECIAL CASES -->
					</xsl:for-each>
				</table>
			</xsl:when>
			<xsl:otherwise>
				<table border="0">
					<tr>
						<td style="color:#ff9933;font-weight:bold">
							<xsl:value-of select="$resource"/>
							<xsl:text> resource NOT FOUND in test message</xsl:text>
						</td>
					</tr>
					<tr>
			</tr>
				</table>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<xsl:template name="report_result">
		<xsl:param name="report_element"/>
		<xsl:param name="report_result"/>
		<xsl:if test="$report_result">
			<tr>
				<td style="color:#008000">
					<xsl:value-of select="$report_element"/>
				</td>
				<!-- see if it is in the message -->
				<td style="color:#008000">
					<xsl:value-of select="$report_result"/>
				</td>
			</tr>
		</xsl:if>
		<xsl:if test="not($report_result)">
			<tr>
				<td style="color:#008000">
					<xsl:value-of select="$report_element"/>
				</td>
				<!-- see if it is in the message -->
				<td style="color:#900000">
					<xsl:value-of select="$report_result"/>
				</td>
			</tr>
		</xsl:if>
	</xsl:template>
</xsl:stylesheet>
