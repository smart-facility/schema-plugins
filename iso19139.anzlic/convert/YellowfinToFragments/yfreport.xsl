<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0"
		xmlns:gco="http://www.isotc211.org/2005/gco"
		xmlns:gmd="http://www.isotc211.org/2005/gmd"
		xmlns:gml="http://www.opengis.net/gml"
		xmlns:xlink="http://www.w3.org/1999/xlink"
		xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"		
		xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

	<xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes" />

	<!-- 
			 This xslt should transform output from the yellowfin report metadata
	     format to fragments that can be linked into the template yellowfin.xml 
	 -->

	<xsl:template match="/root">
		<xsl:variable name="uuid" select="@uuid"/>
		<records>
			<record uuid="{$uuid}">
				<xsl:apply-templates select="*">
					<xsl:with-param name="uuid" select="$uuid"/>
				</xsl:apply-templates>
			</record>
		</records>
	</xsl:template>

	<xsl:template name="addCIResponsibleParty">

				<gmd:CI_ResponsibleParty>
   				<gmd:individualName>
     				<gco:CharacterString><xsl:value-of select="concat(FirstName,' ',LastName)"/></gco:CharacterString>
   				</gmd:individualName>
   				<gmd:organisationName>
     				<gco:CharacterString></gco:CharacterString>
   				</gmd:organisationName>
    			<gmd:positionName>
       			<gco:CharacterString><xsl:value-of select="RoleCode"/></gco:CharacterString>
    			</gmd:positionName>
    			<gmd:role>
       			<gmd:CI_RoleCode codeList="http://www.isotc211.org/2005/resources/Codelist/gmxCodelists.xml#CI_RoleCode" codeListValue="{@role}"/>
    			</gmd:role> 	

					<!-- FIXME: Add contact info -->
				</gmd:CI_ResponsibleParty>

	</xsl:template>

	<xsl:template match="SmallReport">
		<xsl:param name="uuid"/>

		<!-- boundingBox -->
		<xsl:if test="count(bounds/*)>0">
			<fragment id="boundingbox" uuid="{$uuid}_boundingbox">
				<gmd:EX_Extent>
					<gmd:geographicElement>
						<gmd:EX_GeographicBoundingBox>
							<gmd:westBoundLongitude>
								<gco:Decimal><xsl:value-of select="bounds/minX"/></gco:Decimal>
							</gmd:westBoundLongitude>
							<gmd:eastBoundLongitude>
								<gco:Decimal><xsl:value-of select="bounds/maxX"/></gco:Decimal>
							</gmd:eastBoundLongitude>
							<gmd:southBoundLatitude>
								<gco:Decimal><xsl:value-of select="bounds/minY"/></gco:Decimal>
							</gmd:southBoundLatitude>
							<gmd:northBoundLatitude>
								<gco:Decimal><xsl:value-of select="bounds/maxY"/></gco:Decimal>
							</gmd:northBoundLatitude>
						</gmd:EX_GeographicBoundingBox>
					</gmd:geographicElement>
				</gmd:EX_Extent>	
			</fragment>
		</xsl:if>

		<!-- keywords - column names as data parameter names -->

			<fragment id="keywords" uuid="{$uuid}_keywords">
				<gmd:descriptiveKeywords>
					<gmd:MD_Keywords>
						<xsl:for-each select="columns/column/displayName">
							<gmd:keyword>
								<gco:CharacterString><xsl:value-of select="."/></gco:CharacterString>
							</gmd:keyword>
						</xsl:for-each>
						<gmd:type>
							<gmd:MD_KeywordTypeCode codeList="http://www.isotc211.org/2005/resources/Codelist/gmxCodelists.xml#MD_KeywordTypeCode" codeListValue="dataParameterName"/>
						</gmd:type>
					</gmd:MD_Keywords>
				</gmd:descriptiveKeywords>
			</fragment>

		<!-- keywords - category -->

			<fragment id="keywords" uuid="{$uuid}_keywords_category">
				<gmd:descriptiveKeywords>
					<gmd:MD_Keywords>
						<xsl:for-each select="category|subCategory">
							<gmd:keyword>
								<gco:CharacterString><xsl:value-of select="."/></gco:CharacterString>
							</gmd:keyword>
						</xsl:for-each>
						<gmd:type>
							<gmd:MD_KeywordTypeCode codeList="http://www.isotc211.org/2005/resources/Codelist/gmxCodelists.xml#MD_KeywordTypeCode" codeListValue="theme"/>
						</gmd:type>
					</gmd:MD_Keywords>
				</gmd:descriptiveKeywords>
			</fragment>
	</xsl:template>

	<xsl:template match="AdministrationReport">
		<xsl:param name="uuid"/>

			<fragment id="fileIdentifier" uuid="{$uuid}_fileid">
				<gmd:fileIdentifier>
					<gco:CharacterString><xsl:value-of select="ReportUUID"/></gco:CharacterString>
				</gmd:fileIdentifier>
			</fragment>

			<!-- citation -->

			<fragment id="citation" uuid="{$uuid}_citation">
				<gmd:CI_Citation>
					<gmd:title>
						<gco:CharacterString><xsl:value-of select="ReportName"/></gco:CharacterString>
					</gmd:title>
					<gmd:date>
						<gmd:CI_Date>
							<gmd:date>
								<gco:Date>
									<gco:CharacterString><xsl:value-of select="PublishDate"/></gco:CharacterString>
								</gco:Date>
							</gmd:date>
							<gmd:dateType>
								<gmd:CI_DateTypeCode codeList="http://www.isotc211.org/2005/resources/Codelist/gmxCodelists.xml#CI_DateTypeCode" codeListValue="publication"/>
							</gmd:dateType>
						</gmd:CI_Date>
					</gmd:date>
					<gmd:date>
						<gmd:CI_Date>
							<gmd:date>
								<gco:Date>
									<gco:CharacterString><xsl:value-of select="LastModifiedDate"/></gco:CharacterString>
								</gco:Date>
							</gmd:date>
							<gmd:dateType>
								<gmd:CI_DateTypeCode codeList="http://www.isotc211.org/2005/resources/Codelist/gmxCodelists.xml#CI_DateTypeCode" codeListValue="revision"/>
							</gmd:dateType>
						</gmd:CI_Date>
					</gmd:date>
					<!-- report author and last modifier go in here as these are
					     the people who are responsible for the intellectual content
							 of the report -->
					<xsl:for-each select="//AdministrationPerson">
						<gmd:citedResponsibleParty>	
							<xsl:call-template name="addCIResponsibleParty">
								<xsl:with-param name="uuid" select="$uuid"/>
							</xsl:call-template>
						</gmd:citedResponsibleParty>	
					</xsl:for-each>
				</gmd:CI_Citation>
			</fragment>

			<!-- abstract -->

			<fragment id="abstract" uuid="{$uuid}_abstract">
				<gmd:abstract>
					<gco:CharacterString><xsl:value-of select="ReportDescription"/></gco:CharacterString>
				</gmd:abstract>
			</fragment>

			<!-- dateStamp -->

			<fragment id="dateStamp" uuid="{$uuid}_dateStamp">
				<gmd:dateStamp>
					<gco:DateTime><xsl:value-of select="dateStamp"/></gco:DateTime>
				</gmd:dateStamp>
			</fragment>

			<!-- temporal extent = lifespan -->

			<fragment id="tempextent" uuid="{$uuid}_tempextent">
				<gmd:temporalElement>
					<gmd:EX_TemporalExtent>
						<gmd:extent>
							<gml:TimePeriod gml:id="">
								<gml:beginPosition><xsl:value-of select="PublishDate"/></gml:beginPosition>
								<gml:endPosition><xsl:value-of select="LastModifiedDate"/></gml:endPosition>
							</gml:TimePeriod>
						</gmd:extent>
					</gmd:EX_TemporalExtent>
				</gmd:temporalElement>
			</fragment>

			<!-- distribution information - report URL -->

			<fragment id="online_resource" uuid="{$uuid}_online">
				<gmd:onLine>
					<gmd:CI_OnlineResource>
						<gmd:linkage>
							<gmd:URL><xsl:value-of select="reportURL"/></gmd:URL>
						</gmd:linkage>
						<gmd:protocol>
							<gco:CharacterString>WWW:LINK-1.0-http--link</gco:CharacterString>
						</gmd:protocol>
						<gmd:name>
							<gco:CharacterString><xsl:value-of select="ReportName"/></gco:CharacterString>
						</gmd:name>
						<gmd:description>
							<gco:CharacterString><xsl:value-of select="ReportDescription"/></gco:CharacterString>
						</gmd:description>
					</gmd:CI_OnlineResource>
				</gmd:onLine>
			</fragment>

	</xsl:template>

	<!-- do nothing template because we consume AdministrationPerson 
	     elsewhere -->
	<xsl:template match="AdministrationPerson"> 
		<xsl:param name="uuid"/>
	</xsl:template>

</xsl:stylesheet>
