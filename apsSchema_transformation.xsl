<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xlink="http://www.w3.org/1999/xlink"
    xmlns:mods="http://www.loc.gov/mods/v3" xmlns:ead="urn:isbn:1-931666-22-9"
    xmlns:dc="http://dublincore.org/2012/06/14/dcelements.rdf#"
    xmlns:dct="http://dublincore.org/2012/06/14/dcterms.rdf#"
    xsi:schemaLocation="http://www.loc.gov/mods/v3 http://www.loc.gov/standards/mods/v3/mods-3-3.xsd 
    urn:isbn:1-931666-22-9 http://www.loc.gov/ead/ead.xsd"
    xmlns:aps="http://jacobshelby.org/schemas/aps/2014/08/03/apsSchema.rdf#" 
    xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
    xmlns:rdfs="http://www.w3.org/2000/01/rdf-schema#" exclude-result-prefixes="#all">

    <xsl:output method="html" omit-xml-declaration="yes"/>

    <!-- shell for the html -->
    <xsl:template match="/">
        <xsl:text disable-output-escaping="yes"><![CDATA[<!DOCTYPE html>]]></xsl:text>
        <html>
            <xsl:copy-of select="document('apsSchema_tableOfContents.xml')/htmlcode/html/head"/>
            <body>
                <xsl:apply-templates select="rdf:RDF/rdf:Description"/>
                <xsl:copy-of
                    select="document('apsSchema_tableOfContents.xml')/htmlcode/html/body/tableOfContents/div"/>
                <xsl:text disable-output-escaping="yes"><![CDATA[<hr/>]]></xsl:text>
                <xsl:apply-templates select="rdf:RDF" mode="introduction"/>
                <xsl:apply-templates select="rdf:RDF" mode="index"/>
                <xsl:apply-templates select="rdf:RDF"/>
                <xsl:apply-templates select="rdf:RDF" mode="Custom"/>
            </body>
        </html>
    </xsl:template>

    <!-- sets up heading info -->
    <xsl:template match="rdf:RDF/rdf:Description">
        <div id="title">
            <xsl:if test="dc:title">
                <h1>
                    <xsl:value-of select="dc:title"/>
                </h1>
            </xsl:if>
        </div>
        <div id="heading">
            <p>
                <b>
                    <xsl:text>identifier: </xsl:text>
                </b>
                <xsl:element name="a">
                    <xsl:attribute name="href">
                        <xsl:value-of select="../@xml:base"/>
                    </xsl:attribute>
                    <xsl:value-of select="../@xml:base"/>
                </xsl:element>
            </p>
            <xsl:if test="dct:created">
                <p>
                    <b>
                        <xsl:text>date created: </xsl:text>
                    </b>
                    <xsl:value-of select="dct:created"/>
                </p>
            </xsl:if>
            <p>
                <b>
                    <xsl:text>date last modified: </xsl:text>
                </b>
                <xsl:value-of
                    select="document('apsSchema_tableOfContents.xml')/htmlcode/html/head/meta/@content"
                />
            </p>
        </div>
        <xsl:text disable-output-escaping="yes"><![CDATA[<hr/>]]></xsl:text>
    </xsl:template>

    <!-- sets up introduction -->
    <xsl:template match="rdf:RDF" mode="introduction">
        <div id="introduction">
            <h1>Introduction</h1>
            <p>
                <xsl:value-of select="rdf:Description/dc:description"/>
            </p>
            <xsl:copy-of
                select="document('apsSchema_tableOfContents.xml')/htmlcode/html/body/introduction/div/p"
            />
        </div>
        <xsl:text disable-output-escaping="yes"><![CDATA[<hr/>]]></xsl:text>
    </xsl:template>


    <!-- sets up index of terms -->
    <xsl:template match="rdf:RDF" mode="index">
        <div id="index">
            <h1>Index of Terms</h1>
            <p>
                <xsl:for-each select="rdf:Property | rdfsClass | aps:*">
                    <xsl:element name="a">
                        <xsl:attribute name="href">
                            <xsl:text>apsSchema.html#</xsl:text>
                            <xsl:value-of select="./@rdf:ID"/>
                        </xsl:attribute>
                        <xsl:value-of select="./@rdf:ID"/>
                    </xsl:element>
                    <xsl:if test="position() != last()">
                        <xsl:text>, </xsl:text>
                    </xsl:if>
                </xsl:for-each>
            </p>
        </div>
        <xsl:text disable-output-escaping="yes"><![CDATA[<hr/>]]></xsl:text>
    </xsl:template>


    <!-- sets up the Property and Class tables -->
    <xsl:template match="rdf:RDF">
        <!-- <xsl:apply-templates select="rdf:Description"/> -->
        <div id="properties">
            <div class="backToTop">
                <a href="apsSchema.html">back to top</a>
            </div>
            <h1>Properties</h1>
            <table>
                <xsl:apply-templates select="rdf:Property"/>
            </table>
        </div>
        <xsl:text disable-output-escaping="yes"><![CDATA[<hr/>]]></xsl:text>
        <div id="classes">
            <div class="backToTop">
                <a href="apsSchema.html">back to top</a>
            </div>
            <h1>Classes</h1>
            <table>
                <xsl:apply-templates select="rdfs:Class"/>
                <xsl:apply-templates select="aps:*"/>
            </table>
        </div>
        <xsl:text disable-output-escaping="yes"><![CDATA[<hr/>]]></xsl:text>
    </xsl:template>

    <!-- sets up the rdf:Property transformations -->
    <xsl:template match="rdf:Property">
        <xsl:for-each select=".">
            <xsl:if test="rdfs:label">
                <tr>
                    <th class="PCname">
                        <xsl:attribute name="id">
                            <xsl:value-of select="./@rdf:ID"/>
                        </xsl:attribute>
                        <xsl:text>name: </xsl:text>
                    </th>
                    <td class="PCname">
                        <xsl:value-of select="rdfs:label"/>
                    </td>
                </tr>
            </xsl:if>
            <xsl:if test="./@rdf:ID">
                <tr>
                    <th>
                        <xsl:text>url: </xsl:text>
                    </th>
                    <td>
                        <a>
                            <xsl:attribute name="href">
                                <xsl:value-of select="../@xml:base"/>
                                <xsl:value-of select="./@rdf:ID"/>
                            </xsl:attribute>
                            <xsl:value-of select="../@xml:base"/>
                            <xsl:value-of select="./@rdf:ID"/>
                        </a>
                    </td>
                </tr>
            </xsl:if>
            <xsl:if test="rdfs:label">
                <tr>
                    <th>
                        <xsl:text>label: </xsl:text>
                    </th>
                    <td>
                        <xsl:value-of select="rdfs:label"/>
                    </td>
                </tr>
            </xsl:if>
            <xsl:if test="rdfs:comment">
                <tr>
                    <th>
                        <xsl:text>definition: </xsl:text>
                    </th>
                    <td>
                        <xsl:value-of select="rdfs:comment"/>
                    </td>
                </tr>
            </xsl:if>
            <xsl:if test="rdfs:subPropertyOf">
                <tr>
                    <th>
                        <xsl:text>sub-property of: </xsl:text>
                    </th>
                    <td>
                        <a>
                            <xsl:attribute name="href">
                                <xsl:text>apsSchema.html#</xsl:text>
                                <xsl:value-of
                                    select="rdfs:subPropertyOf/@rdf:resource/substring(.,61)"/>
                            </xsl:attribute>
                            <xsl:value-of select="rdfs:subPropertyOf/@rdf:resource/substring(.,61)"
                            />
                        </a>
                    </td>
                </tr>
            </xsl:if>
            <xsl:if test="rdfs:domain">
                <tr>
                    <th>
                        <xsl:text>domain: </xsl:text>
                    </th>
                    <td>
                        <a>
                            <xsl:attribute name="href">
                                <xsl:text>apsSchema.html#</xsl:text>
                                <xsl:value-of select="rdfs:domain/@rdf:resource/substring(.,61)"/>
                            </xsl:attribute>
                            <xsl:value-of select="rdfs:domain/@rdf:resource/substring(.,61)"/>
                        </a>
                    </td>
                </tr>
            </xsl:if>
            <xsl:if test="rdfs:range">
                <tr>
                    <th>
                        <xsl:text>range: </xsl:text>
                    </th>
                    <td>
                        <a>
                            <xsl:attribute name="href">
                                <xsl:text>apsSchema.html#</xsl:text>
                                <xsl:value-of select="rdfs:range/@rdf:resource/substring(.,61)"/>
                            </xsl:attribute>
                            <xsl:value-of select="rdfs:range/@rdf:resource/substring(.,61)"/>
                        </a>
                    </td>
                </tr>
            </xsl:if>
            <xsl:apply-templates select="rdfs:range"/>
        </xsl:for-each>
    </xsl:template>

    <!-- sets up the rdfs:Class transformations -->
    <xsl:template match="rdfs:Class">
        <xsl:for-each select=".">
            <xsl:choose>
                <xsl:when test="@rdf:ID=DDS">
                    <tr>
                        <th class="PCname">
                            <xsl:attribute name="id">
                                <xsl:text>DDS</xsl:text>
                            </xsl:attribute>
                            <xsl:text>name: </xsl:text>
                            <xsl:text>DDS</xsl:text>
                        </th>
                    </tr>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:if test="rdfs:label">
                        <tr>
                            <th class="PCname">
                                <xsl:attribute name="id">
                                    <xsl:value-of select="./@rdf:ID"/>
                                </xsl:attribute>
                                <xsl:text>name: </xsl:text>
                            </th>
                            <td class="PCname">
                                <xsl:value-of select="rdfs:label"/>
                            </td>
                        </tr>
                    </xsl:if>
                </xsl:otherwise>
            </xsl:choose>
            <xsl:if test="./@rdf:ID">
                <tr>
                    <th>
                        <xsl:text>url: </xsl:text>
                    </th>
                    <td>
                        <a>
                            <xsl:attribute name="href">
                                <xsl:value-of select="../@xml:base"/>
                                <xsl:value-of select="./@rdf:ID"/>
                            </xsl:attribute>
                            <xsl:value-of select="../@xml:base"/>
                            <xsl:value-of select="./@rdf:ID"/>
                        </a>
                    </td>
                </tr>
            </xsl:if>
            <xsl:choose>
                <xsl:when test="@rdf:ID=DDS">
                    <tr>
                        <th>
                            <xsl:text>label: </xsl:text>
                            <xsl:text>DDS, Digital Data Storage, Data Cartridge, Data Tape, Data-Grade Tape</xsl:text>
                        </th>
                    </tr>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:if test="rdfs:label">
                        <tr>
                            <th>
                                <xsl:text>label: </xsl:text>
                            </th>
                            <td>
                                <xsl:value-of select="rdfs:label"/>
                            </td>
                        </tr>
                    </xsl:if>
                </xsl:otherwise>
            </xsl:choose>
            <xsl:if test="rdfs:comment">
                <tr>
                    <th>
                        <xsl:text>definition: </xsl:text>
                    </th>
                    <td>
                        <xsl:value-of select="rdfs:comment"/>
                    </td>
                </tr>
            </xsl:if>
            <xsl:if test="rdfs:isDefinedBy">
                <tr>
                    <th>
                        <xsl:text>further defined by: </xsl:text>
                    </th>
                    <td>
                        <a>
                            <xsl:attribute name="href">
                                <xsl:value-of select="rdfs:isDefinedBy/@rdf:resource"/>
                            </xsl:attribute>
                            <xsl:attribute name="target"><xsl:text>_blank</xsl:text></xsl:attribute>
                            <xsl:value-of select="rdfs:isDefinedBy/@rdf:resource"/>
                        </a>
                    </td>
                </tr>
            </xsl:if>
            <xsl:if test="rdfs:subClassOf">
                <tr>
                    <th>
                        <xsl:text>sub-class of</xsl:text>
                    </th>
                    <td>
                        <a>
                            <xsl:attribute name="href">
                                <xsl:text>apsSchema.html#</xsl:text>
                                <xsl:value-of select="rdfs:subClassOf/@rdf:resource/substring(.,61)"
                                />
                            </xsl:attribute>
                            <xsl:value-of select="rdfs:subClassOf/@rdf:resource/substring(.,61)"/>
                        </a>
                    </td>
                </tr>
            </xsl:if>
        </xsl:for-each>
    </xsl:template>

    <!-- sets up aps: Classes -->
    <xsl:template match="aps:*">
        <xsl:for-each select=".">
            <xsl:choose>
                <xsl:when test="@rdf:ID='DDS'">
                    <tr>
                        <th class="PCname">
                            <xsl:attribute name="id">
                                <xsl:text>DDS</xsl:text>
                            </xsl:attribute>
                            <xsl:text>name: </xsl:text>
                        </th>
                        <td class="PCname">
                            <xsl:text>DDS</xsl:text>
                        </td>

                    </tr>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:if test="rdfs:label">
                        <tr>
                            <th class="PCname">
                                <xsl:attribute name="id">
                                    <xsl:value-of select="./@rdf:ID"/>
                                </xsl:attribute>
                                <xsl:text>name: </xsl:text>
                            </th>
                            <td class="PCname">
                                <xsl:value-of select="rdfs:label"/>
                            </td>
                        </tr>
                    </xsl:if>
                </xsl:otherwise>
            </xsl:choose>

            <xsl:if test="./@rdf:ID">
                <tr>
                    <th>
                        <xsl:text>url: </xsl:text>
                    </th>
                    <td>
                        <a>
                            <xsl:attribute name="href">
                                <xsl:value-of select="../@xml:base"/>
                                <xsl:value-of select="./@rdf:ID"/>
                            </xsl:attribute>
                            <xsl:value-of select="../@xml:base"/>
                            <xsl:value-of select="./@rdf:ID"/>
                        </a>
                    </td>
                </tr>
            </xsl:if>

            <xsl:choose>
                <xsl:when test="@rdf:ID='DDS'">
                    <tr>
                        <th>
                            <xsl:text>label: </xsl:text>
                        </th>
                        <td>
                            <xsl:text>DDS, Digital Data Storage, Data Cartridge, Data Tape, Data-Grade Tape</xsl:text>
                        </td>
                    </tr>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:if test="rdfs:label">
                        <tr>
                            <th>
                                <xsl:text>label: </xsl:text>
                            </th>
                            <td>
                                <xsl:value-of select="rdfs:label"/>
                            </td>
                        </tr>
                    </xsl:if>
                </xsl:otherwise>
            </xsl:choose>

            <xsl:if test="rdfs:comment">
                <tr>
                    <th>
                        <xsl:text>definition: </xsl:text>
                    </th>
                    <td>
                        <xsl:value-of select="rdfs:comment"/>
                    </td>
                </tr>
            </xsl:if>
            <xsl:if test="rdfs:isDefinedBy">
                <tr>
                    <th>
                        <xsl:text>defined by: </xsl:text>
                    </th>
                    <td>
                        <a>
                            <xsl:attribute name="href">
                                <xsl:value-of select="rdfs:isDefinedBy/@rdf:resource"/>
                            </xsl:attribute>
                            <xsl:attribute name="target"><xsl:text>_blank</xsl:text></xsl:attribute>
                            <xsl:value-of select="rdfs:isDefinedBy/@rdf:resource"/>
                        </a>
                    </td>
                </tr>
            </xsl:if>
            <xsl:if test="rdfs:seeAlso">
                <tr>
                    <th>
                        <xsl:text>see also: </xsl:text>
                    </th>
                    <td>
                        <a>
                            <xsl:attribute name="href">
                                <xsl:value-of select="rdfs:seeAlso/@rdf:resource"/>
                            </xsl:attribute>
                            <xsl:attribute name="target">_blank</xsl:attribute>
                            <xsl:value-of select="rdfs:seeAlso/@rdf:resource"/>
                        </a>
                    </td>
                </tr>
            </xsl:if>
            <xsl:if test="rdfs:subClassOf">
                <tr>
                    <th>
                        <xsl:text>sub-class of</xsl:text>
                    </th>
                    <td>
                        <a>
                            <xsl:attribute name="href">
                                <xsl:text>apsSchema.html#</xsl:text>
                                <xsl:value-of select="."/>
                            </xsl:attribute>
                            <xsl:value-of select="."/>
                        </a>
                    </td>
                </tr>
            </xsl:if>
        </xsl:for-each>
    </xsl:template>

    <!-- controlled vocabulary template -->
    <xsl:template match="rdfs:range">
        <xsl:if test="@rdf:resource = 'apsSchema#Carrier'">
            <tr>
                <th>
                    <xsl:text>controlled vocabulary: </xsl:text>
                </th>
                <td>
                    <xsl:for-each
                        select="document('controlledVocab.xml')/controlledVocab/Carrier | document('controlledVocab.xml')/controlledVocab/Tape | document('controlledVocab.xml')/controlledVocab/Disc">
                        <a>
                            <xsl:attribute name="href">
                                <xsl:text>apsSchema.html#</xsl:text>
                                <xsl:value-of select="./@rdf:ID"/>
                            </xsl:attribute>
                            <xsl:value-of select="./@rdf:ID"/>
                        </a>
                        <xsl:if test="position() != last()">
                            <xsl:text>, </xsl:text>
                        </xsl:if>
                    </xsl:for-each>
                </td>
            </tr>
        </xsl:if>
        <xsl:if test="@rdf:resource = 'http://jacobshelby.org/schemas/aps/2014/08/03/apsSchema.rdf##Cassette'">
            <tr>
                <th>
                    <xsl:text>controlled vocabulary: </xsl:text>
                </th>
                <td>
                    <xsl:for-each select="document('controlledVocab.xml')/controlledVocab/Cassette">
                        <a>
                            <xsl:attribute name="href">
                                <xsl:text>apsSchema.html#</xsl:text>
                                <xsl:value-of select="./@rdf:ID"/>
                            </xsl:attribute>
                            <xsl:value-of select="./@rdf:ID"/>
                        </a>
                        <xsl:if test="position() != last()">
                            <xsl:text>, </xsl:text>
                        </xsl:if>
                    </xsl:for-each>
                </td>
            </tr>
        </xsl:if>
        <xsl:if test="@rdf:resource = 'http://jacobshelby.org/schemas/aps/2014/08/03/apsSchema.rdf##ConditionStatus'">
            <tr>
                <th>
                    <xsl:text>controlled vocabulary: </xsl:text>
                </th>
                <td>
                    <xsl:for-each
                        select="document('controlledVocab.xml')/controlledVocab/ConditionStatus">
                        <a>
                            <xsl:attribute name="href">
                                <xsl:text>apsSchema.html#</xsl:text>
                                <xsl:value-of select="./@rdf:ID"/>
                            </xsl:attribute>
                            <xsl:value-of select="./@rdf:ID"/>
                        </a>
                        <xsl:if test="position() != last()">
                            <xsl:text>, </xsl:text>
                        </xsl:if>
                    </xsl:for-each>
                </td>
            </tr>
        </xsl:if>
        <xsl:if test="@rdf:resource = 'http://jacobshelby.org/schemas/aps/2014/08/03/apsSchema.rdf##DAT'">
            <tr>
                <th>
                    <xsl:text>controlled vocabulary: </xsl:text>
                </th>
                <td>
                    <xsl:for-each select="document('controlledVocab.xml')/controlledVocab/DAT">
                        <a>
                            <xsl:attribute name="href">
                                <xsl:text>apsSchema.html#</xsl:text>
                                <xsl:value-of select="./@rdf:ID"/>
                            </xsl:attribute>
                            <xsl:value-of select="./@rdf:ID"/>
                        </a>
                        <xsl:if test="position() != last()">
                            <xsl:text>, </xsl:text>
                        </xsl:if>
                    </xsl:for-each>
                </td>
            </tr>
        </xsl:if>
        <xsl:if test="@rdf:resource = 'http://jacobshelby.org/schemas/aps/2014/08/03/apsSchema.rdf##TrackConfig'">
            <tr>
                <th>
                    <xsl:text>controlled vocabulary: </xsl:text>
                </th>
                <td>
                    <xsl:for-each
                        select="document('controlledVocab.xml')/controlledVocab/TrackConfig">
                        <a>
                            <xsl:attribute name="href">
                                <xsl:text>apsSchema.html#</xsl:text>
                                <xsl:value-of select="./@rdf:ID"/>
                            </xsl:attribute>
                            <xsl:value-of select="./@rdf:ID"/>
                        </a>
                        <xsl:if test="position() != last()">
                            <xsl:text>, </xsl:text>
                        </xsl:if>
                    </xsl:for-each>
                </td>
            </tr>
        </xsl:if>
        <xsl:if test="@rdf:resource = 'http://jacobshelby.org/schemas/aps/2014/08/03/apsSchema.rdf##Wire'">
            <tr>
                <th>
                    <xsl:text>controlled vocabulary: </xsl:text>
                </th>
                <td>
                    <xsl:for-each select="document('controlledVocab.xml')/controlledVocab/Wire">
                        <a>
                            <xsl:attribute name="href">
                                <xsl:text>apsSchema.html#</xsl:text>
                                <xsl:value-of select="./@rdf:ID"/>
                            </xsl:attribute>
                            <xsl:value-of select="./@rdf:ID"/>
                        </a>
                        <xsl:if test="position() != last()">
                            <xsl:text>, </xsl:text>
                        </xsl:if>
                    </xsl:for-each>
                </td>
            </tr>
        </xsl:if>
    </xsl:template>

    <!-- Class logical grouping -->
    <xsl:template match="rdf:RDF" mode="Custom">
        <div id="logicalGrouping">
            <div class="backToTop">
                <a href="apsSchema.html">back to top</a>
            </div>
            <h1>Logical Grouping of Physical Audio Formats</h1>
            <ul id="logicalGroupingWrapper">
                <li>
                    <xsl:if test="rdfs:Class/@rdf:ID='Carrier'">
                        <a>
                            <xsl:attribute name="href">
                                <xsl:text>apsSchema.html#</xsl:text>
                                <xsl:text>Carrier</xsl:text>
                            </xsl:attribute>
                            <xsl:text>Carrier</xsl:text>
                        </a>
                    </xsl:if>
                </li>
                <li>
                    <ul>
                        <li>
                            <xsl:if test="aps:Carrier/@rdf:ID='Disc'">
                                <a>
                                    <xsl:attribute name="href">
                                        <xsl:text>apsSchema.html#</xsl:text>
                                        <xsl:text>Disc</xsl:text>
                                    </xsl:attribute>
                                    <xsl:text>Disc</xsl:text>
                                </a>
                            </xsl:if>
                        </li>
                        <li>
                            <ul>
                                <xsl:for-each select="aps:Disc">
                                    <li>
                                        <a>
                                            <xsl:attribute name="href">
                                                <xsl:text>apsSchema.html#</xsl:text>
                                                <xsl:value-of select="./@rdf:ID"/>
                                            </xsl:attribute>
                                            <xsl:value-of select="./@rdf:ID"/>
                                        </a>
                                    </li>
                                </xsl:for-each>
                            </ul>
                        </li>
                        <li>
                            <xsl:if test="aps:Carrier/@rdf:ID='Tape'">
                                <a>
                                    <xsl:attribute name="href">
                                        <xsl:text>apsSchema.html#</xsl:text>
                                        <xsl:text>Tape</xsl:text>
                                    </xsl:attribute>
                                    <xsl:text>Tape</xsl:text>
                                </a>
                            </xsl:if>
                        </li>
                        <xsl:for-each select="aps:Tape">
                            <li>
                                <ul>
                                    <li>
                                        <a>
                                            <xsl:attribute name="href">
                                                <xsl:text>apsSchema.html#</xsl:text>
                                                <xsl:value-of select="./@rdf:ID"/>
                                            </xsl:attribute>
                                            <xsl:value-of select="./@rdf:ID"/>
                                        </a>
                                    </li>
                                    <xsl:if test="./@rdf:ID='Cassette'">
                                        <li>
                                            <ul>
                                                <xsl:for-each select="../aps:Cassette">
                                                  <li>
                                                  <a>
                                                  <xsl:attribute name="href">
                                                  <xsl:text>apsSchema.html#</xsl:text>
                                                  <xsl:value-of select="./@rdf:ID"/>
                                                  </xsl:attribute>
                                                  <xsl:value-of select="./@rdf:ID"/>
                                                  </a>
                                                  </li>
                                                </xsl:for-each>
                                            </ul>
                                        </li>
                                    </xsl:if>
                                    <xsl:if test="./@rdf:ID='DAT'">
                                        <li>
                                            <ul>
                                                <xsl:for-each select="../aps:DAT">
                                                  <li>
                                                  <a>
                                                  <xsl:attribute name="href">
                                                  <xsl:text>apsSchema.html#</xsl:text>
                                                  <xsl:value-of select="./@rdf:ID"/>
                                                  </xsl:attribute>
                                                  <xsl:value-of select="./@rdf:ID"/>
                                                  </a>
                                                  </li>
                                                </xsl:for-each>
                                            </ul>
                                        </li>
                                    </xsl:if>
                                </ul>
                            </li>
                        </xsl:for-each>
                    </ul>
                </li>
                <li>
                    <ul>
                        <xsl:if test="aps:Carrier/@rdf:ID='Wire'">
                            <li>
                                <a>
                                    <xsl:attribute name="href">
                                        <xsl:text>apsSchema.html#</xsl:text>
                                        <xsl:text>Wire</xsl:text>
                                    </xsl:attribute>
                                    <xsl:text>Wire</xsl:text>
                                </a>
                            </li>
                            <li>
                                <ul>
                                    <xsl:for-each select="aps:Wire">
                                        <li>
                                            <a>
                                                <xsl:attribute name="href">
                                                  <xsl:text>apsSchema.html#</xsl:text>
                                                  <xsl:value-of select="./@rdf:ID"/>
                                                </xsl:attribute>
                                                <xsl:value-of select="./@rdf:ID"/>
                                            </a>
                                        </li>
                                    </xsl:for-each>
                                </ul>
                            </li>
                        </xsl:if>
                    </ul>
                </li>
            </ul>
        </div>
    </xsl:template>

    <!-- this checks to see if there is already a file named 'controlledVocab.xml'. if there isn't, it creates an xml document based on the aps:* template -->
    <xsl:template name="checkDocument">
        <xsl:if test="not(document('controlledVocab.xml'))">
            <xsl:result-document href="controlledVocab.xml" method="xml">
                <controlledVocab>
                    <xsl:apply-templates select="aps:*" mode="Custom"/>
                </controlledVocab>
            </xsl:result-document>
        </xsl:if>
    </xsl:template>

    <!-- this removes the aps prefix -->
    <xsl:template match="aps:*" mode="Custom">
        <xsl:element name="{local-name(.)}">
            <xsl:apply-templates select="@*"/>
        </xsl:element>
    </xsl:template>

    <xsl:template match="@*">
        <xsl:attribute name="rdf:ID">
            <xsl:value-of select="."/>
        </xsl:attribute>
    </xsl:template>
</xsl:stylesheet>
