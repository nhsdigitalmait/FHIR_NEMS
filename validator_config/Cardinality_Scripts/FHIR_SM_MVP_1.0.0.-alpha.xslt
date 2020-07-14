<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:fn="http://www.w3.org/2005/xpath-functions" xpath-default-namespace="http://hl7.org/fhir">
  <xsl:output method="html" encoding="UTF-8" indent="yes" omit-xml-declaration="yes" />
  <xsl:template match="/">
    <table border="0">
    <th style="color:#008000">ePMA FHIR Implementation Guidance 1.0.0-alpha: MVP Elements</th>

      <!-- Load reference file-->
      <xsl:variable name="supportedevents" select="document('./SupportedEvents3.xml')" />
      <!-- Get the counts of elements with business rules -->
      <xsl:variable name="id_count" select="count(//*[name()='MedicationRequest']/*[name()='id'])" />
      <xsl:variable name="status_count" select="count(//*[name()='MedicationRequest']/*[name()='status'])" />
	<xsl:variable name="intent_count" select="count(//*[name()='MedicationRequest']/*[name()='intent'])" />
    <xsl:variable name="category_count" select="count(//*[name()='MedicationRequest']/*[name()='category'])" />
    <xsl:variable name="medication_count" select="count(//*[name()='MedicationRequest']/*[name()='medication'])" />
    <xsl:variable name="subject_count" select="count(//*[name()='MedicationRequest']/*[name()='subject'])" />
    <xsl:variable name="authoredOn_count" select="count(//*[name()='MedicationRequest']/*[name()='authoredOn'])" />
	<xsl:variable name="requester_count" select="count(//*[name()='MedicationRequest']/*[name()='requester'])" />
     <xsl:variable name="recorder_count" select="count(//*[name()='MedicationRequest']/*[name()='recorder'])" />
<xsl:variable name="dosageInstruction_count" select="count(//*[name()='MedicationRequest']/*[name()='dosageInstruction'])" />
<xsl:variable name="substitution_count" select="count(//*[name()='MedicationRequest']/*[name()='substitution'])" />     
                                                
      <!--Check the count of each component against the cardinality values in the reference file-->
      <xsl:call-template name="cardinality_check">
        <xsl:with-param name="count" select="$id_count" />
        <xsl:with-param name="ref_xpath" select="$supportedevents//publication/elements/element" />
        <xsl:with-param name="ref_attribute" select="'mr_id'" />
      </xsl:call-template>    
      <xsl:call-template name="cardinality_check">
        <xsl:with-param name="count" select="$status_count" />
        <xsl:with-param name="ref_xpath" select="$supportedevents//publication/elements/element" />
        <xsl:with-param name="ref_attribute" select="'mr_status'" />
      </xsl:call-template>    
      
      <xsl:call-template name="cardinality_check">
        <xsl:with-param name="count" select="$intent_count" />
        <xsl:with-param name="ref_xpath" select="$supportedevents//publication/elements/element" />
        <xsl:with-param name="ref_attribute" select="'mr_intent'" />
      </xsl:call-template>    
      
            <xsl:call-template name="cardinality_check">
        <xsl:with-param name="count" select="$category_count" />
        <xsl:with-param name="ref_xpath" select="$supportedevents//publication/elements/element" />
        <xsl:with-param name="ref_attribute" select="'mr_category'" />
      </xsl:call-template>    


      <xsl:call-template name="cardinality_check">
        <xsl:with-param name="count" select="$medication_count" />
        <xsl:with-param name="ref_xpath" select="$supportedevents//publication/elements/element" />
        <xsl:with-param name="ref_attribute" select="'mr_medication'" />
      </xsl:call-template>    

      <xsl:call-template name="cardinality_check">
        <xsl:with-param name="count" select="$subject_count" />
        <xsl:with-param name="ref_xpath" select="$supportedevents//publication/elements/element" />
        <xsl:with-param name="ref_attribute" select="'mr_subject'" />
      </xsl:call-template>    

      <xsl:call-template name="cardinality_check">
        <xsl:with-param name="count" select="$authoredOn_count" />
        <xsl:with-param name="ref_xpath" select="$supportedevents//publication/elements/element" />
        <xsl:with-param name="ref_attribute" select="'mr_authoredOn'" />
      </xsl:call-template>    

      <xsl:call-template name="cardinality_check">
        <xsl:with-param name="count" select="$requester_count" />
        <xsl:with-param name="ref_xpath" select="$supportedevents//publication/elements/element" />
        <xsl:with-param name="ref_attribute" select="'mr_requester'" />
      </xsl:call-template>    
      <xsl:call-template name="cardinality_check">
        <xsl:with-param name="count" select="$recorder_count" />
        <xsl:with-param name="ref_xpath" select="$supportedevents//publication/elements/element" />
        <xsl:with-param name="ref_attribute" select="'mr_recorder'" />
      </xsl:call-template>    
            <xsl:call-template name="cardinality_check">
        <xsl:with-param name="count" select="$dosageInstruction_count" />
        <xsl:with-param name="ref_xpath" select="$supportedevents//publication/elements/element" />
        <xsl:with-param name="ref_attribute" select="'mr_dosageInstruction'" />
      </xsl:call-template>    
      
            <xsl:call-template name="cardinality_check">
        <xsl:with-param name="count" select="$substitution_count" />
        <xsl:with-param name="ref_xpath" select="$supportedevents//publication/elements/element" />
        <xsl:with-param name="ref_attribute" select="'mr_substitution'" />
      </xsl:call-template>    
    </table>
  </xsl:template>
  
  <xsl:template name="cardinality_check">
		<xsl:param name="count"/>
		<xsl:param name="ref_xpath"/>
		<xsl:param name="ref_attribute"/>
		<xsl:variable name="min" select="$ref_xpath[@name=$ref_attribute]/@min"/>
		<xsl:variable name="max" select="$ref_xpath[@name=$ref_attribute]/@max"/>
		<xsl:variable name="resultString" select="concat( substring-after($ref_attribute,'mr_'), ' element is ')"/>
		<xsl:choose>
			<xsl:when test="((number($count) &lt; number($min)) or (number($count) &gt; number($max)))">
				<xsl:call-template name="reportError">
					<xsl:with-param name="resultString" select="$resultString"/>
				</xsl:call-template>
			</xsl:when>
			<xsl:otherwise>
				<xsl:call-template name="reportPass">
					<xsl:with-param name="resultString" select="$resultString"/>
				</xsl:call-template>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
		<xsl:template name="reportPass">
		<xsl:param name="resultString"/>
		<tr>
			<td style="color:#008000">
				<xsl:value-of select="$resultString"/>
				<xsl:text>   present</xsl:text>
			</td>
		</tr>
	</xsl:template>
	<xsl:template name="reportError">
		<xsl:param name="resultString"/>
		<tr>
			<td style="color:#900000">
				<xsl:value-of select="$resultString"/>
				<xsl:text>    not present</xsl:text>
			</td>
		</tr>
	</xsl:template>
</xsl:stylesheet>

