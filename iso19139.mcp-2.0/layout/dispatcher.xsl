<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:gmd="http://www.isotc211.org/2005/gmd" xmlns:gts="http://www.isotc211.org/2005/gts"
  xmlns:gco="http://www.isotc211.org/2005/gco" xmlns:gmx="http://www.isotc211.org/2005/gmx"
  xmlns:srv="http://www.isotc211.org/2005/srv" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
  xmlns:gml="http://www.opengis.net/gml" xmlns:xlink="http://www.w3.org/1999/xlink"
	xmlns:mcp="http://schemas.aodn.org.au/mcp-2.0"
  xmlns:xs="http://www.w3.org/2001/XMLSchema"
  xmlns:gn="http://www.fao.org/geonetwork"
  xmlns:gn-fn-metadata="http://geonetwork-opensource.org/xsl/functions/metadata"
  xmlns:gn-fn-iso19139="http://geonetwork-opensource.org/xsl/functions/profiles/iso19139"
  xmlns:saxon="http://saxon.sf.net/" extension-element-prefixes="saxon"
  exclude-result-prefixes="#all">
  
  <xsl:include href="layout.xsl"/>
  
  
  <!-- 
    Load the schema configuration for the editor.
      -->
  <xsl:template name="get-iso19139.mcp-2.0-configuration">
    <xsl:copy-of select="document('config-editor.xml')"/>
  </xsl:template>


	<!-- The main dispatch point -->
  <xsl:template name="dispatch-iso19139.mcp-2.0">
    <xsl:param name="base" as="node()"/>
    <xsl:param name="overrideLabel" as="xs:string" required="no" select="''"/>

		<!-- process in iso19139 mode - but we can override any templates
		     defined for iso19139 by importing that stylesheet into our
				 mcp-2.0 stylesheet - that way the iso19139 templates will have
				 a lower priority than ours -->
    <xsl:apply-templates mode="mode-iso19139" select="$base">
     	<xsl:with-param name="overrideLabel" select="$overrideLabel"/>
    	<xsl:with-param name="schema" select="$schema"/>
    	<xsl:with-param name="labels" select="$iso19139.mcp-2.0labels"/>
    </xsl:apply-templates>

  </xsl:template>

  <!-- Evaluate an expression. This is schema dependant in order to properly 
        set namespaces required for evaluate.
        
    "The static context for the expression includes all the in-scope namespaces, 
    types, and functions from the calling stylesheet or query"
    http://saxonica.com/documentation9.4-demo/html/extensions/functions/evaluate.html
    
       A node returned by evaluate will lost its context (ancestors).
    -->
  <xsl:template name="evaluate-iso19139.mcp-2.0">
    <xsl:param name="base" as="node()"/>
    <xsl:param name="in"/>
   <!-- <xsl:message>in xml <xsl:copy-of select="$base"></xsl:copy-of></xsl:message>
    <xsl:message>search for <xsl:copy-of select="$in"></xsl:copy-of></xsl:message>-->
    <xsl:variable name="nodeOrAttribute" select="saxon:evaluate(concat('$p1', $in), $base)"/>
    <xsl:choose>
      <xsl:when test="$nodeOrAttribute/*">
        <xsl:copy-of select="$nodeOrAttribute"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="$nodeOrAttribute"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <!-- Evaluate XPath returning a boolean value. -->
  <xsl:template name="evaluate-iso19139.mcp-2.0-boolean">
    <xsl:param name="base" as="node()"/>
    <xsl:param name="in"/>
   
    <xsl:value-of select="saxon:evaluate(concat('$p1', $in), $base)"/>
  </xsl:template>


</xsl:stylesheet>
