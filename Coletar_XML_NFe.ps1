# ===========================================================
# Coletor de XML de NF-e por Mês/Ano
# Autor: Danilo + ChatGPT
# Versão: 1.0
# ===========================================================

Clear-Host

Write-Host "==============================================" -ForegroundColor Cyan
Write-Host "      COLETOR DE XML DE NF-e" -ForegroundColor Cyan
Write-Host "==============================================" -ForegroundColor Cyan
Write-Host ""

$Origem = Read-Host "Informe a pasta de origem"
$Destino = Read-Host "Informe a pasta de destino"
$Mes = [int](Read-Host "Informe o mês (1-12)")
$Ano = [int](Read-Host "Informe o ano (Ex: 2026)")

if (!(Test-Path $Origem)) {
    Write-Host ""
    Write-Host "A pasta de origem não existe." -ForegroundColor Red
    Pause
    exit
}

if (!(Test-Path $Destino)) {
    New-Item -ItemType Directory -Force -Path $Destino | Out-Null
}

$Cronometro = [System.Diagnostics.Stopwatch]::StartNew()

$Arquivos = Get-ChildItem -Path $Origem -Filter *.xml -Recurse

$Total = $Arquivos.Count
$Processados = 0
$Copiados = 0
$Erros = 0

$Relatorio = Join-Path $Destino "Relatorio.txt"

"RELATÓRIO DE COLETA DE XML" | Out-File $Relatorio
"Data/Hora: $(Get-Date)" | Out-File $Relatorio -Append
"Origem: $Origem" | Out-File $Relatorio -Append
"Destino: $Destino" | Out-File $Relatorio -Append
"Filtro: $Mes/$Ano" | Out-File $Relatorio -Append
"" | Out-File $Relatorio -Append

foreach ($Arquivo in $Arquivos) {

    $Processados++

    $Percentual = [math]::Round(($Processados / $Total) * 100)

    Write-Progress `
        -Activity "Analisando XML..." `
        -Status "$Processados de $Total - Restam $($Total-$Processados)" `
        -PercentComplete $Percentual

    try {

        [xml]$xml = Get-Content $Arquivo.FullName

        $dhEmi = $xml.GetElementsByTagName("dhEmi") | Select-Object -First 1

        if ($dhEmi -eq $null) {
            continue
        }

        $Data = Get-Date $dhEmi.InnerText

        if ($Data.Month -eq $Mes -and $Data.Year -eq $Ano) {

            Copy-Item $Arquivo.FullName -Destination $Destino -Force

            $Copiados++

            $Chave = ""

            $chNFe = $xml.GetElementsByTagName("chNFe") | Select-Object -First 1

            if ($chNFe) {
                $Chave = $chNFe.InnerText
            }

            $Linha = "{0} | {1} | {2}" -f $Data.ToString("dd/MM/yyyy"), $Chave, $Arquivo.Name

            Add-Content -Path $Relatorio -Value $Linha

            Write-Host "Copiado: $($Arquivo.Name)" -ForegroundColor Green

        }

    }
    catch {

        $Erros++

        Write-Host "Erro: $($Arquivo.Name)" -ForegroundColor Yellow

    }

}

$Cronometro.Stop()

Write-Progress -Activity "Finalizado" -Completed

Write-Host ""
Write-Host "==============================================" -ForegroundColor Cyan
Write-Host "PROCESSAMENTO CONCLUÍDO" -ForegroundColor Green
Write-Host "==============================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "Arquivos encontrados : $Total"
Write-Host "Arquivos copiados    : $Copiados"
Write-Host "Erros                : $Erros"
Write-Host "Tempo gasto          : $($Cronometro.Elapsed)"
Write-Host ""
Write-Host "Relatório salvo em:"
Write-Host $Relatorio -ForegroundColor Cyan
Write-Host ""
Pause