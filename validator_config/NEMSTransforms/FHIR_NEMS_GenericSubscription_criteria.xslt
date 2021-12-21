<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:fn="http://www.w3.org/2005/xpath-functions" xpath-default-namespace="http://hl7.org/fhir">
	<xsl:output method="html" encoding="UTF-8" indent="yes" omit-xml-declaration="yes"/>
	<xsl:include href="reporting_templates.xslt"/>
	<xsl:include href="referencing_templates.xslt"/>
	<xsl:template match="/">
		<table border="0">
			<!-- Load reference file-->
			<xsl:variable name="supportedevents" select="document('./GenericSubscriptionSupportedEvents.xml')"/>
			<!-- Get full criteria string-->
			<xsl:variable name="criteria" select="//criteria/@value"/>
			<!-- Set start character and delimiter-->
			<xsl:variable name="startchar" select="'/'"/>
			<xsl:variable name="delim" select="'&amp;'"/>
			<!-- Declare criteria components-->
			<xsl:variable name="bundleType" select="'Bundle?type='"/>
			<xsl:variable name="serviceType" select="'serviceType='"/>
			<xsl:variable name="patient" select="'Patient.identifier='"/>
			<xsl:variable name="event" select="'MessageHeader.event='"/>
			<xsl:variable name="age1" select="'Patient.age='"/>
			<xsl:variable name="age2" select="'Patient.age='"/>
			<xsl:variable name="subscriptionRuleType" select="'subscriptionRuleType='"/>
			<xsl:variable name="organization" select="'Organization.identifier='"/>
			<xsl:variable name="tag" select="'tag='"/>
			<xsl:variable name="c_count" select="count(tokenize($criteria,$delim))"/>
			<xsl:variable name="c_tokens" select="tokenize($criteria,$delim)"/>
			<xsl:variable name="bundleType_present" select="(contains($criteria, $bundleType))"/>
			<xsl:variable name="serviceType_present" select="(contains($criteria, $serviceType))"/>
			<xsl:variable name="patient_present" select="(contains($criteria, $patient))"/>
			<xsl:variable name="event_present" select="(contains($criteria, $event))"/>
			<xsl:variable name="age_One_present" select="contains($criteria, $age1)"/>
			<xsl:variable name="age_Two_present" select="contains($criteria, $age1) and (contains(substring-after($criteria, $age1),$age1))"/>
			<xsl:variable name="subscriptionRuleType_present" select="(contains($criteria, $subscriptionRuleType))"/>
			<xsl:variable name="organization_present" select="(contains($criteria, $organization))"/>
			<xsl:variable name="tag_present" select="(contains($criteria, $tag))"/>
			<tr>
				<td style="color:#008000">
					<xsl:text> criteria_count: </xsl:text>
					<xsl:value-of select="$c_count"/>
				</td>
			</tr>
			<tr>
				<td style="color:#008000">
					<xsl:text> bundleType_present: </xsl:text>
					<xsl:value-of select="$bundleType_present"/>
				</td>
			</tr>
			<tr>
				<td style="color:#008000">
					<xsl:text> serviceType_present: </xsl:text>
					<xsl:value-of select="$serviceType_present"/>
				</td>
			</tr>
			<tr>
				<td style="color:#008000">
					<xsl:text> patient_present: </xsl:text>
					<xsl:value-of select="$patient_present"/>
				</td>
			</tr>
			<tr>
				<td style="color:#008000">
					<xsl:text> event_present: </xsl:text>
					<xsl:value-of select="$event_present"/>
				</td>
			</tr>
			<tr>
				<td style="color:#008000">
					<xsl:text> age[1]_present: </xsl:text>
					<xsl:value-of select="$age_One_present"/>
				</td>
			</tr>
			<tr>
				<td style="color:#008000">
					<xsl:text> age[2]_present: </xsl:text>
					<xsl:value-of select="$age_Two_present"/>
				</td>
			</tr>
			<tr>
				<td style="color:#008000">
					<xsl:text> subscriptionRuleType_present: </xsl:text>
					<xsl:value-of select="$subscriptionRuleType_present"/>
				</td>
			</tr>
			<tr>
				<td style="color:#008000">
					<xsl:text> organization_present: </xsl:text>
					<xsl:value-of select="$organization_present"/>
				</td>
			</tr>
			<tr>
				<td style="color:#008000">
					<xsl:text> tag_present: </xsl:text>
					<xsl:value-of select="$tag_present"/>
				</td>
			</tr>
			<xsl:choose>
				<xsl:when test="not($c_count&lt;3 or $c_count&gt;8 or contains($criteria, concat($delim,$delim))  or starts-with($criteria, $delim) or ends-with($criteria, $delim)) and not($patient_present) ">
					<xsl:choose>
						<!--BSEAASOT-->
						<xsl:when test="$bundleType_present and $serviceType_present and $event_present and $age_One_present and $age_Two_present and $subscriptionRuleType_present and $organization_present and $tag_present and $c_count=8">
							<xsl:choose>
								<xsl:when test="contains($c_tokens[1],$bundleType) and contains($c_tokens[2],$serviceType) and contains($c_tokens[3],$event) and contains($c_tokens[4],$age1) and contains($c_tokens[5],$age2) and contains($c_tokens[6],$subscriptionRuleType) and contains($c_tokens[7],$organization) and contains($c_tokens[8],$tag)">
									<tr>
										<td style="color:#008000">
											<xsl:text>Precedence for selected criteria is correct PASS</xsl:text>
										</td>
									</tr>
									<xsl:variable name="c_bundleType" select="$c_tokens[1]"/>
									<xsl:variable name="c_serviceType" select="replace($c_tokens[2],$serviceType,'')"/>
									<xsl:variable name="c_event" select="replace($c_tokens[3],$event,'')"/>
									<xsl:variable name="c_age1" select="replace($c_tokens[4],$age1,'')"/>
									<xsl:variable name="c_age2" select="replace($c_tokens[5],$age2,'')"/>
									<xsl:variable name="c_subscriptionRuleType" select="replace($c_tokens[6],$subscriptionRuleType,'')"/>
									<xsl:variable name="c_Organization" select="replace($c_tokens[7],$organization,'')"/>
									<xsl:variable name="c_tag" select="replace($c_tokens[8],$tag,'')"/>
									<!--Check each value in the parsed component lists against the allowable values in the reference file-->
									<xsl:call-template name="nems_ref_check">
										<xsl:with-param name="delim" select="'/'"/>
										<xsl:with-param name="name" select="replace($bundleType, '\?', '\\?')"/>
										<xsl:with-param name="list_name" select="$c_bundleType"/>
										<xsl:with-param name="ref_xpath" select="$supportedevents//bundleType"/>
										<xsl:with-param name="ref_attribute" select="'name'"/>
									</xsl:call-template>
									<xsl:call-template name="nems_ref_check">
										<xsl:with-param name="delim" select="$delim"/>
										<xsl:with-param name="name" select="$serviceType"/>
										<xsl:with-param name="list_name" select="$c_serviceType"/>
										<xsl:with-param name="ref_xpath" select="$supportedevents//serviceType"/>
										<xsl:with-param name="ref_attribute" select="'code'"/>
									</xsl:call-template>
									<xsl:call-template name="nems_ref_check">
										<xsl:with-param name="delim" select="$delim"/>
										<xsl:with-param name="name" select="$event"/>
										<xsl:with-param name="list_name" select="$c_event"/>
										<xsl:with-param name="ref_xpath" select="$supportedevents//event[@subscription='T']"/>
										<xsl:with-param name="ref_attribute" select="'code'"/>
									</xsl:call-template>
									<xsl:choose>
										<xsl:when test="matches($c_age1,'^[l|g]?t?[0-9]+(:contains)?$')">
											<tr>
												<td style="color:#008000">
													<xsl:text>&amp;age[1] matches regular expression ^[l|g]?t?[0-9]+(:contains)?$ PASS</xsl:text>
												</td>
											</tr>
										</xsl:when>
										<xsl:otherwise>
											<tr>
												<td style="color:#900000">
													<xsl:text>&amp;age[1] does not match regular expression  ^[l|g]?t?[0-9]+(:contains)?$ ERROR</xsl:text>
												</td>
											</tr>
										</xsl:otherwise>
									</xsl:choose>
									<xsl:choose>
										<xsl:when test="matches($c_age2,'^[l|g]?t?[0-9]+(:contains)?$')">
											<tr>
												<td style="color:#008000">
													<xsl:text>&amp;age[2] matches regular expression ^[l|g]?t?[0-9]+(:contains)?$ PASS</xsl:text>
												</td>
											</tr>
										</xsl:when>
										<xsl:otherwise>
											<tr>
												<td style="color:#900000">
													<xsl:text>&amp;age[2] does not match regular expression  ^[l|g]?t?[0-9]+(:contains)?$ ERROR</xsl:text>
												</td>
											</tr>
										</xsl:otherwise>
									</xsl:choose>
									<xsl:call-template name="nems_ref_check">
										<xsl:with-param name="delim" select="$delim"/>
										<xsl:with-param name="name" select="$subscriptionRuleType"/>
										<xsl:with-param name="list_name" select="$c_subscriptionRuleType"/>
										<xsl:with-param name="ref_xpath" select="$supportedevents//subscriptionRuleType"/>
										<xsl:with-param name="ref_attribute" select="'code'"/>
									</xsl:call-template>
									<xsl:choose>
										<xsl:when test="$c_subscriptionRuleType = 'COUNTRYCODE'">
											<tr>
												<td style="color:#008000">
													<xsl:text>subscriptionRuleType=COUNTRYCODE, validating Organization.identifier against allowable values</xsl:text>
												</td>
											</tr>
											<xsl:call-template name="nems_ref_check">
												<xsl:with-param name="delim" select="$delim"/>
												<xsl:with-param name="name" select="$organization"/>
												<xsl:with-param name="list_name" select="$c_Organization"/>
												<xsl:with-param name="ref_xpath" select="$supportedevents//countrycode"/>
												<xsl:with-param name="ref_attribute" select="'code'"/>
											</xsl:call-template>
										</xsl:when>
										<xsl:otherwise>
											<tr>
												<td style="color:#008000">
													<xsl:text>&amp;Organization.identifier is present and of value '</xsl:text>
													<xsl:value-of select="$c_Organization"/>
													<xsl:text>' this value can not be automatically validated by the Test Harness</xsl:text>
												</td>
											</tr>
										</xsl:otherwise>
									</xsl:choose>
									<xsl:choose>
										<xsl:when test="matches($c_tag,'^[A-Za-z0-9,|_-]{0,100}$')">
											<tr>
												<td style="color:#008000">
													<xsl:text>&amp;tag matches regular expression ^[A-Za-z0-9,|_-]{0,100}$ PASS</xsl:text>
												</td>
											</tr>
										</xsl:when>
										<xsl:otherwise>
											<tr>
												<td style="color:#900000">
													<xsl:text>&amp;tag does not match regular expression  ^[A-Za-z0-9,|_-]{0,100}$ ERROR</xsl:text>
												</td>
											</tr>
										</xsl:otherwise>
									</xsl:choose>
									<!--END-->
								</xsl:when>
								<xsl:otherwise>
									<tr>
										<td style="color:#900000">
											<xsl:text>ERROR Precedence for selected criteria is incorrect, correct precedence is: BundleType, serviceType, MessageHeader.event, Patient.age[1], Patient.age[2], subscriptionRuleType, Organization.identifier, tag</xsl:text>
										</td>
									</tr>
								</xsl:otherwise>
							</xsl:choose>
						</xsl:when>
						<!--BSEAASO-->
						<xsl:when test="$bundleType_present and $serviceType_present and $event_present and $age_One_present and $age_Two_present and $subscriptionRuleType_present and $organization_present and not($tag_present) and $c_count=7">
							<xsl:choose>
								<xsl:when test="contains($c_tokens[1],$bundleType) and contains($c_tokens[2],$serviceType) and contains($c_tokens[3],$event) and contains($c_tokens[4],$age1) and contains($c_tokens[5],$age2) and contains($c_tokens[6],$subscriptionRuleType) and contains($c_tokens[7],$organization)">
									<tr>
										<td style="color:#008000">
											<xsl:text>PASS Precedence for selected criteria is correct</xsl:text>
										</td>
									</tr>
									<xsl:variable name="c_bundleType" select="$c_tokens[1]"/>
									<xsl:variable name="c_serviceType" select="replace($c_tokens[2],$serviceType,'')"/>
									<xsl:variable name="c_event" select="replace($c_tokens[3],$event,'')"/>
									<xsl:variable name="c_age1" select="replace($c_tokens[4],$age1,'')"/>
									<xsl:variable name="c_age2" select="replace($c_tokens[5],$age2,'')"/>
									<xsl:variable name="c_subscriptionRuleType" select="replace($c_tokens[6],$subscriptionRuleType,'')"/>
									<xsl:variable name="c_Organization" select="replace($c_tokens[7],$organization,'')"/>
									<!--Check each value in the parsed component lists against the allowable values in the reference file-->
									<xsl:call-template name="nems_ref_check">
										<xsl:with-param name="delim" select="'/'"/>
										<xsl:with-param name="name" select="replace($bundleType, '\?', '\\?')"/>
										<xsl:with-param name="list_name" select="$c_bundleType"/>
										<xsl:with-param name="ref_xpath" select="$supportedevents//bundleType"/>
										<xsl:with-param name="ref_attribute" select="'name'"/>
									</xsl:call-template>
									<xsl:call-template name="nems_ref_check">
										<xsl:with-param name="delim" select="$delim"/>
										<xsl:with-param name="name" select="$serviceType"/>
										<xsl:with-param name="list_name" select="$c_serviceType"/>
										<xsl:with-param name="ref_xpath" select="$supportedevents//serviceType"/>
										<xsl:with-param name="ref_attribute" select="'code'"/>
									</xsl:call-template>
									<xsl:call-template name="nems_ref_check">
										<xsl:with-param name="delim" select="$delim"/>
										<xsl:with-param name="name" select="$event"/>
										<xsl:with-param name="list_name" select="$c_event"/>
										<xsl:with-param name="ref_xpath" select="$supportedevents//event[@subscription='T']"/>
										<xsl:with-param name="ref_attribute" select="'code'"/>
									</xsl:call-template>
									<xsl:choose>
										<xsl:when test="matches($c_age1,'^[l|g]?t?[0-9]+(:contains)?$')">
											<tr>
												<td style="color:#008000">
													<xsl:text>&amp;age[1] matches regular expression ^[l|g]?t?[0-9]+(:contains)?$ PASS</xsl:text>
												</td>
											</tr>
										</xsl:when>
										<xsl:otherwise>
											<tr>
												<td style="color:#900000">
													<xsl:text>&amp;age[1] does not match regular expression  ^[l|g]?t?[0-9]+(:contains)?$ ERROR</xsl:text>
												</td>
											</tr>
										</xsl:otherwise>
									</xsl:choose>
									<xsl:choose>
										<xsl:when test="matches($c_age2,'^[l|g]?t?[0-9]+(:contains)?$')">
											<tr>
												<td style="color:#008000">
													<xsl:text>&amp;age[2] matches regular expression ^[l|g]?t?[0-9]+(:contains)?$ PASS</xsl:text>
												</td>
											</tr>
										</xsl:when>
										<xsl:otherwise>
											<tr>
												<td style="color:#900000">
													<xsl:text>&amp;age[2] does not match regular expression  ^[l|g]?t?[0-9]+(:contains)?$ ERROR</xsl:text>
												</td>
											</tr>
										</xsl:otherwise>
									</xsl:choose>
									<xsl:call-template name="nems_ref_check">
										<xsl:with-param name="delim" select="$delim"/>
										<xsl:with-param name="name" select="$subscriptionRuleType"/>
										<xsl:with-param name="list_name" select="$c_subscriptionRuleType"/>
										<xsl:with-param name="ref_xpath" select="$supportedevents//subscriptionRuleType"/>
										<xsl:with-param name="ref_attribute" select="'code'"/>
									</xsl:call-template>
									<xsl:choose>
										<xsl:when test="$c_subscriptionRuleType = 'COUNTRYCODE'">
											<tr>
												<td style="color:#008000">
													<xsl:text>subscriptionRuleType=COUNTRYCODE, validating Organization.identifier against allowable values</xsl:text>
												</td>
											</tr>
											<xsl:call-template name="nems_ref_check">
												<xsl:with-param name="delim" select="$delim"/>
												<xsl:with-param name="name" select="$organization"/>
												<xsl:with-param name="list_name" select="$c_Organization"/>
												<xsl:with-param name="ref_xpath" select="$supportedevents//countrycode"/>
												<xsl:with-param name="ref_attribute" select="'code'"/>
											</xsl:call-template>
										</xsl:when>
										<xsl:otherwise>
											<tr>
												<td style="color:#008000">
													<xsl:text>&amp;Organization.identifier is present and of value '</xsl:text>
													<xsl:value-of select="$c_Organization"/>
													<xsl:text>' this value can not be automatically validated by the Test Harness</xsl:text>
												</td>
											</tr>
										</xsl:otherwise>
									</xsl:choose>
									<!--END-->
								</xsl:when>
								<xsl:otherwise>
									<tr>
										<td style="color:#900000">
											<xsl:text>ERROR Precedence for selected criteria is incorrect, correct precedence is: BundleType, serviceType, MessageHeader.event, Patient.age[1], Patient.age[2], subscriptionRuleType, Organization.identifier</xsl:text>
										</td>
									</tr>
								</xsl:otherwise>
							</xsl:choose>
						</xsl:when>
						<!--BSEAAST-->
						<xsl:when test="$bundleType_present and $serviceType_present and $event_present and $age_One_present and $age_Two_present and $subscriptionRuleType_present and not($organization_present) and $tag_present and $c_count=7">
							<xsl:choose>
								<xsl:when test="contains($c_tokens[1],$bundleType) and contains($c_tokens[2],$serviceType) and contains($c_tokens[3],$event) and contains($c_tokens[4],$age1) and contains($c_tokens[5],$age2) and contains($c_tokens[6],$subscriptionRuleType) and contains($c_tokens[7],$tag)">
									<tr>
										<td style="color:#008000">
											<xsl:text>PASS Precedence for selected criteria is correct</xsl:text>
										</td>
									</tr>
									<xsl:variable name="c_bundleType" select="$c_tokens[1]"/>
									<xsl:variable name="c_serviceType" select="replace($c_tokens[2],$serviceType,'')"/>
									<xsl:variable name="c_event" select="replace($c_tokens[3],$event,'')"/>
									<xsl:variable name="c_age1" select="replace($c_tokens[4],$age1,'')"/>
									<xsl:variable name="c_age2" select="replace($c_tokens[5],$age2,'')"/>
									<xsl:variable name="c_subscriptionRuleType" select="replace($c_tokens[6],$subscriptionRuleType,'')"/>
									<xsl:variable name="c_tag" select="replace($c_tokens[7],$tag,'')"/>
									<!--Check each value in the parsed component lists against the allowable values in the reference file-->
									<xsl:call-template name="nems_ref_check">
										<xsl:with-param name="delim" select="'/'"/>
										<xsl:with-param name="name" select="replace($bundleType, '\?', '\\?')"/>
										<xsl:with-param name="list_name" select="$c_bundleType"/>
										<xsl:with-param name="ref_xpath" select="$supportedevents//bundleType"/>
										<xsl:with-param name="ref_attribute" select="'name'"/>
									</xsl:call-template>
									<xsl:call-template name="nems_ref_check">
										<xsl:with-param name="delim" select="$delim"/>
										<xsl:with-param name="name" select="$serviceType"/>
										<xsl:with-param name="list_name" select="$c_serviceType"/>
										<xsl:with-param name="ref_xpath" select="$supportedevents//serviceType"/>
										<xsl:with-param name="ref_attribute" select="'code'"/>
									</xsl:call-template>
									<xsl:call-template name="nems_ref_check">
										<xsl:with-param name="delim" select="$delim"/>
										<xsl:with-param name="name" select="$event"/>
										<xsl:with-param name="list_name" select="$c_event"/>
										<xsl:with-param name="ref_xpath" select="$supportedevents//event[@subscription='T']"/>
										<xsl:with-param name="ref_attribute" select="'code'"/>
									</xsl:call-template>
									<xsl:choose>
										<xsl:when test="matches($c_age1,'^[l|g]?t?[0-9]+(:contains)?$')">
											<tr>
												<td style="color:#008000">
													<xsl:text>&amp;age[1] matches regular expression ^[l|g]?t?[0-9]+(:contains)?$ PASS</xsl:text>
												</td>
											</tr>
										</xsl:when>
										<xsl:otherwise>
											<tr>
												<td style="color:#900000">
													<xsl:text>&amp;age[1] does not match regular expression  ^[l|g]?t?[0-9]+(:contains)?$ ERROR</xsl:text>
												</td>
											</tr>
										</xsl:otherwise>
									</xsl:choose>
									<xsl:choose>
										<xsl:when test="matches($c_age2,'^[l|g]?t?[0-9]+(:contains)?$')">
											<tr>
												<td style="color:#008000">
													<xsl:text>&amp;age[2] matches regular expression ^[l|g]?t?[0-9]+(:contains)?$ PASS</xsl:text>
												</td>
											</tr>
										</xsl:when>
										<xsl:otherwise>
											<tr>
												<td style="color:#900000">
													<xsl:text>&amp;age[2] does not match regular expression  ^[l|g]?t?[0-9]+(:contains)?$ ERROR</xsl:text>
												</td>
											</tr>
										</xsl:otherwise>
									</xsl:choose>
									<xsl:call-template name="nems_ref_check">
										<xsl:with-param name="delim" select="$delim"/>
										<xsl:with-param name="name" select="$subscriptionRuleType"/>
										<xsl:with-param name="list_name" select="$c_subscriptionRuleType"/>
										<xsl:with-param name="ref_xpath" select="$supportedevents//subscriptionRuleType"/>
										<xsl:with-param name="ref_attribute" select="'code'"/>
									</xsl:call-template>
									<xsl:choose>
										<xsl:when test="$c_subscriptionRuleType = 'COUNTRYCODE'">
											<tr>
												<td style="color:#900000">
													<xsl:text>subscriptionRuleType=COUNTRYCODE, required Organization.identifier NOT found ERROR</xsl:text>
												</td>
											</tr>
										</xsl:when>
									</xsl:choose>
									<xsl:choose>
										<xsl:when test="matches($c_tag,'^[A-Za-z0-9,|_-]{0,100}$')">
											<tr>
												<td style="color:#008000">
													<xsl:text>&amp;tag matches regular expression ^[A-Za-z0-9,|_-]{0,100}$ PASS</xsl:text>
												</td>
											</tr>
										</xsl:when>
										<xsl:otherwise>
											<tr>
												<td style="color:#900000">
													<xsl:text>&amp;tag does not match regular expression  ^[A-Za-z0-9,|_-]{0,100}$ ERROR</xsl:text>
												</td>
											</tr>
										</xsl:otherwise>
									</xsl:choose>
									<!--END-->
								</xsl:when>
								<xsl:otherwise>
									<tr>
										<td style="color:#900000">
											<xsl:text>ERROR Precedence for selected criteria is incorrect, correct precedence is: BundleType, serviceType, MessageHeader.event, Patient.age[1], Patient.age[2], subscriptionRuleType, tag</xsl:text>
										</td>
									</tr>
								</xsl:otherwise>
							</xsl:choose>
						</xsl:when>
						<!--BSEASOT-->
						<xsl:when test="$bundleType_present and $serviceType_present and $event_present and $age_One_present and not($age_Two_present) and $subscriptionRuleType_present and $organization_present and $tag_present and $c_count=7">
							<xsl:choose>
								<xsl:when test="contains($c_tokens[1],$bundleType) and contains($c_tokens[2],$serviceType) and contains($c_tokens[3],$event) and contains($c_tokens[4],$age1) and contains($c_tokens[5],$subscriptionRuleType) and contains($c_tokens[6],$organization) and contains($c_tokens[7],$tag)">
									<tr>
										<td style="color:#008000">
											<xsl:text>PASS Precedence for selected criteria is correct</xsl:text>
										</td>
									</tr>
									<xsl:variable name="c_bundleType" select="$c_tokens[1]"/>
									<xsl:variable name="c_serviceType" select="replace($c_tokens[2],$serviceType,'')"/>
									<xsl:variable name="c_event" select="replace($c_tokens[3],$event,'')"/>
									<xsl:variable name="c_age1" select="replace($c_tokens[4],$age1,'')"/>
									<xsl:variable name="c_subscriptionRuleType" select="replace($c_tokens[5],$subscriptionRuleType,'')"/>
									<xsl:variable name="c_Organization" select="replace($c_tokens[6],$organization,'')"/>
									<xsl:variable name="c_tag" select="replace($c_tokens[7],$tag,'')"/>
									<!--Check each value in the parsed component lists against the allowable values in the reference file-->
									<xsl:call-template name="nems_ref_check">
										<xsl:with-param name="delim" select="'/'"/>
										<xsl:with-param name="name" select="replace($bundleType, '\?', '\\?')"/>
										<xsl:with-param name="list_name" select="$c_bundleType"/>
										<xsl:with-param name="ref_xpath" select="$supportedevents//bundleType"/>
										<xsl:with-param name="ref_attribute" select="'name'"/>
									</xsl:call-template>
									<xsl:call-template name="nems_ref_check">
										<xsl:with-param name="delim" select="$delim"/>
										<xsl:with-param name="name" select="$serviceType"/>
										<xsl:with-param name="list_name" select="$c_serviceType"/>
										<xsl:with-param name="ref_xpath" select="$supportedevents//serviceType"/>
										<xsl:with-param name="ref_attribute" select="'code'"/>
									</xsl:call-template>
									<xsl:call-template name="nems_ref_check">
										<xsl:with-param name="delim" select="$delim"/>
										<xsl:with-param name="name" select="$event"/>
										<xsl:with-param name="list_name" select="$c_event"/>
										<xsl:with-param name="ref_xpath" select="$supportedevents//event[@subscription='T']"/>
										<xsl:with-param name="ref_attribute" select="'code'"/>
									</xsl:call-template>
									<xsl:choose>
										<xsl:when test="matches($c_age1,'^[l|g]?t?[0-9]+(:contains)?$')">
											<tr>
												<td style="color:#008000">
													<xsl:text>&amp;age[1] matches regular expression ^[l|g]?t?[0-9]+(:contains)?$ PASS</xsl:text>
												</td>
											</tr>
										</xsl:when>
										<xsl:otherwise>
											<tr>
												<td style="color:#900000">
													<xsl:text>&amp;age[1] does not match regular expression  ^[l|g]?t?[0-9]+(:contains)?$ ERROR</xsl:text>
												</td>
											</tr>
										</xsl:otherwise>
									</xsl:choose>
									<xsl:call-template name="nems_ref_check">
										<xsl:with-param name="delim" select="$delim"/>
										<xsl:with-param name="name" select="$subscriptionRuleType"/>
										<xsl:with-param name="list_name" select="$c_subscriptionRuleType"/>
										<xsl:with-param name="ref_xpath" select="$supportedevents//subscriptionRuleType"/>
										<xsl:with-param name="ref_attribute" select="'code'"/>
									</xsl:call-template>
									<xsl:choose>
										<xsl:when test="$c_subscriptionRuleType = 'COUNTRYCODE'">
											<tr>
												<td style="color:#008000">
													<xsl:text>subscriptionRuleType=COUNTRYCODE, validating Organization.identifier against allowable values</xsl:text>
												</td>
											</tr>
											<xsl:call-template name="nems_ref_check">
												<xsl:with-param name="delim" select="$delim"/>
												<xsl:with-param name="name" select="$organization"/>
												<xsl:with-param name="list_name" select="$c_Organization"/>
												<xsl:with-param name="ref_xpath" select="$supportedevents//countrycode"/>
												<xsl:with-param name="ref_attribute" select="'code'"/>
											</xsl:call-template>
										</xsl:when>
										<xsl:otherwise>
											<tr>
												<td style="color:#008000">
													<xsl:text>&amp;Organization.identifier is present and of value '</xsl:text>
													<xsl:value-of select="$c_Organization"/>
													<xsl:text>' this value can not be automatically validated by the Test Harness</xsl:text>
												</td>
											</tr>
										</xsl:otherwise>
									</xsl:choose>
									<xsl:choose>
										<xsl:when test="matches($c_tag,'^[A-Za-z0-9,|_-]{0,100}$')">
											<tr>
												<td style="color:#008000">
													<xsl:text>&amp;tag matches regular expression ^[A-Za-z0-9,|_-]{0,100}$ PASS</xsl:text>
												</td>
											</tr>
										</xsl:when>
										<xsl:otherwise>
											<tr>
												<td style="color:#900000">
													<xsl:text>&amp;tag does not match regular expression  ^[A-Za-z0-9,|_-]{0,100}$ ERROR</xsl:text>
												</td>
											</tr>
										</xsl:otherwise>
									</xsl:choose>
								</xsl:when>
								<!--END-->
								<xsl:otherwise>
									<tr>
										<td style="color:#900000">
											<xsl:text>ERROR Precedence for selected criteria is incorrect, correct precedence is: BundleType, serviceType, MessageHeader.event, Patient.age[1], subscriptionRuleType, Organization, tag</xsl:text>
										</td>
									</tr>
								</xsl:otherwise>
							</xsl:choose>
						</xsl:when>
						<!--BEAASOT-->
						<xsl:when test="$bundleType_present and not($serviceType_present) and $event_present and $age_One_present and $age_Two_present and $subscriptionRuleType_present and $organization_present and $tag_present and $c_count=7">
							<xsl:choose>
								<xsl:when test="contains($c_tokens[1],$bundleType) and contains($c_tokens[2],$event) and contains($c_tokens[3],$age1) and contains($c_tokens[4],$age2) and contains($c_tokens[5],$subscriptionRuleType) and contains($c_tokens[6],$organization) and contains($c_tokens[7],$tag)">
									<tr>
										<td style="color:#008000">
											<xsl:text>PASS Precedence for selected criteria is correct</xsl:text>
										</td>
									</tr>
									<xsl:variable name="c_bundleType" select="$c_tokens[1]"/>
									<xsl:variable name="c_event" select="replace($c_tokens[2],$event,'')"/>
									<xsl:variable name="c_age1" select="replace($c_tokens[3],$age1,'')"/>
									<xsl:variable name="c_age2" select="replace($c_tokens[4],$age2,'')"/>
									<xsl:variable name="c_subscriptionRuleType" select="replace($c_tokens[5],$subscriptionRuleType,'')"/>
									<xsl:variable name="c_Organization" select="replace($c_tokens[6],$organization,'')"/>
									<xsl:variable name="c_tag" select="replace($c_tokens[7],$tag,'')"/>
									<!--Check each value in the parsed component lists against the allowable values in the reference file-->
									<xsl:call-template name="nems_ref_check">
										<xsl:with-param name="delim" select="'/'"/>
										<xsl:with-param name="name" select="replace($bundleType, '\?', '\\?')"/>
										<xsl:with-param name="list_name" select="$c_bundleType"/>
										<xsl:with-param name="ref_xpath" select="$supportedevents//bundleType"/>
										<xsl:with-param name="ref_attribute" select="'name'"/>
									</xsl:call-template>
									<xsl:call-template name="nems_ref_check">
										<xsl:with-param name="delim" select="$delim"/>
										<xsl:with-param name="name" select="$event"/>
										<xsl:with-param name="list_name" select="$c_event"/>
										<xsl:with-param name="ref_xpath" select="$supportedevents//event[@subscription='T']"/>
										<xsl:with-param name="ref_attribute" select="'code'"/>
									</xsl:call-template>
									<xsl:choose>
										<xsl:when test="matches($c_age1,'^[l|g]?t?[0-9]+(:contains)?$')">
											<tr>
												<td style="color:#008000">
													<xsl:text>&amp;age[1] matches regular expression ^[l|g]?t?[0-9]+(:contains)?$ PASS</xsl:text>
												</td>
											</tr>
										</xsl:when>
										<xsl:otherwise>
											<tr>
												<td style="color:#900000">
													<xsl:text>&amp;age[1] does not match regular expression  ^[l|g]?t?[0-9]+(:contains)?$ ERROR</xsl:text>
												</td>
											</tr>
										</xsl:otherwise>
									</xsl:choose>
									<xsl:choose>
										<xsl:when test="matches($c_age2,'^[l|g]?t?[0-9]+(:contains)?$')">
											<tr>
												<td style="color:#008000">
													<xsl:text>&amp;age[2] matches regular expression ^[l|g]?t?[0-9]+(:contains)?$ PASS</xsl:text>
												</td>
											</tr>
										</xsl:when>
										<xsl:otherwise>
											<tr>
												<td style="color:#900000">
													<xsl:text>&amp;age[2] does not match regular expression  ^[l|g]?t?[0-9]+(:contains)?$ ERROR</xsl:text>
												</td>
											</tr>
										</xsl:otherwise>
									</xsl:choose>
									<xsl:call-template name="nems_ref_check">
										<xsl:with-param name="delim" select="$delim"/>
										<xsl:with-param name="name" select="$subscriptionRuleType"/>
										<xsl:with-param name="list_name" select="$c_subscriptionRuleType"/>
										<xsl:with-param name="ref_xpath" select="$supportedevents//subscriptionRuleType"/>
										<xsl:with-param name="ref_attribute" select="'code'"/>
									</xsl:call-template>
									<xsl:choose>
										<xsl:when test="$c_subscriptionRuleType = 'COUNTRYCODE'">
											<tr>
												<td style="color:#008000">
													<xsl:text>subscriptionRuleType=COUNTRYCODE, validating Organization.identifier against allowable values</xsl:text>
												</td>
											</tr>
											<xsl:call-template name="nems_ref_check">
												<xsl:with-param name="delim" select="$delim"/>
												<xsl:with-param name="name" select="$organization"/>
												<xsl:with-param name="list_name" select="$c_Organization"/>
												<xsl:with-param name="ref_xpath" select="$supportedevents//countrycode"/>
												<xsl:with-param name="ref_attribute" select="'code'"/>
											</xsl:call-template>
										</xsl:when>
										<xsl:otherwise>
											<tr>
												<td style="color:#008000">
													<xsl:text>&amp;Organization.identifier is present and of value '</xsl:text>
													<xsl:value-of select="$c_Organization"/>
													<xsl:text>' this value can not be automatically validated by the Test Harness</xsl:text>
												</td>
											</tr>
										</xsl:otherwise>
									</xsl:choose>
									<xsl:choose>
										<xsl:when test="matches($c_tag,'^[A-Za-z0-9,|_-]{0,100}$')">
											<tr>
												<td style="color:#008000">
													<xsl:text>&amp;tag matches regular expression ^[A-Za-z0-9,|_-]{0,100}$ PASS</xsl:text>
												</td>
											</tr>
										</xsl:when>
										<xsl:otherwise>
											<tr>
												<td style="color:#900000">
													<xsl:text>&amp;tag does not match regular expression  ^[A-Za-z0-9,|_-]{0,100}$ ERROR</xsl:text>
												</td>
											</tr>
										</xsl:otherwise>
									</xsl:choose>
									<!--END-->
								</xsl:when>
								<xsl:otherwise>
									<tr>
										<td style="color:#900000">
											<xsl:text>ERROR Precedence for selected criteria is incorrect, correct precedence is: BundleType, MessageHeader.event, Patient.age[1], Patient.age[2], subscriptionRuleType, Organization.identifier, tag</xsl:text>
										</td>
									</tr>
								</xsl:otherwise>
							</xsl:choose>
						</xsl:when>
						<!--BEAASO-->
						<xsl:when test="$bundleType_present and not($serviceType_present) and $event_present and $age_One_present and $age_Two_present and $subscriptionRuleType_present and $organization_present and not($tag_present) and $c_count=6">
							<xsl:choose>
								<xsl:when test="contains($c_tokens[1],$bundleType) and contains($c_tokens[2],$event) and contains($c_tokens[3],$age1) and contains($c_tokens[4],$age2) and contains($c_tokens[5],$subscriptionRuleType) and contains($c_tokens[6],$organization)">
									<tr>
										<td style="color:#008000">
											<xsl:text>PASS Precedence for selected criteria is correct</xsl:text>
										</td>
									</tr>
									<xsl:variable name="c_bundleType" select="$c_tokens[1]"/>
									<xsl:variable name="c_event" select="replace($c_tokens[2],$event,'')"/>
									<xsl:variable name="c_age1" select="replace($c_tokens[3],$age1,'')"/>
									<xsl:variable name="c_age2" select="replace($c_tokens[4],$age2,'')"/>
									<xsl:variable name="c_subscriptionRuleType" select="replace($c_tokens[5],$subscriptionRuleType,'')"/>
									<xsl:variable name="c_Organization" select="replace($c_tokens[6],$organization,'')"/>
									<!--Check each value in the parsed component lists against the allowable values in the reference file-->
									<xsl:call-template name="nems_ref_check">
										<xsl:with-param name="delim" select="'/'"/>
										<xsl:with-param name="name" select="replace($bundleType, '\?', '\\?')"/>
										<xsl:with-param name="list_name" select="$c_bundleType"/>
										<xsl:with-param name="ref_xpath" select="$supportedevents//bundleType"/>
										<xsl:with-param name="ref_attribute" select="'name'"/>
									</xsl:call-template>
									<xsl:call-template name="nems_ref_check">
										<xsl:with-param name="delim" select="$delim"/>
										<xsl:with-param name="name" select="$event"/>
										<xsl:with-param name="list_name" select="$c_event"/>
										<xsl:with-param name="ref_xpath" select="$supportedevents//event[@subscription='T']"/>
										<xsl:with-param name="ref_attribute" select="'code'"/>
									</xsl:call-template>
									<xsl:choose>
										<xsl:when test="matches($c_age1,'^[l|g]?t?[0-9]+(:contains)?$')">
											<tr>
												<td style="color:#008000">
													<xsl:text>&amp;age[1] matches regular expression ^[l|g]?t?[0-9]+(:contains)?$ PASS</xsl:text>
												</td>
											</tr>
										</xsl:when>
										<xsl:otherwise>
											<tr>
												<td style="color:#900000">
													<xsl:text>&amp;age[1] does not match regular expression  ^[l|g]?t?[0-9]+(:contains)?$ ERROR</xsl:text>
												</td>
											</tr>
										</xsl:otherwise>
									</xsl:choose>
									<xsl:choose>
										<xsl:when test="matches($c_age2,'^[l|g]?t?[0-9]+(:contains)?$')">
											<tr>
												<td style="color:#008000">
													<xsl:text>&amp;age[2] matches regular expression ^[l|g]?t?[0-9]+(:contains)?$ PASS</xsl:text>
												</td>
											</tr>
										</xsl:when>
										<xsl:otherwise>
											<tr>
												<td style="color:#900000">
													<xsl:text>&amp;age[2] does not match regular expression  ^[l|g]?t?[0-9]+(:contains)?$ ERROR</xsl:text>
												</td>
											</tr>
										</xsl:otherwise>
									</xsl:choose>
									<xsl:call-template name="nems_ref_check">
										<xsl:with-param name="delim" select="$delim"/>
										<xsl:with-param name="name" select="$subscriptionRuleType"/>
										<xsl:with-param name="list_name" select="$c_subscriptionRuleType"/>
										<xsl:with-param name="ref_xpath" select="$supportedevents//subscriptionRuleType"/>
										<xsl:with-param name="ref_attribute" select="'code'"/>
									</xsl:call-template>
									<xsl:choose>
										<xsl:when test="$c_subscriptionRuleType = 'COUNTRYCODE'">
											<tr>
												<td style="color:#008000">
													<xsl:text>subscriptionRuleType=COUNTRYCODE, validating Organization.identifier against allowable values</xsl:text>
												</td>
											</tr>
											<xsl:call-template name="nems_ref_check">
												<xsl:with-param name="delim" select="$delim"/>
												<xsl:with-param name="name" select="$organization"/>
												<xsl:with-param name="list_name" select="$c_Organization"/>
												<xsl:with-param name="ref_xpath" select="$supportedevents//countrycode"/>
												<xsl:with-param name="ref_attribute" select="'code'"/>
											</xsl:call-template>
										</xsl:when>
										<xsl:otherwise>
											<tr>
												<td style="color:#008000">
													<xsl:text>&amp;Organization.identifier is present and of value '</xsl:text>
													<xsl:value-of select="$c_Organization"/>
													<xsl:text>' this value can not be automatically validated by the Test Harness</xsl:text>
												</td>
											</tr>
										</xsl:otherwise>
									</xsl:choose>
									<!--END-->
								</xsl:when>
								<xsl:otherwise>
									<tr>
										<td style="color:#900000">
											<xsl:text>ERROR Precedence for selected criteria is incorrect, correct precedence is: BundleType, MessageHeader.event, Patient.age[1], Patient.age[2], subscriptionRuleType, Organization.identifier</xsl:text>
										</td>
									</tr>
								</xsl:otherwise>
							</xsl:choose>
						</xsl:when>
						<!--BEAAST-->
						<xsl:when test="$bundleType_present and not($serviceType_present) and $event_present and $age_One_present and $age_Two_present and $subscriptionRuleType_present and not($organization_present) and $tag_present and $c_count=6">
							<xsl:choose>
								<xsl:when test="contains($c_tokens[1],$bundleType) and contains($c_tokens[2],$event) and contains($c_tokens[3],$age1) and contains($c_tokens[4],$age2) and contains($c_tokens[5],$subscriptionRuleType) and contains($c_tokens[8],$tag)">
									<tr>
										<td style="color:#008000">
											<xsl:text>PASS Precedence for selected criteria is correct</xsl:text>
										</td>
									</tr>
									<xsl:variable name="c_bundleType" select="$c_tokens[1]"/>
									<xsl:variable name="c_event" select="replace($c_tokens[2],$event,'')"/>
									<xsl:variable name="c_age1" select="replace($c_tokens[3],$age1,'')"/>
									<xsl:variable name="c_age2" select="replace($c_tokens[4],$age2,'')"/>
									<xsl:variable name="c_subscriptionRuleType" select="replace($c_tokens[5],$subscriptionRuleType,'')"/>
									<xsl:variable name="c_tag" select="replace($c_tokens[6],$tag,'')"/>
									<!--Check each value in the parsed component lists against the allowable values in the reference file-->
									<xsl:call-template name="nems_ref_check">
										<xsl:with-param name="delim" select="'/'"/>
										<xsl:with-param name="name" select="replace($bundleType, '\?', '\\?')"/>
										<xsl:with-param name="list_name" select="$c_bundleType"/>
										<xsl:with-param name="ref_xpath" select="$supportedevents//bundleType"/>
										<xsl:with-param name="ref_attribute" select="'name'"/>
									</xsl:call-template>
									<xsl:call-template name="nems_ref_check">
										<xsl:with-param name="delim" select="$delim"/>
										<xsl:with-param name="name" select="$event"/>
										<xsl:with-param name="list_name" select="$c_event"/>
										<xsl:with-param name="ref_xpath" select="$supportedevents//event[@subscription='T']"/>
										<xsl:with-param name="ref_attribute" select="'code'"/>
									</xsl:call-template>
									<xsl:choose>
										<xsl:when test="matches($c_age1,'^[l|g]?t?[0-9]+(:contains)?$')">
											<tr>
												<td style="color:#008000">
													<xsl:text>&amp;age[1] matches regular expression ^[l|g]?t?[0-9]+(:contains)?$ PASS</xsl:text>
												</td>
											</tr>
										</xsl:when>
										<xsl:otherwise>
											<tr>
												<td style="color:#900000">
													<xsl:text>&amp;age[1] does not match regular expression  ^[l|g]?t?[0-9]+(:contains)?$ ERROR</xsl:text>
												</td>
											</tr>
										</xsl:otherwise>
									</xsl:choose>
									<xsl:choose>
										<xsl:when test="matches($c_age2,'^[l|g]?t?[0-9]+(:contains)?$')">
											<tr>
												<td style="color:#008000">
													<xsl:text>&amp;age[2] matches regular expression ^[l|g]?t?[0-9]+(:contains)?$ PASS</xsl:text>
												</td>
											</tr>
										</xsl:when>
										<xsl:otherwise>
											<tr>
												<td style="color:#900000">
													<xsl:text>&amp;age[2] does not match regular expression  ^[l|g]?t?[0-9]+(:contains)?$ ERROR</xsl:text>
												</td>
											</tr>
										</xsl:otherwise>
									</xsl:choose>
									<xsl:call-template name="nems_ref_check">
										<xsl:with-param name="delim" select="$delim"/>
										<xsl:with-param name="name" select="$subscriptionRuleType"/>
										<xsl:with-param name="list_name" select="$c_subscriptionRuleType"/>
										<xsl:with-param name="ref_xpath" select="$supportedevents//subscriptionRuleType"/>
										<xsl:with-param name="ref_attribute" select="'code'"/>
									</xsl:call-template>
									<xsl:choose>
										<xsl:when test="$c_subscriptionRuleType = 'COUNTRYCODE'">
											<tr>
												<td style="color:#900000">
													<xsl:text>subscriptionRuleType=COUNTRYCODE, required Organization.identifier NOT found ERROR</xsl:text>
												</td>
											</tr>
										</xsl:when>
									</xsl:choose>
									<xsl:choose>
										<xsl:when test="matches($c_tag,'^[A-Za-z0-9,|_-]{0,100}$')">
											<tr>
												<td style="color:#008000">
													<xsl:text>&amp;tag matches regular expression ^[A-Za-z0-9,|_-]{0,100}$ PASS</xsl:text>
												</td>
											</tr>
										</xsl:when>
										<xsl:otherwise>
											<tr>
												<td style="color:#900000">
													<xsl:text>&amp;tag does not match regular expression  ^[A-Za-z0-9,|_-]{0,100}$ ERROR</xsl:text>
												</td>
											</tr>
										</xsl:otherwise>
									</xsl:choose>
									<!--END-->
								</xsl:when>
								<xsl:otherwise>
									<tr>
										<td style="color:#900000">
											<xsl:text>ERROR Precedence for selected criteria is incorrect, correct precedence is: BundleType, MessageHeader.event, Patient.age[1], Patient.age[2], subscriptionRuleType, tag</xsl:text>
										</td>
									</tr>
								</xsl:otherwise>
							</xsl:choose>
						</xsl:when>
						<!--BEASOT-->
						<xsl:when test="$bundleType_present and not($serviceType_present) and $event_present and $age_One_present and not($age_Two_present) and $subscriptionRuleType_present and $organization_present and $tag_present and $c_count=6">
							<xsl:choose>
								<xsl:when test="contains($c_tokens[1],$bundleType) and contains($c_tokens[2],$event) and contains($c_tokens[3],$age1)  and contains($c_tokens[4],$subscriptionRuleType) and contains($c_tokens[5],$organization) and contains($c_tokens[6],$tag)">
									<tr>
										<td style="color:#008000">
											<xsl:text>PASS Precedence for selected criteria is correct</xsl:text>
										</td>
									</tr>
									<xsl:variable name="c_bundleType" select="$c_tokens[1]"/>
									<xsl:variable name="c_event" select="replace($c_tokens[2],$event,'')"/>
									<xsl:variable name="c_age1" select="replace($c_tokens[3],$age1,'')"/>
									<xsl:variable name="c_subscriptionRuleType" select="replace($c_tokens[4],$subscriptionRuleType,'')"/>
									<xsl:variable name="c_Organization" select="replace($c_tokens[5],$organization,'')"/>
									<xsl:variable name="c_tag" select="replace($c_tokens[6],$tag,'')"/>
									<!--Check each value in the parsed component lists against the allowable values in the reference file-->
									<xsl:call-template name="nems_ref_check">
										<xsl:with-param name="delim" select="'/'"/>
										<xsl:with-param name="name" select="replace($bundleType, '\?', '\\?')"/>
										<xsl:with-param name="list_name" select="$c_bundleType"/>
										<xsl:with-param name="ref_xpath" select="$supportedevents//bundleType"/>
										<xsl:with-param name="ref_attribute" select="'name'"/>
									</xsl:call-template>
									<xsl:call-template name="nems_ref_check">
										<xsl:with-param name="delim" select="$delim"/>
										<xsl:with-param name="name" select="$event"/>
										<xsl:with-param name="list_name" select="$c_event"/>
										<xsl:with-param name="ref_xpath" select="$supportedevents//event[@subscription='T']"/>
										<xsl:with-param name="ref_attribute" select="'code'"/>
									</xsl:call-template>
									<xsl:choose>
										<xsl:when test="matches($c_age1,'^[l|g]?t?[0-9]+(:contains)?$')">
											<tr>
												<td style="color:#008000">
													<xsl:text>&amp;age[1] matches regular expression ^[l|g]?t?[0-9]+(:contains)?$ PASS</xsl:text>
												</td>
											</tr>
										</xsl:when>
										<xsl:otherwise>
											<tr>
												<td style="color:#900000">
													<xsl:text>&amp;age[1] does not match regular expression  ^[l|g]?t?[0-9]+(:contains)?$ ERROR</xsl:text>
												</td>
											</tr>
										</xsl:otherwise>
									</xsl:choose>
									<xsl:call-template name="nems_ref_check">
										<xsl:with-param name="delim" select="$delim"/>
										<xsl:with-param name="name" select="$subscriptionRuleType"/>
										<xsl:with-param name="list_name" select="$c_subscriptionRuleType"/>
										<xsl:with-param name="ref_xpath" select="$supportedevents//subscriptionRuleType"/>
										<xsl:with-param name="ref_attribute" select="'code'"/>
									</xsl:call-template>
									<xsl:choose>
										<xsl:when test="$c_subscriptionRuleType = 'COUNTRYCODE'">
											<tr>
												<td style="color:#008000">
													<xsl:text>subscriptionRuleType=COUNTRYCODE, validating Organization.identifier against allowable values</xsl:text>
												</td>
											</tr>
											<xsl:call-template name="nems_ref_check">
												<xsl:with-param name="delim" select="$delim"/>
												<xsl:with-param name="name" select="$organization"/>
												<xsl:with-param name="list_name" select="$c_Organization"/>
												<xsl:with-param name="ref_xpath" select="$supportedevents//countrycode"/>
												<xsl:with-param name="ref_attribute" select="'code'"/>
											</xsl:call-template>
										</xsl:when>
										<xsl:otherwise>
											<tr>
												<td style="color:#008000">
													<xsl:text>&amp;Organization.identifier is present and of value '</xsl:text>
													<xsl:value-of select="$c_Organization"/>
													<xsl:text>' this value can not be automatically validated by the Test Harness</xsl:text>
												</td>
											</tr>
										</xsl:otherwise>
									</xsl:choose>
									<xsl:choose>
										<xsl:when test="matches($c_tag,'^[A-Za-z0-9,|_-]{0,100}$')">
											<tr>
												<td style="color:#008000">
													<xsl:text>&amp;tag matches regular expression ^[A-Za-z0-9,|_-]{0,100}$ PASS</xsl:text>
												</td>
											</tr>
										</xsl:when>
										<xsl:otherwise>
											<tr>
												<td style="color:#900000">
													<xsl:text>&amp;tag does not match regular expression  ^[A-Za-z0-9,|_-]{0,100}$ ERROR</xsl:text>
												</td>
											</tr>
										</xsl:otherwise>
									</xsl:choose>
								</xsl:when>
								<!--END-->
								<xsl:otherwise>
									<tr>
										<td style="color:#900000">
											<xsl:text>ERROR Precedence for selected criteria is incorrect, correct precedence is: BundleType, MessageHeader.event, Patient.age[1], subscriptionRuleType, Organization.identifier, tag</xsl:text>
										</td>
									</tr>
								</xsl:otherwise>
							</xsl:choose>
						</xsl:when>
						<!--BSEAAS-->
						<xsl:when test="$bundleType_present and $serviceType_present and $event_present and $age_One_present and $age_Two_present and $subscriptionRuleType_present and not($organization_present) and not($tag_present) and $c_count=6">
							<xsl:choose>
								<xsl:when test="contains($c_tokens[1],$bundleType) and contains($c_tokens[2],$serviceType) and contains($c_tokens[3],$event) and contains($c_tokens[4],$age1) and contains($c_tokens[5],$age2) and contains($c_tokens[6],$subscriptionRuleType)">
									<tr>
										<td style="color:#008000">
											<xsl:text>PASS Precedence for selected criteria is correct</xsl:text>
										</td>
									</tr>
									<xsl:variable name="c_bundleType" select="$c_tokens[1]"/>
									<xsl:variable name="c_serviceType" select="replace($c_tokens[2],$serviceType,'')"/>
									<xsl:variable name="c_event" select="replace($c_tokens[3],$event,'')"/>
									<xsl:variable name="c_age1" select="replace($c_tokens[4],$age1,'')"/>
									<xsl:variable name="c_age2" select="replace($c_tokens[5],$age2,'')"/>
									<xsl:variable name="c_subscriptionRuleType" select="replace($c_tokens[6],$subscriptionRuleType,'')"/>
									<!--Check each value in the parsed component lists against the allowable values in the reference file-->
									<xsl:call-template name="nems_ref_check">
										<xsl:with-param name="delim" select="'/'"/>
										<xsl:with-param name="name" select="replace($bundleType, '\?', '\\?')"/>
										<xsl:with-param name="list_name" select="$c_bundleType"/>
										<xsl:with-param name="ref_xpath" select="$supportedevents//bundleType"/>
										<xsl:with-param name="ref_attribute" select="'name'"/>
									</xsl:call-template>
									<xsl:call-template name="nems_ref_check">
										<xsl:with-param name="delim" select="$delim"/>
										<xsl:with-param name="name" select="$serviceType"/>
										<xsl:with-param name="list_name" select="$c_serviceType"/>
										<xsl:with-param name="ref_xpath" select="$supportedevents//serviceType"/>
										<xsl:with-param name="ref_attribute" select="'code'"/>
									</xsl:call-template>
									<xsl:call-template name="nems_ref_check">
										<xsl:with-param name="delim" select="$delim"/>
										<xsl:with-param name="name" select="$event"/>
										<xsl:with-param name="list_name" select="$c_event"/>
										<xsl:with-param name="ref_xpath" select="$supportedevents//event[@subscription='T']"/>
										<xsl:with-param name="ref_attribute" select="'code'"/>
									</xsl:call-template>
									<xsl:choose>
										<xsl:when test="matches($c_age1,'^[l|g]?t?[0-9]+(:contains)?$')">
											<tr>
												<td style="color:#008000">
													<xsl:text>&amp;age[1] matches regular expression ^[l|g]?t?[0-9]+(:contains)?$ PASS</xsl:text>
												</td>
											</tr>
										</xsl:when>
										<xsl:otherwise>
											<tr>
												<td style="color:#900000">
													<xsl:text>&amp;age[1] does not match regular expression  ^[l|g]?t?[0-9]+(:contains)?$ ERROR</xsl:text>
												</td>
											</tr>
										</xsl:otherwise>
									</xsl:choose>
									<xsl:choose>
										<xsl:when test="matches($c_age2,'^[l|g]?t?[0-9]+(:contains)?$')">
											<tr>
												<td style="color:#008000">
													<xsl:text>&amp;age[2] matches regular expression ^[l|g]?t?[0-9]+(:contains)?$ PASS</xsl:text>
												</td>
											</tr>
										</xsl:when>
										<xsl:otherwise>
											<tr>
												<td style="color:#900000">
													<xsl:text>&amp;age[2] does not match regular expression  ^[l|g]?t?[0-9]+(:contains)?$ ERROR</xsl:text>
												</td>
											</tr>
										</xsl:otherwise>
									</xsl:choose>
									<xsl:call-template name="nems_ref_check">
										<xsl:with-param name="delim" select="$delim"/>
										<xsl:with-param name="name" select="$subscriptionRuleType"/>
										<xsl:with-param name="list_name" select="$c_subscriptionRuleType"/>
										<xsl:with-param name="ref_xpath" select="$supportedevents//subscriptionRuleType"/>
										<xsl:with-param name="ref_attribute" select="'code'"/>
									</xsl:call-template>
									<xsl:choose>
										<xsl:when test="$c_subscriptionRuleType = 'COUNTRYCODE'">
											<tr>
												<td style="color:#900000">
													<xsl:text>subscriptionRuleType=COUNTRYCODE, required Organization.identifier NOT found ERROR</xsl:text>
												</td>
											</tr>
										</xsl:when>
									</xsl:choose>
									<!--END-->
								</xsl:when>
								<xsl:otherwise>
									<tr>
										<td style="color:#900000">
											<xsl:text>ERROR Precedence for selected criteria is incorrect, correct precedence is: BundleType, serviceType, MessageHeader.event, Patient.age[1], Patient.age[2], subscriptionRuleType</xsl:text>
										</td>
									</tr>
								</xsl:otherwise>
							</xsl:choose>
						</xsl:when>
						<!--BSEASO-->
						<xsl:when test="$bundleType_present and $serviceType_present and $event_present and $age_One_present and not($age_Two_present) and $subscriptionRuleType_present and $organization_present and not($tag_present) and $c_count=6">
							<xsl:choose>
								<xsl:when test="contains($c_tokens[1],$bundleType) and contains($c_tokens[2],$serviceType) and contains($c_tokens[3],$event) and contains($c_tokens[4],$age1) and contains($c_tokens[5],$subscriptionRuleType) and contains($c_tokens[6],$organization)">
									<tr>
										<td style="color:#008000">
											<xsl:text>PASS Precedence for selected criteria is correct</xsl:text>
										</td>
									</tr>
									<xsl:variable name="c_bundleType" select="$c_tokens[1]"/>
									<xsl:variable name="c_serviceType" select="replace($c_tokens[2],$serviceType,'')"/>
									<xsl:variable name="c_event" select="replace($c_tokens[3],$event,'')"/>
									<xsl:variable name="c_age1" select="replace($c_tokens[4],$age1,'')"/>
									<xsl:variable name="c_subscriptionRuleType" select="replace($c_tokens[5],$subscriptionRuleType,'')"/>
									<xsl:variable name="c_Organization" select="replace($c_tokens[6],$organization,'')"/>
									<!--Check each value in the parsed component lists against the allowable values in the reference file-->
									<xsl:call-template name="nems_ref_check">
										<xsl:with-param name="delim" select="'/'"/>
										<xsl:with-param name="name" select="replace($bundleType, '\?', '\\?')"/>
										<xsl:with-param name="list_name" select="$c_bundleType"/>
										<xsl:with-param name="ref_xpath" select="$supportedevents//bundleType"/>
										<xsl:with-param name="ref_attribute" select="'name'"/>
									</xsl:call-template>
									<xsl:call-template name="nems_ref_check">
										<xsl:with-param name="delim" select="$delim"/>
										<xsl:with-param name="name" select="$serviceType"/>
										<xsl:with-param name="list_name" select="$c_serviceType"/>
										<xsl:with-param name="ref_xpath" select="$supportedevents//serviceType"/>
										<xsl:with-param name="ref_attribute" select="'code'"/>
									</xsl:call-template>
									<xsl:call-template name="nems_ref_check">
										<xsl:with-param name="delim" select="$delim"/>
										<xsl:with-param name="name" select="$event"/>
										<xsl:with-param name="list_name" select="$c_event"/>
										<xsl:with-param name="ref_xpath" select="$supportedevents//event[@subscription='T']"/>
										<xsl:with-param name="ref_attribute" select="'code'"/>
									</xsl:call-template>
									<xsl:choose>
										<xsl:when test="matches($c_age1,'^[l|g]?t?[0-9]+(:contains)?$')">
											<tr>
												<td style="color:#008000">
													<xsl:text>&amp;age[1] matches regular expression ^[l|g]?t?[0-9]+(:contains)?$ PASS</xsl:text>
												</td>
											</tr>
										</xsl:when>
										<xsl:otherwise>
											<tr>
												<td style="color:#900000">
													<xsl:text>&amp;age[1] does not match regular expression  ^[l|g]?t?[0-9]+(:contains)?$ ERROR</xsl:text>
												</td>
											</tr>
										</xsl:otherwise>
									</xsl:choose>
									<xsl:call-template name="nems_ref_check">
										<xsl:with-param name="delim" select="$delim"/>
										<xsl:with-param name="name" select="$subscriptionRuleType"/>
										<xsl:with-param name="list_name" select="$c_subscriptionRuleType"/>
										<xsl:with-param name="ref_xpath" select="$supportedevents//subscriptionRuleType"/>
										<xsl:with-param name="ref_attribute" select="'code'"/>
									</xsl:call-template>
									<xsl:choose>
										<xsl:when test="$c_subscriptionRuleType = 'COUNTRYCODE'">
											<tr>
												<td style="color:#008000">
													<xsl:text>subscriptionRuleType=COUNTRYCODE, validating Organization.identifier against allowable values</xsl:text>
												</td>
											</tr>
											<xsl:call-template name="nems_ref_check">
												<xsl:with-param name="delim" select="$delim"/>
												<xsl:with-param name="name" select="$organization"/>
												<xsl:with-param name="list_name" select="$c_Organization"/>
												<xsl:with-param name="ref_xpath" select="$supportedevents//countrycode"/>
												<xsl:with-param name="ref_attribute" select="'code'"/>
											</xsl:call-template>
										</xsl:when>
										<xsl:otherwise>
											<tr>
												<td style="color:#008000">
													<xsl:text>&amp;Organization.identifier is present and of value '</xsl:text>
													<xsl:value-of select="$c_Organization"/>
													<xsl:text>' this value can not be automatically validated by the Test Harness</xsl:text>
												</td>
											</tr>
										</xsl:otherwise>
									</xsl:choose>
								</xsl:when>
								<!--END-->
								<xsl:otherwise>
									<tr>
										<td style="color:#900000">
											<xsl:text>ERROR Precedence for selected criteria is incorrect, correct precedence is: BundleType, serviceType, MessageHeader.event, Patient.age[1], subscriptionRuleType, Organization.identifier</xsl:text>
										</td>
									</tr>
								</xsl:otherwise>
							</xsl:choose>
						</xsl:when>
						<!--BSEAST-->
						<xsl:when test="$bundleType_present and $serviceType_present and $event_present and $age_One_present and not($age_Two_present) and $subscriptionRuleType_present and not($organization_present) and $tag_present and $c_count=6">
							<xsl:choose>
								<xsl:when test="contains($c_tokens[1],$bundleType) and contains($c_tokens[2],$serviceType) and contains($c_tokens[3],$event) and contains($c_tokens[4],$age1) and contains($c_tokens[5],$subscriptionRuleType) and contains($c_tokens[6],$organization)">
									<tr>
										<td style="color:#008000">
											<xsl:text>PASS Precedence for selected criteria is correct</xsl:text>
										</td>
									</tr>
									<xsl:variable name="c_bundleType" select="$c_tokens[1]"/>
									<xsl:variable name="c_serviceType" select="replace($c_tokens[2],$serviceType,'')"/>
									<xsl:variable name="c_event" select="replace($c_tokens[3],$event,'')"/>
									<xsl:variable name="c_age1" select="replace($c_tokens[4],$age1,'')"/>
									<xsl:variable name="c_subscriptionRuleType" select="replace($c_tokens[5],$subscriptionRuleType,'')"/>
									<xsl:variable name="c_tag" select="replace($c_tokens[6],$tag,'')"/>
									<!--Check each value in the parsed component lists against the allowable values in the reference file-->
									<xsl:call-template name="nems_ref_check">
										<xsl:with-param name="delim" select="'/'"/>
										<xsl:with-param name="name" select="replace($bundleType, '\?', '\\?')"/>
										<xsl:with-param name="list_name" select="$c_bundleType"/>
										<xsl:with-param name="ref_xpath" select="$supportedevents//bundleType"/>
										<xsl:with-param name="ref_attribute" select="'name'"/>
									</xsl:call-template>
									<xsl:call-template name="nems_ref_check">
										<xsl:with-param name="delim" select="$delim"/>
										<xsl:with-param name="name" select="$serviceType"/>
										<xsl:with-param name="list_name" select="$c_serviceType"/>
										<xsl:with-param name="ref_xpath" select="$supportedevents//serviceType"/>
										<xsl:with-param name="ref_attribute" select="'code'"/>
									</xsl:call-template>
									<xsl:call-template name="nems_ref_check">
										<xsl:with-param name="delim" select="$delim"/>
										<xsl:with-param name="name" select="$event"/>
										<xsl:with-param name="list_name" select="$c_event"/>
										<xsl:with-param name="ref_xpath" select="$supportedevents//event[@subscription='T']"/>
										<xsl:with-param name="ref_attribute" select="'code'"/>
									</xsl:call-template>
									<xsl:choose>
										<xsl:when test="matches($c_age1,'^[l|g]?t?[0-9]+(:contains)?$')">
											<tr>
												<td style="color:#008000">
													<xsl:text>&amp;age[1] matches regular expression ^[l|g]?t?[0-9]+(:contains)?$ PASS</xsl:text>
												</td>
											</tr>
										</xsl:when>
										<xsl:otherwise>
											<tr>
												<td style="color:#900000">
													<xsl:text>&amp;age[1] does not match regular expression  ^[l|g]?t?[0-9]+(:contains)?$ ERROR</xsl:text>
												</td>
											</tr>
										</xsl:otherwise>
									</xsl:choose>
									<xsl:call-template name="nems_ref_check">
										<xsl:with-param name="delim" select="$delim"/>
										<xsl:with-param name="name" select="$subscriptionRuleType"/>
										<xsl:with-param name="list_name" select="$c_subscriptionRuleType"/>
										<xsl:with-param name="ref_xpath" select="$supportedevents//subscriptionRuleType"/>
										<xsl:with-param name="ref_attribute" select="'code'"/>
									</xsl:call-template>
									<xsl:choose>
										<xsl:when test="$c_subscriptionRuleType = 'COUNTRYCODE'">
											<tr>
												<td style="color:#900000">
													<xsl:text>subscriptionRuleType=COUNTRYCODE, required Organization.identifier NOT found ERROR</xsl:text>
												</td>
											</tr>
										</xsl:when>
									</xsl:choose>
									<xsl:choose>
										<xsl:when test="matches($c_tag,'^[A-Za-z0-9,|_-]{0,100}$')">
											<tr>
												<td style="color:#008000">
													<xsl:text>&amp;tag matches regular expression ^[A-Za-z0-9,|_-]{0,100}$ PASS</xsl:text>
												</td>
											</tr>
										</xsl:when>
										<xsl:otherwise>
											<tr>
												<td style="color:#900000">
													<xsl:text>&amp;tag does not match regular expression  ^[A-Za-z0-9,|_-]{0,100}$ ERROR</xsl:text>
												</td>
											</tr>
										</xsl:otherwise>
									</xsl:choose>
									<!--END-->
								</xsl:when>
								<xsl:otherwise>
									<tr>
										<td style="color:#900000">
											<xsl:text>ERROR Precedence for selected criteria is incorrect, correct precedence is: BundleType, serviceType, MessageHeader.event, Patient.age[1], subscriptionRuleType, tag</xsl:text>
										</td>
									</tr>
								</xsl:otherwise>
							</xsl:choose>
						</xsl:when>
						<!--BSESOT-->
						<xsl:when test="$bundleType_present and $serviceType_present and $event_present and not($age_One_present) and not($age_Two_present) and $subscriptionRuleType_present and $organization_present and $tag_present and $c_count=6">
							<xsl:choose>
								<xsl:when test="contains($c_tokens[1],$bundleType) and contains($c_tokens[2],$serviceType) and contains($c_tokens[3],$event) and contains($c_tokens[4],$subscriptionRuleType) and contains($c_tokens[5],$organization) and contains($c_tokens[6],$tag)">
									<tr>
										<td style="color:#008000">
											<xsl:text>PASS Precedence for selected criteria is correct</xsl:text>
										</td>
									</tr>
									<xsl:variable name="c_bundleType" select="$c_tokens[1]"/>
									<xsl:variable name="c_serviceType" select="replace($c_tokens[2],$serviceType,'')"/>
									<xsl:variable name="c_event" select="replace($c_tokens[3],$event,'')"/>
									<xsl:variable name="c_subscriptionRuleType" select="replace($c_tokens[4],$subscriptionRuleType,'')"/>
									<xsl:variable name="c_Organization" select="replace($c_tokens[5],$organization,'')"/>
									<xsl:variable name="c_tag" select="replace($c_tokens[6],$tag,'')"/>
									<!--Check each value in the parsed component lists against the allowable values in the reference file-->
									<xsl:call-template name="nems_ref_check">
										<xsl:with-param name="delim" select="'/'"/>
										<xsl:with-param name="name" select="replace($bundleType, '\?', '\\?')"/>
										<xsl:with-param name="list_name" select="$c_bundleType"/>
										<xsl:with-param name="ref_xpath" select="$supportedevents//bundleType"/>
										<xsl:with-param name="ref_attribute" select="'name'"/>
									</xsl:call-template>
									<xsl:call-template name="nems_ref_check">
										<xsl:with-param name="delim" select="$delim"/>
										<xsl:with-param name="name" select="$serviceType"/>
										<xsl:with-param name="list_name" select="$c_serviceType"/>
										<xsl:with-param name="ref_xpath" select="$supportedevents//serviceType"/>
										<xsl:with-param name="ref_attribute" select="'code'"/>
									</xsl:call-template>
									<xsl:call-template name="nems_ref_check">
										<xsl:with-param name="delim" select="$delim"/>
										<xsl:with-param name="name" select="$event"/>
										<xsl:with-param name="list_name" select="$c_event"/>
										<xsl:with-param name="ref_xpath" select="$supportedevents//event[@subscription='T']"/>
										<xsl:with-param name="ref_attribute" select="'code'"/>
									</xsl:call-template>
									<xsl:call-template name="nems_ref_check">
										<xsl:with-param name="delim" select="$delim"/>
										<xsl:with-param name="name" select="$subscriptionRuleType"/>
										<xsl:with-param name="list_name" select="$c_subscriptionRuleType"/>
										<xsl:with-param name="ref_xpath" select="$supportedevents//subscriptionRuleType"/>
										<xsl:with-param name="ref_attribute" select="'code'"/>
									</xsl:call-template>
									<xsl:choose>
										<xsl:when test="$c_subscriptionRuleType = 'COUNTRYCODE'">
											<tr>
												<td style="color:#008000">
													<xsl:text>subscriptionRuleType=COUNTRYCODE, validating Organization.identifier against allowable values</xsl:text>
												</td>
											</tr>
											<xsl:call-template name="nems_ref_check">
												<xsl:with-param name="delim" select="$delim"/>
												<xsl:with-param name="name" select="$organization"/>
												<xsl:with-param name="list_name" select="$c_Organization"/>
												<xsl:with-param name="ref_xpath" select="$supportedevents//countrycode"/>
												<xsl:with-param name="ref_attribute" select="'code'"/>
											</xsl:call-template>
										</xsl:when>
										<xsl:otherwise>
											<tr>
												<td style="color:#008000">
													<xsl:text>&amp;Organization.identifier is present and of value '</xsl:text>
													<xsl:value-of select="$c_Organization"/>
													<xsl:text>' this value can not be automatically validated by the Test Harness</xsl:text>
												</td>
											</tr>
										</xsl:otherwise>
									</xsl:choose>
									<xsl:choose>
										<xsl:when test="matches($c_tag,'^[A-Za-z0-9,|_-]{0,100}$')">
											<tr>
												<td style="color:#008000">
													<xsl:text>&amp;tag matches regular expression ^[A-Za-z0-9,|_-]{0,100}$ PASS</xsl:text>
												</td>
											</tr>
										</xsl:when>
										<xsl:otherwise>
											<tr>
												<td style="color:#900000">
													<xsl:text>&amp;tag does not match regular expression  ^[A-Za-z0-9,|_-]{0,100}$ ERROR</xsl:text>
												</td>
											</tr>
										</xsl:otherwise>
									</xsl:choose>
									<!--END-->
								</xsl:when>
								<xsl:otherwise>
									<tr>
										<td style="color:#900000">
											<xsl:text>ERROR Precedence for selected criteria is incorrect, correct precedence is: BundleType, serviceType, MessageHeader.event, subscriptionRuleType, Organization.identifier, tag</xsl:text>
										</td>
									</tr>
								</xsl:otherwise>
							</xsl:choose>
						</xsl:when>
						<!--BEAAS-->
						<xsl:when test="$bundleType_present and not($serviceType_present) and $event_present and $age_One_present and $age_Two_present and $subscriptionRuleType_present and not($organization_present) and not($tag_present) and $c_count=5">
							<xsl:choose>
								<xsl:when test="contains($c_tokens[1],$bundleType) and contains($c_tokens[2],$event) and contains($c_tokens[3],$age1) and contains($c_tokens[4],$age2) and contains($c_tokens[5],$subscriptionRuleType)">
									<tr>
										<td style="color:#008000">
											<xsl:text>PASS Precedence for selected criteria is correct</xsl:text>
										</td>
									</tr>
									<xsl:variable name="c_bundleType" select="$c_tokens[1]"/>
									<xsl:variable name="c_event" select="replace($c_tokens[2],$event,'')"/>
									<xsl:variable name="c_age1" select="replace($c_tokens[3],$age1,'')"/>
									<xsl:variable name="c_age2" select="replace($c_tokens[4],$age2,'')"/>
									<xsl:variable name="c_subscriptionRuleType" select="replace($c_tokens[5],$subscriptionRuleType,'')"/>
									<!--Check each value in the parsed component lists against the allowable values in the reference file-->
									<xsl:call-template name="nems_ref_check">
										<xsl:with-param name="delim" select="'/'"/>
										<xsl:with-param name="name" select="replace($bundleType, '\?', '\\?')"/>
										<xsl:with-param name="list_name" select="$c_bundleType"/>
										<xsl:with-param name="ref_xpath" select="$supportedevents//bundleType"/>
										<xsl:with-param name="ref_attribute" select="'name'"/>
									</xsl:call-template>
									<xsl:call-template name="nems_ref_check">
										<xsl:with-param name="delim" select="$delim"/>
										<xsl:with-param name="name" select="$event"/>
										<xsl:with-param name="list_name" select="$c_event"/>
										<xsl:with-param name="ref_xpath" select="$supportedevents//event[@subscription='T']"/>
										<xsl:with-param name="ref_attribute" select="'code'"/>
									</xsl:call-template>
									<xsl:choose>
										<xsl:when test="matches($c_age1,'^[l|g]?t?[0-9]+(:contains)?$')">
											<tr>
												<td style="color:#008000">
													<xsl:text>&amp;age[1] matches regular expression ^[l|g]?t?[0-9]+(:contains)?$ PASS</xsl:text>
												</td>
											</tr>
										</xsl:when>
										<xsl:otherwise>
											<tr>
												<td style="color:#900000">
													<xsl:text>&amp;age[1] does not match regular expression  ^[l|g]?t?[0-9]+(:contains)?$ ERROR</xsl:text>
												</td>
											</tr>
										</xsl:otherwise>
									</xsl:choose>
									<xsl:choose>
										<xsl:when test="matches($c_age2,'^[l|g]?t?[0-9]+(:contains)?$')">
											<tr>
												<td style="color:#008000">
													<xsl:text>&amp;age[2] matches regular expression ^[l|g]?t?[0-9]+(:contains)?$ PASS</xsl:text>
												</td>
											</tr>
										</xsl:when>
										<xsl:otherwise>
											<tr>
												<td style="color:#900000">
													<xsl:text>&amp;age[2] does not match regular expression  ^[l|g]?t?[0-9]+(:contains)?$ ERROR</xsl:text>
												</td>
											</tr>
										</xsl:otherwise>
									</xsl:choose>
									<xsl:call-template name="nems_ref_check">
										<xsl:with-param name="delim" select="$delim"/>
										<xsl:with-param name="name" select="$subscriptionRuleType"/>
										<xsl:with-param name="list_name" select="$c_subscriptionRuleType"/>
										<xsl:with-param name="ref_xpath" select="$supportedevents//subscriptionRuleType"/>
										<xsl:with-param name="ref_attribute" select="'code'"/>
									</xsl:call-template>
									<xsl:choose>
										<xsl:when test="$c_subscriptionRuleType = 'COUNTRYCODE'">
											<tr>
												<td style="color:#900000">
													<xsl:text>subscriptionRuleType=COUNTRYCODE, required Organization.identifier NOT found ERROR</xsl:text>
												</td>
											</tr>
										</xsl:when>
									</xsl:choose>
									<!--END-->
								</xsl:when>
								<xsl:otherwise>
									<tr>
										<td style="color:#900000">
											<xsl:text>ERROR Precedence for selected criteria is incorrect, correct precedence is: BundleType, MessageHeader.event, Patient.age[1], Patient.age[2], subscriptionRuleType</xsl:text>
										</td>
									</tr>
								</xsl:otherwise>
							</xsl:choose>
						</xsl:when>
						<!--BEASO-->
						<xsl:when test="$bundleType_present and not($serviceType_present) and $event_present and $age_One_present and not($age_Two_present) and $subscriptionRuleType_present and $organization_present and not($tag_present) and $c_count=5">
							<xsl:choose>
								<xsl:when test="contains($c_tokens[1],$bundleType) and contains($c_tokens[2],$event) and contains($c_tokens[3],$age1) and contains($c_tokens[4],$subscriptionRuleType) and contains($c_tokens[5],$organization)">
									<tr>
										<td style="color:#008000">
											<xsl:text>PASS Precedence for selected criteria is correct</xsl:text>
										</td>
									</tr>
									<xsl:variable name="c_bundleType" select="$c_tokens[1]"/>
									<xsl:variable name="c_event" select="replace($c_tokens[2],$event,'')"/>
									<xsl:variable name="c_age1" select="replace($c_tokens[3],$age1,'')"/>
									<xsl:variable name="c_subscriptionRuleType" select="replace($c_tokens[4],$subscriptionRuleType,'')"/>
									<xsl:variable name="c_Organization" select="replace($c_tokens[5],$organization,'')"/>
									<!--Check each value in the parsed component lists against the allowable values in the reference file-->
									<xsl:call-template name="nems_ref_check">
										<xsl:with-param name="delim" select="'/'"/>
										<xsl:with-param name="name" select="replace($bundleType, '\?', '\\?')"/>
										<xsl:with-param name="list_name" select="$c_bundleType"/>
										<xsl:with-param name="ref_xpath" select="$supportedevents//bundleType"/>
										<xsl:with-param name="ref_attribute" select="'name'"/>
									</xsl:call-template>
									<xsl:call-template name="nems_ref_check">
										<xsl:with-param name="delim" select="$delim"/>
										<xsl:with-param name="name" select="$event"/>
										<xsl:with-param name="list_name" select="$c_event"/>
										<xsl:with-param name="ref_xpath" select="$supportedevents//event[@subscription='T']"/>
										<xsl:with-param name="ref_attribute" select="'code'"/>
									</xsl:call-template>
									<xsl:choose>
										<xsl:when test="matches($c_age1,'^[l|g]?t?[0-9]+(:contains)?$')">
											<tr>
												<td style="color:#008000">
													<xsl:text>&amp;age[1] matches regular expression ^[l|g]?t?[0-9]+(:contains)?$ PASS</xsl:text>
												</td>
											</tr>
										</xsl:when>
										<xsl:otherwise>
											<tr>
												<td style="color:#900000">
													<xsl:text>&amp;age[1] does not match regular expression  ^[l|g]?t?[0-9]+(:contains)?$ ERROR</xsl:text>
												</td>
											</tr>
										</xsl:otherwise>
									</xsl:choose>
									<xsl:call-template name="nems_ref_check">
										<xsl:with-param name="delim" select="$delim"/>
										<xsl:with-param name="name" select="$subscriptionRuleType"/>
										<xsl:with-param name="list_name" select="$c_subscriptionRuleType"/>
										<xsl:with-param name="ref_xpath" select="$supportedevents//subscriptionRuleType"/>
										<xsl:with-param name="ref_attribute" select="'code'"/>
									</xsl:call-template>									
									<xsl:choose>
										<xsl:when test="$c_subscriptionRuleType = 'COUNTRYCODE'">
											<tr>
												<td style="color:#008000">
													<xsl:text>subscriptionRuleType=COUNTRYCODE, validating Organization.identifier against allowable values</xsl:text>
												</td>
											</tr>
											<xsl:call-template name="nems_ref_check">
												<xsl:with-param name="delim" select="$delim"/>
												<xsl:with-param name="name" select="$organization"/>
												<xsl:with-param name="list_name" select="$c_Organization"/>
												<xsl:with-param name="ref_xpath" select="$supportedevents//countrycode"/>
												<xsl:with-param name="ref_attribute" select="'code'"/>
											</xsl:call-template>
										</xsl:when>
										<xsl:otherwise>
											<tr>
												<td style="color:#008000">
													<xsl:text>&amp;Organization.identifier is present and of value '</xsl:text>
													<xsl:value-of select="$c_Organization"/>
													<xsl:text>' this value can not be automatically validated by the Test Harness</xsl:text>
												</td>
											</tr>
										</xsl:otherwise>
									</xsl:choose>
									<!--END-->
								</xsl:when>
								<xsl:otherwise>
									<tr>
										<td style="color:#900000">
											<xsl:text>ERROR Precedence for selected criteria is incorrect, correct precedence is: BundleType, MessageHeader.event, Patient.age[1], subscriptionRuleType, Organization.identifier</xsl:text>
										</td>
									</tr>
								</xsl:otherwise>
							</xsl:choose>
						</xsl:when>
						<!--BEAST-->
						<xsl:when test="$bundleType_present and not($serviceType_present) and $event_present and $age_One_present and not($age_Two_present) and $subscriptionRuleType_present and not($organization_present) and $tag_present and $c_count=5">
							<xsl:choose>
								<xsl:when test="contains($c_tokens[1],$bundleType) and contains($c_tokens[2],$event) and contains($c_tokens[3],$age1) and contains($c_tokens[4],$subscriptionRuleType) and contains($c_tokens[5],$tag)">
									<tr>
										<td style="color:#008000">
											<xsl:text>PASS Precedence for selected criteria is correct</xsl:text>
										</td>
									</tr>
									<xsl:variable name="c_bundleType" select="$c_tokens[1]"/>
									<xsl:variable name="c_event" select="replace($c_tokens[2],$event,'')"/>
									<xsl:variable name="c_age1" select="replace($c_tokens[3],$age1,'')"/>
									<xsl:variable name="c_subscriptionRuleType" select="replace($c_tokens[4],$subscriptionRuleType,'')"/>
									<xsl:variable name="c_tag" select="replace($c_tokens[5],$tag,'')"/>
									<!--Check each value in the parsed component lists against the allowable values in the reference file-->
									<xsl:call-template name="nems_ref_check">
										<xsl:with-param name="delim" select="'/'"/>
										<xsl:with-param name="name" select="replace($bundleType, '\?', '\\?')"/>
										<xsl:with-param name="list_name" select="$c_bundleType"/>
										<xsl:with-param name="ref_xpath" select="$supportedevents//bundleType"/>
										<xsl:with-param name="ref_attribute" select="'name'"/>
									</xsl:call-template>
									<xsl:call-template name="nems_ref_check">
										<xsl:with-param name="delim" select="$delim"/>
										<xsl:with-param name="name" select="$event"/>
										<xsl:with-param name="list_name" select="$c_event"/>
										<xsl:with-param name="ref_xpath" select="$supportedevents//event[@subscription='T']"/>
										<xsl:with-param name="ref_attribute" select="'code'"/>
									</xsl:call-template>
									<xsl:choose>
										<xsl:when test="matches($c_age1,'^[l|g]?t?[0-9]+(:contains)?$')">
											<tr>
												<td style="color:#008000">
													<xsl:text>&amp;age[1] matches regular expression ^[l|g]?t?[0-9]+(:contains)?$ PASS</xsl:text>
												</td>
											</tr>
										</xsl:when>
										<xsl:otherwise>
											<tr>
												<td style="color:#900000">
													<xsl:text>&amp;age[1] does not match regular expression  ^[l|g]?t?[0-9]+(:contains)?$ ERROR</xsl:text>
												</td>
											</tr>
										</xsl:otherwise>
									</xsl:choose>
									<xsl:call-template name="nems_ref_check">
										<xsl:with-param name="delim" select="$delim"/>
										<xsl:with-param name="name" select="$subscriptionRuleType"/>
										<xsl:with-param name="list_name" select="$c_subscriptionRuleType"/>
										<xsl:with-param name="ref_xpath" select="$supportedevents//subscriptionRuleType"/>
										<xsl:with-param name="ref_attribute" select="'code'"/>
									</xsl:call-template>
									<xsl:choose>
										<xsl:when test="$c_subscriptionRuleType = 'COUNTRYCODE'">
											<tr>
												<td style="color:#900000">
													<xsl:text>subscriptionRuleType=COUNTRYCODE, required Organization.identifier NOT found ERROR</xsl:text>
												</td>
											</tr>
										</xsl:when>
									</xsl:choose>
									<xsl:choose>
										<xsl:when test="matches($c_tag,'^[A-Za-z0-9,|_-]{0,100}$')">
											<tr>
												<td style="color:#008000">
													<xsl:text>&amp;tag matches regular expression ^[A-Za-z0-9,|_-]{0,100}$ PASS</xsl:text>
												</td>
											</tr>
										</xsl:when>
										<xsl:otherwise>
											<tr>
												<td style="color:#900000">
													<xsl:text>&amp;tag does not match regular expression  ^[A-Za-z0-9,|_-]{0,100}$ ERROR</xsl:text>
												</td>
											</tr>
										</xsl:otherwise>
									</xsl:choose>
									<!--END-->
								</xsl:when>
								<xsl:otherwise>
									<tr>
										<td style="color:#900000">
											<xsl:text>ERROR Precedence for selected criteria is incorrect, correct precedence is: BundleType, MessageHeader.event, Patient.age[1], subscriptionRuleType, tag</xsl:text>
										</td>
									</tr>
								</xsl:otherwise>
							</xsl:choose>
						</xsl:when>
						<!--BESOT-->
						<xsl:when test="$bundleType_present and not($serviceType_present) and $event_present and not($age_One_present) and not($age_Two_present) and $subscriptionRuleType_present and $organization_present and $tag_present and $c_count=5">
							<xsl:choose>
								<xsl:when test="contains($c_tokens[1],$bundleType) and contains($c_tokens[2],$event) and contains($c_tokens[3],$subscriptionRuleType) and contains($c_tokens[4],$organization) and contains($c_tokens[5],$tag)">
									<tr>
										<td style="color:#008000">
											<xsl:text>PASS Precedence for selected criteria is correct</xsl:text>
										</td>
									</tr>
									<xsl:variable name="c_bundleType" select="$c_tokens[1]"/>
									<xsl:variable name="c_event" select="replace($c_tokens[2],$event,'')"/>
									<xsl:variable name="c_subscriptionRuleType" select="replace($c_tokens[3],$subscriptionRuleType,'')"/>
									<xsl:variable name="c_Organization" select="replace($c_tokens[4],$organization,'')"/>
									<xsl:variable name="c_tag" select="replace($c_tokens[5],$tag,'')"/>
									<!--Check each value in the parsed component lists against the allowable values in the reference file-->
									<xsl:call-template name="nems_ref_check">
										<xsl:with-param name="delim" select="'/'"/>
										<xsl:with-param name="name" select="replace($bundleType, '\?', '\\?')"/>
										<xsl:with-param name="list_name" select="$c_bundleType"/>
										<xsl:with-param name="ref_xpath" select="$supportedevents//bundleType"/>
										<xsl:with-param name="ref_attribute" select="'name'"/>
									</xsl:call-template>
									<xsl:call-template name="nems_ref_check">
										<xsl:with-param name="delim" select="$delim"/>
										<xsl:with-param name="name" select="$event"/>
										<xsl:with-param name="list_name" select="$c_event"/>
										<xsl:with-param name="ref_xpath" select="$supportedevents//event[@subscription='T']"/>
										<xsl:with-param name="ref_attribute" select="'code'"/>
									</xsl:call-template>
									<xsl:call-template name="nems_ref_check">
										<xsl:with-param name="delim" select="$delim"/>
										<xsl:with-param name="name" select="$subscriptionRuleType"/>
										<xsl:with-param name="list_name" select="$c_subscriptionRuleType"/>
										<xsl:with-param name="ref_xpath" select="$supportedevents//subscriptionRuleType"/>
										<xsl:with-param name="ref_attribute" select="'code'"/>
									</xsl:call-template>									
									<xsl:choose>
										<xsl:when test="$c_subscriptionRuleType = 'COUNTRYCODE'">
											<tr>
												<td style="color:#008000">
													<xsl:text>subscriptionRuleType=COUNTRYCODE, validating Organization.identifier against allowable values</xsl:text>
												</td>
											</tr>
											<xsl:call-template name="nems_ref_check">
												<xsl:with-param name="delim" select="$delim"/>
												<xsl:with-param name="name" select="$organization"/>
												<xsl:with-param name="list_name" select="$c_Organization"/>
												<xsl:with-param name="ref_xpath" select="$supportedevents//countrycode"/>
												<xsl:with-param name="ref_attribute" select="'code'"/>
											</xsl:call-template>
										</xsl:when>
										<xsl:otherwise>
											<tr>
												<td style="color:#008000">
													<xsl:text>&amp;Organization.identifier is present and of value '</xsl:text>
													<xsl:value-of select="$c_Organization"/>
													<xsl:text>' this value can not be automatically validated by the Test Harness</xsl:text>
												</td>
											</tr>
										</xsl:otherwise>
									</xsl:choose>
									<xsl:choose>
										<xsl:when test="matches($c_tag,'^[A-Za-z0-9,|_-]{0,100}$')">
											<tr>
												<td style="color:#008000">
													<xsl:text>&amp;tag matches regular expression ^[A-Za-z0-9,|_-]{0,100}$ PASS</xsl:text>
												</td>
											</tr>
										</xsl:when>
										<xsl:otherwise>
											<tr>
												<td style="color:#900000">
													<xsl:text>&amp;tag does not match regular expression  ^[A-Za-z0-9,|_-]{0,100}$ ERROR</xsl:text>
												</td>
											</tr>
										</xsl:otherwise>
									</xsl:choose>
									<!--END-->
								</xsl:when>
								<xsl:otherwise>
									<tr>
										<td style="color:#900000">
											<xsl:text>ERROR Precedence for selected criteria is incorrect, correct precedence is: BundleType, MessageHeader.event, subscriptionRuleType, Organization.identifier, tag</xsl:text>
										</td>
									</tr>
								</xsl:otherwise>
							</xsl:choose>
						</xsl:when>
						<!--BSEAS-->
						<xsl:when test="$bundleType_present and $serviceType_present and $event_present and $age_One_present and not($age_Two_present) and $subscriptionRuleType_present and not($organization_present) and not($tag_present) and $c_count=5">
							<xsl:choose>
								<xsl:when test="contains($c_tokens[1],$bundleType) and contains($c_tokens[2],$serviceType) and contains($c_tokens[3],$event) and contains($c_tokens[4],$age1) and contains($c_tokens[5],$subscriptionRuleType)">
									<tr>
										<td style="color:#008000">
											<xsl:text>PASS Precedence for selected criteria is correct</xsl:text>
										</td>
									</tr>
									<xsl:variable name="c_bundleType" select="$c_tokens[1]"/>
									<xsl:variable name="c_serviceType" select="replace($c_tokens[2],$serviceType,'')"/>
									<xsl:variable name="c_event" select="replace($c_tokens[3],$event,'')"/>
									<xsl:variable name="c_age1" select="replace($c_tokens[4],$age1,'')"/>
									<xsl:variable name="c_subscriptionRuleType" select="replace($c_tokens[5],$subscriptionRuleType,'')"/>
									<!--Check each value in the parsed component lists against the allowable values in the reference file-->
									<xsl:call-template name="nems_ref_check">
										<xsl:with-param name="delim" select="'/'"/>
										<xsl:with-param name="name" select="replace($bundleType, '\?', '\\?')"/>
										<xsl:with-param name="list_name" select="$c_bundleType"/>
										<xsl:with-param name="ref_xpath" select="$supportedevents//bundleType"/>
										<xsl:with-param name="ref_attribute" select="'name'"/>
									</xsl:call-template>
									<xsl:call-template name="nems_ref_check">
										<xsl:with-param name="delim" select="$delim"/>
										<xsl:with-param name="name" select="$serviceType"/>
										<xsl:with-param name="list_name" select="$c_serviceType"/>
										<xsl:with-param name="ref_xpath" select="$supportedevents//serviceType"/>
										<xsl:with-param name="ref_attribute" select="'code'"/>
									</xsl:call-template>
									<xsl:call-template name="nems_ref_check">
										<xsl:with-param name="delim" select="$delim"/>
										<xsl:with-param name="name" select="$event"/>
										<xsl:with-param name="list_name" select="$c_event"/>
										<xsl:with-param name="ref_xpath" select="$supportedevents//event[@subscription='T']"/>
										<xsl:with-param name="ref_attribute" select="'code'"/>
									</xsl:call-template>
									<xsl:choose>
										<xsl:when test="matches($c_age1,'^[l|g]?t?[0-9]+(:contains)?$')">
											<tr>
												<td style="color:#008000">
													<xsl:text>&amp;age[1] matches regular expression ^[l|g]?t?[0-9]+(:contains)?$ PASS</xsl:text>
												</td>
											</tr>
										</xsl:when>
										<xsl:otherwise>
											<tr>
												<td style="color:#900000">
													<xsl:text>&amp;age[1] does not match regular expression  ^[l|g]?t?[0-9]+(:contains)?$ ERROR</xsl:text>
												</td>
											</tr>
										</xsl:otherwise>
									</xsl:choose>
									<xsl:call-template name="nems_ref_check">
										<xsl:with-param name="delim" select="$delim"/>
										<xsl:with-param name="name" select="$subscriptionRuleType"/>
										<xsl:with-param name="list_name" select="$c_subscriptionRuleType"/>
										<xsl:with-param name="ref_xpath" select="$supportedevents//subscriptionRuleType"/>
										<xsl:with-param name="ref_attribute" select="'code'"/>
									</xsl:call-template>
									<xsl:choose>
										<xsl:when test="$c_subscriptionRuleType = 'COUNTRYCODE'">
											<tr>
												<td style="color:#900000">
													<xsl:text>subscriptionRuleType=COUNTRYCODE, required Organization.identifier NOT found ERROR</xsl:text>
												</td>
											</tr>
										</xsl:when>
									</xsl:choose>
									<!--END-->
								</xsl:when>
								<xsl:otherwise>
									<tr>
										<td style="color:#900000">
											<xsl:text>ERROR Precedence for selected criteria is incorrect, correct precedence is: BundleType, serviceType, MessageHeader.event, Patient.age[1], subscriptionRuleType</xsl:text>
										</td>
									</tr>
								</xsl:otherwise>
							</xsl:choose>
						</xsl:when>
						<!--BSESO-->
						<xsl:when test="$bundleType_present and $serviceType_present and $event_present and not($age_One_present) and not($age_Two_present) and $subscriptionRuleType_present and $organization_present and not($tag_present) and $c_count=5">
							<xsl:choose>
								<xsl:when test="contains($c_tokens[1],$bundleType) and contains($c_tokens[2],$serviceType) and contains($c_tokens[3],$event) and contains($c_tokens[4],$subscriptionRuleType) and contains($c_tokens[5],$organization)">
									<tr>
										<td style="color:#008000">
											<xsl:text>PASS Precedence for selected criteria is correct</xsl:text>
										</td>
									</tr>
									<xsl:variable name="c_bundleType" select="$c_tokens[1]"/>
									<xsl:variable name="c_serviceType" select="replace($c_tokens[2],$serviceType,'')"/>
									<xsl:variable name="c_event" select="replace($c_tokens[3],$event,'')"/>
									<xsl:variable name="c_subscriptionRuleType" select="replace($c_tokens[4],$subscriptionRuleType,'')"/>
									<xsl:variable name="c_Organization" select="replace($c_tokens[5],$organization,'')"/>
									<!--Check each value in the parsed component lists against the allowable values in the reference file-->
									<xsl:call-template name="nems_ref_check">
										<xsl:with-param name="delim" select="'/'"/>
										<xsl:with-param name="name" select="replace($bundleType, '\?', '\\?')"/>
										<xsl:with-param name="list_name" select="$c_bundleType"/>
										<xsl:with-param name="ref_xpath" select="$supportedevents//bundleType"/>
										<xsl:with-param name="ref_attribute" select="'name'"/>
									</xsl:call-template>
									<xsl:call-template name="nems_ref_check">
										<xsl:with-param name="delim" select="$delim"/>
										<xsl:with-param name="name" select="$serviceType"/>
										<xsl:with-param name="list_name" select="$c_serviceType"/>
										<xsl:with-param name="ref_xpath" select="$supportedevents//serviceType"/>
										<xsl:with-param name="ref_attribute" select="'code'"/>
									</xsl:call-template>
									<xsl:call-template name="nems_ref_check">
										<xsl:with-param name="delim" select="$delim"/>
										<xsl:with-param name="name" select="$event"/>
										<xsl:with-param name="list_name" select="$c_event"/>
										<xsl:with-param name="ref_xpath" select="$supportedevents//event[@subscription='T']"/>
										<xsl:with-param name="ref_attribute" select="'code'"/>
									</xsl:call-template>
									<xsl:call-template name="nems_ref_check">
										<xsl:with-param name="delim" select="$delim"/>
										<xsl:with-param name="name" select="$subscriptionRuleType"/>
										<xsl:with-param name="list_name" select="$c_subscriptionRuleType"/>
										<xsl:with-param name="ref_xpath" select="$supportedevents//subscriptionRuleType"/>
										<xsl:with-param name="ref_attribute" select="'code'"/>
									</xsl:call-template>									
									<xsl:choose>
										<xsl:when test="$c_subscriptionRuleType = 'COUNTRYCODE'">
											<tr>
												<td style="color:#008000">
													<xsl:text>subscriptionRuleType=COUNTRYCODE, validating Organization.identifier against allowable values</xsl:text>
												</td>
											</tr>
											<xsl:call-template name="nems_ref_check">
												<xsl:with-param name="delim" select="$delim"/>
												<xsl:with-param name="name" select="$organization"/>
												<xsl:with-param name="list_name" select="$c_Organization"/>
												<xsl:with-param name="ref_xpath" select="$supportedevents//countrycode"/>
												<xsl:with-param name="ref_attribute" select="'code'"/>
											</xsl:call-template>
										</xsl:when>
										<xsl:otherwise>
											<tr>
												<td style="color:#008000">
													<xsl:text>&amp;Organization.identifier is present and of value '</xsl:text>
													<xsl:value-of select="$c_Organization"/>
													<xsl:text>' this value can not be automatically validated by the Test Harness</xsl:text>
												</td>
											</tr>
										</xsl:otherwise>
									</xsl:choose>
									<!--END-->
								</xsl:when>
								<xsl:otherwise>
									<tr>
										<td style="color:#900000">
											<xsl:text>ERROR Precedence for selected criteria is incorrect, correct precedence is: BundleType, serviceType, MessageHeader.event, subscriptionRuleType, Organization.identifier</xsl:text>
										</td>
									</tr>
								</xsl:otherwise>
							</xsl:choose>
						</xsl:when>
						<!--BSEST-->
						<xsl:when test="$bundleType_present and $serviceType_present and $event_present and not($age_One_present) and not($age_Two_present) and $subscriptionRuleType_present and not($organization_present) and $tag_present and $c_count=5">
							<xsl:choose>
								<xsl:when test="contains($c_tokens[1],$bundleType) and contains($c_tokens[2],$serviceType) and contains($c_tokens[3],$event) and contains($c_tokens[4],$subscriptionRuleType) and contains($c_tokens[5],$tag)">
									<tr>
										<td style="color:#008000">
											<xsl:text>PASS Precedence for selected criteria is correct</xsl:text>
										</td>
									</tr>
									<xsl:variable name="c_bundleType" select="$c_tokens[1]"/>
									<xsl:variable name="c_serviceType" select="replace($c_tokens[2],$serviceType,'')"/>
									<xsl:variable name="c_event" select="replace($c_tokens[3],$event,'')"/>
									<xsl:variable name="c_subscriptionRuleType" select="replace($c_tokens[4],$subscriptionRuleType,'')"/>
									<xsl:variable name="c_tag" select="replace($c_tokens[5],$tag,'')"/>
									<!--Check each value in the parsed component lists against the allowable values in the reference file-->
									<xsl:call-template name="nems_ref_check">
										<xsl:with-param name="delim" select="'/'"/>
										<xsl:with-param name="name" select="replace($bundleType, '\?', '\\?')"/>
										<xsl:with-param name="list_name" select="$c_bundleType"/>
										<xsl:with-param name="ref_xpath" select="$supportedevents//bundleType"/>
										<xsl:with-param name="ref_attribute" select="'name'"/>
									</xsl:call-template>
									<xsl:call-template name="nems_ref_check">
										<xsl:with-param name="delim" select="$delim"/>
										<xsl:with-param name="name" select="$serviceType"/>
										<xsl:with-param name="list_name" select="$c_serviceType"/>
										<xsl:with-param name="ref_xpath" select="$supportedevents//serviceType"/>
										<xsl:with-param name="ref_attribute" select="'code'"/>
									</xsl:call-template>
									<xsl:call-template name="nems_ref_check">
										<xsl:with-param name="delim" select="$delim"/>
										<xsl:with-param name="name" select="$event"/>
										<xsl:with-param name="list_name" select="$c_event"/>
										<xsl:with-param name="ref_xpath" select="$supportedevents//event[@subscription='T']"/>
										<xsl:with-param name="ref_attribute" select="'code'"/>
									</xsl:call-template>
									<xsl:call-template name="nems_ref_check">
										<xsl:with-param name="delim" select="$delim"/>
										<xsl:with-param name="name" select="$subscriptionRuleType"/>
										<xsl:with-param name="list_name" select="$c_subscriptionRuleType"/>
										<xsl:with-param name="ref_xpath" select="$supportedevents//subscriptionRuleType"/>
										<xsl:with-param name="ref_attribute" select="'code'"/>
									</xsl:call-template>
									<xsl:choose>
										<xsl:when test="$c_subscriptionRuleType = 'COUNTRYCODE'">
											<tr>
												<td style="color:#900000">
													<xsl:text>subscriptionRuleType=COUNTRYCODE, required Organization.identifier NOT found ERROR</xsl:text>
												</td>
											</tr>
										</xsl:when>
									</xsl:choose>
									<xsl:choose>
										<xsl:when test="matches($c_tag,'^[A-Za-z0-9,|_-]{0,100}$')">
											<tr>
												<td style="color:#008000">
													<xsl:text>&amp;tag matches regular expression ^[A-Za-z0-9,|_-]{0,100}$ PASS</xsl:text>
												</td>
											</tr>
										</xsl:when>
										<xsl:otherwise>
											<tr>
												<td style="color:#900000">
													<xsl:text>&amp;tag does not match regular expression  ^[A-Za-z0-9,|_-]{0,100}$ ERROR</xsl:text>
												</td>
											</tr>
										</xsl:otherwise>
									</xsl:choose>
									<!--END-->
								</xsl:when>
								<xsl:otherwise>
									<tr>
										<td style="color:#900000">
											<xsl:text>ERROR Precedence for selected criteria is incorrect, correct precedence is: BundleType, serviceType, MessageHeader.event, subscriptionRuleType, tag</xsl:text>
										</td>
									</tr>
								</xsl:otherwise>
							</xsl:choose>
						</xsl:when>
						<!--BEAS-->
						<xsl:when test="$bundleType_present and not($serviceType_present) and $event_present and $age_One_present and not($age_Two_present) and $subscriptionRuleType_present and not($organization_present) and not($tag_present) and $c_count=4">
							<xsl:choose>
								<xsl:when test="contains($c_tokens[1],$bundleType) and contains($c_tokens[2],$event) and contains($c_tokens[3],$age1) and contains($c_tokens[4],$subscriptionRuleType)">
									<tr>
										<td style="color:#008000">
											<xsl:text>PASS Precedence for selected criteria is correct</xsl:text>
										</td>
									</tr>
									<xsl:variable name="c_bundleType" select="$c_tokens[1]"/>
									<xsl:variable name="c_event" select="replace($c_tokens[2],$event,'')"/>
									<xsl:variable name="c_age1" select="replace($c_tokens[3],$age1,'')"/>
									<xsl:variable name="c_subscriptionRuleType" select="replace($c_tokens[4],$subscriptionRuleType,'')"/>
									<!--Check each value in the parsed component lists against the allowable values in the reference file-->
									<xsl:call-template name="nems_ref_check">
										<xsl:with-param name="delim" select="'/'"/>
										<xsl:with-param name="name" select="replace($bundleType, '\?', '\\?')"/>
										<xsl:with-param name="list_name" select="$c_bundleType"/>
										<xsl:with-param name="ref_xpath" select="$supportedevents//bundleType"/>
										<xsl:with-param name="ref_attribute" select="'name'"/>
									</xsl:call-template>
									<xsl:call-template name="nems_ref_check">
										<xsl:with-param name="delim" select="$delim"/>
										<xsl:with-param name="name" select="$event"/>
										<xsl:with-param name="list_name" select="$c_event"/>
										<xsl:with-param name="ref_xpath" select="$supportedevents//event[@subscription='T']"/>
										<xsl:with-param name="ref_attribute" select="'code'"/>
									</xsl:call-template>
									<xsl:choose>
										<xsl:when test="matches($c_age1,'^[l|g]?t?[0-9]+(:contains)?$')">
											<tr>
												<td style="color:#008000">
													<xsl:text>&amp;age[1] matches regular expression ^[l|g]?t?[0-9]+(:contains)?$ PASS</xsl:text>
												</td>
											</tr>
										</xsl:when>
										<xsl:otherwise>
											<tr>
												<td style="color:#900000">
													<xsl:text>&amp;age[1] does not match regular expression  ^[l|g]?t?[0-9]+(:contains)?$ ERROR</xsl:text>
												</td>
											</tr>
										</xsl:otherwise>
									</xsl:choose>
									<xsl:call-template name="nems_ref_check">
										<xsl:with-param name="delim" select="$delim"/>
										<xsl:with-param name="name" select="$subscriptionRuleType"/>
										<xsl:with-param name="list_name" select="$c_subscriptionRuleType"/>
										<xsl:with-param name="ref_xpath" select="$supportedevents//subscriptionRuleType"/>
										<xsl:with-param name="ref_attribute" select="'code'"/>
									</xsl:call-template>
									<xsl:choose>
										<xsl:when test="$c_subscriptionRuleType = 'COUNTRYCODE'">
											<tr>
												<td style="color:#900000">
													<xsl:text>subscriptionRuleType=COUNTRYCODE, required Organization.identifier NOT found ERROR</xsl:text>
												</td>
											</tr>
										</xsl:when>
									</xsl:choose>
									<!--END-->
								</xsl:when>
								<xsl:otherwise>
									<tr>
										<td style="color:#900000">
											<xsl:text>ERROR Precedence for selected criteria is incorrect, correct precedence is: BundleType, MessageHeader.event, Patient.age[1], subscriptionRuleType</xsl:text>
										</td>
									</tr>
								</xsl:otherwise>
							</xsl:choose>
						</xsl:when>
						<!--BESO-->
						<xsl:when test="$bundleType_present and not($serviceType_present) and $event_present and not($age_One_present) and not($age_Two_present) and $subscriptionRuleType_present and $organization_present and not($tag_present) and $c_count=4">
							<xsl:choose>
								<xsl:when test="contains($c_tokens[1],$bundleType) and contains($c_tokens[2],$event) and contains($c_tokens[3],$subscriptionRuleType) and contains($c_tokens[4],$organization)">
									<tr>
										<td style="color:#008000">
											<xsl:text>PASS Precedence for selected criteria is correct</xsl:text>
										</td>
									</tr>
									<xsl:variable name="c_bundleType" select="$c_tokens[1]"/>
									<xsl:variable name="c_event" select="replace($c_tokens[2],$event,'')"/>
									<xsl:variable name="c_subscriptionRuleType" select="replace($c_tokens[3],$subscriptionRuleType,'')"/>
									<xsl:variable name="c_Organization" select="replace($c_tokens[4],$organization,'')"/>
									<!--Check each value in the parsed component lists against the allowable values in the reference file-->
									<xsl:call-template name="nems_ref_check">
										<xsl:with-param name="delim" select="'/'"/>
										<xsl:with-param name="name" select="replace($bundleType, '\?', '\\?')"/>
										<xsl:with-param name="list_name" select="$c_bundleType"/>
										<xsl:with-param name="ref_xpath" select="$supportedevents//bundleType"/>
										<xsl:with-param name="ref_attribute" select="'name'"/>
									</xsl:call-template>
									<xsl:call-template name="nems_ref_check">
										<xsl:with-param name="delim" select="$delim"/>
										<xsl:with-param name="name" select="$event"/>
										<xsl:with-param name="list_name" select="$c_event"/>
										<xsl:with-param name="ref_xpath" select="$supportedevents//event[@subscription='T']"/>
										<xsl:with-param name="ref_attribute" select="'code'"/>
									</xsl:call-template>
									<xsl:call-template name="nems_ref_check">
										<xsl:with-param name="delim" select="$delim"/>
										<xsl:with-param name="name" select="$subscriptionRuleType"/>
										<xsl:with-param name="list_name" select="$c_subscriptionRuleType"/>
										<xsl:with-param name="ref_xpath" select="$supportedevents//subscriptionRuleType"/>
										<xsl:with-param name="ref_attribute" select="'code'"/>
									</xsl:call-template>
									<xsl:choose>
										<xsl:when test="$c_subscriptionRuleType = 'COUNTRYCODE'">
											<tr>
												<td style="color:#008000">
													<xsl:text>subscriptionRuleType=COUNTRYCODE, validating Organization.identifier against allowable values</xsl:text>
												</td>
											</tr>
											<xsl:call-template name="nems_ref_check">
												<xsl:with-param name="delim" select="$delim"/>
												<xsl:with-param name="name" select="$organization"/>
												<xsl:with-param name="list_name" select="$c_Organization"/>
												<xsl:with-param name="ref_xpath" select="$supportedevents//countrycode"/>
												<xsl:with-param name="ref_attribute" select="'code'"/>
											</xsl:call-template>
										</xsl:when>
										<xsl:otherwise>
											<tr>
												<td style="color:#008000">
													<xsl:text>&amp;Organization.identifier is present and of value '</xsl:text>
													<xsl:value-of select="$c_Organization"/>
													<xsl:text>' this value can not be automatically validated by the Test Harness</xsl:text>
												</td>
											</tr>
										</xsl:otherwise>
									</xsl:choose>
									<!--END-->
								</xsl:when>
								<xsl:otherwise>
									<tr>
										<td style="color:#900000">
											<xsl:text>ERROR Precedence for selected criteria is incorrect, correct precedence is: BundleType, MessageHeader.event, subscriptionRuleType, Organization.identifier</xsl:text>
										</td>
									</tr>
								</xsl:otherwise>
							</xsl:choose>
						</xsl:when>
						<!--BEST-->
						<xsl:when test="$bundleType_present and not($serviceType_present) and $event_present and not($age_One_present) and not($age_Two_present) and $subscriptionRuleType_present and not($organization_present) and $tag_present and $c_count=4">
							<xsl:choose>
								<xsl:when test="contains($c_tokens[1],$bundleType) and contains($c_tokens[2],$event) and contains($c_tokens[3],$subscriptionRuleType) and contains($c_tokens[4],$tag)">
									<tr>
										<td style="color:#008000">
											<xsl:text>PASS Precedence for selected criteria is correct</xsl:text>
										</td>
									</tr>
									<xsl:variable name="c_bundleType" select="$c_tokens[1]"/>
									<xsl:variable name="c_event" select="replace($c_tokens[2],$event,'')"/>
									<xsl:variable name="c_subscriptionRuleType" select="replace($c_tokens[3],$subscriptionRuleType,'')"/>
									<xsl:variable name="c_tag" select="replace($c_tokens[4],$tag,'')"/>
									<!--Check each value in the parsed component lists against the allowable values in the reference file-->
									<xsl:call-template name="nems_ref_check">
										<xsl:with-param name="delim" select="'/'"/>
										<xsl:with-param name="name" select="replace($bundleType, '\?', '\\?')"/>
										<xsl:with-param name="list_name" select="$c_bundleType"/>
										<xsl:with-param name="ref_xpath" select="$supportedevents//bundleType"/>
										<xsl:with-param name="ref_attribute" select="'name'"/>
									</xsl:call-template>
									<xsl:call-template name="nems_ref_check">
										<xsl:with-param name="delim" select="$delim"/>
										<xsl:with-param name="name" select="$event"/>
										<xsl:with-param name="list_name" select="$c_event"/>
										<xsl:with-param name="ref_xpath" select="$supportedevents//event[@subscription='T']"/>
										<xsl:with-param name="ref_attribute" select="'code'"/>
									</xsl:call-template>
									<xsl:call-template name="nems_ref_check">
										<xsl:with-param name="delim" select="$delim"/>
										<xsl:with-param name="name" select="$subscriptionRuleType"/>
										<xsl:with-param name="list_name" select="$c_subscriptionRuleType"/>
										<xsl:with-param name="ref_xpath" select="$supportedevents//subscriptionRuleType"/>
										<xsl:with-param name="ref_attribute" select="'code'"/>
									</xsl:call-template>
									<xsl:choose>
										<xsl:when test="$c_subscriptionRuleType = 'COUNTRYCODE'">
											<tr>
												<td style="color:#900000">
													<xsl:text>subscriptionRuleType=COUNTRYCODE, required Organization.identifier NOT found ERROR</xsl:text>
												</td>
											</tr>
										</xsl:when>
									</xsl:choose>
									<xsl:choose>
										<xsl:when test="matches($c_tag,'^[A-Za-z0-9,|_-]{0,100}$')">
											<tr>
												<td style="color:#008000">
													<xsl:text>&amp;tag matches regular expression ^[A-Za-z0-9,|_-]{0,100}$ PASS</xsl:text>
												</td>
											</tr>
										</xsl:when>
										<xsl:otherwise>
											<tr>
												<td style="color:#900000">
													<xsl:text>&amp;tag does not match regular expression  ^[A-Za-z0-9,|_-]{0,100}$ ERROR</xsl:text>
												</td>
											</tr>
										</xsl:otherwise>
									</xsl:choose>
									<!--END-->
								</xsl:when>
								<xsl:otherwise>
									<tr>
										<td style="color:#900000">
											<xsl:text>ERROR Precedence for selected criteria is incorrect, correct precedence is: BundleType, MessageHeader.event, subscriptionRuleType, tag</xsl:text>
										</td>
									</tr>
								</xsl:otherwise>
							</xsl:choose>
						</xsl:when>
						<!--BSES-->
						<xsl:when test="$bundleType_present and $serviceType_present and $event_present and not($age_One_present) and not($age_Two_present) and $subscriptionRuleType_present and not($organization_present) and not($tag_present) and $c_count=4">
							<xsl:choose>
								<xsl:when test="contains($c_tokens[1],$bundleType) and contains($c_tokens[2],$serviceType) and contains($c_tokens[3],$event) and contains($c_tokens[4],$subscriptionRuleType)">
									<tr>
										<td style="color:#008000">
											<xsl:text>PASS Precedence for selected criteria is correct</xsl:text>
										</td>
									</tr>
									<xsl:variable name="c_bundleType" select="$c_tokens[1]"/>
									<xsl:variable name="c_serviceType" select="replace($c_tokens[2],$serviceType,'')"/>
									<xsl:variable name="c_event" select="replace($c_tokens[3],$event,'')"/>
									<xsl:variable name="c_subscriptionRuleType" select="replace($c_tokens[4],$subscriptionRuleType,'')"/>
									<!--Check each value in the parsed component lists against the allowable values in the reference file-->
									<xsl:call-template name="nems_ref_check">
										<xsl:with-param name="delim" select="'/'"/>
										<xsl:with-param name="name" select="replace($bundleType, '\?', '\\?')"/>
										<xsl:with-param name="list_name" select="$c_bundleType"/>
										<xsl:with-param name="ref_xpath" select="$supportedevents//bundleType"/>
										<xsl:with-param name="ref_attribute" select="'name'"/>
									</xsl:call-template>
									<xsl:call-template name="nems_ref_check">
										<xsl:with-param name="delim" select="$delim"/>
										<xsl:with-param name="name" select="$serviceType"/>
										<xsl:with-param name="list_name" select="$c_serviceType"/>
										<xsl:with-param name="ref_xpath" select="$supportedevents//serviceType"/>
										<xsl:with-param name="ref_attribute" select="'code'"/>
									</xsl:call-template>
									<xsl:call-template name="nems_ref_check">
										<xsl:with-param name="delim" select="$delim"/>
										<xsl:with-param name="name" select="$event"/>
										<xsl:with-param name="list_name" select="$c_event"/>
										<xsl:with-param name="ref_xpath" select="$supportedevents//event[@subscription='T']"/>
										<xsl:with-param name="ref_attribute" select="'code'"/>
									</xsl:call-template>
									<xsl:call-template name="nems_ref_check">
										<xsl:with-param name="delim" select="$delim"/>
										<xsl:with-param name="name" select="$subscriptionRuleType"/>
										<xsl:with-param name="list_name" select="$c_subscriptionRuleType"/>
										<xsl:with-param name="ref_xpath" select="$supportedevents//subscriptionRuleType"/>
										<xsl:with-param name="ref_attribute" select="'code'"/>
									</xsl:call-template>
									<xsl:choose>
										<xsl:when test="$c_subscriptionRuleType = 'COUNTRYCODE'">
											<tr>
												<td style="color:#900000">
													<xsl:text>subscriptionRuleType=COUNTRYCODE, required Organization.identifier NOT found ERROR</xsl:text>
												</td>
											</tr>
										</xsl:when>
									</xsl:choose>
									<!--END-->
								</xsl:when>
								<xsl:otherwise>
									<tr>
										<td style="color:#900000">
											<xsl:text>ERROR Precedence for selected criteria is incorrect, correct precedence is: BundleType, serviceType, MessageHeader.event, subscriptionRuleType</xsl:text>
										</td>
									</tr>
								</xsl:otherwise>
							</xsl:choose>
						</xsl:when>
						<!--BES-->
						<xsl:when test="$bundleType_present and not($serviceType_present) and $event_present and not($age_One_present) and not($age_Two_present) and $subscriptionRuleType_present and not($organization_present) and not($tag_present) and $c_count=3">
							<xsl:choose>
								<xsl:when test="contains($c_tokens[1],$bundleType) and contains($c_tokens[2],$event) and contains($c_tokens[3],$subscriptionRuleType)">
									<tr>
										<td style="color:#008000">
											<xsl:text>PASS Precedence for selected criteria is correct</xsl:text>
										</td>
									</tr>
									<xsl:variable name="c_bundleType" select="$c_tokens[1]"/>
									<xsl:variable name="c_event" select="replace($c_tokens[2],$event,'')"/>
									<xsl:variable name="c_subscriptionRuleType" select="replace($c_tokens[3],$subscriptionRuleType,'')"/>
									<!--Check each value in the parsed component lists against the allowable values in the reference file-->
									<xsl:call-template name="nems_ref_check">
										<xsl:with-param name="delim" select="'/'"/>
										<xsl:with-param name="name" select="replace($bundleType, '\?', '\\?')"/>
										<xsl:with-param name="list_name" select="$c_bundleType"/>
										<xsl:with-param name="ref_xpath" select="$supportedevents//bundleType"/>
										<xsl:with-param name="ref_attribute" select="'name'"/>
									</xsl:call-template>
									<xsl:call-template name="nems_ref_check">
										<xsl:with-param name="delim" select="$delim"/>
										<xsl:with-param name="name" select="$event"/>
										<xsl:with-param name="list_name" select="$c_event"/>
										<xsl:with-param name="ref_xpath" select="$supportedevents//event[@subscription='T']"/>
										<xsl:with-param name="ref_attribute" select="'code'"/>
									</xsl:call-template>
									<xsl:call-template name="nems_ref_check">
										<xsl:with-param name="delim" select="$delim"/>
										<xsl:with-param name="name" select="$subscriptionRuleType"/>
										<xsl:with-param name="list_name" select="$c_subscriptionRuleType"/>
										<xsl:with-param name="ref_xpath" select="$supportedevents//subscriptionRuleType"/>
										<xsl:with-param name="ref_attribute" select="'code'"/>
									</xsl:call-template>
									<xsl:choose>
										<xsl:when test="$c_subscriptionRuleType = 'COUNTRYCODE'">
											<tr>
												<td style="color:#900000">
													<xsl:text>subscriptionRuleType=COUNTRYCODE, required Organization.identifier NOT found ERROR</xsl:text>
												</td>
											</tr>
										</xsl:when>
									</xsl:choose>
									<!--END-->
								</xsl:when>
								<xsl:otherwise>
									<tr>
										<td style="color:#900000">
											<xsl:text>ERROR Precedence for selected criteria is incorrect, correct precedence is: BundleType, MessageHeader.event, subscriptionRuleType</xsl:text>
										</td>
									</tr>
								</xsl:otherwise>
							</xsl:choose>
						</xsl:when>
					</xsl:choose>
				</xsl:when>
				<xsl:otherwise>
					<tr>
						<td style="color:#900000">
							<xsl:choose>
								<xsl:when test="$patient_present">
									<xsl:text>ERROR Patient.identifier is 0..0 for generic subscriptions</xsl:text>
								</xsl:when>
								<xsl:when test="starts-with($criteria, $delim)">
									<xsl:text>ERROR Criteria begins with a delimiter</xsl:text>
								</xsl:when>
								<xsl:when test="ends-with($criteria, $delim)">
									<xsl:text>ERROR Criteria has a trailing delimiter</xsl:text>
								</xsl:when>
								<xsl:when test="contains($criteria, concat($delim,$delim))">
									<xsl:text>ERROR Criteria contains repeated delimiters</xsl:text>
								</xsl:when>
								<xsl:when test="$c_count&lt;3">
									<xsl:text>ERROR Too few criteria are present to form a valid criteria selection</xsl:text>
								</xsl:when>
								<xsl:when test="$c_count&gt;8">
									<xsl:text>ERROR Additonal criteria found, too many are present to form a valid criteria selection</xsl:text>
								</xsl:when>
								<xsl:otherwise>
									<xsl:text>ERROR An unhandled exception has occurred attempting to parse the criteria selection</xsl:text>
								</xsl:otherwise>
							</xsl:choose>
						</td>
					</tr>
				</xsl:otherwise>
			</xsl:choose>
		</table>
	</xsl:template>
</xsl:stylesheet>
