<?xml version="1.0" encoding="UTF-8"?>
<!-- Validate NEMS-Subscription-1 resource details. -->
<!-- January 2019                                        		    -->
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:fhir="http://hl7.org/fhir" xmlns:xs="http://www.w3.org/2001/XMLSchema" xpath-default-namespace="http://hl7.org/fhir">
	<xsl:output method="html" encoding="UTF-8" indent="yes" omit-xml-declaration="yes"/>
	<xsl:template match="/">
		<table border="0">
			<xsl:for-each select="/Subscription">
			
				
				<!-- check  mandatory STATUS is present -->
				<xsl:variable name="status" select="./status/@value"/>
				<xsl:variable name="report_string" select=" 'The status of the subscription will always be &quot;requested&quot; until the subscription is reviewed and activated' "/>
				
				<xsl:choose>
					<xsl:when test="$status=('requested')">
						<xsl:call-template name="reportPassLocation">
							<xsl:with-param name="resultString" select="$report_string"/>
							<xsl:with-param name="location" select="./status"/>
						</xsl:call-template>
					</xsl:when>
					<xsl:otherwise>
						<xsl:call-template name="reportErrorLocation">
								<xsl:with-param name="resultString" select="$report_string"/>
								<xsl:with-param name="location" select="./status"/>
						</xsl:call-template>
					</xsl:otherwise>
				</xsl:choose>
				
				
				<!-- Contact ,  The first instance of the contact element within the Subscription resource SHALL represent the organization requesting the subscription. -->
				
					<xsl:if test="count(./contact)=0">
						<xsl:variable name="report_string" select=" 'The first instance of the contact element within the Subscription resource SHALL represent the organization requesting the subscription. There are no contact details present  ' "/>
						<xsl:call-template name="reportErrorLocation">
							<xsl:with-param name="resultString" select="$report_string"/>
							<xsl:with-param name="location" select="."/>
						</xsl:call-template>
					</xsl:if>
										
					<xsl:if test="count(./contact) !=0">
						<xsl:variable name="ODS_code" select="substring-after(./contact[1]/value/@value, 'https://directory.spineservices.nhs.uk/STU3/Organization/') "/>
						<xsl:variable name="use" select="./contact[1]/use/@value"/>
						<xsl:variable name="report_string" select=" 'The first instance of the contact element within the Subscription resource SHALL represent the organization requesting the subscription  ' "/>
						<!--<xsl:value-of select="$use"/>-->
						
						<xsl:choose>
							<xsl:when test="(string-length($ODS_code) &gt; 0) and ($use='work') ">
							
							<xsl:call-template name="reportPassLocation">
								<xsl:with-param name="resultString" select="$report_string"/>
								<xsl:with-param name="location" select="./contact[1]/value"/>
							</xsl:call-template>
							</xsl:when>
							
							<xsl:otherwise>
								<xsl:call-template name="reportErrorLocation">
									<xsl:with-param name="resultString" select="$report_string"/>
									<xsl:with-param name="location" select="./contact[1]/value"/>
								</xsl:call-template>
							</xsl:otherwise>
						</xsl:choose>
					</xsl:if>
				
				
				<!-- End Date/time -->
				<xsl:variable name="endDT" select="./end/@value"/>
				<xsl:variable name="report_string" select=" 'End date/time for subscription  ' "/>
				
				<xsl:if test="$endDT">
					<xsl:choose>
						<xsl:when test="$endDT castable as xs:dateTime">
								<xsl:call-template name="reportPassLocation">
								<xsl:with-param name="resultString" select="$report_string"/>
								<xsl:with-param name="location" select="./end"/>
							</xsl:call-template>					
						</xsl:when>
						<xsl:otherwise>
							<xsl:call-template name="reportErrorLocation">
								<xsl:with-param name="resultString" select="$report_string"/>
								<xsl:with-param name="location" select="./end"/>
							</xsl:call-template>
						
						</xsl:otherwise>
					</xsl:choose>
				</xsl:if>
				
				
				
				
				<!-- Reason (1..1)-->
				<xsl:variable name="reason" select="./reason/@value"/>
				<xsl:variable name="report_string" select=" 'The reason for creating the subscription is mandatry ' "/>
				
				<xsl:choose>
					<xsl:when test="$reason and (string-length(./reason/@value) &gt; 0)">
							<xsl:call-template name="reportPassLocation">
							<xsl:with-param name="resultString" select="$report_string"/>
							<xsl:with-param name="location" select="./reason"/>
						</xsl:call-template>					
					</xsl:when>
					<xsl:otherwise>
						<xsl:call-template name="reportErrorLocation">
							<xsl:with-param name="resultString" select="$report_string"/>
							<xsl:with-param name="location" select="./reason"/>
						</xsl:call-template>
					
					</xsl:otherwise>
				</xsl:choose>
				
								
				<!-- Criteria -->
				<xsl:variable name="criteria" select="./criteria/@value"/>
				<xsl:variable name="report_string" select=" 'Criteria to match events against for this subscription ' "/>
				 
				<xsl:choose>
					<xsl:when test="$criteria and (string-length($criteria) &gt; 0)">
							<xsl:call-template name="reportPassLocation">
							<xsl:with-param name="resultString" select="$report_string"/>
							<xsl:with-param name="location" select="./criteria"/>
						</xsl:call-template>					
					</xsl:when>
					<xsl:otherwise>
						<xsl:call-template name="reportErrorLocation">
							<xsl:with-param name="resultString" select="$report_string"/>
							<xsl:with-param name="location" select="./criteria"/>
						</xsl:call-template>
					</xsl:otherwise>
				</xsl:choose>
				
				
				<!-- Channel is Mandatory (1..1) -->
				<xsl:variable name="channel" select="./channel"/>
				<xsl:variable name="report_string" select=" 'Channel data block is mandatry ' "/>
				 
				<xsl:choose>
					<xsl:when test="$channel">
							<xsl:call-template name="reportPassLocation">
							<xsl:with-param name="resultString" select="$report_string"/>
							<xsl:with-param name="location" select="./channel"/>
						</xsl:call-template>					
					</xsl:when>
					<xsl:otherwise>
						<xsl:call-template name="reportErrorLocation">
							<xsl:with-param name="resultString" select="$report_string"/>
							<xsl:with-param name="location" select="./channel"/>
						</xsl:call-template>
					</xsl:otherwise>
				</xsl:choose>
				
				
				<!-- Channel.Type(1..1) -->
				<xsl:variable name="c_type" select="./channel/type/@value"/>
				<xsl:variable name="report_string" select=" 'The delivery channel to use to deliver the event to the subscriber, currently only &quot;message&quot; is supported ' "/>
				 
				<xsl:choose>
					<xsl:when test="$c_type">
							<xsl:call-template name="reportPassLocation">
							<xsl:with-param name="resultString" select="$report_string"/>
							<xsl:with-param name="location" select="./channel/type"/>
						</xsl:call-template>					
					</xsl:when>
					<xsl:otherwise>
						<xsl:call-template name="reportErrorLocation">
							<xsl:with-param name="resultString" select="$report_string"/>
							<xsl:with-param name="location" select="./channel/type"/>
						</xsl:call-template>
					</xsl:otherwise>
				</xsl:choose>
				
				
				<!-- Channel.Endpoint (0..1 in FHIR spec BUT must be present here). -->
				<xsl:variable name="c_endpoint" select="./channel/endpoint/@value"/>
				<xsl:variable name="report_string" select=" 'The specific endpoint (initially MESH mailbox ID) to deliver to  ' "/>
				 
				<xsl:choose>
					<xsl:when test="$c_endpoint and (string-length($c_endpoint) &gt; 0)">
							<xsl:call-template name="reportPassLocation">
							<xsl:with-param name="resultString" select="$report_string"/>
							<xsl:with-param name="location" select="./channel/endpoint"/>
						</xsl:call-template>					
					</xsl:when>
					<xsl:otherwise>
						<xsl:call-template name="reportErrorLocation">
							<xsl:with-param name="resultString" select="$report_string"/>
							<xsl:with-param name="location" select="./channel/endpoint"/>
						</xsl:call-template>
					</xsl:otherwise>
				</xsl:choose>
				
			</xsl:for-each>
		</table>
	</xsl:template>
	
	
	
	<!-- reusable reporting templates -->
	<xsl:template name="reportPass">
		<xsl:param name="resultString"/>
			<tr>
				<td style="color:#008000">
					<xsl:value-of select="$resultString"/>
					<xsl:text>   PASS</xsl:text>
				</td>
			</tr>
	</xsl:template>	
	
	<xsl:template name="reportError">
		<xsl:param name="resultString"/>
			<tr>
				<td style="color:#900000">
					<xsl:value-of select="$resultString"/>
					<xsl:text>    ERROR</xsl:text>
				</td>
			</tr>
	</xsl:template>
	
	<xsl:template name="reportPassLocation">
		<xsl:param name="resultString"/>
		<xsl:param name="location"/>
			<tr>
				<td style="color:#008000">
					<xsl:value-of select="$resultString"/>
					<xsl:text> in xpath '</xsl:text>
					<xsl:call-template name="plotPath">
						<xsl:with-param name="forNode" select="$location"/>
					</xsl:call-template>
					<xsl:text>'   PASS</xsl:text>
				</td>
			</tr>
	</xsl:template>
	
	<xsl:template name="reportErrorLocation">
		<xsl:param name="resultString"/>
		<xsl:param name="location"/>
			<tr>
				<td style="color:#900000">
					
					<xsl:value-of select="$resultString"/>
					<xsl:text> in xpath '</xsl:text>
					<xsl:call-template name="plotPath">
						<xsl:with-param name="forNode" select="$location"/>
					</xsl:call-template>
					<xsl:text>'    ERROR</xsl:text>
				</td>
			</tr>
	</xsl:template>
	<xsl:include href="FHIR_Generic_Get_Xpath_v1.0.xslt"/>
</xsl:stylesheet>
