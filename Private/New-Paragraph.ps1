# Add C# Indenter type if not already loaded
if (-not ([System.Management.Automation.PSTypeName]'Indenter').Type) {
    Add-Type -TypeDefinition @"
using System;
using System.Text;

public class Indenter
{
    public static string NewIndent(int position, int indent, string str)
    {
        var StringBuilder = new StringBuilder();
        var words = str.Split(' ');

        int currentLineLength = 0;
        StringBuilder.Append(' ', indent);
        foreach (var word in words)
        {
            if (currentLineLength + word.Length > position)
            {
                StringBuilder.AppendLine();
                StringBuilder.Append(' ', indent);
                currentLineLength = 0;
            }

            StringBuilder.Append(word);
            StringBuilder.Append(' ');
            currentLineLength += word.Length + 1;
        }

        return StringBuilder.ToString();
    }
}
"@
}

function New-Paragraph {
    <#
    .SYNOPSIS
    New-Paragraph is a function that generates readable text by indenting it, simulating the effect of a paragraph in a book.
    .DESCRIPTION
    New-Paragraph is a function that generates readable text by indenting it, simulating the effect of a paragraph in a book.
    .PARAMETER position
    The position at which to start the indent.
    .PARAMETER indent
    The number of spaces to indent.
    .PARAMETER string
    The string to be indented.
    #>
    [CmdletBinding()]
    [OutputType([string])]
    param(
        [Parameter(Mandatory = $true)]
        [int]$position,

        [Parameter(Mandatory = $true)]
        [int]$indent,
       
        [Parameter(Mandatory = $true)]
        [string]$string
    )

    return [Indenter]::NewIndent($position, $indent, $string)
}
