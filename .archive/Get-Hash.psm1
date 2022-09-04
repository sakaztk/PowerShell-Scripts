<#
.SYNOPSIS
指定したファイルのハッシュ値を取得。

.DESCRIPTION
サイズが大きい場合は時間を要する。

.PARAMETER file
対象ファイルパスを指定。

.PARAMETER algorithms
取得するハッシュ関数のアルゴリズムを指定。デフォルトはSHA256。

.PARAMETER plain
指定した場合、ハッシュ値のみを返す。アルゴリズム指定が1つの場合のみ有効。

.EXAMPLE
Get-Hash -file c:\hoge.exe -algorithms md5,sha256
hoge.exe の MD5 および SHA256 のハッシュ値を取得。

.EXAMPLE
Get-Hash c:\hoge.exe md5 -plain
hoge.exe の MD5 のハッシュ値をオブジェクトではなくテキストのみで取得。

.EXAMPLE
Get-Hash c:\hoge all
MACTripleDes, MD5, RIPEMD160, SHA1, SHA256, SHA384, SHA512 のハッシュ値を取得

.LINK
http://msdn.microsoft.com/library/system.security.cryptography.hashalgorithm.aspx

.NOTES
2014-07-31 SKD 作成

#>
function Get-Hash {
    [CmdletBinding()]
    Param (
        [String]$file,
        [ValidateSet('MACTripleDes','MD5','RIPEMD160','SHA1','SHA256','SHA384','SHA512','ALL')][String[]]$algorithms = 'SHA256',
        [Switch]$plain
    )
    Begin {
        $ErrorActionPreference = 'Stop'
        if ($algorithms -contains 'ALL') {
            $algorithms = ('MACTripleDes','MD5','RIPEMD160','SHA1','SHA256','SHA384','SHA512')
        }
    }
    Process{
        if ($file -eq '') {
            Get-Help $MyInvocation.MyCommand.Name
        }
        else {
            foreach ($algorithm in $algorithms) {
                $fileStream = [system.io.file]::openread((resolve-path $file))
                $hasher = [system.security.cryptography.hashalgorithm]::create($algorithm)
                $hash = $hasher.computehash($filestream)
                $ret = [system.bitconverter]::tostring($hash)
                if (($algorithms.length -eq 1) -And ($plain -eq $True)) {
                    $ret
                }
                else {
                    New-Object -TypeName PSObject -Property @{
                        Algorithm = $algorithm
                        Hash = $ret
                    }
                }
            }
        }
    }
}