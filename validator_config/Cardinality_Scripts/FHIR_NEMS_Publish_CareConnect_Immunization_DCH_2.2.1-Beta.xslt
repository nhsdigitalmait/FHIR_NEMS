<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:fn="http://www.w3.org/2005/xpath-functions" xpath-default-namespace="http://hl7.org/fhir">
  <xsl:output method="html" encoding="UTF-8" indent="yes" omit-xml-declaration="yes" />
  <xsl:include href="reporting_templates.xslt" />
  <xsl:include href="referencing_templates.xslt" />
  <xsl:template match="/">
    <table border="0">
      <!-- Load reference file-->
      <xsl:variable name="supportedevents" select="document('./SupportedEvents3.xml')" />
      <!-- Get the counts of elements with business rules -->
      <xsl:variable name="extension_count" select="count(//*[name()='Immunization']/*[name()='extension'][@url='https://fhir.hl7.org.uk/STU3/StructureDefinition/Extension-CareConnect-VaccinationProcedure-1'])" />
      <xsl:variable name="identifier_count" select="count(//*[name()='Immunization']/*[name()='identifier'])" />
      <xsl:variable name="notGiven_count" select="count(//*[name()='Immunization']/*[name()='notGiven'])" />
      <xsl:variable name="vaccineCode_count" select="count(//*[name()='Immunization']/*[name()='vaccineCode'])" />
      <xsl:variable name="date_count" select="count(//*[name()='Immunization']/*[name()='date'])" />
      <xsl:variable name="primarySource_count" select="count(//*[name()='Immunization']/*[name()='primarySource'])" />
      <xsl:variable name="reportOrigin_count" select="count(//*[name()='Immunization']/*[name()='reportOrigin'])" />
      <xsl:variable name="manufacturer_count" select="count(//*[name()='Immunization']/*[name()='manufacturer'])" />
      <xsl:variable name="site_count" select="count(//*[name()='Immunization']/*[name()='site'])" />
      <xsl:variable name="route_count" select="count(//*[name()='Immunization']/*[name()='route'])" />
      <xsl:variable name="explanation_reasonNotGiven_count" select="count(//*[name()='Immunization']/*[name()='explanation']/*[name()='reasonNotGiven'])" />
      <xsl:variable name="vaccinationProtocol_doseSequence_count" select="count(//*[name()='Immunization']/*[name()='vaccinationProtocol']/*[name()='doseSequence'])" />
      <!--Check the count of each component against the cardinality values in the reference file-->
      <xsl:call-template name="cardinality_check">
        <xsl:with-param name="count" select="$extension_count" />
        <xsl:with-param name="ref_xpath" select="$supportedevents//publication/elements/element" />
        <xsl:with-param name="ref_attribute" select="'i_extension'" />
      </xsl:call-template>    
      <xsl:call-template name="cardinality_check">
        <xsl:with-param name="count" select="$identifier_count" />
        <xsl:with-param name="ref_xpath" select="$supportedevents//publication/elements/element" />
        <xsl:with-param name="ref_attribute" select="'i_identifier'" />
      </xsl:call-template>    
      <xsl:call-template name="cardinality_check">
        <xsl:with-param name="count" select="$notGiven_count" />
        <xsl:with-param name="ref_xpath" select="$supportedevents//publication/elements/element" />
        <xsl:with-param name="ref_attribute" select="'i_notGiven'" />
      </xsl:call-template>    
      <xsl:call-template name="cardinality_check">
        <xsl:with-param name="count" select="$vaccineCode_count" />
        <xsl:with-param name="ref_xpath" select="$supportedevents//publication/elements/element" />
        <xsl:with-param name="ref_attribute" select="'i_vaccineCode'" />
      </xsl:call-template>    
      <xsl:call-template name="cardinality_check">
        <xsl:with-param name="count" select="$date_count" />
        <xsl:with-param name="ref_xpath" select="$supportedevents//publication/elements/element" />
        <xsl:with-param name="ref_attribute" select="'i_date'" />
      </xsl:call-template>    
      <xsl:call-template name="cardinality_check">
        <xsl:with-param name="count" select="$primarySource_count" />
        <xsl:with-param name="ref_xpath" select="$supportedevents//publication/elements/element" />
        <xsl:with-param name="ref_attribute" select="'i_primarySource'" />
      </xsl:call-template>    
      <xsl:call-template name="cardinality_check">
        <xsl:with-param name="count" select="$reportOrigin_count" />
        <xsl:with-param name="ref_xpath" select="$supportedevents//publication/elements/element" />
        <xsl:with-param name="ref_attribute" select="'i_reportOrigin'" />
      </xsl:call-template>    
      <xsl:call-template name="cardinality_check">
        <xsl:with-param name="count" select="$manufacturer_count" />
        <xsl:with-param name="ref_xpath" select="$supportedevents//publication/elements/element" />
        <xsl:with-param name="ref_attribute" select="'i_manufacturer'" />
      </xsl:call-template>    
      <xsl:call-template name="cardinality_check">
        <xsl:with-param name="count" select="$site_count" />
        <xsl:with-param name="ref_xpath" select="$supportedevents//publication/elements/element" />
        <xsl:with-param name="ref_attribute" select="'i_site'" />
      </xsl:call-template>    
      <xsl:call-template name="cardinality_check">
        <xsl:with-param name="count" select="$route_count" />
        <xsl:with-param name="ref_xpath" select="$supportedevents//publication/elements/element" />
        <xsl:with-param name="ref_attribute" select="'i_route'" />
      </xsl:call-template>    
      <xsl:call-template name="cardinality_check">
        <xsl:with-param name="count" select="$explanation_reasonNotGiven_count" />
        <xsl:with-param name="ref_xpath" select="$supportedevents//publication/elements/element" />
        <xsl:with-param name="ref_attribute" select="'i_explanation_reasonNotGiven'" />
      </xsl:call-template>    
      <xsl:call-template name="cardinality_check">
        <xsl:with-param name="count" select="$vaccinationProtocol_doseSequence_count" />
        <xsl:with-param name="ref_xpath" select="$supportedevents//publication/elements/element" />
        <xsl:with-param name="ref_attribute" select="'i_vaccinationProtocol_doseSequence'" />
      </xsl:call-template>    
    </table>
  </xsl:template>
</xsl:stylesheet>
