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
      <xsl:variable name="organization_count" select="count(//*[name()='PractitionerRole']/*[name()='organization'])" />
      <xsl:variable name="practitioner_count" select="count(//*[name()='PractitionerRole']/*[name()='practitioner'])" />
      <xsl:variable name="code_count" select="count(//*[name()='PractitionerRole']/*[name()='code'])" />
      <xsl:variable name="specialty_count" select="count(//*[name()='PractitionerRole']/*[name()='specialty'])" />
      <!--Check the count of each component against the cardinality values in the reference file-->
      <xsl:call-template name="cardinality_check">
        <xsl:with-param name="count" select="$organization_count" />
        <xsl:with-param name="ref_xpath" select="$supportedevents//publication/elements/element" />
        <xsl:with-param name="ref_attribute" select="'pr_organization'" />
      </xsl:call-template>    
      <xsl:call-template name="cardinality_check">
        <xsl:with-param name="count" select="$practitioner_count" />
        <xsl:with-param name="ref_xpath" select="$supportedevents//publication/elements/element" />
        <xsl:with-param name="ref_attribute" select="'pr_practitioner'" />
      </xsl:call-template>    
      <xsl:call-template name="cardinality_check">
        <xsl:with-param name="count" select="$code_count" />
        <xsl:with-param name="ref_xpath" select="$supportedevents//publication/elements/element" />
        <xsl:with-param name="ref_attribute" select="'pr_code'" />
      </xsl:call-template>    
      <xsl:call-template name="cardinality_check">
        <xsl:with-param name="count" select="$specialty_count" />
        <xsl:with-param name="ref_xpath" select="$supportedevents//publication/elements/element" />
        <xsl:with-param name="ref_attribute" select="'pr_specialty'" />
      </xsl:call-template>    
    </table>
  </xsl:template>
</xsl:stylesheet>
