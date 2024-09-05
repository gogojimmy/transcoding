<?xml version="1.0"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
    <xsl:template match="/">
        <html>
        <head>
            <title>RTMP Server Status</title>
            <style>
                body { font-family: Arial, sans-serif; }
                table { border-collapse: collapse; width: 100%; }
                th, td { border: 1px solid #ddd; padding: 8px; }
                th { background-color: #f2f2f2; }
            </style>
        </head>
        <body>
            <h1>RTMP Server Status</h1>
            <table>
                <tr>
                    <th>Application</th>
                    <th>Stream</th>
                    <th>Clients</th>
                    <th>BW In</th>
                    <th>BW Out</th>
                </tr>
                <xsl:for-each select="rtmp/server/application">
                    <xsl:variable name="app" select="name"/>
                    <xsl:for-each select="live/stream">
                        <tr>
                            <td><xsl:value-of select="$app"/></td>
                            <td><xsl:value-of select="name"/></td>
                            <td><xsl:value-of select="nclients"/></td>
                            <td><xsl:value-of select="bw_in"/></td>
                            <td><xsl:value-of select="bw_out"/></td>
                        </tr>
                    </xsl:for-each>
                </xsl:for-each>
            </table>
        </body>
        </html>
    </xsl:template>
</xsl:stylesheet>